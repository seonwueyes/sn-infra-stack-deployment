#!/bin/sh
set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="${ENV_FILE:-${SCRIPT_DIR}/../.env}"
if [ -f "${ENV_FILE}" ]; then
  # shellcheck disable=SC1090
  . "${ENV_FILE}"
fi

TS="$(date +"%Y%m%d_%H%M%S")"
OUT="/backups/${MYSQL_DATABASE}_${TS}.sql"

mysqldump \
  -h "${MYSQL_HOST}" \
  -P "${MYSQL_PORT}" \
  -u"${MYSQL_USER}" \
  -p"${MYSQL_PASSWORD}" \
  --no-tablespaces \
  --single-transaction \
  --routines \
  --events \
  "${MYSQL_DATABASE}" > "${OUT}"

if [ "${BACKUP_COMPRESS:-true}" = "true" ]; then
  gzip "${OUT}"
fi

find /backups -type f -name "${MYSQL_DATABASE}_*.sql*" -mtime "+${BACKUP_RETENTION_DAYS:-7}" -delete
