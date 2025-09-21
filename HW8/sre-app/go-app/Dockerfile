FROM golang:1.21-alpine

WORKDIR /app

# Установка системных зависимостей
RUN apk add --no-cache \
    curl \
    git

# Копирование исходного кода
COPY main.go .

# Сборка приложения
RUN go mod init sre-go-app && \
    go mod tidy && \
    go build -o main .

# Создание минимального образа
FROM alpine:3.18

WORKDIR /app

# Установка необходимых пакетов
RUN apk add --no-cache ca-certificates

# Копирование бинарника из builder stage
COPY --from=0 /app/main .

# Создание non-root пользователя
RUN adduser -D -u 1000 appuser && \
    chown -R appuser:appuser /app
USER appuser

# Открываем порт приложения
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/healthz || exit 1

# Запуск приложения
CMD ["./main"]