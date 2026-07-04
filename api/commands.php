<?php
declare(strict_types=1);

require __DIR__ . '/config.php';

$action = (string)($_GET['action'] ?? $_POST['action'] ?? 'poll');
$data = request_data();

if ($action === 'create') {
    require_once dirname(__DIR__) . '/app/auth.php';
    require_login();
    verify_csrf();

    $deviceId = trim((string)($data['device_id'] ?? ''));
    if (!preg_match('/^[A-Za-z0-9_-]{1,64}$/', $deviceId)) {
        json_error('invalid_device_id');
    }

    $clear = db()->prepare('DELETE FROM commands WHERE device_id = ? AND consumed_at IS NULL');
    $clear->bind_param('s', $deviceId);
    $clear->execute();

    $command = 'OPEN';
    $stmt = db()->prepare('INSERT INTO commands (device_id, command) VALUES (?, ?)');
    $stmt->bind_param('ss', $deviceId, $command);
    $stmt->execute();
    json_ok(['message' => 'command_created']);
}

$deviceId = trim((string)($_GET['device_id'] ?? ''));
$apiKey = trim((string)($_GET['api_key'] ?? ''));
if ($deviceId === '' || !valid_device($deviceId, $apiKey)) {
    json_error('unauthorized', 401);
}

touch_device($deviceId);

$stmt = db()->prepare(
    'SELECT id, device_id, command, payload, created_at
     FROM commands
     WHERE device_id = ? AND consumed_at IS NULL
     ORDER BY created_at ASC, id ASC
     LIMIT 1'
);
$stmt->bind_param('s', $deviceId);
$stmt->execute();
$row = $stmt->get_result()->fetch_assoc();

if (!$row) {
    json_response(['command' => 'NONE']);
}

$id = (int)$row['id'];
$update = db()->prepare('UPDATE commands SET consumed_at = NOW() WHERE id = ?');
$update->bind_param('i', $id);
$update->execute();

json_response([
    'device_id' => $row['device_id'],
    'command' => $row['command'],
    'payload' => $row['payload'],
    'created_at' => $row['created_at'],
]);
