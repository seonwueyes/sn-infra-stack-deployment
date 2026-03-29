#!/bin/sh
set -eu

# 호스트에서 실행하는 스크립트입니다.
# 사용 예:
#   BACKUP_FILE=sn-zabbix-01-db/backup-data/zabbix_YYYYMMDD_HHMMSS.sql.gz \
#   MYSQL_USER=zabbix \
#   MYSQL_PASSWORD=changeme \
#   MYSQL_DATABASE=zabbix \
#   sn-zabbix-01-db/backup/mysqldump_restore.sh

: "${BACKUP_FILE:?BACKUP_FILE 경로를 지정하세요}"
: "${MYSQL_USER:?MYSQL_USER를 지정하세요}"
: "${MYSQL_PASSWORD:?MYSQL_PASSWORD를 지정하세요}"
: "${MYSQL_DATABASE:?MYSQL_DATABASE를 지정하세요}"

COMPOSE_FILE="${COMPOSE_FILE:-sn-zabbix-01-db/docker-compose.yml}"
DB_SERVICE="${DB_SERVICE:-sn-zabbix-mysql-server}"

if [ ! -f "${BACKUP_FILE}" ]; then
  echo "ERROR: BACKUP_FILE이 존재하지 않습니다: ${BACKUP_FILE}" >&2
  exit 1
fi

case "${BACKUP_FILE}" in
  *.gz)
    gunzip -c "${BACKUP_FILE}" | \
      docker compose -f "${COMPOSE_FILE}" exec -T "${DB_SERVICE}" \
      mysql -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}"
    ;;
  *.sql)
    docker compose -f "${COMPOSE_FILE}" exec -T "${DB_SERVICE}" \
      mysql -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" < "${BACKUP_FILE}"
    ;;
  *)
    echo "ERROR: 지원하지 않는 확장자입니다. .sql 또는 .sql.gz만 지원합니다." >&2
    exit 1
    ;;
esac

 echo "OK: restored ${BACKUP_FILE}"
