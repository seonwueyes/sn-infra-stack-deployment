## 계정 정보

계정 정보

```
admin / admin123!
```

## 도커 재구성 구성하기

### 이미지 다시 만들면서 올리기(Dockerfile이 있는 서비스의 이미지를 다시 빌드)

```bash
docker-compose up -d --build
```

## 이슈 정리

### 젠킨스에서 gitlab의 소스를 못땡기는 이유(CA 이슈)

```bash
git config --global http.sslVerify false
```

### root로 실행되어 jenkins_home 권한 오류가 있을 때

```bash
chown -R 1000:1000 /your/host/jenkins_home
```

### 메모리 부족으로 죽을때 Memory Resource Upgrade 가이드

> 메모리 부분 수정하고 아래 내용을 수행한다.

- 실행중인 컨테이너 중지

```bash
docker stop sn-front-jenkins
```

- 의존성까지는 건드리지 말고 이미지만 강제로 재생성해서 올려라.

```bash
docker-compose up -d --no-deps --force-recreate sn-front-jenkins
```
