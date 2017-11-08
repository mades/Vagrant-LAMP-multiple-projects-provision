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

-- --------------------------------------------------------

--
-- Структура таблицы `comments`
--

CREATE TABLE IF NOT EXISTS `comments` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `active` tinyint(4) NOT NULL DEFAULT '1',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `guest_name` varchar(255) NOT NULL DEFAULT '',
  `ip` varchar(255) NOT NULL DEFAULT '',
  `object_type` varchar(50) NOT NULL DEFAULT 'none',
  `object_id` int(10) UNSIGNED DEFAULT '0',
  `subobject_id` int(10) UNSIGNED DEFAULT '0',
  `message` text NOT NULL,
  `parent_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `parents_string` varchar(255) NOT NULL DEFAULT '',
  `parent_level` int(11) NOT NULL DEFAULT '0',
  `created_at` int(10) UNSIGNED NOT NULL,
  `updated_at` int(10) UNSIGNED NOT NULL,
  `thumbs_up_count` int(11) NOT NULL DEFAULT '0',
  `thumbs_down_count` int(11) NOT NULL DEFAULT '0',
  `complain_count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `object_type` (`object_type`,`object_id`),
  KEY `active` (`active`),
  KEY `parents_string` (`parents_string`)
) ENGINE=MyISAM AUTO_INCREMENT=905 DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `comments`
--

INSERT INTO `comments` (`id`, `active`, `user_id`, `guest_name`, `ip`, `object_type`, `object_id`, `subobject_id`, `message`, `parent_id`, `parents_string`, `parent_level`, `created_at`, `updated_at`, `thumbs_up_count`, `thumbs_down_count`, `complain_count`) VALUES
(898, 2, 50, '', '46.216.218.36', 'blog', 1, 0, 'Опа-па', 0, ':00000000898:', 0, 1454415406, 1454415570, 0, 1, 0),
(899, 2, 50, '', '46.216.218.49', 'blog', 1, 0, '12', 0, ':00000000899:', 0, 1454595155, 1454595256, 1, 0, 0),
(901, 2, 50, '', '46.216.218.49', 'blog', 1, 0, 'dsfsd', 0, ':00000000901:', 0, 1454595335, 1454595335, 1, 0, 0),
(904, 2, 50, '', '46.216.218.49', 'blog', 1, 0, 'dsfsd', 899, ':00000000899:00000000904:', 1, 1454595423, 1454595423, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `thumbs`
--

CREATE TABLE IF NOT EXISTS `thumbs` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `ip` varchar(255) NOT NULL DEFAULT '',
  `object_type` varchar(255) NOT NULL DEFAULT 'none',
  `object_id` int(11) UNSIGNED NOT NULL,
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '1 - down, 2 - up, -1 - complain',
  `created_at` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `updated_at` int(10) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `type` (`type`),
  KEY `object_index` (`object_type`,`object_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1212 DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `thumbs`
--

INSERT INTO `thumbs` (`id`, `user_id`, `ip`, `object_type`, `object_id`, `type`, `created_at`, `updated_at`) VALUES
(1207, 50, '46.216.218.49', 'comment', 901, 2, 1454584643, 1454584643),
(1210, 50, '46.216.218.49', 'comment', 898, 1, 1454584660, 1454584660),
(1211, 50, '80.249.93.6', 'comment', 899, 2, 1454595577, 1454595577);

-- --------------------------------------------------------
