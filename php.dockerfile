###################################
# Stage 2: PHP-FPM (Laravel)
###################################
FROM php:8.2-fpm-alpine3.20 AS php

# ساخت مسیر پروژه و افزودن ابزارهای مورد نیاز
RUN mkdir -p /var/www/html && \
    usermod -u 1000 www-data

# نصب وابستگی‌ها و کامپایل اکستنشن‌ها
RUN apk add --no-cache \
    shadow \
    zip unzip git curl \
    pcre-dev $PHPIZE_DEPS \
    postgresql-dev \
    && docker-php-ext-install pdo pdo_mysql mysqli pcntl pdo_pgsql \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del $PHPIZE_DEPS

# نصب composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# تنظیم دسترسی‌ها
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

USER www-data
WORKDIR /var/www/html