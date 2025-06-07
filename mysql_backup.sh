#!/bin/bash

# تنظیمات
CONTAINER_NAME="mysql"         # نام کانتینر MySQL
BACKUP_DIR="./mysql_backup"   # مسیر ذخیره بک‌آپ‌ها در لوکال
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
FILENAME="backup_$DATE.sql"

# ساخت پوشه بک‌آپ اگر وجود نداشت
mkdir -p $BACKUP_DIR

# اجرای بک‌آپ داخل کانتینر و ذخیره در لوکال
docker exec $CONTAINER_NAME sh -c 'exec mysqldump -uroot -p"$MYSQL_ROOT_PASSWORD" laraveldb' > $BACKUP_DIR/$FILENAME

# حذف بک‌آپ‌های قدیمی‌تر از 7 روز
find $BACKUP_DIR -type f -name "*.sql" -mtime +7 -exec rm {} \;

echo "✅ بک‌آپ گرفته شد: $FILENAME"
