## 확장 템플릿

templates는 컨테이너를 구성할 때 커스텀 템플릿을 추가적으로 적용하기 위한 디랙토리 입니다. posixAccount로 계정을 생성할 때 필요한 필드를 추가했습니다.

먼저 기본 이미지로 컨테이너를 구성한 후 필요한 기본 템플릿을 아래의 방식으로 가져와서
커스터마이징 했습니다. 그 후 다시 컨테이너를 만들어 배포 할 때 추가됩니다.

```
예:
    docker cp <container>:/var/www/phpldapadmin/templates/creation/posixAccount.xml ./templates/posixAccount_ext.xml
    docker cp <container>:/var/www/phpldapadmin/templates/creation/posixGroup.xml ./templates/posixGroup_ext.xml
```

재배포

```bash
docker-compose up -d --build
```
