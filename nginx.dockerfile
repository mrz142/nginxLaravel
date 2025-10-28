###################################
# Stage 1: Nginx
###################################
FROM nginx:stable-alpine AS nginx

# کپی تنظیمات Nginx
ADD ./nginx/default.conf /etc/nginx/conf.d/default.conf

# ساخت مسیر پروژه
RUN mkdir -p /var/www/html \
    && mkdir -p /etc/nginx/certs/mkcerts

# کپی گواهی‌ها (در صورت نیاز)
ADD ./nginx/certs/ /etc/nginx/certs/mkcerts

