## to install laravel Run this
######  docker-compose run --rm composer create-project --prefer-dist laravel/laravel .
## to install your own laravel project Run this
######  cd src
######  git clone https://github.com/username/repository.git .
######  cd ..
######  docker-compose run --rm composer install
######  docker-compose run --rm npm install
#####  generate .env file from .env.example and paste this in it
###### DB_CONNECTION=mysql
###### DB_HOST=mysql
###### DB_PORT=3306
###### DB_DATABASE=laraveldb
###### DB_USERNAME=root
###### DB_PASSWORD=secret
######  docker-compose run --rm artisan key:generate
######  docker-compose run --rm artisan migrate

## if you have problem with laravel ==> 
#### file_put_contents(/var/www/html/laravel/storage/framework/views/823ba0f21fb92d4957f115f907d5ac44.php): Failed to open stream: Permission denied
#### inter this comond in php container 
###### docker exec -it php /bin/sh
###### chmod -R gu+w storage
###### chmod -R guo+w storage
###### php artisan cache:clear
## if you have problem with laravel ==> Internal Server Error
#### Illuminate\Database\QueryException
#### SQLSTATE[HY000]: General error: 8 attempt to write a readonly database (Connection: sqlite, SQL: update "sessions" set "payload" = YTozOntzOjY6Il90b2tlbiI7czo0MDoiYkZCd094ZmN6TzBtMzFtNW42Rk9aS3JVNnJLblJVbk9FSWU0alYzNyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MTY6Imh0dHA6Ly9sb2NhbGhvc3QiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19, "last_activity" = 1733811449, "user_id" = ?, "ip_address" = 172.19.0.1, "user_agent" = Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36, "id" = rJNbpc0o2TTRzT7rvTiyoaRc0KEGVBt6eHI85JC2 where "id" = rJNbpc0o2TTRzT7rvTiyoaRc0KEGVBt6eHI85JC2)
###### correct .env file if the error occurred again run the in php container : 
###### chmod -R 775 database/
###### chown -R www-data:www-data database/

## to inter artisan commond you can write this
###### docker-compose run --rm artisan ...
## for example : 
###### docker-compose run --rm artisan migrate

## to inter npm commond you can write this
###### docker-compose run --rm npm ...
## for example : 
###### docker-compose run --rm npm install
