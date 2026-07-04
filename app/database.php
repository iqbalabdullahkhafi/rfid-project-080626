<?php
declare(strict_types=1);

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

$appConfig = require dirname(__DIR__) . '/config/app.php';
date_default_timezone_set((string)($appConfig['timezone'] ?? 'Asia/Jakarta'));

function db(): mysqli
{
    static $connection = null;
    if ($connection instanceof mysqli) {
        return $connection;
    }

    $config = require dirname(__DIR__) . '/config/database.php';
    $ports = array_values(array_unique(array_map('intval', $config['ports'] ?? [3306])));
    $lastError = 'Database tidak dapat terhubung.';

    foreach ($ports as $port) {
        try {
            $connection = new mysqli(
                (string)$config['host'],
                (string)$config['user'],
                (string)$config['password'],
                (string)$config['database'],
                $port
            );
            $connection->set_charset('utf8mb4');
            $connection->query("SET time_zone = '+07:00'");
            return $connection;
        } catch (Throwable $error) {
            $lastError = $error->getMessage();
        }
    }

    throw new RuntimeException($lastError);
}
