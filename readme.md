## to install laravel Run this
 docker-compose run --rm composer create-project --prefer-dist laravel/laravel .
## to install your own laravel project Run this
 cd src
 git clone https://github.com/username/repository.git .
 cd ..
 docker-compose run --rm composer install
 docker-compose run --rm npm install
#####  generate .env file from .env.example and paste this in it
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=laraveldb
DB_USERNAME=root
DB_PASSWORD=secret
 docker-compose run --rm artisan key:generate
 docker-compose run --rm artisan migrate

## if you have problem with laravel ==> 
#### file_put_contents(/var/www/html/laravel/storage/framework/views/823ba0f21fb92d4957f115f907d5ac44.php): Failed to open stream: Permission denied
#### inter this comond in php container 
docker exec -it php /bin/sh
chmod -R gu+w storage
chmod -R guo+w storage
php artisan cache:clear
## if you have problem with laravel ==> Internal Server Error
#### Illuminate\Database\QueryException
#### SQLSTATE[HY000]: General error: 8 attempt to write a readonly database (Connection: sqlite, SQL: update "sessions" set "payload" = YTozOntzOjY6Il90b2tlbiI7czo0MDoiYkZCd094ZmN6TzBtMzFtNW42Rk9aS3JVNnJLblJVbk9FSWU0alYzNyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MTY6Imh0dHA6Ly9sb2NhbGhvc3QiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19, "last_activity" = 1733811449, "user_id" = ?, "ip_address" = 172.19.0.1, "user_agent" = Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36, "id" = rJNbpc0o2TTRzT7rvTiyoaRc0KEGVBt6eHI85JC2 where "id" = rJNbpc0o2TTRzT7rvTiyoaRc0KEGVBt6eHI85JC2)
correct .env file if the error occurred again run the in php container : 
chmod -R 775 database/
chown -R www-data:www-data database/

## to inter artisan commond you can write this
docker-compose run --rm artisan ...
## for example : 
docker-compose run --rm artisan migrate

## to inter npm commond you can write this
docker-compose run --rm npm ...
## for example : 
docker-compose run --rm npm install

# mosquitto
```
docker-compose up -d
```
#
```
docker exec -it mosquitto sh
```
#
```
mosquitto_passwd -c /mosquitto/config/pwfile user1
```


#### https://grok.com/share/bGVnYWN5_11003b2b-acfc-4856-9981-fe3d9cbf3978

