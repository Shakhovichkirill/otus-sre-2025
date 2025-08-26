# HW6

1.Собрать образ репозитория https://github.com/OtusTeam/sre-image;
2.Сохранить журнал сборки.

# Выполнено

```
podman build -v $PWD/requirements.txt:/app/requirements.txt:z -t otus-app:v1.0 .
```

# Результат

Файл лога log.txt

Вывод podman images

```
REPOSITORY                TAG          IMAGE ID      CREATED        SIZE
localhost/otus-app        v1.0         ca3acd9cca75  6 minutes ago  161 MB
docker.io/library/python  3.11.4-slim  596e0d6b34df  2 years ago    156 MB
```

