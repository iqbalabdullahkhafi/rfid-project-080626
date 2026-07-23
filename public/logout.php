<?php
declare(strict_types=1);

require_once dirname(__DIR__) . '/app/session.php';
require_once dirname(__DIR__) . '/app/helpers.php';

unset($_SESSION['user']);

flash('success', 'Logout berhasil.');
redirect_to('login.php');
