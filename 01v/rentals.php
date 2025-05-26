<?php
session_start();
require 'db.php';

// Проверка авторизации
if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit;
}

// Получение списка аренд
$rentals = $mysqli->query("
    SELECT r.*, p.address, c.full_name AS client_name
    FROM rentals r
    JOIN properties p ON r.property_id = p.property_id
    JOIN clients c ON r.client_id = c.client_id
    ORDER BY r.start_date DESC
")->fetch_all(MYSQLI_ASSOC);

// Получение списка объектов и клиентов для форм
$properties = $mysqli->query("SELECT * FROM properties WHERE status = 'Available'")->fetch_all(MYSQLI_ASSOC);
$clients = $mysqli->query("SELECT * FROM clients")->fetch_all(MYSQLI_ASSOC);

// Обработка добавления новой аренды
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['add_rental'])) {
    $property_id = $_POST['property_id'];
    $client_id = $_POST['client_id'];
    $user_id = $_SESSION['user_id']; // Добавляем user_id из сессии
    $start_date = $_POST['start_date'];
    $end_date = $_POST['end_date'];
    $monthly_price = $_POST['monthly_price'];
    
    $mysqli->begin_transaction();
    
    try {
        $stmt = $mysqli->prepare("INSERT INTO rentals (property_id, client_id, user_id, start_date, end_date, monthly_price) VALUES (?, ?, ?, ?, ?, ?)");
        if (!$stmt) {
            throw new Exception("Ошибка подготовки запроса: " . $mysqli->error);
        }
        
        $stmt->bind_param("iiissd", $property_id, $client_id, $user_id, $start_date, $end_date, $monthly_price);
        
        if (!$stmt->execute()) {
            throw new Exception("Ошибка выполнения запроса: " . $stmt->error);
        }
        
        $mysqli->query("UPDATE properties SET status = 'Occupied' WHERE property_id = $property_id") or die($mysqli->error);
        
        $mysqli->commit();
        $message = "Аренда успешно оформлена. ID: " . $stmt->insert_id;
    } catch (Exception $e) {
        $mysqli->rollback();
        $error = "Ошибка при оформлении аренды: " . $e->getMessage();
    }
}

// Обработка завершения аренды
if (isset($_GET['complete_rental'])) {
    $rental_id = intval($_GET['complete_rental']);
    
    // Начинаем транзакцию
    $mysqli->begin_transaction();
    
    try {
        // Получаем property_id перед завершением аренды
        $result = $mysqli->query("SELECT property_id FROM rentals WHERE rental_id = $rental_id");
        $rental = $result->fetch_assoc();
        $property_id = $rental['property_id'];
        
        // Завершаем аренду
        $mysqli->query("UPDATE rentals SET status = 'Completed', end_date = NOW() WHERE rental_id = $rental_id");
        
        // Меняем статус объекта на "Dirty"
        $mysqli->query("UPDATE properties SET status = 'Dirty' WHERE property_id = $property_id");
        
        $mysqli->commit();
        $message = "Аренда успешно завершена";
    } catch (Exception $e) {
        $mysqli->rollback();
        $error = "Ошибка при завершении аренды: " . $e->getMessage();
    }
    
    header("Location: rentals.php");
    exit;
}
?>

<link rel="stylesheet" href="style.css">

<div class="welcome-container">
    <div class="welcome-box">
        <h1>Управление арендой</h1>
        
        <?php if (isset($error)): ?>
            <p style="color:red"><?= htmlspecialchars($error) ?></p>
        <?php elseif (isset($message)): ?>
            <p style="color:green"><?= htmlspecialchars($message) ?></p>
        <?php endif; ?>
        
        <h3>Оформить новую аренду</h3>
        <form method="post">
            <div>
                <label>Объект недвижимости:</label>
                <select name="property_id" required>
                    <?php foreach ($properties as $property): ?>
                        <option value="<?= $property['property_id'] ?>">
                            <?= htmlspecialchars($property['address']) ?> (<?= $property['monthly_price'] ?> руб/мес)
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>
            <div>
                <label>Клиент:</label>
                <select name="client_id" required>
                    <?php foreach ($clients as $client): ?>
                        <option value="<?= $client['client_id'] ?>"><?= htmlspecialchars($client['full_name']) ?></option>
                    <?php endforeach; ?>
                </select>
            </div>
            <div>
                <label>Дата начала:</label>
                <input type="date" name="start_date" required>
            </div>
            <div>
                <label>Дата окончания (необязательно):</label>
                <input type="date" name="end_date">
            </div>
            <div>
                <label>Месячная цена (руб):</label>
                <input type="number" step="0.01" name="monthly_price" required>
            </div>
            <button type="submit" name="add_rental">Оформить аренду</button>
        </form>
        
        <h3>Список аренд</h3>
        <table border="1">
            <tr>
                <th>ID</th>
                <th>Объект</th>
                <th>Клиент</th>
                <th>Начало</th>
                <th>Окончание</th>
                <th>Цена</th>
                <th>Статус</th>
                <th>Действия</th>
            </tr>
            <?php foreach ($rentals as $rental): ?>
            <tr>
                <td><?= $rental['rental_id'] ?></td>
                <td><?= htmlspecialchars($rental['address']) ?></td>
                <td><?= htmlspecialchars($rental['client_name']) ?></td>
                <td><?= date('d.m.Y', strtotime($rental['start_date'])) ?></td>
                <td><?= $rental['end_date'] ? date('d.m.Y', strtotime($rental['end_date'])) : '—' ?></td>
                <td><?= number_format($rental['monthly_price'], 2) ?> руб</td>
                <td><?= $rental['status'] ?></td>
                <td>
                    <?php if ($rental['status'] == 'Active'): ?>
                        <a href="rentals.php?complete_rental=<?= $rental['rental_id'] ?>">Завершить</a>
                    <?php endif; ?>
                    <a href="payments.php?rental_id=<?= $rental['rental_id'] ?>">Платежи</a>
                </td>
            </tr>
            <?php endforeach; ?>
        </table>
        
        <p><a href="dashboard.php">Назад в личный кабинет</a></p>
    </div>
</div>