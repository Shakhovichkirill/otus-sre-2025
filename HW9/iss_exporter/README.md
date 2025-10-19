# HW9

Получите ответ от API http://open-notify.org/Open-Notify-API/ISS-Location-Now/ и сконвертируйте его в формат Prometheus

# Выполнено

Написан iss_https_exporter.py -  сервис, который отдает значения место положения космической станции в Prometheus формате

Выполнена сборка Docker образа и запущен контейнер.

```
docker build -t iss-http-exporter .
docker run -d -p 8000:8000 --name iss-http-exporter iss-http-exporter
```

# Результат

```
curl http://localhost:8000/metrics
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