## Run this 
```   
composer require php-mqtt/client
npm install mqtt
```
## paste this to .env file
```
 MQTT_BROKER_HOST=broker.emqx.io
MQTT_BROKER_PORT=1883
MQTT_USERNAME=emqx_user
MQTT_PASSWORD=public
MQTT_CLIENT_ID=mqtt_laravel_client
```
## create mqtt.php in config folder and paste this to it
```
// config/mqtt.php
return [
    'host' => env('MQTT_BROKER_HOST', 'broker.emqx.io'),
    'port' => env('MQTT_BROKER_PORT', 1883),
    'username' => env('MQTT_USERNAME', ''),
    'password' => env('MQTT_PASSWORD', ''),
    'client_id' => env('MQTT_CLIENT_ID', 'laravel_client_'.rand(5, 15)),
];
```
## in terminall
```
php artisan make:service MqttService
```
## paste this on it 
```
<?php

namespace App\Services;

use PhpMqtt\Client\MqttClient;
use PhpMqtt\Client\ConnectionSettings;

class MqttService
{
    protected $mqtt;

    public function __construct()
    {
        $config = config('mqtt');

        // تنظیمات اتصال
        $connectionSettings = (new ConnectionSettings)
            ->setUsername($config['username'])
            ->setPassword($config['password'])
            ->setKeepAliveInterval(30) // 30 ثانیه
            ->setConnectTimeout(3)
            ->setLastWillTopic('laravel/mqtt/status') // تاپیک LWT
            ->setLastWillMessage(json_encode(['status' => 'disconnected'])) // پیام LWT
            ->setLastWillQualityOfService(1); // QoS برای LWT

        // ایجاد کلاینت MQTT
        $this->mqtt = new MqttClient(
            $config['host'],
            $config['port'],
            $config['client_id'],
            MqttClient::MQTT_3_1_1
        );

        // اتصال به بروکر
        try {
            $this->mqtt->connect($connectionSettings, true);
        } catch (\Exception $e) {
            \Log::error("MQTT Connection failed: " . $e->getMessage());
            throw $e;
        }
    }

    public function subscribe($topic, callable $callback, $qos = 1)
    {
        // اشتراک در تاپیک با QoS مشخص‌شده
        $this->mqtt->subscribe($topic, $callback, $qos);
        $this->mqtt->loop(true);
    }

    public function publish($topic, $message, $qos = 1)
    {
        // انتشار پیام با QoS مشخص‌شده
        $this->mqtt->publish($topic, $message, $qos);
    }

    public function __destruct()
    {
        // قطع اتصال هنگام تخریب شیء
        $this->mqtt->disconnect();
    }
}
```
## دلخواه
## in terminal 
```
php artisan make:controller MqttController
```
paste this on it
```
<?php

namespace App\Http\Controllers;

use App\Services\MqttService;
use Illuminate\Http\Request;

class MqttController extends Controller
{
    protected $mqttService;

    public function __construct(MqttService $mqttService)
    {
        $this->mqttService = $mqttService;
    }

    public function publish(Request $request)
    {
        $topic = $request->input('topic', 'laravel/mqtt');
        $message = $request->input('message', json_encode([
            'from' => 'Laravel',
            'date' => now()->toDateTimeString(),
        ]));

        $ StaffordshireService->publish($topic, $message);

        return response()->json(['status' => 'Message published']);
    }

    public function subscribe()
    {
        $topic = 'laravel/mqtt';

        $this->mqttService->subscribe($topic, function ($topic, $message) {
            echo "Received message on topic [$topic]: $message\n";
        });

        return response()->json(['status' => 'Subscribed to topic']);
    }
}
```
on the api file
```
// routes/api.php
use App\Http\Controllers\MqttController;

Route::post('/mqtt/publish', [MqttController::class, 'publish']);
Route::get('/mqtt/subscribe', [MqttController::class, 'subscribe']);
```
for react 
```
import { useState, useEffect, useCallback } from 'react';
import mqtt from 'mqtt';

const Lamp = ({ lamp }) => {
    const [isOn, setIsOn] = useState(lamp.is_on);
    const [client, setClient] = useState(null);
    const [connectionStatus, setConnectionStatus] = useState('disconnected');

    const mqttOptions = {
        clientId: `lamp_${lamp.id}_${Math.random().toString(16).slice(3)}`,
        reconnectPeriod: 1000,
        connectTimeout: 30 * 1000,
        username: 'your_mqtt_username', // Replace with your MQTT username
        password: 'your_mqtt_password', // Replace with your MQTT password
    };

    const toggleLamp = useCallback(() => {
        if (client && connectionStatus === 'connected') {
            const newState = !isOn;
            const topic = `lamps/${lamp.id}/state`;
            client.publish(topic, newState ? '1' : '0', { qos: 1 }, (err) => {
                if (!err) {
                    setIsOn(newState);
                    // Inertia.post(`/lamps/${lamp.id}/toggle`);
                } else {
                    console.error('Failed to publish MQTT message:', err);
                }
            });
        }
    }, [client, isOn, connectionStatus, lamp.id]);

    useEffect(() => {
        const mqttClient = mqtt.connect('ws://127.0.0.1:9001', mqttOptions);

        mqttClient.on('connect', () => {
            setConnectionStatus('connected');
            const topic = `lamps/${lamp.id}/state`;
            mqttClient.subscribe(topic, { qos: 1 }, (err) => {
                if (err) {
                    console.error('Subscribe error:', err);
                }
            });
        });

        mqttClient.on('message', (topic, message) => {
            const state = message.toString() === '1';
            setIsOn(state);
        });

        mqttClient.on('error', (err) => {
            console.error('MQTT Error:', err);
            setConnectionStatus('error');
        });

        mqttClient.on('close', () => {
            setConnectionStatus('disconnected');
        });

        setClient(mqttClient);

        return () => {
            mqttClient.end(false, () => {
                setConnectionStatus('disconnected');
            });
        };
    }, [lamp.id]);

    return (
        <div className="bg-white shadow-md rounded-lg p-4 flex flex-col items-center">
            <div
                className={`w-16 h-16 rounded-full mb-4 ${
                    isOn ? 'bg-yellow-400' : 'bg-gray-300'
                }`}
            ></div>
            <h3 className="text-lg font-semibold">{lamp.name}</h3>
            <p className="text-sm text-gray-600">{isOn ? 'روشن' : 'خاموش'}</p>
            <p className="text-sm text-gray-600">وضعیت: {connectionStatus}</p>
            <button
                onClick={toggleLamp}
                disabled={connectionStatus !== 'connected'}
                className={`mt-4 px-4 py-2 rounded ${
                    isOn ? 'bg-red-500 hover:bg-red-600' : 'bg-green-500 hover:bg-green-600'
                } text-white ${connectionStatus !== 'connected' ? 'opacity-50 cursor-not-allowed' : ''}`}
            >
                {isOn ? 'خاموش کن' : 'روشن کن'}
            </button>
        </div>
    );
};

export default Lamp;
```
and for dashboard
```
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';
import Lamp from './Lamp';

export default function Dashboard({ lamps }) {
    return (
        <AuthenticatedLayout
            header={
                <h2 className="text-xl font-semibold leading-tight text-gray-800 dark:text-gray-200">
                    Dashboard
                </h2>
            }
        >
            <Head title="Dashboard" />

            <div className="py-12">
                <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
                    <div className="overflow-hidden bg-white shadow-sm sm:rounded-lg dark:bg-gray-800">
                        <div className="p-6 text-gray-900 dark:text-gray-100 grid grid-cols-1 md:grid-cols-3 gap-4">
                            {lamps.map((lamp) => (
                                <Lamp key={lamp.id} lamp={lamp} />
                            ))}
                        </div>
                    </div>
                </div>
            </div>
        </AuthenticatedLayout>
    );
}
```
# for backup
```
chmod +x mysql_backup.sh
```
```
crontab -e
```
paste this in the botom of the file opend
```
0 3 * * * /bin/bash /path/to/your/project/mysql_backup.sh >> /path/to/your/project/backup.log 2>&1
```