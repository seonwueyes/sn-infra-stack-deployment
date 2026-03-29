#!/bin/sh
set -eu

# 호스트에서 실행하는 스크립트입니다.
# 필요 시 VOLUME_NAME을 실제 볼륨명으로 변경하세요.
VOLUME_NAME="${VOLUME_NAME:-sn-zabbix-01-db_mysql_data}"
BACKUP_DIR="${BACKUP_DIR:-$(pwd)/sn-zabbix-01-db/backup-data}"
TS="$(date +"%Y%m%d_%H%M%S")"
OUT="${BACKUP_DIR}/mysql_volume_${TS}.tar.gz"
OUT_BASENAME="$(basename "${OUT}")"

mkdir -p "${BACKUP_DIR}"

start_db() {
  ( cd "$(pwd)/sn-zabbix-01-db" && docker compose -f docker-compose.yml start sn-zabbix-mysql-server ) || true
}

# 데이터 일관성을 위해 DB를 잠시 중지
( cd "$(pwd)/sn-zabbix-01-db" && docker compose -f docker-compose.yml stop sn-zabbix-mysql-server )
trap start_db EXIT

# 볼륨 스냅샷(아카이브)
docker run --rm \
  -v "${VOLUME_NAME}:/data:ro" \
  -v "${BACKUP_DIR}:/backup" \
  alpine:3.20 \
  sh -c "tar czf /backup/${OUT_BASENAME} -C /data ."

trap - EXIT
start_db

echo "OK: ${OUT}"
