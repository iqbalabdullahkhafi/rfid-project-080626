<?php
declare(strict_types=1);

require __DIR__ . '/config.php';

$result = db()->query(
    "SELECT u.id, u.name, u.uid, u.role, u.status,
            GROUP_CONCAT(ac.device_id ORDER BY ac.device_id SEPARATOR ',') AS access_doors
     FROM users u
     LEFT JOIN access_control ac ON ac.user_uid = u.uid
     WHERE u.uid IS NOT NULL AND u.uid <> ''
     GROUP BY u.id, u.name, u.uid, u.role, u.status
     ORDER BY u.name"
);

json_ok(['data' => $result->fetch_all(MYSQLI_ASSOC)]);
