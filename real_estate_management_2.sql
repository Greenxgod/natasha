-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Май 26 2025 г., 01:18
-- Версия сервера: 10.4.32-MariaDB
-- Версия PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `real_estate_management`
--

-- --------------------------------------------------------

--
-- Структура таблицы `cleaning_assignments`
--

CREATE TABLE `cleaning_assignments` (
  `assignment_id` int(11) NOT NULL,
  `cleaning_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `cleaning_assignments`
--

INSERT INTO `cleaning_assignments` (`assignment_id`, `cleaning_id`, `employee_id`) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `cleaning_schedule`
--

CREATE TABLE `cleaning_schedule` (
  `cleaning_id` int(11) NOT NULL,
  `property_id` int(11) NOT NULL,
  `scheduled_date` datetime NOT NULL,
  `completed_date` datetime DEFAULT NULL,
  `status` enum('Scheduled','Completed','Canceled') DEFAULT 'Scheduled',
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `cleaning_schedule`
--

INSERT INTO `cleaning_schedule` (`cleaning_id`, `property_id`, `scheduled_date`, `completed_date`, `status`, `notes`) VALUES
(1, 1, '2024-03-01 09:00:00', NULL, 'Scheduled', NULL),
(2, 5, '2024-03-02 10:00:00', NULL, 'Completed', NULL),
(3, 6, '2024-03-03 11:00:00', NULL, 'Scheduled', NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `clients`
--

CREATE TABLE `clients` (
  `client_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `passport_data` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `clients`
--

INSERT INTO `clients` (`client_id`, `full_name`, `phone`, `email`, `passport_data`) VALUES
(1, 'Иванов Иван Иванович', '+79161234567', 'ivanov@example.com', '4510 123456'),
(2, 'Петрова Мария Сергеевна', '+79167654321', 'petrova@example.com', '4511 654321'),
(3, 'Сидоров Алексей Владимирович', '+79169998877', 'sidorov@example.com', '4512 987654');

-- --------------------------------------------------------

--
-- Структура таблицы `employees`
--

CREATE TABLE `employees` (
  `employee_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `position` varchar(50) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `hire_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `employees`
--

INSERT INTO `employees` (`employee_id`, `full_name`, `position`, `phone`, `email`, `hire_date`) VALUES
(1, 'Смирнов Олег Петрович', 'Уборщик', '+79161112233', NULL, '2023-01-15'),
(2, 'Кузнецова Анна Викторовна', 'Администратор', '+79162223344', NULL, '2022-05-10'),
(3, 'Васильев Дмитрий Игоревич', 'Менеджер', '+79163334455', NULL, '2023-03-20');

-- --------------------------------------------------------

--
-- Структура таблицы `maintenance`
--

CREATE TABLE `maintenance` (
  `maintenance_id` int(11) NOT NULL,
  `property_id` int(11) NOT NULL,
  `type` enum('Cleaning','Repair','Inspection') NOT NULL,
  `scheduled_date` datetime NOT NULL,
  `completed_date` datetime DEFAULT NULL,
  `status` enum('Scheduled','In Progress','Completed','Cancelled') DEFAULT 'Scheduled',
  `cost` decimal(10,2) DEFAULT 0.00,
  `notes` text DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `payments`
--

CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL,
  `rental_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_date` datetime NOT NULL,
  `period_start` date NOT NULL,
  `period_end` date NOT NULL,
  `status` enum('Pending','Paid','Overdue') DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `payments`
--

INSERT INTO `payments` (`payment_id`, `rental_id`, `amount`, `payment_date`, `period_start`, `period_end`, `status`) VALUES
(1, 1, 28000.00, '2024-01-05 12:30:00', '2024-01-01', '2024-01-31', 'Paid'),
(2, 1, 28000.00, '2024-02-05 12:30:00', '2024-02-01', '2024-02-29', 'Paid'),
(3, 2, 30000.00, '2024-02-05 14:15:00', '2024-02-01', '2024-02-29', 'Paid'),
(4, 3, 45000.00, '2023-12-05 10:00:00', '2023-12-01', '2023-12-31', 'Paid'),
(5, 3, 45000.00, '2024-01-05 10:00:00', '2024-01-01', '2024-01-31', 'Paid'),
(6, 3, 45000.00, '2024-02-05 10:00:00', '2024-02-01', '2024-02-29', 'Paid');

-- --------------------------------------------------------

--
-- Структура таблицы `properties`
--

CREATE TABLE `properties` (
  `property_id` int(11) NOT NULL,
  `address` varchar(255) NOT NULL,
  `category_id` int(11) NOT NULL,
  `square_meters` decimal(10,2) DEFAULT NULL,
  `rooms` int(11) DEFAULT NULL,
  `status` enum('Available','Occupied','Dirty','Cleaning Scheduled','Ready') DEFAULT 'Available',
  `cleaning_date` date DEFAULT NULL,
  `monthly_price` decimal(10,2) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `properties`
--

INSERT INTO `properties` (`property_id`, `address`, `category_id`, `square_meters`, `rooms`, `status`, `cleaning_date`, `monthly_price`, `description`) VALUES
(1, 'ул. Гагарина, д. 23, кв. 14', 1, 45.50, 2, 'Occupied', NULL, 25000.00, NULL),
(2, '4-й Парковый проезд, д. 45, кв. 67', 1, 48.00, 2, 'Occupied', NULL, 28000.00, NULL),
(3, 'ул. Талалихина, д. 49, кв. 44', 1, 50.00, 2, 'Available', NULL, 30000.00, NULL),
(4, 'ул. 8-го Марта, д. 5, кв. 11', 2, 75.00, 3, 'Occupied', NULL, 45000.00, NULL),
(5, 'Фестивальная ул., д. 34, кв. 78', 2, 80.00, 3, 'Occupied', NULL, 50000.00, NULL),
(6, 'Ударная ул., д. 2', 3, 120.00, 4, 'Occupied', NULL, 80000.00, NULL),
(7, 'Набережная ул., д. 19, оф. 3', 5, 35.00, 1, 'Occupied', NULL, 40000.00, NULL),
(8, 'ул. Щорса, стр. 12', 6, 90.00, 3, 'Occupied', NULL, 120000.00, NULL),
(9, 'Фабричная ул., стр. 22', 7, 200.00, 0, 'Occupied', NULL, 50000.00, NULL),
(10, 'г. Москва, ул. Тверская, д. 10, кв. 5', 3, 54.30, 2, 'Available', NULL, 65000.00, 'Евроремонт, меблированная, вид на центр'),
(11, 'г. Москва, ул. Ленинградская, д. 25, кв. 12', 4, 78.50, 3, 'Occupied', NULL, 85000.00, 'Ремонт премиум-класса, панорамные окна'),
(12, 'г. Москва, ул. Садовая, д. 15, кв. 7', 2, 32.70, 1, 'Available', NULL, 45000.00, 'Свежий ремонт, удобная планировка'),
(13, 'МО, г. Красногорск, ул. Центральная, д. 5', 5, 145.00, 5, 'Available', NULL, 120000.00, 'Коттедж с участком, охраняемая территория'),
(14, 'г. Москва, ул. Деловая, д. 12, оф. 34', 6, 45.00, 1, 'Occupied', NULL, 75000.00, 'Офис в бизнес-центре класса А'),
(15, 'г. Москва, ул. Торговая, д. 3', 7, 85.00, 1, 'Available', NULL, 95000.00, 'Торговая площадь с витринами, отдельный вход'),
(16, 'МО, г. Химки, ул. Промышленная, д. 8', 8, 200.00, 0, 'Available', NULL, 60000.00, 'Склад с подъемными воротами, охрана');

-- --------------------------------------------------------

--
-- Структура таблицы `property_categories`
--

CREATE TABLE `property_categories` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `property_categories`
--

INSERT INTO `property_categories` (`category_id`, `category_name`, `description`) VALUES
(1, 'Квартира 2-комнатная', 'Двухкомнатные квартиры'),
(2, 'Квартира 3-комнатная', 'Трехкомнатные квартиры'),
(3, 'Частное домовладение', 'Частные дома'),
(4, 'Офис бюджет', 'Бюджетные офисные помещения'),
(5, 'Офис стандарт', 'Стандартные офисные помещения'),
(6, 'Офис премиум', 'Премиальные офисные помещения'),
(7, 'Склад', 'Складские помещения'),
(8, 'Садовый участок', 'Земельные участки в садоводствах'),
(9, 'Загородный дом', 'Дома за городом'),
(10, 'Квартира-студия', 'Компактные квартиры свободной планировки'),
(11, '1-комнатная квартира', 'Квартиры с одной жилой комнатой'),
(12, '2-комнатная квартира', 'Квартиры с двумя жилыми комнатами'),
(13, '3-комнатная квартира', 'Просторные квартиры с тремя комнатами'),
(14, 'Частный дом', 'Отдельно стоящие жилые дома'),
(15, 'Офисное помещение', 'Помещения для офисной деятельности'),
(16, 'Торговое помещение', 'Помещения для розничной торговли'),
(17, 'Складское помещение', 'Помещения для хранения товаров'),
(18, 'Квартира-студия', 'Компактные квартиры свободной планировки'),
(19, '1-комнатная квартира', 'Квартиры с одной жилой комнатой'),
(20, '2-комнатная квартира', 'Квартиры с двумя жилыми комнатами'),
(21, '3-комнатная квартира', 'Просторные квартиры с тремя комнатами'),
(22, 'Частный дом', 'Отдельно стоящие жилые дома'),
(23, 'Офисное помещение', 'Помещения для офисной деятельности'),
(24, 'Торговое помещение', 'Помещения для розничной торговли'),
(25, 'Складское помещение', 'Помещения для хранения товаров');

-- --------------------------------------------------------

--
-- Структура таблицы `rentals`
--

CREATE TABLE `rentals` (
  `rental_id` int(11) NOT NULL,
  `property_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime DEFAULT NULL,
  `monthly_price` decimal(10,2) NOT NULL,
  `status` enum('Active','Completed','Canceled') DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `rentals`
--

INSERT INTO `rentals` (`rental_id`, `property_id`, `client_id`, `user_id`, `start_date`, `end_date`, `monthly_price`, `status`) VALUES
(1, 2, 1, 2, '2024-01-01 00:00:00', '2024-12-31 00:00:00', 28000.00, 'Active'),
(2, 3, 2, 2, '2024-02-01 00:00:00', '2024-11-30 00:00:00', 30000.00, 'Active'),
(3, 4, 3, 3, '2023-12-01 00:00:00', '2024-11-30 00:00:00', 45000.00, 'Active');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('user','admin') NOT NULL DEFAULT 'user',
  `is_blocked` tinyint(1) NOT NULL DEFAULT 0,
  `login_attempts` int(11) NOT NULL DEFAULT 0,
  `last_login_date` datetime DEFAULT NULL,
  `must_change_password` tinyint(1) NOT NULL DEFAULT 0,
  `full_name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `role`, `is_blocked`, `login_attempts`, `last_login_date`, `must_change_password`, `full_name`) VALUES
(1, 'admin', 'admin123', 'admin', 0, 5, '2025-05-26 02:11:35', 0, 'Администратор Системы'),
(2, 'manager1', 'man123', 'user', 0, 0, NULL, 0, 'Менеджер Петров'),
(3, 'manager2', 'man222', 'user', 0, 0, NULL, 0, 'Менеджер Сидорова'),
(4, 'manager3', '123', 'user', 0, 0, NULL, 0, 'Менеджер Сидорова2'),
(5, 'manager4', '12334', 'user', 0, 0, NULL, 0, 'Менеджер Сидорова3'),
(6, 'manager5', '23233', 'user', 0, 0, NULL, 0, 'Менеджер Сидорова4');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `cleaning_assignments`
--
ALTER TABLE `cleaning_assignments`
  ADD PRIMARY KEY (`assignment_id`),
  ADD KEY `cleaning_id` (`cleaning_id`),
  ADD KEY `employee_id` (`employee_id`);

--
-- Индексы таблицы `cleaning_schedule`
--
ALTER TABLE `cleaning_schedule`
  ADD PRIMARY KEY (`cleaning_id`),
  ADD KEY `property_id` (`property_id`);

--
-- Индексы таблицы `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`client_id`);

--
-- Индексы таблицы `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`employee_id`);

--
-- Индексы таблицы `maintenance`
--
ALTER TABLE `maintenance`
  ADD PRIMARY KEY (`maintenance_id`),
  ADD KEY `property_id` (`property_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Индексы таблицы `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `rental_id` (`rental_id`);

--
-- Индексы таблицы `properties`
--
ALTER TABLE `properties`
  ADD PRIMARY KEY (`property_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Индексы таблицы `property_categories`
--
ALTER TABLE `property_categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Индексы таблицы `rentals`
--
ALTER TABLE `rentals`
  ADD PRIMARY KEY (`rental_id`),
  ADD KEY `property_id` (`property_id`),
  ADD KEY `client_id` (`client_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `cleaning_assignments`
--
ALTER TABLE `cleaning_assignments`
  MODIFY `assignment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `cleaning_schedule`
--
ALTER TABLE `cleaning_schedule`
  MODIFY `cleaning_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `clients`
--
ALTER TABLE `clients`
  MODIFY `client_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `employees`
--
ALTER TABLE `employees`
  MODIFY `employee_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `maintenance`
--
ALTER TABLE `maintenance`
  MODIFY `maintenance_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `properties`
--
ALTER TABLE `properties`
  MODIFY `property_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT для таблицы `property_categories`
--
ALTER TABLE `property_categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT для таблицы `rentals`
--
ALTER TABLE `rentals`
  MODIFY `rental_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `cleaning_assignments`
--
ALTER TABLE `cleaning_assignments`
  ADD CONSTRAINT `cleaning_assignments_ibfk_1` FOREIGN KEY (`cleaning_id`) REFERENCES `cleaning_schedule` (`cleaning_id`),
  ADD CONSTRAINT `cleaning_assignments_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`);

--
-- Ограничения внешнего ключа таблицы `cleaning_schedule`
--
ALTER TABLE `cleaning_schedule`
  ADD CONSTRAINT `cleaning_schedule_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`);

--
-- Ограничения внешнего ключа таблицы `maintenance`
--
ALTER TABLE `maintenance`
  ADD CONSTRAINT `maintenance_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`),
  ADD CONSTRAINT `maintenance_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`);

--
-- Ограничения внешнего ключа таблицы `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`rental_id`);

--
-- Ограничения внешнего ключа таблицы `properties`
--
ALTER TABLE `properties`
  ADD CONSTRAINT `properties_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `property_categories` (`category_id`);

--
-- Ограничения внешнего ключа таблицы `rentals`
--
ALTER TABLE `rentals`
  ADD CONSTRAINT `rentals_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`),
  ADD CONSTRAINT `rentals_ibfk_2` FOREIGN KEY (`client_id`) REFERENCES `clients` (`client_id`),
  ADD CONSTRAINT `rentals_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
