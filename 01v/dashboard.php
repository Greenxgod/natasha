<?php
session_start();

// Подключаем файл с соединением к БД
require 'db.php'; // Используем mysqli вместо PDO

// Проверяем авторизацию пользователя
if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit;
}

// Получаем информацию о пользователе
$user_id = $_SESSION['user_id'];
$query = "SELECT * FROM users WHERE user_id = ?";
$stmt = $mysqli->prepare($query);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();
$user = $result->fetch_assoc();

// Проверяем блокировку по времени (1 месяц)
if ($user['last_login_date'] && strtotime($user['last_login_date']) < strtotime('-1 month')) {
    $mysqli->query("UPDATE users SET is_blocked = TRUE WHERE user_id = $user_id");
    session_destroy();
    header("Location: login.php?error=Ваш аккаунт заблокирован из-за неактивности");
    exit();
}
// Обновляем дату последнего входа
$mysqli->query("UPDATE users SET last_login_date = NOW() WHERE user_id = $user_id");



if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	header("Location: admin.php");
}

?>



<link rel="stylesheet" href="style.css">

<div class="welcome-container">
    <div class="welcome-box">
        <h1>Добро пожаловать, <?php echo $user['full_name']; ?>!</h1>
        <p>Ваша роль: <?php echo ($user['role'] === 'admin') ? 'Администратор' : 'Пользователь'; ?></p>
        <?php if ($user['role'] == 'admin'): ?>
		<?php if (isset($_SESSION['message'])): ?>
			<p style="color: green;"><?php echo $_SESSION['message']; unset($_SESSION['message']); ?></p>
		<?php endif; ?>
            <p class="welcome-text">
                Вы обладаете расширенными правами доступа.
                <ul class="admin-list">
                    <li>Добавлять новых пользователей;</li>
                    <li>Редактировать существующие записи;</li>
                    <li>Удалять пользователей из базы;</li>
                    <li>Контролировать доступ к информации;</li>
					<li>Множество других функций;</li>
                </ul>
            </p>
            <a href="rentals.php" class="button-g">Управление арендой</a>
			<a href="admin.php" class="button-g">Управление пользователями</a>
        <?php endif; ?>
		<a href="logout.php" class="button-r">Выйти</a>
    </div>
</div>