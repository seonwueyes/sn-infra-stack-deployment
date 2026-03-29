# SN-INFRA-ZABBIX

순차적으로 실행해 Zabbix를 구성합니다. (1번부터 순서대로)

## 사전 준비
- Docker / Docker Compose 설치
- 공용 네트워크 생성
```bash
docker network create scm-network
```

## 1. DB 구성
```bash
cd sn-zabbix-01-db
docker compose -f docker-compose.yml up -d
```
- DB 계정/비밀번호는 `sn-zabbix-01-db/.env`에서 관리
- DB 백업/복구는 아래 문서를 참고:
  `sn-zabbix-01-db/README.md`

## 2. Java Gateway 구성
```bash
cd sn-zabbix-02-gateway
docker compose -f docker-compose.yml up -d
```

## 3. Zabbix Server 구성
```bash
cd sn-zabbix-03-server
docker compose -f docker-compose.yml up -d --build
```

## 4. Zabbix Web(Nginx) 구성
```bash
cd sn-zabbix-04-web-nginx
docker compose -f docker-compose.yml up -d
```

## 5. (선택) Agent 구성
```bash
cd sn-zabbix-agent
docker compose -f docker-compose.yml up -d
```

## 접속 정보
- Web UI: `http://<HOST>:10030`
- 기본 로그인: `Admin` / `zabbix`

## 종료
```bash
# 각 디렉터리에서
# docker compose -f docker-compose.yml down
```
