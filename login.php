<?php
session_start();
require 'db.php';  // Подключение к БД через mysqli

$error = '';
$username = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'];
    $password = $_POST['password'];
    
    // Защита от SQL-инъекций
    $stmt = $mysqli->prepare("SELECT * FROM users WHERE username = ?");
    $stmt->bind_param("s", $username);
    $stmt->execute();
    $result = $stmt->get_result();
    $user = $result->fetch_assoc();
    
    if ($user) {
        if ($user['is_blocked']) {
            $error = "Вы заблокированы. Обратитесь к администратору";
        } elseif ($password === $user['password']) { 
            // Сброс попыток входа
            $mysqli->query("UPDATE users SET login_attempts = 0, last_login_date = NOW() WHERE user_id = " . $user['user_id']);
            
            $_SESSION['user_id'] = $user['user_id'];
            $_SESSION['username'] = $user['username'];
            $_SESSION['role'] = $user['role'];
			$_SESSION['full_name'] = $user['full_name'];
            
            if ($user['must_change_password']) {
                header("Location: change_password.php");
                exit;
            } else {
                $_SESSION['message'] = "Вы успешно авторизовались";
                header("Location: dashboard.php");
                exit;
            }
        } else {
            // Блокировка после 3 попыток
            $attempts = $user['login_attempts'] + 1;
            $is_blocked = $attempts >= 3 ? 1 : 0;
            
            $mysqli->query("UPDATE users SET login_attempts = $attempts, is_blocked = $is_blocked WHERE user_id = " . $user['id']);
            
            $error = $is_blocked 
                ? "Вы заблокированы. Обратитесь к администратору" 
                : "Неверный логин или пароль";
        }
    } else {
        $error = "Неверный логин или пароль";
    }
}
?>

<link rel="stylesheet" href="style.css">
<div class="auth-wrapper">
	<form method="post" class="login">
		<h3>Вход в систему</h3>
		<input type="text" name="username" placeholder="Логин" value="<?= htmlspecialchars($username) ?>" required>
		<input type="password" name="password" placeholder="Пароль" required>
		<button type="submit">Войти</button>
		<?php if ($error): ?>
			<p style="color:red"><?= $error ?></p>
		<?php endif; ?>
	</form>
</div>
