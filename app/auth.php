<?php
declare(strict_types=1);

require_once __DIR__ . '/helpers.php';

function is_logged_in(): bool
{
    return !empty($_SESSION['user']);
}

function current_user(): array
{
    return $_SESSION['user'] ?? ['name' => 'Administrator', 'username' => 'admin', 'role' => 'Admin'];
}

function require_login(): void
{
    if (!is_logged_in()) {
        redirect_to('login.php');
    }
}
