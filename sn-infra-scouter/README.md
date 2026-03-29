# 스카우터 서버 실행

상위 디렉터리의 `docker-compose.yml`로 Scouter Server와 Paper를 한 번에 올립니다.

```bash
docker-compose up -d
```

버전은 `.env`에 정의되어 있습니다.

본 구성은 Scouter 오픈소스 프로젝트의 내용을 기반으로 작성되었습니다.

## 커스터마이징 가이드

기본 실행은 상위 `docker-compose.yml`을 그대로 쓰는 방식입니다.
버전 변경이나 `scouter.conf` 튜닝 등 커스터마이징이 필요하면 하위 `scouter-server`에서 수정 후
이미지를 빌드해서 사용하세요.

1. 하위 디렉터리 이동

```bash
cd scouter-server
```

2. 설정/버전 수정

- `scouter.conf`의 값은 `startup.sh`에서 환경변수로 치환됩니다.
- `Dockerfile`의 `SCOUTER_VERSION`으로 서버 버전을 고정/변경할 수 있습니다.

3. 이미지 빌드 및 실행

```bash
docker-compose up -d --build
```
