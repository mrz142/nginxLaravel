<?php
$cfg['Servers'][1]['auth_type'] = 'cookie'; // هر بار یوزر و پسورد می‌خواد
$cfg['Servers'][1]['host'] = 'mysql';       // نام سرویس دیتابیس در docker-compose
$cfg['Servers'][1]['compress'] = false;
$cfg['Servers'][1]['AllowNoPassword'] = false; // بدون رمز اجازه نده
