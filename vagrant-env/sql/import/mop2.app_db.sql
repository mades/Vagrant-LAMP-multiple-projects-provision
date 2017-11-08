-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Время создания: Фев 07 2017 г., 12:57
-- Версия сервера: 5.5.52-38.3
-- Версия PHP: 5.6.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `mades1989_mop`
--



--
-- Структура таблицы `user_notifications`
--

CREATE TABLE IF NOT EXISTS `user_notifications` (
  `user_id` int(11) UNSIGNED NOT NULL COMMENT 'Профиль',
  `type` enum('new_subscriber','new_message','new_room_message') NOT NULL,
  `object_id` int(11) UNSIGNED NOT NULL COMMENT 'На кого подписка',
  `from_user_id` int(10) UNSIGNED NOT NULL,
  `message` varchar(255) NOT NULL DEFAULT '',
  `data` text NOT NULL,
  `isnew` tinyint(4) NOT NULL DEFAULT '1',
  `created_at` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `updated_at` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`user_id`,`type`,`object_id`),
  KEY `created_at` (`created_at`),
  KEY `updated_at` (`updated_at`),
  KEY `user_id` (`user_id`),
  KEY `isnew` (`isnew`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Уведомления пользователя';

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;