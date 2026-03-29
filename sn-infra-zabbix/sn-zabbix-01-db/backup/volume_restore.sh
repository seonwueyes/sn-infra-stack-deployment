#!/bin/sh
set -eu

# 호스트에서 실행하는 스크립트입니다.
# 사용 예:
#   BACKUP_FILE=sn-zabbix-01-db/backup-data/mysql_volume_YYYYMMDD_HHMMSS.tar.gz \
#   VOLUME_NAME=sn-zabbix-01-db_mysql_data \
#   CONFIRM=YES \
#   sn-zabbix-01-db/backup/volume_restore.sh

: "${BACKUP_FILE:?BACKUP_FILE 경로를 지정하세요}"
: "${CONFIRM:?CONFIRM=YES 로 지정하세요}"

if [ "${CONFIRM}" != "YES" ]; then
  echo "ERROR: CONFIRM=YES 가 필요합니다. 기존 볼륨이 삭제됩니다." >&2
  exit 1
fi

VOLUME_NAME="${VOLUME_NAME:-sn-zabbix-01-db_mysql_data}"
BACKUP_PATH="${BACKUP_FILE}"
BACKUP_DIR="$(dirname "${BACKUP_PATH}")"
BACKUP_BASENAME="$(basename "${BACKUP_PATH}")"
BACKUP_DIR_ABS="$(cd "${BACKUP_DIR}" && pwd)"

if [ ! -f "${BACKUP_PATH}" ]; then
  echo "ERROR: BACKUP_FILE이 존재하지 않습니다: ${BACKUP_PATH}" >&2
  exit 1
fi

start_db() {
  ( cd "$(pwd)/sn-zabbix-01-db" && docker compose -f docker-compose.yml up -d sn-zabbix-mysql-server ) || true
}

# 데이터 일관성을 위해 DB를 잠시 중지
( cd "$(pwd)/sn-zabbix-01-db" && docker compose -f docker-compose.yml stop sn-zabbix-mysql-server )
trap start_db EXIT

# 복구를 위해 DB 컨테이너를 제거 (볼륨 사용 해제)
docker rm -f sn-zabbix-mysql-server >/dev/null 2>&1 || true

# 볼륨이 사용 중이면 중단
IN_USE_CONTAINERS="$(docker ps -q --filter "volume=${VOLUME_NAME}")"
if [ -n "${IN_USE_CONTAINERS}" ]; then 
  echo "ERROR: 볼륨이 사용 중입니다. 먼저 관련 컨테이너를 중지하세요." >&2
  echo "CONTAINERS: ${IN_USE_CONTAINERS}" >&2
  exit 1
fi

# 기존 볼륨 삭제 후 재생성
if docker volume inspect "${VOLUME_NAME}" >/dev/null 2>&1; then
  docker volume rm "${VOLUME_NAME}"
fi

docker volume create "${VOLUME_NAME}" >/dev/null

# 볼륨 복구
docker run --rm \
  -v "${VOLUME_NAME}:/data" \
  -v "${BACKUP_DIR_ABS}:/backup" \
  alpine:3.20 \
  sh -c "tar xzf /backup/${BACKUP_BASENAME} -C /data"

trap - EXIT
start_db

echo "OK: restored ${BACKUP_PATH} to ${VOLUME_NAME}"
