###################################
# Stage 2: PHP-FPM (Laravel)
###################################
FROM php:8.2-fpm-alpine3.20 AS php

# ایجاد ساختار پروژه
RUN mkdir -p /var/www/html

# نصب وابستگی‌ها
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

# ایجاد پوشه‌های ضروری Laravel و تنظیم دسترسی اولیه (همه چیز با root)
RUN mkdir -p \
        /var/www/html/storage/framework/{sessions,views,cache} \
        /var/www/html/storage/logs \
        /var/www/html/bootstrap/cache \
    && touch /var/www/html/storage/logs/laravel.log \
    && chown -R www-data:www-data \
        /var/www/html/storage \
        /var/www/html/bootstrap/cache \
    && chmod -R 775 \
        /var/www/html/storage \
        /var/www/html/bootstrap/cache \
    && chmod 664 /var/www/html/storage/logs/laravel.log

# تغییر کاربر به www-data برای امنیت
USER www-data

WORKDIR /var/www/html