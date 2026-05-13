## Сборка и публикация образа

Перед пушем образа необходимо авторизоваться:

```bash
# Авторизация
docker login gitlab.site:5050

# Сборка образа
docker build --provenance=false -t bpmsoft-deploy-image:latest .

# Тегирование образа
docker tag bpmsoft-deploy-image:latest gitlab.site:5050/bpmsoft/bpmsoft-deploy-image:latest

# Публикация образа в GitLab Registry
docker push gitlab.site:5050/bpmsoft/bpmsoft-deploy-image:latest
```

## Использование в GitLab CI/CD

1. В проекте, в который был запушен образ, необходимо в настройках **Project access tokens** создать новый токен со scope *read_api*.  
2. Скопировать полученный токен.  
3. В проекте с пайплайном создать новую переменную конвейера **DOCKER_AUTH_CONFIG** со значением:

```json
{"auths":{"site:5050":{"auth":"<base64-строка>"}}}
```

где `auth` — это строка в формате Base64, закодированная из пары:  
```
gitlab-ci-token:token
```

Таким образом, пайплайн сможет авторизоваться в реестре и использовать образ.

Пример `.gitlab-ci.yml`:

```yaml
stages:
  - test

run_tool:
  stage: test
  image: gitlab.site:5050/bpmsoft/bpmsoft-deploy-image:latest
  script:
    - /usr/bin/ubs help
```
