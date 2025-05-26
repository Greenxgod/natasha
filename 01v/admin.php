<?php
session_start();
require 'db.php'; // Подключение через mysqli

// Проверка прав администратора
if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'admin') {
    header("Location: login.php");
    exit;
}

// Обработка добавления пользователя
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['add_user'])) {
    $username = $_POST['username'];
    $password = $_POST['password'];
    $role = $_POST['role'];
    $full_name = $_POST['full_name'];
    
    // Проверка существования пользователя
    $stmt = $mysqli->prepare("SELECT user_id FROM users WHERE username = ?");
    $stmt->bind_param("s", $username);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows > 0) {
        $error = "Пользователь с таким логином уже существует";
    } else {
        // Добавление нового пользователя
        $stmt = $mysqli->prepare("INSERT INTO users (username, password, role, full_name) VALUES (?, ?, ?, ?)");
        $stmt->bind_param("ssss", $username, $password, $role, $full_name); // Изменено с "sss" на "ssss"
        $stmt->execute();
        $message = "Пользователь успешно добавлен";
    }
}

// Обработка блокировки/разблокировки
if (isset($_GET['toggle_block'])) {
    $user_id = intval($_GET['toggle_block']);
    $mysqli->query("UPDATE users SET is_blocked = NOT is_blocked WHERE user_id = $user_id");
    header("Location: admin.php");
    exit;
}

// Получение списка пользователей
$users = $mysqli->query("SELECT * FROM users ORDER BY user_id")->fetch_all(MYSQLI_ASSOC);
?>



<link rel="stylesheet" href="style.css">

<div class="welcome-container">
    <div class="welcome-box">
		<h1>Панель администратора</h1>
		
		<?php if (isset($error)): ?>
			<p style="color:red"><?= htmlspecialchars($error) ?></p>
		<?php elseif (isset($message)): ?>
			<p style="color:green"><?= htmlspecialchars($message) ?></p>
		<?php endif; ?>
		
		<h3>Добавить пользователя</h3>
		<form method="post">
			<div>
				<label>Логин:</label>
				<input type="text" name="username" required>
			</div>
			<div>
				<label>Пароль:</label>
				<input type="text" name="password" required>
			</div>
			<div>
				<label>Роль:</label>
				<select name="role">
					<option value="user">Пользователь</option>
					<option value="admin">Администратор</option>
				</select>
			</div>
			<div>
				<label>ФИО:</label>
				<input type="text" name="full_name" required>
			</div>
			<button type="submit" name="add_user">Добавить</button>
		</form>
		
		<h3>Список пользователей</h3>
		<table border="1">
			<tr>
				<th>ID</th>
				<th>Логин</th>
				<th>Роль</th>
				<th>Статус</th>
				<th>Действия</th>
			</tr>
			<?php foreach ($users as $user): ?>
			<tr>
				<td><?= $user['user_id'] ?></td>
				<td><?= htmlspecialchars($user['username']) ?></td>
				<td><?= $user['role'] === 'admin' ? 'Администратор' : 'Пользователь' ?></td>
				<td><?= $user['is_blocked'] ? 'Заблокирован' : 'Активен' ?></td>
				<td>
					<a href="admin.php?toggle_block=<?= $user['user_id'] ?>">
						<?= $user['is_blocked'] ? 'Разблокировать' : 'Заблокировать' ?>
					</a>
				</td>
			</tr>
			<?php endforeach; ?>
		</table>
		
		<p><a href="dashboard.php">Назад в личный кабинет</a></p>
	</div>
</div>