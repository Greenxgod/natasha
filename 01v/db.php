<?php
// Создаем соединение с БД
$mysqli = new mysqli('localhost', 'root', 'root', 'real_estate_management');

// Проверяем подключение
if ($mysqli->connect_error) {
    die("Ошибка подключения к БД: " . $mysqli->connect_error);
}

// Кодировочка
$mysqli->set_charset('utf8mb4');
?>