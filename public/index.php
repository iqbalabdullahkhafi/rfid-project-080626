<?php
declare(strict_types=1);

require_once dirname(__DIR__) . '/app/auth.php';
require_login();

$page = 'control';
$message = flash();

if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'POST') {
    verify_csrf();
    $action = (string)($_POST['action'] ?? '');

    try {
        if ($action === 'add_door' || $action === 'edit_door') {
            $deviceId = trim((string)($_POST['device_id'] ?? ''));
            $name = trim((string)($_POST['device_name'] ?? ''));
            if (!preg_match('/^[A-Za-z0-9_-]{1,64}$/', $deviceId) || $name === '') {
                throw new RuntimeException('Data perangkat belum lengkap.');
            }

            if ($action === 'add_door') {
                $apiKey = bin2hex(random_bytes(16));
                $stmt = db()->prepare(
                    "INSERT INTO devices (device_id, api_key, device_name, name, status)
                     VALUES (?, ?, ?, ?, 'OFFLINE')"
                );
                $stmt->bind_param('ssss', $deviceId, $apiKey, $name, $name);
            } else {
                $stmt = db()->prepare('UPDATE devices SET device_name = ?, name = ? WHERE device_id = ?');
                $stmt->bind_param('sss', $name, $name, $deviceId);
            }
            $stmt->execute();
            flash('success', 'Data perangkat berhasil disimpan.');
        }

        if ($action === 'add_user' || $action === 'edit_user') {
            $id = (int)($_POST['user_id'] ?? 0);
            $name = trim((string)($_POST['name'] ?? ''));
            $userType = (string)($_POST['user_type'] ?? 'rfid');

            $uid = null;
            $username = null;
            $password = null;
            $doors = [];

            if ($userType === 'rfid' || $userType === 'both') {
                $uid = normalize_uid((string)($_POST['uid'] ?? ''));
                if ($uid === '') throw new RuntimeException('UID RFID wajib diisi untuk tipe ini.');
                $doors = array_values(array_filter(array_map('strval', $_POST['access_doors'] ?? [])));
            }
            if ($userType === 'web' || $userType === 'both') {
                $username = trim((string)($_POST['username'] ?? ''));
                if ($username === '') throw new RuntimeException('Username wajib diisi untuk tipe ini.');
                if ($action === 'add_user' || ($_POST['password'] ?? '') !== '') {
                    $newPass = (string)($_POST['password'] ?? '');
                    if (strlen($newPass) < 6) throw new RuntimeException('Password baru minimal 6 karakter.');
                    $password = password_hash($newPass, PASSWORD_DEFAULT);
                }
            }

            if ($name === '') throw new RuntimeException('Nama wajib diisi.');

            db()->begin_transaction();
            $oldUid = $uid;
            if ($action === 'add_user') {
                $stmt = db()->prepare("INSERT INTO users (name, uid, username, password, status) VALUES (?, ?, ?, ?, 'Active')");
                $stmt->bind_param('ssss', $name, $uid, $username, $password);
            } else {
                $lookup = db()->prepare('SELECT uid FROM users WHERE id = ? AND username IS NULL LIMIT 1');
                $lookup->bind_param('i', $id);
                $lookup->execute();
                $oldUid = (string)($lookup->get_result()->fetch_assoc()['uid'] ?? $uid);

                if ($password !== null) {
                    $stmt = db()->prepare("UPDATE users SET name = ?, uid = ?, username = ?, password = ? WHERE id = ?");
                    $stmt->bind_param('ssssi', $name, $uid, $username, $password, $id);
                } else {
                    $stmt = db()->prepare("UPDATE users SET name = ?, uid = ?, username = ? WHERE id = ?");
                    $stmt->bind_param('sssi', $name, $uid, $username, $id);
                }
            }
            $stmt->execute();

            // Determine the UID that was previously associated with this user (if editing)
            // This is crucial for cleaning up old access_control entries if UID changes or user type changes from RFID to WEB
            $uidToClearAccess = null;
            if ($action === 'edit_user') {
                $stmtPrevUid = db()->prepare('SELECT uid FROM users WHERE id = ? LIMIT 1');
                $stmtPrevUid->bind_param('i', $id);
                $stmtPrevUid->execute();
                $uidToClearAccess = (string)($stmtPrevUid->get_result()->fetch_assoc()['uid'] ?? null);
            }

            // Clear any access control entries associated with the previous UID
            // This ensures that if a user's UID changes, or they become a WEB-only user,
            // their old RFID access permissions are removed.
            if ($uidToClearAccess !== null) {
                $deleteOldAccess = db()->prepare('DELETE FROM access_control WHERE user_uid = ?');
                $deleteOldAccess->bind_param('s', $uidToClearAccess);
                $deleteOldAccess->execute();
            }

            // If the current user type is RFID or BOTH, and a UID is provided,
            // then insert new access control entries for the *new* UID.
            if (($userType === 'rfid' || $userType === 'both') && $uid !== null) {
                $insertNewAccess = db()->prepare('INSERT IGNORE INTO access_control (user_uid, device_id) VALUES (?, ?)');
                foreach ($doors as $doorId) {
                    if (preg_match('/^[A-Za-z0-9_-]{1,64}$/', $doorId)) {
                        $insertNewAccess->bind_param('ss', $uid, $doorId);
                        $insertNewAccess->execute();
                    }
                }
            }
            db()->commit();
            flash('success', 'Data pengguna berhasil disimpan.');
        }

        if ($action === 'delete_door') {
            $deviceId = trim((string)($_POST['device_id'] ?? ''));
            if ($deviceId === '') throw new RuntimeException('Device ID tidak valid.');
            $stmt = db()->prepare('DELETE FROM devices WHERE device_id = ?');
            $stmt->bind_param('s', $deviceId);
            $stmt->execute();
            flash('success', 'Perangkat berhasil dihapus.');
        }

        if ($action === 'delete_user') {
            $id = (int)($_POST['user_id'] ?? 0);
            if ($id <= 0) throw new RuntimeException('User ID tidak valid.');

            db()->begin_transaction();
            // Ambil UID pengguna sebelum dihapus untuk membersihkan hak akses
            $stmtUid = db()->prepare('SELECT uid FROM users WHERE id = ? LIMIT 1');
            $stmtUid->bind_param('i', $id);
            $stmtUid->execute();
            $userToDelete = $stmtUid->get_result()->fetch_assoc();

            if ($userToDelete && !empty($userToDelete['uid'])) {
                $deleteAccess = db()->prepare('DELETE FROM access_control WHERE user_uid = ?');
                $deleteAccess->bind_param('s', $userToDelete['uid']);
                $deleteAccess->execute();
            }

            $deleteUser = db()->prepare("DELETE FROM users WHERE id = ? AND username <> 'admin'");
            $deleteUser->bind_param('i', $id);
            $deleteUser->execute();
            db()->commit();
            flash('success', 'Pengguna berhasil dihapus.');
        }

        if ($action === 'regenerate_api_key') {
            $deviceId = trim((string)($_POST['device_id'] ?? ''));
            if ($deviceId === '') {
                json_error('Device ID tidak valid.');
            }
            $newApiKey = bin2hex(random_bytes(16));
            $stmt = db()->prepare('UPDATE devices SET api_key = ? WHERE device_id = ?');
            $stmt->bind_param('ss', $newApiKey, $deviceId);
            $stmt->execute();
            // Menggunakan fungsi dari app/helpers.php yang dimuat oleh api/config.php
            // Untuk konsistensi, kita bisa definisikan json_ok di helpers.php jika belum ada
            header('Content-Type: application/json; charset=utf-8');
            echo json_encode(['success' => true, 'api_key' => $newApiKey]);
            exit; // Hentikan eksekusi agar tidak terjadi redirect
        }

        if ($action === 'unlock') {
            $deviceId = trim((string)($_POST['device_id'] ?? ''));
            if (!preg_match('/^[A-Za-z0-9_-]{1,64}$/', $deviceId)) {
                throw new RuntimeException('Device ID tidak valid.');
            }

            db()->begin_transaction();
            $clear = db()->prepare('DELETE FROM commands WHERE device_id = ? AND consumed_at IS NULL');
            $clear->bind_param('s', $deviceId);
            $clear->execute();

            $command = 'OPEN';
            $cmd = db()->prepare('INSERT INTO commands (device_id, command) VALUES (?, ?)');
            $cmd->bind_param('ss', $deviceId, $command);
            $cmd->execute();

            $admin = current_user()['name'] ?? 'Administrator';
            $uid = 'WEB';
            $status = 'GRANTED';
            $method = 'web';
            $log = db()->prepare(
                "INSERT INTO logs (device_id, device_name, name, uid, status, method)
                 SELECT device_id, COALESCE(NULLIF(device_name,''), name, device_id), ?, ?, ?, ?
                 FROM devices WHERE device_id = ?"
            );
            $log->bind_param('sssss', $admin, $uid, $status, $method, $deviceId);
            $log->execute();
            db()->commit();
            flash('success', 'Perintah unlock berhasil dikirim.');
        }
    } catch (Throwable $error) {
        try { db()->rollback(); } catch (Throwable) {}
        $errorMessage = $error->getMessage();
        // Check for MySQL duplicate entry error (code 1062)
        if ($error instanceof mysqli_sql_exception && $error->getCode() === 1062) {
            // Check if the error is for the 'PRIMARY' key of the 'devices' table
            // Check if the error is for the 'PRIMARY' key (or any primary key)
            if (str_contains($errorMessage, 'for key \'PRIMARY\'')) {
                $errorMessage = 'Device ID sudah digunakan. Silakan gunakan Device ID lain.';
            }
        }
        flash('error', $errorMessage);
    }

    redirect_to('index.php');
}

