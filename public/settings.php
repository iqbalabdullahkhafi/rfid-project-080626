<?php
declare(strict_types=1);

require_once dirname(__DIR__) . '/app/auth.php';
require_login();

$message = flash();

if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'POST') {
    verify_csrf();
    $mode = strtolower(trim((string)($_POST['mode'] ?? 'online')));
    $name = trim((string)($_POST['name'] ?? ''));
    $username = trim((string)($_POST['username'] ?? ''));
    $current = (string)($_POST['current_password'] ?? '');
    $new = (string)($_POST['new_password'] ?? '');
    $confirm = (string)($_POST['confirm_password'] ?? '');

    try {
        if (!in_array($mode, ['online', 'hybrid'], true) || $name === '' || $username === '') {
            throw new RuntimeException('Data pengaturan belum lengkap.');
        }
        save_setting('mode', $mode);

        $oldUsername = (string)(current_user()['username'] ?? 'admin');
        $stmt = db()->prepare('SELECT password FROM users WHERE username = ? LIMIT 1');
        $stmt->bind_param('s', $oldUsername);
        $stmt->execute();
        $user = $stmt->get_result()->fetch_assoc();

        if ($new !== '') {
            if (!$user || !password_verify($current, (string)$user['password'])) {
                throw new RuntimeException('Password saat ini tidak sesuai.');
            }
            if (strlen($new) < 6 || $new !== $confirm) {
                throw new RuntimeException('Password baru minimal 6 karakter dan harus sama.');
            }
            $hash = password_hash($new, PASSWORD_DEFAULT);
            $update = db()->prepare('UPDATE users SET name = ?, username = ?, password = ? WHERE username = ?');
            $update->bind_param('ssss', $name, $username, $hash, $oldUsername);
        } else {
            $update = db()->prepare('UPDATE users SET name = ?, username = ? WHERE username = ?');
            $update->bind_param('sss', $name, $username, $oldUsername);
        }
        $update->execute();
        $_SESSION['user']['name'] = $name;
        $_SESSION['user']['username'] = $username;
        flash('success', 'Pengaturan berhasil disimpan.');
    } catch (Throwable $error) {
        flash('error', $error->getMessage());
    }
    redirect_to('settings.php');
}

$user = current_user();
$mode = setting('mode', 'online');
?>
<!doctype html>
<html lang="id">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Settings - RFID Door Access</title>
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
      <a href="logs.php"><img src="assets/icons/book-svgrepo-com.svg" class="nav-icon" alt="Log"> <span>Access Log</span></a>
      <a class="active" href="settings.php"><img src="assets/icons/settings-svgrepo-com.svg" class="nav-icon" alt="Set"> <span>Settings</span></a>
      <a href="logout.php" data-confirm="Apakah Anda yakin ingin logout?"><img src="assets/icons/logout-svgrepo-com.svg" class="nav-icon" alt="Out"> <span>Logout</span></a>
    </nav>
  </aside>

  <main class="content">
    <?php if ($message): ?><div class="alert <?= e($message['type']) ?>"><?= e($message['message']) ?></div><?php endif; ?>
    <header class="page-header">
      <div><h1>Settings</h1><p>Pengaturan sistem dan akun administrator</p></div>

    </header>

    <form method="post">
      <input type="hidden" name="csrf_token" value="<?= e(csrf_token()) ?>">
      <section class="card settings-card">
        <h2>Pengaturan Sistem</h2>
        <div class="setting-row">
          <div><strong>Mode Sistem</strong><span>Pilih mode operasi sistem.</span></div>
          <select name="mode">
            <option value="online" <?= $mode === 'online' ? 'selected' : '' ?>>Online</option>
            <option value="hybrid" <?= $mode === 'hybrid' ? 'selected' : '' ?>>Hybrid</option>
          </select>
        </div>
      </section>

      <section class="card settings-card">
        <h2>Akun Administrator</h2>
        <div class="account-grid">
          <label>Nama Lengkap<input name="name" value="<?= e($user['name'] ?? '') ?>" required></label>
          <label>Username<input name="username" value="<?= e($user['username'] ?? '') ?>" required></label>
          <label>Password Saat Ini<input name="current_password" type="password" placeholder="Masukkan password saat ini" autocomplete="current-password"></label>
          <label>Password Baru<input name="new_password" type="password" placeholder="Masukkan password baru" autocomplete="new-password"></label>
          <label>Konfirmasi Password<input name="confirm_password" type="password" placeholder="Ulangi password baru" autocomplete="new-password"></label>
        </div>
        <button class="btn primary save-btn">Save Changes</button>
      </section>
    </form>
  </main>
</div>
<script src="assets/js/app.js"></script>
</body>
</html>
