FROM php:8.2-fpm-alpine

RUN mkdir -p /var/www/html && apk --no-cache add shadow && usermod -u 1000 www-data && docker-php-ext-install pdo pdo_mysql mysqli

RUN apk --no-cache add pcre-dev ${PHPIZE_DEPS} \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del pcre-dev ${PHPIZE_DEPS}
# ADD ./src/ /var/www/html
