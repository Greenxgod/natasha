<?php
session_start();
require 'db.php';

// Проверка авторизации
if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit;
}

$rental_id = isset($_GET['rental_id']) ? intval($_GET['rental_id']) : 0;

// Получение информации об аренде
$rental = [];
if ($rental_id) {
    $stmt = $mysqli->prepare("
        SELECT r.*, p.address, c.full_name AS client_name 
        FROM rentals r
        JOIN properties p ON r.property_id = p.property_id
        JOIN clients c ON r.client_id = c.client_id
        WHERE r.rental_id = ?
    ");
    $stmt->bind_param("i", $rental_id);
    $stmt->execute();
    $rental = $stmt->get_result()->fetch_assoc();
}

// Получение списка платежей
$payments = [];
if ($rental_id) {
    $payments = $mysqli->query("
        SELECT * FROM payments 
        WHERE rental_id = $rental_id 
        ORDER BY payment_date DESC
    ")->fetch_all(MYSQLI_ASSOC);
}

// Обработка добавления платежа
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['add_payment'])) {
    $amount = $_POST['amount'];
    $payment_date = $_POST['payment_date'];
    $period_start = $_POST['period_start'];
    $period_end = $_POST['period_end'];
    
    $stmt = $mysqli->prepare("INSERT INTO payments (rental_id, amount, payment_date, period_start, period_end, status) VALUES (?, ?, ?, ?, ?, 'Оплачено')");
    $stmt->bind_param("idsss", $rental_id, $amount, $payment_date, $period_start, $period_end);
    
    if ($stmt->execute()) {
        $message = "Платеж успешно добавлен";
    } else {
        $error = "Ошибка при добавлении платежа: " . $mysqli->error;
    }
}
?>

<link rel="stylesheet" href="style.css">

<div class="welcome-container">
    <div class="welcome-box">
        <h1>Управление платежами</h1>
        
        <?php if (isset($error)): ?>
            <p style="color:red"><?= htmlspecialchars($error) ?></p>
        <?php elseif (isset($message)): ?>
            <p style="color:green"><?= htmlspecialchars($message) ?></p>
        <?php endif; ?>
        
        <?php if ($rental): ?>
            <h3>Аренда: <?= htmlspecialchars($rental['address']) ?></h3>
            <p>Клиент: <?= htmlspecialchars($rental['client_name']) ?></p>
            <p>Период: <?= date('d.m.Y', strtotime($rental['start_date'])) ?> — <?= $rental['end_date'] ? date('d.m.Y', strtotime($rental['end_date'])) : 'не определено' ?></p>
            <p>Месячная плата: <?= number_format($rental['monthly_price'], 2) ?> руб</p>
            
            <h4>Добавить платеж</h4>
            <form method="post">
                <div>
                    <label>Сумма:</label>
                    <input type="number" step="0.01" name="amount" required>
                </div>
                <div>
                    <label>Дата платежа:</label>
                    <input type="date" name="payment_date" required value="<?= date('Y-m-d') ?>">
                </div>
                <div>
                    <label>Период с:</label>
                    <input type="date" name="period_start" required>
                </div>
                <div>
                    <label>Период по:</label>
                    <input type="date" name="period_end" required>
                </div>
                <button type="submit" name="add_payment">Добавить платеж</button>
            </form>
            
            <h4>История платежей</h4>
            <table border="1">
                <tr>
                    <th>Дата</th>
                    <th>Сумма</th>
                    <th>Период</th>
                    <th>Статус</th>
                </tr>
                <?php foreach ($payments as $payment): ?>
                <tr>
                    <td><?= date('d.m.Y', strtotime($payment['payment_date'])) ?></td>
                    <td><?= number_format($payment['amount'], 2) ?> руб</td>
                    <td><?= date('d.m.Y', strtotime($payment['period_start'])) ?> — <?= date('d.m.Y', strtotime($payment['period_end'])) ?></td>
                    <td><?= $payment['status'] ?></td>
                </tr>
                <?php endforeach; ?>
            </table>
        <?php else: ?>
            <p>Выберите аренду для просмотра платежей</p>
        <?php endif; ?>
        
        <p><a href="rentals.php">Вернуться к списку аренд</a></p>
        <p><a href="dashboard.php">Назад в личный кабинет</a></p>
    </div>
</div>