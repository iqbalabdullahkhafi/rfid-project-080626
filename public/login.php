<?php
declare(strict_types=1);

require_once dirname(__DIR__) . '/app/auth.php';
require_once dirname(__DIR__) . '/app/helpers.php'; // Tambahkan ini

if (is_logged_in()) {
    redirect_to('index.php');
}

// Ambil pesan error dari session jika ada
$error = '';
if (isset($_SESSION['login_error'])) {
    $error = $_SESSION['login_error'];
    unset($_SESSION['login_error']);
}

// Ambil flash message umum (untuk logout, dll)
$flash_message = flash(); // Panggil flash tanpa parameter untuk mengambil dan membersihkan


if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'POST') {
    $username = trim((string)($_POST['username'] ?? ''));
    $password = (string)($_POST['password'] ?? '');

    if ($username === '' || $password === '') {
        $_SESSION['login_error'] = 'Username dan password wajib diisi.';
        redirect_to('login.php');
    }
    
    $stmt = db()->prepare(
        "SELECT name, username, password
        FROM users
        WHERE username = ?
        LIMIT 1"
    );
    
    $stmt->bind_param('s', $username);
    $stmt->execute();
    $user = $stmt->get_result()->fetch_assoc();

    if ($user && password_verify($password, (string)$user['password'])) {
        session_regenerate_id(true);
        $_SESSION['user'] = [
            'name' => $user['name'],
            'username' => $user['username'],
        ];
        redirect_to('index.php');
    }

    // Simpan error di session dan redirect
    $_SESSION['login_error'] = 'Username atau password salah.';
    redirect_to('login.php');
}
?>
<!doctype html>
<html lang="id">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Login - RFID Door Access</title>
  <link rel="icon" href="assets/icons/ikonwebsite.png" type="image/png">
  <link rel="stylesheet" href="assets/css/app.css">
</head>
<body class="login-page">
  <form class="login-card" method="post" autocomplete="off">
    <h1 style="text-align: center; white-space: nowrap; margin-bottom: 24px;">Smart Door Security System</h1>
    <?php if ($flash_message && $flash_message['type'] === 'success'): ?><div class="alert success"><?= e($flash_message['message']) ?></div><?php endif; ?>
    <?php if ($error !== ''): ?><div class="alert error"><?= e($error) ?></div><?php endif; ?>
    <label>Username<input name="username" autocomplete="off" placeholder="Username" required></label>
    <label>Password<input name="password" type="password" autocomplete="off" placeholder="Password" required></label>
    <button class="btn primary login-btn">Login</button>
  </form>
  <script src="assets/js/app.js"></script>
</body>
</html>