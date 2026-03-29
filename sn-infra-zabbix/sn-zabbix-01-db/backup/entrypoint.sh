#!/bin/sh
set -eu

apk add --no-cache mysql-client tzdata >/dev/null

if [ "$#" -gt 0 ]; then
  exec "$@"
fi

crontab /backup/crontab

exec crond -f -L /var/log/cron.log
