FROM php:8.2-fpm-alpine

# ایجاد دایرکتوری پروژه و تنظیمات اولیه
RUN mkdir -p /var/www/html && \
    apk --no-cache add shadow && \
    usermod -u 1000 www-data && \
    docker-php-ext-install pdo pdo_mysql mysqli pcntl

# نصب Redis، Git، Zip و ابزارهای موردنیاز دیگر
RUN apk --no-cache add \
    zip unzip git curl \
    pcre-dev $PHPIZE_DEPS && \
    pecl install redis && \
    docker-php-ext-enable redis && \
    apk del pcre-dev $PHPIZE_DEPS

    # نصب composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# (اختیاری) اگر خواستی سورس پروژه رو اضافه کنی:
# ADD ./src/ /var/www/html