$devices = db()->query(
    "SELECT device_id, device_name, api_key, last_seen
     FROM devices ORDER BY device_id ASC"
)->fetch_all(MYSQLI_ASSOC);

$users = db()->query(
    "SELECT u.id, u.name, u.uid, u.username,
            GROUP_CONCAT(COALESCE(d.device_name, ac.device_id) ORDER BY d.device_name SEPARATOR ', ') AS access_doors,
            GROUP_CONCAT(ac.device_id ORDER BY ac.device_id SEPARATOR ',') AS door_ids
     FROM users u
     LEFT JOIN access_control ac ON ac.user_uid = u.uid
     LEFT JOIN devices d ON d.device_id = ac.device_id
     WHERE u.username IS NULL OR u.username <> 'admin'
     GROUP BY u.id, u.name, u.uid, u.username
     ORDER BY u.name"
)->fetch_all(MYSQLI_ASSOC);

$onlineCount = 0;
foreach ($devices as $device) {
    if (device_status($device['last_seen'] ?? null) === 'ONLINE') {
        $onlineCount++;
    }
}
?>
<!doctype html>
<html lang="id">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Control Panel - RFID Door Access</title>
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
    .btn.danger {
      background-color: #fbebee;
      color: #c62828;
      border: 1px solid #ef9a9a;
    }
    .btn.danger:hover {
      background-color: #e53935;
      color: #fff;
      border-color: #e53935;
    }
    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 24px;
    }
    .btn.unlock:disabled {
      background-color: #e9ecef;
      border-color: #dee2e6;
      color: #6c757d;
      cursor: not-allowed;
      box-shadow: none;
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
      <a class="active" href="index.php"><img src="assets/icons/grid-svgrepo-com.svg" class="nav-icon" alt="CP"> <span>Control Panel</span></a>
      <a href="logs.php"><img src="assets/icons/book-svgrepo-com.svg" class="nav-icon" alt="Log"> <span>Access Log</span></a>
      <a href="settings.php"><img src="assets/icons/settings-svgrepo-com.svg" class="nav-icon" alt="Set"> <span>Settings</span></a>
      <a href="logout.php" data-confirm="Apakah Anda yakin ingin logout?"><img src="assets/icons/logout-svgrepo-com.svg" class="nav-icon" alt="Out"> <span>Logout</span></a>
    </nav>
  </aside>

  <main class="content">
    <?php if ($message): ?><div class="alert <?= e($message['type']) ?>"><?= e($message['message']) ?></div><?php endif; ?>

    <header class="page-header">
      <div>
        <h1>Control Panel</h1>
        <p>Kelola perangkat pintu, pengguna, dan akses sistem</p>
      </div>
    </header>

    <section class="card">
      <div class="card-header">
        <h2>Daftar Perangkat Pintu</h2>
        <button class="btn primary" data-modal="doorModal">+ Add Door</button>
      </div>
      <div class="table-wrap">
        <table>
          <thead><tr><th>Nama Perangkat</th><th>Device ID</th><th>Status Perangkat</th><th>Aksi</th></tr></thead>
          <tbody id="deviceRows">
          <?php foreach ($devices as $device): $status = device_status($device['last_seen'] ?? null); ?>
            <tr data-device-id="<?= e($device['device_id']) ?>">
              <td><strong><?= e($device['device_name']) ?></strong></td>
              <td><code><?= e($device['device_id']) ?></code></td>
              <td><span class="pill <?= strtolower($status) ?>" data-device-status><?= e($status) ?></span></td>
              <td class="actions">
                <form method="post" data-confirm-form="Kirim perintah unlock ke <?= e($device['device_name']) ?>?">
                  <input type="hidden" name="csrf_token" value="<?= e(csrf_token()) ?>">
                  <input type="hidden" name="action" value="unlock">
                  <input type="hidden" name="device_id" value="<?= e($device['device_id']) ?>">
                  <button class="btn unlock" type="submit" <?= $status === 'OFFLINE' ? 'disabled' : '' ?>>Unlock</button>                  
                </form>
                <button class="btn outline" data-edit-door
                  data-id="<?= e($device['device_id']) ?>"
                  data-name="<?= e($device['device_name']) ?>"
                  data-key="<?= e($device['api_key']) ?>">Edit</button>
              </td>
            </tr>
          <?php endforeach; ?>
          <?php if (!$devices): ?><tr><td colspan="4" class="empty">Belum ada perangkat pintu.</td></tr><?php endif; ?>
          </tbody>
        </table>
      </div>
    </section>

    <section class="card">
      <div class="card-header">
        <h2>Daftar Pengguna & Akses</h2>
        <button class="btn primary" data-modal="userModal">+ Add User</button>
      </div>
      <div class="table-wrap">
        <table>
          <thead><tr><th>Pengguna</th><th>Tipe Pengguna</th><th>UID RFID</th><th>Username</th><th>Akses Pintu</th><th>Aksi</th></tr></thead>
          <tbody>
          <?php foreach ($users as $user):
              $hasUid = !empty($user['uid']) && $user['uid'] !== '-';
              $hasUsername = !empty($user['username']) && $user['username'] !== '-';
              $userType = 'RFID';
              if ($hasUid && $hasUsername) $userType = 'BOTH';
              elseif ($hasUsername) $userType = 'WEB';
          ?>
            <tr>
              <td><strong><?= e($user['name']) ?></strong></td>
              <td><span class="pill type-<?= strtolower($userType) ?>"><?= e($userType) ?></span></td>
              <td><code><?= e($user['uid'] ?: '-') ?></code></td>
              <td><?= e($user['username'] ?: '-') ?></td>
              <td><?= e($user['access_doors'] ?: '') ?></td>
              <td><button class="btn outline" data-edit-user
                data-id="<?= (int)$user['id'] ?>"
                data-name="<?= e($user['name']) ?>"
                data-uid="<?= e($user['uid'] ?? '') ?>"
                data-username="<?= e($user['username'] ?? '') ?>"
                data-doors="<?= e($user['door_ids'] ?? '') ?>">Edit</button></td>
            </tr>
          <?php endforeach; ?>
          <?php if (!$users): ?><tr><td colspan="6" class="empty">Belum ada pengguna.</td></tr><?php endif; ?>
          </tbody>
        </table>
      </div>
    </section>
  </main>
</div>

<div class="modal" id="doorModal">
  <form class="modal-card small" method="post">
    <input type="hidden" name="csrf_token" value="<?= e(csrf_token()) ?>">
    <input type="hidden" name="action" id="doorAction" value="add_door">
    <div class="modal-head"><div><h2 id="doorTitle">Add Door</h2><p>Kelola identitas perangkat pintu.</p></div><button type="button" data-close>×</button></div>
    <label>Nama Perangkat<input name="device_name" id="doorName" placeholder="RUANG NOC" required></label>
    <label>Device ID<input name="device_id" id="doorId" placeholder="door_1" required></label>
    <div id="apiKeyField" hidden>
      <label>API Key <small>(read-only)</small><input id="doorApiKey" type="text" readonly style="cursor: copy; background: #f8f9fa;"></label>
    </div>
    <div class="modal-actions">
      <div style="flex-grow: 1"></div>
      <button type="button" class="btn outline" data-close>Batal</button>
      <button class="btn primary">Simpan</button>
    </div>
  </form>
  <form method="post" id="deleteDoorForm" hidden><input type="hidden" name="csrf_token" value="<?= e(csrf_token()) ?>"><input type="hidden" name="device_id" id="deleteDoorId"></form>
</div>

<div class="modal" id="userModal">
  <form class="modal-card" method="post">
    <input type="hidden" name="csrf_token" value="<?= e(csrf_token()) ?>">
    <input type="hidden" name="action" id="userAction" value="add_user">
    <input type="hidden" name="user_id" id="userId">
    <div class="modal-head"><div><h2 id="userTitle">Add User</h2><p>Isi data pengguna sesuai tipe akses yang digunakan.</p></div><button type="button" data-close>×</button></div>
    <label>Nama Lengkap<input name="name" id="userName" placeholder="e.g. Aldi" required></label>
    <label>Tipe Pengguna
      <select name="user_type" id="userType">
        <option value="rfid">RFID</option>
        <option value="web">WEB</option>
        <option value="both">BOTH</option>
      </select>
    </label>
    <div class="form-grid">
      <label id="uidField">UID RFID<input name="uid" id="userUid" placeholder="04A1B2C3D4"></label>
      <label id="usernameField">Username<input name="username" id="userUsername" placeholder="e.g. aldi"></label>
    </div>
    <div id="passwordField">
      <label>Password <span id="passwordHint">(kosongkan jika tidak ingin diubah)</span>
        <input name="password" type="password" autocomplete="new-password"></label>
    </div>
    <div class="access-box" id="accessDoorsField">
      <div><strong>Akses Pintu</strong><span>Pilih satu atau lebih pintu</span></div>
      <?php foreach ($devices as $device): ?>
        <label><input type="checkbox" name="access_doors[]" value="<?= e($device['device_id']) ?>"> <?= e($device['device_name']) ?></label>
      <?php endforeach; ?>
    </div>
    <div class="modal-actions">
      <div style="flex-grow: 1"></div>
      <button type="button" class="btn outline" data-close>Cancel</button>
      <button class="btn primary">Save</button>
    </div>
  </form>
  <form method="post" id="deleteUserForm" hidden><input type="hidden" name="csrf_token" value="<?= e(csrf_token()) ?>"><input type="hidden" name="user_id" id="deleteUserId"></form>
</div>

<script src="assets/js/app.js"></script>
<script>
document.addEventListener('DOMContentLoaded', () => {
  const userModal = document.getElementById('userModal');
  if (!userModal) return;

  const userType = userModal.querySelector('#userType');
  const uidField = userModal.querySelector('#uidField');
  const usernameField = userModal.querySelector('#usernameField');
  const passwordField = userModal.querySelector('#passwordField');
  const passwordHint = userModal.querySelector('#passwordHint');
  const accessDoorsField = userModal.querySelector('#accessDoorsField');
  const userAction = userModal.querySelector('#userAction');

  function toggleUserFields() {
    const type = userType.value;
    const isAdd = userAction.value === 'add_user';

    const showRfid = ['rfid', 'both'].includes(type);
    const showWeb = ['web', 'both'].includes(type);

    // Use style.display for more reliable hiding
    uidField.style.display = showRfid ? '' : 'none';
    uidField.querySelector('input').required = showRfid;

    usernameField.style.display = showWeb ? '' : 'none';
    usernameField.querySelector('input').required = showWeb;

    passwordField.style.display = showWeb ? '' : 'none';
    passwordField.querySelector('input').required = showWeb && isAdd;
    passwordHint.style.display = isAdd ? 'none' : 'inline';

    accessDoorsField.style.display = type === 'web' ? 'none' : '';
  }

  userType.addEventListener('change', toggleUserFields);

  userModal.addEventListener('show', () => {
    // Dipanggil dari app.js saat modal dibuka
    setTimeout(toggleUserFields, 50);
  });

  // Panggil sekali saat halaman dimuat untuk mengatur state awal form
  toggleUserFields();
});
</script>
</body>
</html>
