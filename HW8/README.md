# HW8

Создать helm-chart деплоймента для приложения: https://github.com/OtusTeam/sre-app

# Выполнено

Предварительно выполнен сбор Docker-образов. sre-app/build-images.sh - подготовлен скрипт для создания образов приложений и отправку в Docker репозиторий. 


Далее написан Helm-chart для деплоя двух сервисов прилоежния (Flask и go-приложения).

Выполнен деплой приложений, также сервисы опубликованы через ingress.

Установка Helm-chart:

```
kubectl create ns sre-app

helm upgrade --install sre-app ./sre-app-chart -n sre-app --atomic --debug
```

# Результат

Проверка работоспособности приложения:

```
curl http://sre-app.example.com/health

{
  "status": "OK"
}
```

```
curl -i -u admin:password123 http://sre-app.example.com/admin


HTTP/1.1 200 OK
Date: Sun, 21 Sep 2025 18:51:11 GMT
Content-Type: application/json
Content-Length: 110
Connection: keep-alive

{
  "app": "Go app",
  "hostname": "sre-app-go-69b8786f49-qgqfz",
  "version": "1.0.0",
  "zone": "private"
}
```

```
curl -i -u admin:password123 http://sre-app.example.com/metrics


HTTP/1.1 200 OK
Date: Sun, 21 Sep 2025 18:57:48 GMT
Content-Type: text/plain; charset=utf-8
Content-Length: 2771
Connection: keep-alive

# HELP python_gc_objects_collected_total Objects collected during gc
# TYPE python_gc_objects_collected_total counter
python_gc_objects_collected_total{generation="0"} 20331.0
python_gc_objects_collected_total{generation="1"} 2299.0
python_gc_objects_collected_total{generation="2"} 0.0
# HELP python_gc_objects_uncollectable_total Uncollectable objects found during GC
# TYPE python_gc_objects_uncollectable_total counter
python_gc_objects_uncollectable_total{generation="0"} 0.0
python_gc_objects_uncollectable_total{generation="1"} 0.0
python_gc_objects_uncollectable_total{generation="2"} 0.0
```


Вывод метрик

```
# HELP iss_timestamp UNIX timestamp of ISS position data
# TYPE iss_timestamp gauge
iss_timestamp 1758444404
# HELP iss_latitude Latitude coordinate of ISS
# TYPE iss_latitude gauge
iss_latitude -46.0881
# HELP iss_longitude Longitude coordinate of ISS
# TYPE iss_longitude gauge
iss_longitude 2.8128
```

