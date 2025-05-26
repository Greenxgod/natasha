<?php
session_start();
require 'db.php';

if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit;
}

$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $current_password = $_POST['current_password'];
    $new_password = $_POST['new_password'];
    $confirm_password = $_POST['confirm_password'];
    
    $user_id = $_SESSION['user_id'];
    $result = $mysqli->query("SELECT password FROM users WHERE id = $user_id");
    $user = $result->fetch_assoc();
    
    if ($current_password !== $user['password']) {
        $error = "Текущий пароль неверен";
    } elseif ($new_password !== $confirm_password) {
        $error = "Пароли не совпадают";
    } else {
        $hashed_password = password_hash($new_password, PASSWORD_DEFAULT);
		$stmt = $mysqli->prepare("UPDATE users SET password = ? WHERE user_id = ?");
		$stmt->bind_param("si", $hashed_password, $_SESSION['user_id']);
        $_SESSION['message'] = "Пароль изменен!";
        header("Location: dashboard.php");
        exit;
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Смена пароля</title>
</head>
<body>
    <h2>Смена пароля</h2>
    <?php if ($error): ?>
        <p style="color:red"><?= $error ?></p>
    <?php endif; ?>
    <form method="post">
        <input type="password" name="current_password" placeholder="Текущий пароль" required>
        <input type="password" name="new_password" placeholder="Новый пароль" required>
        <input type="password" name="confirm_password" placeholder="Подтвердите пароль" required>
        <button type="submit">Изменить</button>
    </form>
</body>
</html>