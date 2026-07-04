<?php
declare(strict_types=1);

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store');

require_once dirname(__DIR__) . '/app/helpers.php';

function json_response(array $data, int $status = 200): never
{
    http_response_code($status);
    echo json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

function json_ok(array $data = []): never
{
    json_response(['success' => true] + $data);
}

function json_error(string $message, int $status = 400): never
{
    json_response(['success' => false, 'error' => $message], $status);
}

function request_data(): array
{
    $json = json_decode((string)file_get_contents('php://input'), true);
    return is_array($json) ? $json : $_POST;
}

function valid_device(string $deviceId, string $apiKey): bool
{
    $stmt = db()->prepare('SELECT api_key FROM devices WHERE device_id = ? LIMIT 1');
    $stmt->bind_param('s', $deviceId);
    $stmt->execute();
    $row = $stmt->get_result()->fetch_assoc();
    $stored = (string)($row['api_key'] ?? '');
    return $stored !== '' && $apiKey !== '' && hash_equals($stored, $apiKey);
}

function touch_device(string $deviceId): void
{
    $ip = (string)($_SERVER['REMOTE_ADDR'] ?? '');
    $stmt = db()->prepare("UPDATE devices SET last_seen = NOW(), last_ip = ?, status = 'ONLINE' WHERE device_id = ?");
    $stmt->bind_param('ss', $ip, $deviceId);
    $stmt->execute();
}
