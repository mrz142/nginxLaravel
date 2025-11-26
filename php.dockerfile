###################################
# Stage 2: PHP-FPM (Laravel)
###################################
# استفاده از نسخه 3.18 (پایدارترین حالت)
FROM php:8.2-fpm-alpine3.18 AS php

# تغییر میرور به یک سرور جایگزین و سپس نصب پکیج‌ها
RUN sed -i 's/dl-cdn.alpinelinux.org/uk.alpinelinux.org/g' /etc/apk/repositories && \
    mkdir -p /var/www/html && \
    apk --no-cache add shadow postgresql-dev && \
    usermod -u 1000 www-data && \
    docker-php-ext-install pdo pdo_mysql mysqli pcntl pdo_pgsql

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