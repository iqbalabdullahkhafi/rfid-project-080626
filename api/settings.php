<?php
declare(strict_types=1);

require __DIR__ . '/config.php';

$deviceId = trim((string)($_GET['device_id'] ?? ''));
$apiKey = trim((string)($_GET['api_key'] ?? ''));

if ($deviceId !== '' && !valid_device($deviceId, $apiKey)) {
    json_error('unauthorized', 401);
}
if ($deviceId !== '') {
    touch_device($deviceId);
}

json_ok(['mode' => setting('mode', 'online')]);
