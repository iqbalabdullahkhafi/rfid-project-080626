<?php
declare(strict_types=1);

require_once dirname(__DIR__) . '/app/session.php';
require_once dirname(__DIR__) . '/app/helpers.php';

// Cukup hapus session user, jangan hancurkan seluruh session
// agar flash message bisa terbawa
unset($_SESSION['user']);

flash('success', 'Logout berhasil.');
redirect_to('login.php');
