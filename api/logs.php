<?php
declare(strict_types=1);

require __DIR__ . '/config.php';

$result = db()->query(
    'SELECT id, time AS created_at, device_name, name AS user_name, uid, status, method
     FROM logs
     ORDER BY time DESC
     LIMIT 80'
);

json_ok(['data' => $result->fetch_all(MYSQLI_ASSOC)]);
