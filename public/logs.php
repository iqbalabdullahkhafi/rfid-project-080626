<?php
declare(strict_types=1);

require_once dirname(__DIR__) . '/app/auth.php';
require_login();

$page = 'logs';
$q = trim((string)($_GET['q'] ?? ''));
$status = strtoupper(trim((string)($_GET['status'] ?? '')));
$method = strtolower(trim((string)($_GET['method'] ?? '')));

$where = [];
$params = [];
$types = '';

if ($q !== '') {
    if (preg_match('/^\d{4}-\d{2}-\d{2}$/', $q)) {
        $where[] = 'DATE(time) = ?';
        $params[] = $q;
        $types .= 's';
    } else {
        $where[] = '(device_name LIKE ? OR name LIKE ? OR uid LIKE ?)';
        $like = "%{$q}%";
        array_push($params, $like, $like, $like);
        $types .= 'sss';
    }
}
if (in_array($status, ['GRANTED', 'DENIED'], true)) {
    $where[] = 'status = ?';
    $params[] = $status;
    $types .= 's';
}
if (in_array($method, ['rfid', 'web'], true)) {
    $where[] = 'method = ?';
    $params[] = $method;
    $types .= 's';
}

$sql = 'SELECT time AS created_at, device_name, name AS user_name, uid, status, method FROM logs';
if ($where) {
    $sql .= ' WHERE ' . implode(' AND ', $where);
}
$sql .= ' ORDER BY time DESC LIMIT 80';

$stmt = db()->prepare($sql);
if ($params) {
    $stmt->bind_param($types, ...$params);
}
$stmt->execute();
$logs = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
?>
<!doctype html>
<html lang="id">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Access Log - RFID Door Access</title>
  <link rel="icon" href="assets/icons/ikonwebsite.png" type="image/png">
  <link rel="stylesheet" href="assets/css/app.css">
  <style>
    .nav-icon {
      width: 18px;
      height: 18px;
      vertical-align: middle;
      margin-right: 10px;
      position: relative;
      top: -1px;
    }
  </style>
</head>
<body>
<div class="app">
  <aside class="sidebar">
    <div class="brand">
      <strong>Smart Door Security System</strong>
    </div>
    <nav>
      <a href="index.php"><img src="assets/icons/grid-svgrepo-com.svg" class="nav-icon" alt="CP"> <span>Control Panel</span></a>
      <a class="active" href="logs.php"><img src="assets/icons/book-svgrepo-com.svg" class="nav-icon" alt="Log"> <span>Access Log</span></a>
      <a href="settings.php"><img src="assets/icons/settings-svgrepo-com.svg" class="nav-icon" alt="Set"> <span>Settings</span></a>
      <a href="logout.php" data-confirm="Apakah Anda yakin ingin logout?"><img src="assets/icons/logout-svgrepo-com.svg" class="nav-icon" alt="Out"> <span>Logout</span></a>
    </nav>
  </aside>

  <main class="content">
    <header class="page-header compact">
      <div><h1>Access Log</h1><p>Riwayat aktivitas akses RFID dan remote unlock.</p></div>
    </header>

    <form class="filters" method="get">
      <input name="q" value="<?= e($q) ?>" placeholder="Cari UID / Nama / Pintu">
      <select name="status">
        <option value="">Semua Status</option>
        <option value="GRANTED" <?= $status === 'GRANTED' ? 'selected' : '' ?>>Granted</option>
        <option value="DENIED" <?= $status === 'DENIED' ? 'selected' : '' ?>>Denied</option>
      </select>
      <select name="method">
        <option value="">Semua Metode</option>
        <option value="rfid" <?= $method === 'rfid' ? 'selected' : '' ?>>RFID</option>
        <option value="web" <?= $method === 'web' ? 'selected' : '' ?>>WEB</option>
      </select>
      <button class="btn outline">Filter</button>
      <a class="btn outline" href="logs.php">Reset</a>
    </form>

    <section class="card">
      <h2>Riwayat Akses</h2>
      <div class="table-wrap log-table">
        <table>
          <thead><tr><th>Waktu</th><th>Pintu</th><th>User</th><th>UID RFID</th><th>Status</th><th>Metode</th></tr></thead>
          <tbody>
          <?php foreach ($logs as $log): ?>
            <tr>
              <td><?= e($log['created_at']) ?></td>
              <td><?= e($log['device_name'] ?: '-') ?></td>
              <td><?= e($log['user_name'] ?: 'Unknown User') ?></td>
              <td><code><?= e($log['method'] === 'web' ? '-' : ($log['uid'] ?: '-')) ?></code></td>
              <td><span class="pill <?= strtolower((string)$log['status']) ?>"><?= e($log['status']) ?></span></td>
              <td><span class="source <?= e($log['method']) ?>"><?= strtoupper(e($log['method'])) ?></span></td>
            </tr>
          <?php endforeach; ?>
          <?php if (!$logs): ?><tr><td colspan="6" class="empty">Riwayat akses belum tersedia.</td></tr><?php endif; ?>
          </tbody>
        </table>
      </div>
    </section>
  </main>
</div>
<script src="assets/js/app.js"></script>
</body>
</html>
