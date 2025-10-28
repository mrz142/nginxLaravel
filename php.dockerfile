###################################
# Stage 2: PHP-FPM (Laravel)
###################################
FROM php:8.2-fpm-alpine AS php

# ساخت مسیر پروژه و افزودن ابزارهای مورد نیاز
RUN mkdir -p /var/www/html && \
    apk --no-cache add shadow && \
    usermod -u 1000 www-data && \
    docker-php-ext-install pdo pdo_mysql mysqli pcntl

# نصب Redis، Git، Zip و ابزارهای موردنیاز
RUN apk --no-cache add zip unzip git curl pcre-dev $PHPIZE_DEPS && \
    pecl install redis && \
    docker-php-ext-enable redis && \
    apk del pcre-dev $PHPIZE_DEPS

# نصب composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# تنظیم دسترسی‌ها برای لاراول
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# استفاده از کاربر غیر root
USER www-data

WORKDIR /var/www/html

# اگر خواستی سورس پروژه را در build اضافه کنی (در حالت dev معمولاً bind mount داریم)
# ADD ./src/ /var/www/html