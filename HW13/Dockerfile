FROM wordpress:6.5-php8.2

# Устанавливаем зависимости
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем OpenTelemetry PHP расширение
RUN pecl install opentelemetry-1.0.0beta3

# Создаем директории
RUN mkdir -p /var/www/html/wp-content/mu-plugins \
    && mkdir -p /var/www/html/wp-content/snippets

# Копируем конфигурацию PHP (БЕЗ дублирования расширения)
COPY opentelemetry.ini /usr/local/etc/php/conf.d/opentelemetry.ini

# Устанавливаем права
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html
