# sn-zabbix-01-db

샘플용 Zabbix MySQL 및 백업 스케줄 구성.

## sn-zabbix-01-db 설명
Zabbix 서버가 사용할 MySQL DB를 단일 컨테이너로 제공하고, 동일 네트워크(`scm-network`) 내에서 접근하도록 구성합니다.  
또한 별도 백업 컨테이너가 매일 정해진 시간에 `mysqldump`를 수행해 `backup-data`에 저장합니다.

## 구성
- MySQL 8.0 컨테이너
- 매일 02:30(Asia/Seoul) `mysqldump` 백업
- 기본 보관 7일(환경값으로 조정)

## 주의
- `.env`의 비밀번호는 **샘플 기본값**입니다. 운영 환경에서는 secret/vault로 분리하세요.
- 백업 보관 기간/스케줄은 환경에 맞게 조정하세요.

## 운영 시 권장사항
- 백업은 가능하면 스토리지 스냅샷(RDS Snapshot 등) 기반으로 이중화하세요.
- 백업 계정은 최소 권한 원칙으로 분리하고, 비밀번호는 secret/vault로 관리하세요.
- 정기적으로 복구 리허설을 수행해 백업 유효성을 점검하세요.

## 실행
```bash
docker compose -f sn-zabbix-01-db/docker-compose.yml up -d
```

## 수동 백업 테스트
`--rm`은 컨테이너만 삭제하며, 백업 파일은 `backup-data`에 남습니다.
```bash
docker compose -f sn-zabbix-01-db/docker-compose.yml run --rm sn-zabbix-mysql-backup /backup/mysqldump_backup.sh
```
## 수동 백업 복구(테스트)
복구 전에 DB를 비워야 “백업 시점과 동일한 상태”로 돌아갑니다.
```bash
docker compose -f sn-zabbix-01-db/docker-compose.yml exec -T sn-zabbix-mysql-server \
  mysql -uzabbix -p'<PASSWORD>' -e "DROP DATABASE zabbix; CREATE DATABASE zabbix;"

BACKUP_FILE=sn-zabbix-01-db/backup-data/zabbix_YYYYMMDD_HHMMSS.sql.gz \
MYSQL_USER=zabbix \
MYSQL_PASSWORD=changeme \
MYSQL_DATABASE=zabbix \
./sn-zabbix-01-db/backup/mysqldump_restore.sh
```

## 볼륨 스냅샷 백업(호스트 실행)
named volume 자체를 tar로 백업합니다. DB 일관성을 위해 잠시 중지합니다.
```bash
sn-zabbix-01-db/backup/volume_backup.sh
```
필요하면 `VOLUME_NAME`을 실제 볼륨명으로 지정하세요. 예:
```bash
VOLUME_NAME=sn-zabbix-01-db_mysql_data sn-zabbix-01-db/backup/volume_backup.sh
```

## 볼륨 스냅샷 복구(호스트 실행)
기존 볼륨을 삭제 후 복원합니다. **데이터가 덮어써지므로 주의**하세요.
```bash
BACKUP_FILE=sn-zabbix-01-db/backup-data/mysql_volume_YYYYMMDD_HHMMSS.tar.gz \
VOLUME_NAME=sn-zabbix-01-db_mysql_data \
CONFIRM=YES \
sn-zabbix-01-db/backup/volume_restore.sh
```

## 복구
백업 파일이 있으면 아래처럼 복구할 수 있습니다.

### 일반 SQL 파일 복구
```bash
docker compose -f sn-zabbix-01-db/docker-compose.yml exec -T sn-zabbix-mysql-server \
  mysql -uzabbix -p'<PASSWORD>' zabbix < sn-zabbix-01-db/backup-data/zabbix_YYYYMMDD_HHMMSS.sql
```

### gzip 압축 파일 복구
```bash
gunzip -c sn-zabbix-01-db/backup-data/zabbix_YYYYMMDD_HHMMSS.sql.gz | \
  docker compose -f sn-zabbix-01-db/docker-compose.yml exec -T sn-zabbix-mysql-server \
  mysql -uzabbix -p'<PASSWORD>' zabbix
```

## mysqldump 복구 스크립트(호스트 실행)
```bash
BACKUP_FILE=sn-zabbix-01-db/backup-data/zabbix_YYYYMMDD_HHMMSS.sql.gz \
MYSQL_USER=zabbix \
MYSQL_PASSWORD=changeme \
MYSQL_DATABASE=zabbix \
sn-zabbix-01-db/backup/mysqldump_restore.sh
```
