<?php
declare(strict_types=1);

require __DIR__ . '/config.php';

$result = db()->query(
    "SELECT device_id, device_name, last_seen,
            IF(last_seen IS NOT NULL AND TIMESTAMPDIFF(SECOND, last_seen, NOW()) <= 20, 'ONLINE', 'OFFLINE') AS status
     FROM devices
     ORDER BY device_name"
);

json_ok(['data' => $result->fetch_all(MYSQLI_ASSOC)]);
