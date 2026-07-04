<?php
declare(strict_types=1);

require __DIR__ . '/config.php';

$data = request_data();
$deviceId = trim((string)($data['device_id'] ?? $_GET['device_id'] ?? ''));
$apiKey = trim((string)($data['api_key'] ?? $_GET['api_key'] ?? ''));
$uid = normalize_uid((string)($data['uid'] ?? $_GET['uid'] ?? ''));

if ($deviceId === '' || $uid === '') {
    json_error('device_id_uid_required');
}
if (!valid_device($deviceId, $apiKey)) {
    json_error('unauthorized', 401);
}

touch_device($deviceId);

$userStmt = db()->prepare("SELECT name, uid, status FROM users WHERE uid = ? LIMIT 1");
$userStmt->bind_param('s', $uid);
$userStmt->execute();
$user = $userStmt->get_result()->fetch_assoc();

$decision = 'DENIED';
$reason = 'user_not_found';

if ($user) {
    $active = strtolower((string)$user['status']) === 'active';
    $reason = $active ? 'no_access' : 'user_inactive';
    if ($active) {
        $access = db()->prepare('SELECT 1 FROM access_control WHERE user_uid = ? AND device_id = ? LIMIT 1');
        $access->bind_param('ss', $uid, $deviceId);
        $access->execute();
        if ($access->get_result()->num_rows > 0) {
            $decision = 'GRANTED';
            $reason = 'access_ok';
        }
    }
}

$deviceStmt = db()->prepare('SELECT device_name FROM devices WHERE device_id = ? LIMIT 1');
$deviceStmt->bind_param('s', $deviceId);
$deviceStmt->execute();
$device = $deviceStmt->get_result()->fetch_assoc();

$deviceName = (string)($device['device_name'] ?? $deviceId);
$userName = $user['name'] ?? null;
$method = 'rfid';
$log = db()->prepare(
    'INSERT INTO logs (device_id, device_name, name, uid, status, method)
     VALUES (?, ?, ?, ?, ?, ?)'
);
$log->bind_param('ssssss', $deviceId, $deviceName, $userName, $uid, $decision, $method);
$log->execute();

json_ok([
    'decision' => $decision,
    'reason' => $reason,
    'user' => ['name' => $user['name'] ?? '', 'uid' => $uid],
]);
