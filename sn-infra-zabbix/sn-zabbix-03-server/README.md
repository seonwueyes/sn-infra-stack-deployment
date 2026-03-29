# sn-zabbix-03-server

Zabbix Server 컨테이너와 알림 스크립트(alertscripts) 배포 위치를 정리한 문서입니다.

## alertscripts 위치
컨테이너 내부 기본 경로:
```bash
/usr/lib/zabbix/alertscripts/
```

## 동작 개요
- `sn-zabbix-03-server/syncdata/alertscripts`의 스크립트들이
  컨테이너의 `/usr/lib/zabbix/alertscripts`로 복제됩니다.
- Zabbix에서 External Script(또는 Media Script) 호출 시
  기본 실행 디렉터리가 위 경로입니다.

## 예시 (Dooray 알림)
```bash
./notification-dooray.py \
  "https://static.dooray.com/static_images/dooray-bot.png" \
  "Zabbix" \
  "NOTIHELLO" \
  "https://hook.dooray.com/services/{DOORAY_SERVICEID}/{DOORAY_ROOMID}"
```

## 참고
- 실제 운영에서는 webhook URL을 secret/vault 등으로 분리하세요.
