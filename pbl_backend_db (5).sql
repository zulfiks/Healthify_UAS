-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jul 03, 2026 at 02:13 AM
-- Server version: 8.4.3
-- PHP Version: 8.3.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pbl_backend_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `achievements`
--

CREATE TABLE `achievements` (
  `id` bigint NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `description` text,
  `badge_icon` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `achievements`
--

INSERT INTO `achievements` (`id`, `title`, `description`, `badge_icon`) VALUES
(1, 'Beginner Logger', '3 hari mencatat makanan', '🥉'),
(2, 'Food Warrior', '7 hari mencatat makanan', '🥈'),
(3, 'Nutrition Master', '30 hari mencatat makanan', '🥇'),
(4, 'Sugar Fighter', '3 hari tanpa minuman manis', '🥤'),
(5, 'Active Walker', '5 hari berjalan kaki', '🚶');

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

CREATE TABLE `activity_logs` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `activity_type` varchar(100) NOT NULL,
  `duration_minutes` int NOT NULL,
  `intensity` enum('ringan','sedang','berat') NOT NULL,
  `calories_burned` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `activity_logs`
--

INSERT INTO `activity_logs` (`id`, `user_id`, `activity_type`, `duration_minutes`, `intensity`, `calories_burned`, `created_at`, `updated_at`) VALUES
(7, 2, 'Jalan kaki', 20, 'ringan', 80, NULL, NULL),
(8, 2, 'Jalan kaki', 20, 'ringan', 80, NULL, NULL),
(9, 18, 'Bersepeda', 120, 'ringan', 0, NULL, NULL),
(10, 18, 'Bersepeda', 120, 'ringan', 0, NULL, NULL),
(15, 18, 'Jalan Kaki', 20, 'ringan', 80, NULL, NULL),
(16, 18, 'Jalan kaki', 20, 'ringan', 56, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `activity_programs`
--

CREATE TABLE `activity_programs` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `current_week` tinyint NOT NULL DEFAULT '1',
  `completed_sessions` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `activity_programs`
--

INSERT INTO `activity_programs` (`id`, `user_id`, `current_week`, `completed_sessions`, `created_at`, `updated_at`) VALUES
(1, 18, 1, 2, '2026-07-01 03:52:20', '2026-07-02 07:41:12'),
(2, 9, 1, 0, '2026-07-02 08:12:12', '2026-07-02 08:12:12');

-- --------------------------------------------------------

--
-- Table structure for table `activity_recommendations`
--

CREATE TABLE `activity_recommendations` (
  `id` bigint NOT NULL,
  `week` int NOT NULL,
  `min_bmi` double NOT NULL,
  `max_bmi` double NOT NULL,
  `activity_name` varchar(100) DEFAULT NULL,
  `duration_minutes` int DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `activity_recommendations`
--

INSERT INTO `activity_recommendations` (`id`, `week`, `min_bmi`, `max_bmi`, `activity_name`, `duration_minutes`, `description`, `created_at`, `updated_at`) VALUES
(1, 1, 0, 100, 'Jalan Kaki', 15, 'Mulai perlahan dengan jalan kaki ringan', NULL, NULL),
(2, 2, 0, 100, 'Jalan Kaki', 20, 'Tambah durasi menjadi 20 menit', NULL, NULL),
(3, 3, 0, 100, 'Jalan Kaki + Peregangan', 25, 'Tambahkan peregangan ringan', NULL, NULL),
(4, 4, 0, 100, 'Jalan Kaki + Squat Ringan', 30, 'Evaluasi kemampuan tubuh', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('super_admin','nutritionist','admin') DEFAULT 'admin',
  `is_active` tinyint(1) DEFAULT '1',
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `name`, `email`, `password`, `role`, `is_active`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Healthify Admin', 'admin@healthify.com', '$2y$12$RolAyxX1VU2NZKa5Glgv4.UGvzc9CQkK/9EQ2znS/VBIfTsSi6eiG', 'super_admin', 1, NULL, NULL, '2026-07-02 07:11:16');

-- --------------------------------------------------------

--
-- Table structure for table `behavior_coaching_history`
--

CREATE TABLE `behavior_coaching_history` (
  `id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `motivation` text,
  `habit_evaluation` text,
  `overeating_strategy` text,
  `mindful_eating` text,
  `craving_support` text,
  `generated_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `challenge_progress`
--

CREATE TABLE `challenge_progress` (
  `id` bigint NOT NULL,
  `user_id` bigint DEFAULT NULL,
  `challenge_id` bigint DEFAULT NULL,
  `progress_days` int DEFAULT '0',
  `completed` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `coaching_histories`
--

CREATE TABLE `coaching_histories` (
  `id` bigint NOT NULL,
  `user_id` int DEFAULT NULL,
  `template_id` bigint DEFAULT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `coaching_histories`
--

INSERT INTO `coaching_histories` (`id`, `user_id`, `template_id`, `read_at`, `created_at`, `updated_at`) VALUES
(1, 9, 3, '2026-06-09 09:26:05', '2026-06-09 09:26:05', '2026-06-09 09:26:05'),
(2, 9, 1, '2026-06-09 09:29:36', '2026-06-09 09:29:36', '2026-06-09 09:29:36'),
(3, 9, 1, '2026-06-09 09:30:04', '2026-06-09 09:30:04', '2026-06-09 09:30:04'),
(4, 2, 3, '2026-06-09 09:30:36', '2026-06-09 09:30:36', '2026-06-09 09:30:36'),
(5, 2, 1, '2026-06-09 09:32:40', '2026-06-09 09:32:40', '2026-06-09 09:32:40'),
(6, 2, 4, '2026-06-09 09:33:11', '2026-06-09 09:33:11', '2026-06-09 09:33:11'),
(7, 2, 1, '2026-06-09 09:33:24', '2026-06-09 09:33:24', '2026-06-09 09:33:24'),
(8, 2, 1, '2026-06-09 09:33:34', '2026-06-09 09:33:34', '2026-06-09 09:33:34'),
(9, 9, 6, '2026-06-09 09:49:38', '2026-06-09 09:49:38', '2026-06-09 09:49:38'),
(10, 10, 11, '2026-06-09 09:52:01', '2026-06-09 09:52:01', '2026-06-09 09:52:01'),
(11, 10, 11, '2026-06-09 09:52:22', '2026-06-09 09:52:22', '2026-06-09 09:52:22'),
(12, 10, 10, '2026-06-09 09:53:07', '2026-06-09 09:53:07', '2026-06-09 09:53:07'),
(13, 10, 10, '2026-06-09 09:53:45', '2026-06-09 09:53:45', '2026-06-09 09:53:45'),
(14, 10, 11, '2026-06-09 09:54:04', '2026-06-09 09:54:04', '2026-06-09 09:54:04'),
(15, 10, 10, '2026-06-09 09:54:51', '2026-06-09 09:54:51', '2026-06-09 09:54:51'),
(16, 10, 6, '2026-06-09 09:55:42', '2026-06-09 09:55:42', '2026-06-09 09:55:42'),
(17, 10, 7, '2026-06-09 10:23:02', '2026-06-09 10:23:02', '2026-06-09 10:23:02'),
(18, 10, 6, '2026-06-09 21:31:09', '2026-06-09 21:31:09', '2026-06-09 21:31:09'),
(19, 10, 7, '2026-06-09 21:34:18', '2026-06-09 21:34:18', '2026-06-09 21:34:18'),
(20, 10, 7, '2026-06-09 22:21:52', '2026-06-09 22:21:52', '2026-06-09 22:21:52'),
(21, 10, 6, '2026-06-09 22:32:06', '2026-06-09 22:32:06', '2026-06-09 22:32:06'),
(22, 10, 7, '2026-06-09 22:33:02', '2026-06-09 22:33:02', '2026-06-09 22:33:02'),
(23, 10, 6, '2026-06-09 23:13:03', '2026-06-09 23:13:03', '2026-06-09 23:13:03'),
(24, 10, 6, '2026-06-10 00:08:04', '2026-06-10 00:08:04', '2026-06-10 00:08:04'),
(25, 10, 6, '2026-06-10 01:15:56', '2026-06-10 01:15:56', '2026-06-10 01:15:56'),
(26, 12, 3, '2026-06-10 02:06:58', '2026-06-10 02:06:58', '2026-06-10 02:06:58'),
(27, 12, 4, '2026-06-10 02:07:29', '2026-06-10 02:07:29', '2026-06-10 02:07:29'),
(28, 12, 6, '2026-06-10 02:09:38', '2026-06-10 02:09:38', '2026-06-10 02:09:38'),
(29, 10, 6, '2026-06-10 06:43:45', '2026-06-10 06:43:45', '2026-06-10 06:43:45'),
(30, 10, 6, '2026-06-10 06:43:56', '2026-06-10 06:43:56', '2026-06-10 06:43:56'),
(31, 10, 6, '2026-06-10 06:54:34', '2026-06-10 06:54:34', '2026-06-10 06:54:34'),
(32, 9, 6, '2026-06-10 06:58:45', '2026-06-10 06:58:45', '2026-06-10 06:58:45'),
(33, 9, 11, '2026-06-10 07:02:32', '2026-06-10 07:02:32', '2026-06-10 07:02:32'),
(34, 9, 10, '2026-06-10 07:07:05', '2026-06-10 07:07:05', '2026-06-10 07:07:05'),
(35, 9, 11, '2026-06-10 07:07:39', '2026-06-10 07:07:39', '2026-06-10 07:07:39'),
(36, 2, 7, '2026-06-10 21:32:26', '2026-06-10 21:32:26', '2026-06-10 21:32:26'),
(37, 2, 9, '2026-06-10 21:40:34', '2026-06-10 21:40:34', '2026-06-10 21:40:34'),
(38, 2, 11, '2026-06-10 21:42:48', '2026-06-10 21:42:48', '2026-06-10 21:42:48'),
(39, 2, 10, '2026-06-10 21:54:16', '2026-06-10 21:54:16', '2026-06-10 21:54:16'),
(40, 2, 11, '2026-06-10 22:01:34', '2026-06-10 22:01:34', '2026-06-10 22:01:34'),
(41, 2, 10, '2026-06-10 22:57:40', '2026-06-10 22:57:40', '2026-06-10 22:57:40'),
(42, 2, 10, '2026-06-10 23:23:25', '2026-06-10 23:23:25', '2026-06-10 23:23:25'),
(43, 10, 6, '2026-06-11 01:17:54', '2026-06-11 01:17:54', '2026-06-11 01:17:54'),
(44, 10, 6, '2026-06-11 01:18:05', '2026-06-11 01:18:05', '2026-06-11 01:18:05'),
(45, 10, 6, '2026-06-11 01:30:05', '2026-06-11 01:30:05', '2026-06-11 01:30:05'),
(46, 10, 6, '2026-06-11 01:31:45', '2026-06-11 01:31:45', '2026-06-11 01:31:45'),
(47, 9, 11, '2026-06-11 01:42:35', '2026-06-11 01:42:35', '2026-06-11 01:42:35'),
(48, 10, 6, '2026-06-11 03:11:16', '2026-06-11 03:11:16', '2026-06-11 03:11:16'),
(49, 10, 7, '2026-06-11 03:12:27', '2026-06-11 03:12:27', '2026-06-11 03:12:27'),
(50, 2, 11, '2026-06-11 03:33:32', '2026-06-11 03:33:32', '2026-06-11 03:33:32'),
(51, 10, 7, '2026-06-11 03:34:45', '2026-06-11 03:34:45', '2026-06-11 03:34:45'),
(52, 9, 11, '2026-06-11 03:55:10', '2026-06-11 03:55:10', '2026-06-11 03:55:10'),
(53, 9, 10, '2026-06-11 04:29:37', '2026-06-11 04:29:37', '2026-06-11 04:29:37'),
(54, 9, 11, '2026-06-11 04:50:05', '2026-06-11 04:50:05', '2026-06-11 04:50:05'),
(55, 9, 10, '2026-06-11 04:50:50', '2026-06-11 04:50:50', '2026-06-11 04:50:50'),
(56, 9, 11, '2026-06-11 04:51:09', '2026-06-11 04:51:09', '2026-06-11 04:51:09'),
(57, 9, 11, '2026-06-11 04:52:38', '2026-06-11 04:52:38', '2026-06-11 04:52:38'),
(58, 9, 6, '2026-06-11 04:53:48', '2026-06-11 04:53:48', '2026-06-11 04:53:48'),
(59, 9, 7, '2026-06-11 05:15:15', '2026-06-11 05:15:15', '2026-06-11 05:15:15'),
(60, 9, 7, '2026-06-11 05:24:39', '2026-06-11 05:24:39', '2026-06-11 05:24:39'),
(61, 9, 6, '2026-06-11 05:26:07', '2026-06-11 05:26:07', '2026-06-11 05:26:07'),
(62, 2, 11, '2026-06-11 05:28:36', '2026-06-11 05:28:36', '2026-06-11 05:28:36'),
(63, 9, 7, '2026-06-11 05:45:15', '2026-06-11 05:45:15', '2026-06-11 05:45:15'),
(64, 9, 7, '2026-06-11 05:45:58', '2026-06-11 05:45:58', '2026-06-11 05:45:58'),
(65, 10, 7, '2026-06-11 05:55:10', '2026-06-11 05:55:10', '2026-06-11 05:55:10'),
(66, 10, 6, '2026-06-11 05:55:48', '2026-06-11 05:55:48', '2026-06-11 05:55:48'),
(67, 10, 6, '2026-06-11 05:57:02', '2026-06-11 05:57:02', '2026-06-11 05:57:02'),
(68, 9, 10, '2026-06-11 06:25:56', '2026-06-11 06:25:56', '2026-06-11 06:25:56'),
(69, 9, 10, '2026-06-11 06:28:59', '2026-06-11 06:28:59', '2026-06-11 06:28:59'),
(70, 10, 6, '2026-06-11 06:29:23', '2026-06-11 06:29:23', '2026-06-11 06:29:23'),
(71, 10, 7, '2026-06-11 06:32:28', '2026-06-11 06:32:28', '2026-06-11 06:32:28'),
(72, 9, 11, '2026-06-11 06:40:47', '2026-06-11 06:40:47', '2026-06-11 06:40:47'),
(73, 9, 10, '2026-06-11 06:44:18', '2026-06-11 06:44:18', '2026-06-11 06:44:18'),
(74, 9, 10, '2026-06-11 06:44:45', '2026-06-11 06:44:45', '2026-06-11 06:44:45'),
(75, 9, 10, '2026-06-11 06:50:47', '2026-06-11 06:50:47', '2026-06-11 06:50:47'),
(76, 10, 6, '2026-06-11 06:59:33', '2026-06-11 06:59:33', '2026-06-11 06:59:33'),
(77, 10, 6, '2026-06-11 07:00:54', '2026-06-11 07:00:54', '2026-06-11 07:00:54'),
(78, 9, 11, '2026-06-11 07:01:07', '2026-06-11 07:01:07', '2026-06-11 07:01:07'),
(79, 9, 11, '2026-06-11 07:02:47', '2026-06-11 07:02:47', '2026-06-11 07:02:47'),
(80, 10, 6, '2026-06-11 07:16:57', '2026-06-11 07:16:57', '2026-06-11 07:16:57'),
(81, 10, 10, '2026-06-11 07:19:09', '2026-06-11 07:19:09', '2026-06-11 07:19:09'),
(82, 15, 10, '2026-06-11 07:36:57', '2026-06-11 07:36:57', '2026-06-11 07:36:57'),
(83, 15, 11, '2026-06-11 07:38:50', '2026-06-11 07:38:50', '2026-06-11 07:38:50'),
(84, 15, 11, '2026-06-11 07:44:05', '2026-06-11 07:44:05', '2026-06-11 07:44:05'),
(85, 15, 11, '2026-06-11 07:44:26', '2026-06-11 07:44:26', '2026-06-11 07:44:26'),
(86, 9, 11, '2026-06-11 07:52:46', '2026-06-11 07:52:46', '2026-06-11 07:52:46'),
(87, 9, 11, '2026-06-11 07:53:15', '2026-06-11 07:53:15', '2026-06-11 07:53:15'),
(88, 9, 7, '2026-06-11 07:56:42', '2026-06-11 07:56:42', '2026-06-11 07:56:42'),
(89, 9, 6, '2026-06-11 07:56:55', '2026-06-11 07:56:55', '2026-06-11 07:56:55'),
(90, 9, 7, '2026-06-11 07:58:13', '2026-06-11 07:58:13', '2026-06-11 07:58:13'),
(91, 9, 6, '2026-06-11 07:59:01', '2026-06-11 07:59:01', '2026-06-11 07:59:01'),
(92, 9, 7, '2026-06-11 08:58:15', '2026-06-11 08:58:15', '2026-06-11 08:58:15'),
(93, 9, 6, '2026-06-11 08:58:48', '2026-06-11 08:58:48', '2026-06-11 08:58:48'),
(94, 9, 7, '2026-06-11 08:59:04', '2026-06-11 08:59:04', '2026-06-11 08:59:04'),
(95, 9, 7, '2026-06-11 08:59:35', '2026-06-11 08:59:35', '2026-06-11 08:59:35'),
(96, 9, 6, '2026-06-11 08:59:49', '2026-06-11 08:59:49', '2026-06-11 08:59:49'),
(97, 9, 7, '2026-06-11 09:00:15', '2026-06-11 09:00:15', '2026-06-11 09:00:15'),
(98, 9, 6, '2026-06-11 09:01:28', '2026-06-11 09:01:28', '2026-06-11 09:01:28'),
(99, 9, 7, '2026-06-11 09:06:10', '2026-06-11 09:06:10', '2026-06-11 09:06:10'),
(100, 16, 6, '2026-06-11 09:24:13', '2026-06-11 09:24:13', '2026-06-11 09:24:13'),
(101, 16, 6, '2026-06-11 09:24:54', '2026-06-11 09:24:54', '2026-06-11 09:24:54'),
(102, 16, 6, '2026-06-11 09:25:01', '2026-06-11 09:25:01', '2026-06-11 09:25:01'),
(103, 16, 7, '2026-06-11 09:25:20', '2026-06-11 09:25:20', '2026-06-11 09:25:20'),
(104, 16, 7, '2026-06-11 09:26:18', '2026-06-11 09:26:18', '2026-06-11 09:26:18'),
(105, 16, 6, '2026-06-11 09:28:23', '2026-06-11 09:28:23', '2026-06-11 09:28:23'),
(106, 16, 7, '2026-06-11 09:28:31', '2026-06-11 09:28:31', '2026-06-11 09:28:31'),
(107, 17, 11, '2026-06-11 09:45:51', '2026-06-11 09:45:51', '2026-06-11 09:45:51'),
(108, 17, 10, '2026-06-11 09:46:12', '2026-06-11 09:46:12', '2026-06-11 09:46:12'),
(109, 17, 11, '2026-06-11 09:46:35', '2026-06-11 09:46:35', '2026-06-11 09:46:35'),
(110, 17, 10, '2026-06-11 09:47:15', '2026-06-11 09:47:15', '2026-06-11 09:47:15'),
(111, 17, 11, '2026-06-11 09:47:33', '2026-06-11 09:47:33', '2026-06-11 09:47:33'),
(112, 9, 7, '2026-06-12 01:56:38', '2026-06-12 01:56:38', '2026-06-12 01:56:38'),
(113, 9, 10, '2026-06-12 02:00:12', '2026-06-12 02:00:12', '2026-06-12 02:00:12'),
(114, 9, 10, '2026-06-12 02:01:07', '2026-06-12 02:01:07', '2026-06-12 02:01:07'),
(115, 9, 11, '2026-06-12 02:51:10', '2026-06-12 02:51:10', '2026-06-12 02:51:10'),
(116, 10, 11, '2026-06-12 03:00:51', '2026-06-12 03:00:51', '2026-06-12 03:00:51'),
(117, 10, 11, '2026-06-12 03:02:31', '2026-06-12 03:02:31', '2026-06-12 03:02:31'),
(118, 18, 7, '2026-06-12 05:24:53', '2026-06-12 05:24:53', '2026-06-12 05:24:53'),
(119, 18, 1, '2026-06-12 05:25:33', '2026-06-12 05:25:33', '2026-06-12 05:25:33'),
(120, 18, 11, '2026-06-12 05:25:56', '2026-06-12 05:25:56', '2026-06-12 05:25:56'),
(121, 18, 3, '2026-06-12 05:26:09', '2026-06-12 05:26:09', '2026-06-12 05:26:09'),
(122, 18, 1, '2026-06-12 05:26:28', '2026-06-12 05:26:28', '2026-06-12 05:26:28'),
(123, 18, 10, '2026-06-12 05:26:34', '2026-06-12 05:26:34', '2026-06-12 05:26:34'),
(124, 18, 8, '2026-06-12 05:26:56', '2026-06-12 05:26:56', '2026-06-12 05:26:56'),
(125, 18, 8, '2026-06-12 05:27:27', '2026-06-12 05:27:27', '2026-06-12 05:27:27'),
(126, 18, 4, '2026-06-12 05:27:48', '2026-06-12 05:27:48', '2026-06-12 05:27:48'),
(127, 2, 10, '2026-06-12 05:28:00', '2026-06-12 05:28:00', '2026-06-12 05:28:00'),
(128, 2, 11, '2026-06-12 05:28:12', '2026-06-12 05:28:12', '2026-06-12 05:28:12'),
(129, 18, 8, '2026-06-12 06:19:55', '2026-06-12 06:19:55', '2026-06-12 06:19:55'),
(130, 18, 11, '2026-06-12 06:20:29', '2026-06-12 06:20:29', '2026-06-12 06:20:29'),
(131, 18, 3, '2026-06-12 06:20:49', '2026-06-12 06:20:49', '2026-06-12 06:20:49'),
(132, 9, 11, '2026-06-12 06:21:05', '2026-06-12 06:21:05', '2026-06-12 06:21:05'),
(133, 9, 10, '2026-06-12 06:22:03', '2026-06-12 06:22:03', '2026-06-12 06:22:03'),
(134, 9, 10, '2026-06-12 06:22:19', '2026-06-12 06:22:19', '2026-06-12 06:22:19'),
(135, 9, 11, '2026-06-12 06:22:33', '2026-06-12 06:22:33', '2026-06-12 06:22:33'),
(136, 9, 11, '2026-06-12 06:22:53', '2026-06-12 06:22:53', '2026-06-12 06:22:53'),
(137, 9, 11, '2026-06-12 06:23:02', '2026-06-12 06:23:02', '2026-06-12 06:23:02'),
(138, 9, 10, '2026-06-12 06:23:18', '2026-06-12 06:23:18', '2026-06-12 06:23:18'),
(139, 9, 11, '2026-06-12 06:23:43', '2026-06-12 06:23:43', '2026-06-12 06:23:43'),
(140, 9, 10, '2026-06-12 06:24:01', '2026-06-12 06:24:01', '2026-06-12 06:24:01'),
(141, 9, 11, '2026-06-12 06:24:11', '2026-06-12 06:24:11', '2026-06-12 06:24:11'),
(142, 10, 11, '2026-06-12 06:24:20', '2026-06-12 06:24:20', '2026-06-12 06:24:20'),
(143, 10, 11, '2026-06-12 06:24:27', '2026-06-12 06:24:27', '2026-06-12 06:24:27'),
(144, 18, 1, '2026-06-12 06:24:36', '2026-06-12 06:24:36', '2026-06-12 06:24:36'),
(145, 18, 2, '2026-06-12 06:52:06', '2026-06-12 06:52:06', '2026-06-12 06:52:06'),
(146, 18, 3, '2026-06-12 06:53:16', '2026-06-12 06:53:16', '2026-06-12 06:53:16'),
(147, 18, 2, '2026-06-12 06:53:35', '2026-06-12 06:53:35', '2026-06-12 06:53:35'),
(148, 18, 4, '2026-06-12 06:58:20', '2026-06-12 06:58:20', '2026-06-12 06:58:20'),
(149, 18, 6, '2026-06-12 06:59:00', '2026-06-12 06:59:00', '2026-06-12 06:59:00'),
(150, 18, 3, '2026-06-12 07:16:31', '2026-06-12 07:16:31', '2026-06-12 07:16:31'),
(151, 18, 8, '2026-06-12 07:16:38', '2026-06-12 07:16:38', '2026-06-12 07:16:38'),
(152, 18, 10, '2026-06-12 07:22:37', '2026-06-12 07:22:37', '2026-06-12 07:22:37'),
(153, 18, 5, '2026-06-12 07:23:06', '2026-06-12 07:23:06', '2026-06-12 07:23:06'),
(154, 18, 11, '2026-06-12 07:35:03', '2026-06-12 07:35:03', '2026-06-12 07:35:03'),
(155, 18, 2, '2026-06-12 07:35:09', '2026-06-12 07:35:09', '2026-06-12 07:35:09'),
(156, 9, 11, '2026-06-12 07:54:37', '2026-06-12 07:54:37', '2026-06-12 07:54:37'),
(157, 9, 11, '2026-06-12 07:54:43', '2026-06-12 07:54:43', '2026-06-12 07:54:43'),
(158, 18, 6, '2026-06-12 21:29:13', '2026-06-12 21:29:13', '2026-06-12 21:29:13'),
(159, 18, 1, '2026-06-12 21:29:56', '2026-06-12 21:29:56', '2026-06-12 21:29:56'),
(160, 18, 7, '2026-06-12 21:30:24', '2026-06-12 21:30:24', '2026-06-12 21:30:24'),
(161, 18, 7, '2026-06-12 21:30:27', '2026-06-12 21:30:27', '2026-06-12 21:30:27'),
(162, 18, 10, '2026-06-12 21:31:14', '2026-06-12 21:31:14', '2026-06-12 21:31:14'),
(163, 18, 5, '2026-06-12 21:35:32', '2026-06-12 21:35:32', '2026-06-12 21:35:32'),
(164, 18, 10, '2026-06-12 21:36:02', '2026-06-12 21:36:02', '2026-06-12 21:36:02'),
(165, 18, 9, '2026-06-12 21:37:31', '2026-06-12 21:37:31', '2026-06-12 21:37:31'),
(166, 18, 11, '2026-06-12 22:14:31', '2026-06-12 22:14:31', '2026-06-12 22:14:31'),
(167, 18, 3, '2026-06-12 22:19:50', '2026-06-12 22:19:50', '2026-06-12 22:19:50'),
(168, 18, 7, '2026-06-12 22:23:05', '2026-06-12 22:23:05', '2026-06-12 22:23:05'),
(169, 18, 7, '2026-06-12 22:23:41', '2026-06-12 22:23:41', '2026-06-12 22:23:41'),
(170, 10, 10, '2026-06-12 23:17:05', '2026-06-12 23:17:05', '2026-06-12 23:17:05'),
(171, 10, 10, '2026-06-12 23:17:51', '2026-06-12 23:17:51', '2026-06-12 23:17:51'),
(172, 10, 11, '2026-06-12 23:19:56', '2026-06-12 23:19:56', '2026-06-12 23:19:56'),
(173, 10, 10, '2026-06-12 23:30:56', '2026-06-12 23:30:56', '2026-06-12 23:30:56'),
(174, 10, 10, '2026-06-12 23:32:12', '2026-06-12 23:32:12', '2026-06-12 23:32:12'),
(175, 10, 11, '2026-06-12 23:32:32', '2026-06-12 23:32:32', '2026-06-12 23:32:32'),
(176, 9, 11, '2026-06-13 00:34:04', '2026-06-13 00:34:04', '2026-06-13 00:34:04'),
(177, 18, 6, '2026-06-15 08:29:28', '2026-06-15 08:29:28', '2026-06-15 08:29:28'),
(178, 18, 7, '2026-06-15 20:25:54', '2026-06-15 20:25:54', '2026-06-15 20:25:54'),
(179, 18, 6, '2026-06-15 20:26:43', '2026-06-15 20:26:43', '2026-06-15 20:26:43'),
(180, 18, 7, '2026-06-15 20:26:53', '2026-06-15 20:26:53', '2026-06-15 20:26:53'),
(181, 18, 7, '2026-06-15 20:27:37', '2026-06-15 20:27:37', '2026-06-15 20:27:37'),
(182, 18, 7, '2026-06-15 20:28:33', '2026-06-15 20:28:33', '2026-06-15 20:28:33'),
(183, 18, 6, '2026-06-16 08:09:41', '2026-06-16 08:09:41', '2026-06-16 08:09:41'),
(184, 18, 6, '2026-06-16 08:11:45', '2026-06-16 08:11:45', '2026-06-16 08:11:45'),
(185, 10, 11, '2026-06-16 08:37:03', '2026-06-16 08:37:03', '2026-06-16 08:37:03'),
(186, 10, 11, '2026-06-16 08:39:38', '2026-06-16 08:39:38', '2026-06-16 08:39:38'),
(187, 10, 10, '2026-06-16 08:42:18', '2026-06-16 08:42:18', '2026-06-16 08:42:18'),
(188, 18, 6, '2026-06-16 08:54:49', '2026-06-16 08:54:49', '2026-06-16 08:54:49'),
(189, 18, 6, '2026-06-16 08:55:23', '2026-06-16 08:55:23', '2026-06-16 08:55:23'),
(190, 18, 7, '2026-06-16 08:55:47', '2026-06-16 08:55:47', '2026-06-16 08:55:47'),
(191, 18, 8, '2026-06-16 08:56:46', '2026-06-16 08:56:46', '2026-06-16 08:56:46'),
(192, 9, 10, '2026-06-16 09:34:23', '2026-06-16 09:34:23', '2026-06-16 09:34:23'),
(193, 9, 11, '2026-06-16 09:34:40', '2026-06-16 09:34:40', '2026-06-16 09:34:40'),
(194, 9, 10, '2026-06-16 09:36:02', '2026-06-16 09:36:02', '2026-06-16 09:36:02'),
(195, 9, 10, '2026-06-16 09:36:33', '2026-06-16 09:36:33', '2026-06-16 09:36:33'),
(196, 9, 10, '2026-06-16 09:36:50', '2026-06-16 09:36:50', '2026-06-16 09:36:50'),
(197, 9, 10, '2026-06-16 09:37:30', '2026-06-16 09:37:30', '2026-06-16 09:37:30'),
(198, 9, 10, '2026-06-16 09:37:43', '2026-06-16 09:37:43', '2026-06-16 09:37:43'),
(199, 9, 10, '2026-06-16 09:38:13', '2026-06-16 09:38:13', '2026-06-16 09:38:13'),
(200, 9, 11, '2026-06-16 09:38:46', '2026-06-16 09:38:46', '2026-06-16 09:38:46'),
(201, 9, 11, '2026-06-16 10:17:18', '2026-06-16 10:17:18', '2026-06-16 10:17:18'),
(202, 2, 11, '2026-06-16 10:17:39', '2026-06-16 10:17:39', '2026-06-16 10:17:39'),
(203, 2, 10, '2026-06-16 10:19:01', '2026-06-16 10:19:01', '2026-06-16 10:19:01'),
(204, 10, 11, '2026-06-16 10:19:14', '2026-06-16 10:19:14', '2026-06-16 10:19:14'),
(205, 10, 11, '2026-06-16 10:19:30', '2026-06-16 10:19:30', '2026-06-16 10:19:30'),
(206, 10, 10, '2026-06-16 10:20:04', '2026-06-16 10:20:04', '2026-06-16 10:20:04'),
(207, 9, 10, '2026-06-16 10:20:24', '2026-06-16 10:20:24', '2026-06-16 10:20:24'),
(208, 9, 10, '2026-06-16 10:20:35', '2026-06-16 10:20:35', '2026-06-16 10:20:35'),
(209, 18, 8, '2026-06-18 05:35:00', '2026-06-18 05:35:00', '2026-06-18 05:35:00'),
(210, 18, 8, '2026-06-18 05:35:39', '2026-06-18 05:35:39', '2026-06-18 05:35:39'),
(211, 18, 8, '2026-06-18 05:35:51', '2026-06-18 05:35:51', '2026-06-18 05:35:51'),
(212, 18, 8, '2026-06-18 05:36:30', '2026-06-18 05:36:30', '2026-06-18 05:36:30'),
(213, 18, 8, '2026-06-18 05:36:50', '2026-06-18 05:36:50', '2026-06-18 05:36:50'),
(214, 9, 10, '2026-06-18 05:37:05', '2026-06-18 05:37:05', '2026-06-18 05:37:05'),
(215, 9, 11, '2026-06-18 05:37:19', '2026-06-18 05:37:19', '2026-06-18 05:37:19'),
(216, 9, 10, '2026-06-18 05:38:31', '2026-06-18 05:38:31', '2026-06-18 05:38:31'),
(217, 9, 11, '2026-06-18 05:39:40', '2026-06-18 05:39:40', '2026-06-18 05:39:40'),
(218, 9, 10, '2026-06-18 05:39:50', '2026-06-18 05:39:50', '2026-06-18 05:39:50'),
(219, 18, 8, '2026-06-18 05:39:56', '2026-06-18 05:39:56', '2026-06-18 05:39:56'),
(220, 18, 8, '2026-06-18 05:41:03', '2026-06-18 05:41:03', '2026-06-18 05:41:03'),
(221, 18, 8, '2026-06-18 05:50:04', '2026-06-18 05:50:04', '2026-06-18 05:50:04'),
(222, 18, 8, '2026-06-18 05:50:34', '2026-06-18 05:50:34', '2026-06-18 05:50:34'),
(223, 18, 8, '2026-06-18 06:17:07', '2026-06-18 06:17:07', '2026-06-18 06:17:07'),
(224, 18, 8, '2026-06-18 07:01:50', '2026-06-18 07:01:50', '2026-06-18 07:01:50'),
(225, 18, 8, '2026-06-18 07:06:59', '2026-06-18 07:06:59', '2026-06-18 07:06:59'),
(226, 18, 8, '2026-06-18 07:40:49', '2026-06-18 07:40:49', '2026-06-18 07:40:49'),
(227, 18, 8, '2026-06-18 07:41:07', '2026-06-18 07:41:07', '2026-06-18 07:41:07'),
(228, 18, 8, '2026-06-18 08:38:08', '2026-06-18 08:38:08', '2026-06-18 08:38:08'),
(229, 18, 8, '2026-06-18 08:38:41', '2026-06-18 08:38:41', '2026-06-18 08:38:41'),
(230, 18, 8, '2026-06-18 08:39:21', '2026-06-18 08:39:21', '2026-06-18 08:39:21'),
(231, 18, 8, '2026-06-18 08:39:44', '2026-06-18 08:39:44', '2026-06-18 08:39:44'),
(232, 18, 8, '2026-06-18 08:39:56', '2026-06-18 08:39:56', '2026-06-18 08:39:56'),
(233, 18, 8, '2026-06-18 08:40:06', '2026-06-18 08:40:06', '2026-06-18 08:40:06'),
(234, 18, 8, '2026-06-19 05:31:06', '2026-06-19 05:31:06', '2026-06-19 05:31:06'),
(235, 18, 8, '2026-06-19 05:41:45', '2026-06-19 05:41:45', '2026-06-19 05:41:45'),
(236, 18, 8, '2026-06-19 05:42:26', '2026-06-19 05:42:26', '2026-06-19 05:42:26'),
(237, 18, 8, '2026-06-19 05:49:25', '2026-06-19 05:49:25', '2026-06-19 05:49:25'),
(238, 18, 8, '2026-06-19 05:49:58', '2026-06-19 05:49:58', '2026-06-19 05:49:58'),
(239, 10, 11, '2026-06-19 05:50:26', '2026-06-19 05:50:26', '2026-06-19 05:50:26'),
(240, 10, 11, '2026-06-19 05:51:37', '2026-06-19 05:51:37', '2026-06-19 05:51:37'),
(241, 10, 11, '2026-06-19 05:52:08', '2026-06-19 05:52:08', '2026-06-19 05:52:08'),
(242, 10, 11, '2026-06-19 05:52:30', '2026-06-19 05:52:30', '2026-06-19 05:52:30'),
(243, 10, 10, '2026-06-19 05:53:07', '2026-06-19 05:53:07', '2026-06-19 05:53:07'),
(244, 10, 11, '2026-06-19 05:53:30', '2026-06-19 05:53:30', '2026-06-19 05:53:30'),
(245, 9, 11, '2026-06-19 05:53:48', '2026-06-19 05:53:48', '2026-06-19 05:53:48'),
(246, 9, 10, '2026-06-19 05:54:37', '2026-06-19 05:54:37', '2026-06-19 05:54:37'),
(247, 2, 10, '2026-06-19 06:45:12', '2026-06-19 06:45:12', '2026-06-19 06:45:12'),
(248, 2, 11, '2026-06-19 06:45:27', '2026-06-19 06:45:27', '2026-06-19 06:45:27'),
(249, 2, 10, '2026-06-19 06:46:28', '2026-06-19 06:46:28', '2026-06-19 06:46:28'),
(250, 15, 10, '2026-06-19 06:46:38', '2026-06-19 06:46:38', '2026-06-19 06:46:38'),
(251, 15, 10, '2026-06-19 06:55:22', '2026-06-19 06:55:22', '2026-06-19 06:55:22'),
(252, 18, 8, '2026-06-19 06:58:13', '2026-06-19 06:58:13', '2026-06-19 06:58:13'),
(253, 18, 8, '2026-06-22 01:06:40', '2026-06-22 01:06:40', '2026-06-22 01:06:40'),
(254, 18, 8, '2026-06-23 22:30:48', '2026-06-23 22:30:48', '2026-06-23 22:30:48'),
(255, 10, 11, '2026-06-23 22:53:44', '2026-06-23 22:53:44', '2026-06-23 22:53:44'),
(256, 10, 10, '2026-06-23 23:17:58', '2026-06-23 23:17:58', '2026-06-23 23:17:58'),
(257, 10, 11, '2026-06-23 23:19:28', '2026-06-23 23:19:28', '2026-06-23 23:19:28'),
(258, 18, 8, '2026-06-24 00:12:34', '2026-06-24 00:12:34', '2026-06-24 00:12:34'),
(259, 10, 11, '2026-06-24 00:27:49', '2026-06-24 00:27:49', '2026-06-24 00:27:49'),
(260, 10, 11, '2026-06-24 00:29:19', '2026-06-24 00:29:19', '2026-06-24 00:29:19'),
(261, 10, 10, '2026-06-24 01:13:53', '2026-06-24 01:13:53', '2026-06-24 01:13:53'),
(262, 18, 8, '2026-06-24 03:56:16', '2026-06-24 03:56:16', '2026-06-24 03:56:16'),
(263, 18, 11, '2026-06-24 03:58:06', '2026-06-24 03:58:06', '2026-06-24 03:58:06'),
(264, 9, 10, '2026-06-24 04:52:07', '2026-06-24 04:52:07', '2026-06-24 04:52:07'),
(265, 9, 11, '2026-06-24 04:53:20', '2026-06-24 04:53:20', '2026-06-24 04:53:20'),
(266, 9, 11, '2026-06-24 04:54:12', '2026-06-24 04:54:12', '2026-06-24 04:54:12'),
(267, 9, 10, '2026-06-24 04:54:59', '2026-06-24 04:54:59', '2026-06-24 04:54:59'),
(268, 9, 8, '2026-06-24 04:56:58', '2026-06-24 04:56:58', '2026-06-24 04:56:58'),
(269, 9, 8, '2026-06-24 04:58:02', '2026-06-24 04:58:02', '2026-06-24 04:58:02');

-- --------------------------------------------------------

--
-- Table structure for table `coaching_templates`
--

CREATE TABLE `coaching_templates` (
  `id` bigint NOT NULL,
  `category` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `message` text COLLATE utf8mb4_general_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `risk_level` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `coaching_templates`
--

INSERT INTO `coaching_templates` (`id`, `category`, `title`, `message`, `created_at`, `updated_at`, `risk_level`) VALUES
(1, 'motivation', 'Motivasi Harian', 'Setiap langkah kecil membawa perubahan besar. Tetap konsisten menjaga pola hidup sehat.', NULL, NULL, NULL),
(2, 'craving', 'Mengatasi Craving Malam', 'Kalau ingin ngemil malam, coba minum air putih dan tunggu 10 menit. Jika masih lapar, pilih buah atau yogurt rendah gula.', NULL, NULL, NULL),
(3, 'overeat', 'Mengurangi Makan Berlebih', 'Gunakan piring yang lebih kecil dan makan secara perlahan agar tubuh memiliki waktu mengenali rasa kenyang.', NULL, NULL, NULL),
(4, 'mindful', 'Mindful Eating', 'Fokus pada makanan yang sedang dikonsumsi dan hindari makan sambil bermain ponsel atau menonton.', NULL, NULL, NULL),
(5, 'habits', 'Evaluasi Kebiasaan', 'Mencatat makanan setiap hari adalah kebiasaan baik yang dapat membantu mengontrol asupan kalori.', NULL, NULL, NULL),
(6, 'motivation', 'Motivasi Harian', 'Pertahankan pola makan sehat dan aktivitas fisik secara rutin.', NULL, NULL, 'Normal'),
(7, 'mindful', 'Mindful Eating', 'Hindari makan sambil menonton atau bermain HP agar lebih sadar terhadap rasa kenyang.', NULL, NULL, 'Normal'),
(8, 'craving', 'Mengatasi Craving', 'Jika ingin ngemil malam, minumlah air putih terlebih dahulu dan tunggu 10 menit.', NULL, NULL, 'Moderate'),
(9, 'overeat', 'Mengurangi Makan Berlebih', 'Gunakan piring yang lebih kecil dan makan secara perlahan agar tubuh mengenali rasa kenyang.', NULL, NULL, 'High'),
(10, 'habits', 'Aktivitas Fisik Ringan', 'Mulailah dengan jalan santai 15-20 menit setiap hari dan tingkatkan secara bertahap.', NULL, NULL, 'Very High'),
(11, 'overeat', 'Kontrol Porsi Makan', 'Kurangi porsi makan sedikit demi sedikit dan hindari minuman tinggi gula.', NULL, NULL, 'Very High');

-- --------------------------------------------------------

--
-- Table structure for table `craving_histories`
--

CREATE TABLE `craving_histories` (
  `id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `craving_type` varchar(100) NOT NULL,
  `message` text,
  `ai_response` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `craving_histories`
--

INSERT INTO `craving_histories` (`id`, `user_id`, `craving_type`, `message`, `ai_response`, `created_at`, `updated_at`) VALUES
(1, 10, 'sweet_drink', 'Ingin minuman manis', 'Coba minum air putih terlebih dahulu dan tunggu 10 menit. Jika masih ingin minuman manis, pilih teh tanpa gula.', '2026-06-15 07:25:20', '2026-06-15 07:25:20'),
(2, 18, 'sweet_drink', 'Ingin minuman manis', 'Coba minum air putih terlebih dahulu dan tunggu 10 menit. Jika masih ingin minuman manis, pilih teh tanpa gula.', '2026-06-15 08:30:13', '2026-06-15 08:30:13'),
(3, 18, 'fast_food', 'Ingin fast food', 'Kamu tetap boleh makan ayam geprek, tetapi pilih nasi setengah porsi dan air putih agar menghemat sekitar 250 kkal.', '2026-06-15 08:30:15', '2026-06-15 08:30:15'),
(4, 18, 'night_snack', 'Lapar malam', 'Jika lapar malam, pilih buah, yoghurt rendah gula, atau telur rebus.', '2026-06-15 08:30:17', '2026-06-15 08:30:17'),
(5, 18, 'stress_eating', 'Makan karena stres', 'Cobalah berjalan ringan selama 10 menit atau lakukan pernapasan dalam sebelum makan.', '2026-06-15 08:30:18', '2026-06-15 08:30:18'),
(6, 0, 'sweet_drink', 'Ingin minuman manis', 'Coba minum air putih terlebih dahulu dan tunggu 10 menit. Jika masih ingin minuman manis, pilih teh tanpa gula.', '2026-06-15 08:36:48', '2026-06-15 08:36:48'),
(7, 0, 'fast_food', 'Ingin fast food', 'Kamu tetap boleh makan ayam geprek, tetapi pilih nasi setengah porsi dan air putih agar menghemat sekitar 250 kkal.', '2026-06-15 08:37:03', '2026-06-15 08:37:03'),
(8, 0, 'night_snack', 'Lapar malam', 'Jika lapar malam, pilih buah, yoghurt rendah gula, atau telur rebus.', '2026-06-15 08:37:09', '2026-06-15 08:37:09'),
(9, 0, 'stress_eating', 'Makan karena stres', 'Cobalah berjalan ringan selama 10 menit atau lakukan pernapasan dalam sebelum makan.', '2026-06-15 08:37:18', '2026-06-15 08:37:18'),
(10, 18, 'fast_food', 'fast_food', 'Delay Technique: \nTunggu selama 10 menit sebelum membeli makanan cepat saji untuk memberi waktu pada diri Anda untuk mempertimbangkan pilihan yang lebih sehat.\n\nHealthy Snack: \nPilih buah-buahan segar seperti apel atau jeruk sebagai camilan yang lebih sehat daripada makanan cepat saji.\n\nShort Motivation: \nAnda memiliki kekuatan untuk mengubah kebiasaan hidup sehat, mulai dari mengurangi konsumsi makanan cepat saji dan meningkatkan aktivitas fisik.\n\nDistraction Activity: \nLakukan aktivitas seperti berjalan kaki singkat atau melakukan peregangan ringan untuk mengalihkan perhatian dari craving makanan cepat saji.', '2026-06-24 07:16:00', '2026-06-24 07:16:00'),
(11, 15, 'night_snack', 'night_snack', 'Delay Technique: \nTunggu selama 10 menit sebelum mengambil camilan malam, ini dapat membantu Anda menilai apakah Anda benar-benar lapar atau hanya mengalami keinginan semata.\n\nHealthy Snack: \nPilih buah segar seperti apel atau jeruk, atau sayuran renyah seperti wortel dengan hummus sebagai alternatif sehat untuk camilan malam.\n\nShort Motivation: \nAnda kuat dan mampu mengontrol keinginan tidak sehat, setiap pilihan sehat yang Anda buat membawa Anda lebih dekat ke tujuan kesehatan yang lebih baik.\n\nDistraction Activity: \nLakukan kegiatan yang menyenangkan seperti membaca buku, mendengarkan musik, atau bermeditasi selama beberapa menit untuk mengalihkan perhatian dari keinginan camilan malam.', '2026-06-24 07:18:59', '2026-06-24 07:18:59'),
(12, 15, 'night_snack', 'night_snack', 'Delay Technique: \nTunda konsumsi camilan malam selama 10 menit untuk memberi waktu kepada diri Anda untuk mempertimbangkan apakah Anda benar-benar lapar atau hanya bosan.\n\nHealthy Snack: \nPilih buah segar seperti apel atau pisang sebagai camilan malam yang lebih sehat.\n\nShort Motivation: \nIngat, setiap pilihan sehat yang Anda buat membawa Anda lebih dekat kepada tubuh yang lebih baik dan lebih sehat.\n\nDistraction Activity: \nLakukan beberapa peregangan ringan atau minum segelas air untuk mengalihkan perhatian dari hasrat untuk mengonsumsi camilan malam.', '2026-06-24 07:22:06', '2026-06-24 07:22:06'),
(13, 18, 'fast_food', 'fast_food', 'Delay Technique: \nTunggu selama 10 menit sebelum membeli atau mengonsumsi fast food untuk memberi waktu bagi diri Anda untuk mempertimbangkan pilihan lain yang lebih sehat.\n\nHealthy Snack: \nPilih buah-buahan segar seperti apel atau pisang sebagai camilan sehat untuk mengurangi keinginan akan fast food.\n\nShort Motivation: \nSetiap pilihan sehat yang Anda buat hari ini akan membawa Anda lebih dekat kepada tubuh yang lebih kuat dan sehat, jadi jangan menyerah!\n\nDistraction Activity: \nLakukan aktivitas fisik ringan seperti berjalan kaki selama 5 menit atau melakukan peregangan untuk mengalihkan perhatian dari keinginan fast food dan meningkatkan energi.', '2026-06-25 23:25:24', '2026-06-25 23:25:24');

-- --------------------------------------------------------

--
-- Table structure for table `education_contents`
--

CREATE TABLE `education_contents` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `image_url` varchar(255) DEFAULT NULL,
  `type` enum('article','youtube','tiktok') DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `url` text,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `education_contents`
--

INSERT INTO `education_contents` (`id`, `title`, `description`, `image_url`, `type`, `category`, `url`, `created_at`, `updated_at`) VALUES
(1, 'Kenali Jenis Diet yang Ampuh Menurunkan Berat Badan', 'Banyak jenis diet yang ampuh menurunkan berat badan. Namun, apakah semua jenis diet tersebut aman bagi kesehatan? Agar tidak salah pilih, cari tahu dulu berbagai jenis diet yang ampuh dalam menurunkan berat badan, sekaligus sehat dan aman.', 'https://images.alodokter.com/dk0z4ums3/image/upload/v1607319365/attached_image/kenali-jenis-diet-yang-ampuh-menurunkan-berat-badan-0-alodokter.jpg', 'article', 'diet', 'https://www.alodokter.com/kenali-jenis-diet-yang-ampuh-menurunkan-berat-badan', '2026-06-24 06:25:16', '2026-06-24 06:25:16'),
(2, 'Tips Diet Anti Gagal, Bukan Cuma Mengurangi Makan ...\r\n', 'Diet anti gagal tidak hanya berkutat pada pengurangan porsi makan, tetapi juga mencakup perubahan kebiasaan', NULL, 'youtube', 'olahraga', 'https://www.youtube.com/watch?v=G_uKDsK1Z4U', '2026-06-24 06:27:25', '2026-06-24 06:27:25'),
(3, 'Tips Diet Sehat untuk Pemula\r\n', '\r\nprotein hewani nabati itu wajib sekali. makan tuh ada. untuk olahraganya. lebih direkomendasiin untuk kardio. Jalan kaki 30 menit. sebenarnya', 'https://i.ytimg.com/vi/y4i1a0X5S0s/oar2.jpg?sqp=-oaymwEoCJUDENAFSFqQAgHyq4qpAxcIARUAAIhC2AEB4gEKCBgQAhgGOAFAAQ==&rs=AOn4CLD4cW7z6_Ir-OZ5GNJEli5kFicMKw&usqp=CCk', 'tiktok', 'yoga', 'https://www.tiktok.com/@rsuherminabogor/video/7495689956384410898', '2026-06-24 06:30:55', '2026-06-24 06:30:55');

-- --------------------------------------------------------

--
-- Table structure for table `expert_reviews`
--

CREATE TABLE `expert_reviews` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `expert_name` varchar(100) NOT NULL,
  `ai_recommendation` longtext,
  `expert_note` longtext,
  `meal_plan` longtext,
  `status` enum('pending','approved','revised') DEFAULT 'pending',
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `expert_reviews`
--

INSERT INTO `expert_reviews` (`id`, `user_id`, `expert_name`, `ai_recommendation`, `expert_note`, `meal_plan`, `status`, `reviewed_at`, `created_at`, `updated_at`) VALUES
(3, 2, 'coba', NULL, 'coba', 'coba', 'pending', '2026-06-29 08:56:20', '2026-06-29 08:56:20', '2026-06-29 08:56:20'),
(4, 18, 'Dr. Beach', 'Focus: Penurunan berat badan bertahap dengan mengubah pola makan dan meningkatkan aktivitas fisik, serta mengelola kondisi diabetes.\n\nActivity Target: Mulai dengan berjalan kaki selama 30 menit, 3 kali seminggu, dan secara bertahap meningkatkan durasi dan frekuensi.\n\nSmall Habit: Mengganti minuman manis dengan air putih dan mengurangi konsumsi makanan cepat saji dengan membatasi frekuensi konsumsi menjadi 1 kali seminggu.\n\nMenu Recommendation: Menu lokal sehat seperti nasi merah dengan sayuran rebus, ikan bakar, dan buah-buahan segar seperti apel atau jeruk, serta mengonsumsi bubur kacang hijau atau gado-gado sebagai camilan sehat.', 'p pah', 'lol', 'revised', '2026-06-29 08:59:46', '2026-06-29 08:59:46', '2026-06-29 08:59:46'),
(5, 15, 'dr. lol', NULL, 'ai plan gaada?', 'coba makan yang lebih sehat', 'revised', '2026-06-29 09:01:19', '2026-06-29 09:01:19', '2026-06-29 09:01:19'),
(6, 19, 'dr gadungan', NULL, 'nope', 'nope', 'approved', '2026-06-29 23:49:14', '2026-06-29 23:49:14', '2026-06-29 23:49:14');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `foods`
--

CREATE TABLE `foods` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `calories` int NOT NULL,
  `protein` decimal(6,2) DEFAULT '0.00',
  `carbs` decimal(6,2) DEFAULT '0.00',
  `fat` decimal(6,2) DEFAULT '0.00',
  `serving_size` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1 porsi',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `foods`
--

INSERT INTO `foods` (`id`, `name`, `calories`, `protein`, `carbs`, `fat`, `serving_size`, `created_at`, `updated_at`) VALUES
(1, 'Nasi Padang (Ayam Pop)', 700, 32.00, 58.00, 26.00, '1 Porsi', '2026-05-06 08:32:46', '2026-05-06 08:32:46'),
(2, 'Nasi Pecel Madiun', 450, 12.00, 60.00, 14.00, '1 Porsi', '2026-05-06 08:32:46', '2026-05-06 08:32:46'),
(3, 'Bakso Sapi Urat', 380, 18.00, 35.00, 16.00, '1 Mangkuk', '2026-05-06 08:32:46', '2026-05-06 08:32:46'),
(4, 'Mie Ayam Pangsit', 420, 20.00, 50.00, 15.00, '1 Mangkuk', '2026-05-06 08:32:46', '2026-05-06 08:32:46'),
(5, 'Es Teh Manis', 85, 0.00, 22.00, 0.00, '1 Gelas', '2026-05-06 08:32:46', '2026-05-06 08:32:46'),
(6, 'Ayam Geprek & Nasi', 650, 28.00, 55.00, 25.00, '1 Porsi', '2026-05-06 08:32:46', '2026-05-06 08:32:46'),
(7, 'Gorengan (Bakwan/Tahu)', 140, 3.00, 12.00, 9.00, '1 Potong', '2026-05-06 08:32:46', '2026-05-06 08:32:46'),
(8, 'Seblak Kuah Pedas', 480, 12.00, 48.00, 20.00, '1 Mangkuk', '2026-05-06 08:32:46', '2026-05-06 08:32:46'),
(9, 'Soto Ayam', 320, 22.00, 18.00, 14.00, '1 Mangkuk', '2026-06-25 12:24:24', '2026-06-25 12:24:24'),
(10, 'Nasi Goreng Ayam', 620, 21.00, 68.00, 24.00, '1 Porsi', '2026-06-25 12:24:24', '2026-06-25 12:24:24');

-- --------------------------------------------------------

--
-- Table structure for table `food_logs`
--

CREATE TABLE `food_logs` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `food_id` bigint UNSIGNED DEFAULT NULL,
  `food_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `portion` double NOT NULL DEFAULT '1',
  `total_calories` int NOT NULL,
  `log_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `food_logs`
--

INSERT INTO `food_logs` (`id`, `user_id`, `food_id`, `food_name`, `portion`, `total_calories`, `log_date`, `created_at`, `updated_at`) VALUES
(1, 4, 1, 'Nasi Padang (Ayam Pop)', 1, 700, '2026-05-06', '2026-05-06 09:39:10', '2026-05-06 09:39:10'),
(2, 4, 3, 'Bakso Sapi Urat', 1, 380, '2026-05-06', '2026-05-06 09:45:35', '2026-05-06 09:45:35'),
(3, 4, 1, 'Nasi Padang (Ayam Pop)', 2, 1400, '2026-05-07', '2026-05-06 18:52:46', '2026-05-06 18:52:46'),
(5, 4, 1, 'Nasi Padang (Ayam Pop)', 1, 700, '2026-05-07', '2026-05-07 05:59:04', '2026-05-07 05:59:04'),
(6, 4, 2, 'Nasi Pecel Madiun', 1, 450, '2026-05-07', '2026-05-07 06:15:14', '2026-05-07 06:15:14'),
(7, 4, 1, 'Nasi Padang (Ayam Pop)', 1, 700, '2026-05-07', '2026-05-07 07:03:07', '2026-05-07 07:03:07'),
(8, 6, 2, 'Nasi Pecel Madiun', 0.5, 225, '2026-05-07', '2026-05-07 07:24:02', '2026-05-07 07:24:02'),
(9, 6, 1, 'Nasi Padang (Ayam Pop)', 1, 700, '2026-05-07', '2026-05-07 07:24:15', '2026-05-07 07:24:15'),
(10, 4, 1, 'Nasi Padang (Ayam Pop)', 1, 700, '2026-05-07', '2026-05-07 08:34:03', '2026-05-07 08:34:03'),
(14, 4, NULL, 'Nasi Padang', 1, 700, '2026-06-01', NULL, NULL),
(15, 4, NULL, 'spageti', 1, 250, '2026-06-01', NULL, NULL),
(16, 4, NULL, 'spageti', 1, 350, '2026-06-01', NULL, NULL),
(17, 4, NULL, 'spageti', 1, 250, '2026-06-01', NULL, NULL),
(18, 4, NULL, 'spageti', 1, 250, '2026-06-01', NULL, NULL),
(19, 4, NULL, 'spageti', 1, 250, '2026-06-01', NULL, NULL),
(20, 4, NULL, 'mie ayam', 1, 400, '2026-06-01', NULL, NULL),
(21, 4, NULL, 'perkedel', 1, 200, '2026-06-01', NULL, NULL),
(22, 4, NULL, 'mie ayam', 1, 400, '2026-06-01', NULL, NULL),
(23, 4, NULL, 'perkedel', 1, 250, '2026-06-01', NULL, NULL),
(24, 4, NULL, 'mie ayam', 1, 400, '2026-06-01', NULL, NULL),
(25, 4, NULL, 'perkedel', 1, 150, '2026-06-01', NULL, NULL),
(26, 4, NULL, 'mie ayam', 1, 400, '2026-06-01', NULL, NULL),
(27, 4, NULL, 'perkedel', 1, 200, '2026-06-01', NULL, NULL),
(28, 4, NULL, 'mie ayam', 1, 350, '2026-06-01', NULL, NULL),
(29, 4, NULL, 'perkedel', 1, 120, '2026-06-01', NULL, NULL),
(30, 4, NULL, 'mie ayam', 1, 400, '2026-06-01', NULL, NULL),
(31, 4, NULL, 'mie ayam', 1, 400, '2026-06-01', NULL, NULL),
(32, 4, NULL, 'mie ayam', 1, 400, '2026-06-01', NULL, NULL),
(33, 4, NULL, 'mie ayam', 1, 400, '2026-06-01', NULL, NULL),
(34, 4, NULL, 'mie ayam', 1, 400, '2026-06-01', NULL, NULL),
(35, 4, NULL, 'risol', 1, 200, '2026-06-01', NULL, NULL),
(36, 4, NULL, 'risol', 1, 120, '2026-06-01', NULL, NULL),
(37, 4, NULL, 'risol', 1, 200, '2026-06-01', NULL, NULL),
(38, 4, NULL, 'risol', 1, 120, '2026-06-01', NULL, NULL),
(39, 4, NULL, 'risol', 1, 200, '2026-06-01', NULL, NULL),
(40, 4, NULL, 'siomay', 1, 250, '2026-06-01', NULL, NULL),
(41, 4, NULL, 'siomay', 1, 500, '2026-06-01', NULL, NULL),
(42, 4, NULL, 'siomay', 1, 200, '2026-06-01', NULL, NULL),
(43, 4, NULL, 'siomay', 1, 500, '2026-06-01', NULL, NULL),
(44, 4, NULL, 'siomay', 1, 1000, '2026-06-01', NULL, NULL),
(45, 4, NULL, 'spageti', 1, 350, '2026-06-01', NULL, NULL),
(46, 4, NULL, 'spageti', 1, 300, '2026-06-01', NULL, NULL),
(47, 4, NULL, 'spageti', 1, 400, '2026-06-01', NULL, NULL),
(48, 4, NULL, 'spageti', 1, 300, '2026-06-01', NULL, NULL),
(49, 4, NULL, 'spageti', 1, 200, '2026-06-01', NULL, NULL),
(50, 4, NULL, 'mie ayam', 1, 400, '2026-06-01', NULL, NULL),
(51, 4, NULL, 'mie ayam', 1, 400, '2026-06-01', NULL, NULL),
(52, 4, NULL, 'mie ayam', 1, 400, '2026-06-01', NULL, NULL),
(53, 4, NULL, 'mie ayam', 1, 400, '2026-06-01', NULL, NULL),
(54, 4, NULL, 'mie ayam', 1, 400, '2026-06-01', NULL, NULL),
(55, 4, NULL, 'makanan yang Anda inginkan', 1, 0, '2026-06-01', NULL, NULL),
(56, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(57, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(58, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(59, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(60, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(61, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(62, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(63, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(64, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(65, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(66, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(67, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(68, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(69, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(70, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(71, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(72, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(73, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(74, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(75, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(76, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(77, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(78, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(79, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(80, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(81, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(82, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(83, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(84, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(85, 4, NULL, 'nasi goreng', 1, 500, '2026-06-01', NULL, NULL),
(86, 4, NULL, 'kwetiau', 1, 300, '2026-06-01', NULL, NULL),
(87, 4, NULL, 'kwetiau', 1, 320, '2026-06-01', NULL, NULL),
(88, 4, NULL, 'kwetiau', 1, 500, '2026-06-01', NULL, NULL),
(89, 4, NULL, 'kwetiau', 1, 300, '2026-06-01', NULL, NULL),
(90, 4, NULL, 'kwetiau', 1, 500, '2026-06-01', NULL, NULL),
(91, 4, 1, 'Nasi Goreng', 1, 500, '2026-06-01', '2026-06-01 12:54:53', '2026-06-01 12:54:53'),
(92, 4, 1, 'Nasi Goreng', 1, 500, '2026-06-01', '2026-06-01 12:54:54', '2026-06-01 12:54:54'),
(93, 4, 1, 'Nasi Goreng', 1, 500, '2026-06-01', '2026-06-01 12:54:55', '2026-06-01 12:54:55'),
(94, 4, 1, 'Nasi Goreng', 1, 500, '2026-06-01', '2026-06-01 12:54:55', '2026-06-01 12:54:55'),
(95, 4, 1, 'Nasi Goreng', 1, 500, '2026-06-01', '2026-06-01 12:54:56', '2026-06-01 12:54:56'),
(96, 4, 1, 'nasi goreng', 1, 400, '2026-06-01', '2026-06-01 13:04:43', '2026-06-01 13:04:43'),
(97, 4, 1, 'nasi goreng', 1, 400, '2026-06-01', '2026-06-01 13:04:43', '2026-06-01 13:04:43'),
(98, 4, 1, 'nasi goreng', 1, 400, '2026-06-01', '2026-06-01 13:04:44', '2026-06-01 13:04:44'),
(99, 4, 1, 'nasi goreng', 1, 400, '2026-06-01', '2026-06-01 13:04:45', '2026-06-01 13:04:45'),
(100, 4, 1, 'nasi goreng', 1, 400, '2026-06-01', '2026-06-01 13:04:46', '2026-06-01 13:04:46'),
(101, 4, 1, 'indomei', 1, 350, '2026-06-01', '2026-06-01 13:15:34', '2026-06-01 13:15:34'),
(102, 4, 1, 'indomei', 1, 350, '2026-06-01', '2026-06-01 13:15:35', '2026-06-01 13:15:35'),
(103, 4, 1, 'indomei', 1, 350, '2026-06-01', '2026-06-01 13:15:35', '2026-06-01 13:15:35'),
(104, 4, 1, 'indomei', 1, 350, '2026-06-01', '2026-06-01 13:15:36', '2026-06-01 13:15:36'),
(105, 4, 1, 'indomei', 1, 350, '2026-06-01', '2026-06-01 13:15:37', '2026-06-01 13:15:37'),
(106, 4, 1, 'mie goreng', 1, 550, '2026-06-01', '2026-06-01 13:24:52', '2026-06-01 13:24:52'),
(107, 4, 1, 'nasi goreng', 1, 400, '2026-06-01', '2026-06-01 13:31:53', '2026-06-01 13:31:53'),
(108, 4, 1, 'ayam', 1, 200, '2026-06-01', '2026-06-01 14:02:15', '2026-06-01 14:02:15'),
(109, 2, 1, 'ayam goreng', 1, 250, '2026-06-02', '2026-06-02 10:32:40', '2026-06-02 10:32:40'),
(110, 2, 1, 'ayam goreng', 1, 300, '2026-06-02', '2026-06-02 12:03:34', '2026-06-02 12:03:34'),
(111, 2, 1, 'nasi goreng', 1, 250, '2026-06-02', '2026-06-02 12:04:12', '2026-06-02 12:04:12'),
(112, 2, 1, 'pisang goreng', 1, 120, '2026-06-02', '2026-06-02 12:22:10', '2026-06-02 12:22:10'),
(113, 2, 1, 'nasi goreng', 1, 400, '2026-06-02', '2026-06-02 13:22:32', '2026-06-02 13:22:32'),
(114, 2, 1, 'Nasi Goreng', 1, 400, '2026-06-02', '2026-06-02 13:22:33', '2026-06-02 13:22:33'),
(115, 2, 1, 'buah', 1, 50, '2026-06-02', '2026-06-02 13:40:06', '2026-06-02 13:40:06'),
(116, 2, 1, 'takoyaki', 1, 200, '2026-06-02', '2026-06-02 13:54:49', '2026-06-02 13:54:49'),
(117, 2, 1, 'siomay', 1, 200, '2026-06-02', '2026-06-02 14:01:15', '2026-06-02 14:01:15'),
(118, 2, 1, 'nasi pecel', 1, 500, '2026-06-02', '2026-06-02 14:06:21', '2026-06-02 14:06:21'),
(119, 2, 1, 'siomay', 1, 200, '2026-06-02', '2026-06-02 14:55:43', '2026-06-02 14:55:43'),
(120, 2, 1, 'ayam crispy', 1, 300, '2026-06-02', '2026-06-02 15:08:02', '2026-06-02 15:08:02'),
(121, 2, 1, 'Ayam Crispy', 1, 300, '2026-06-02', '2026-06-02 15:08:05', '2026-06-02 15:08:05'),
(122, 2, 1, 'batagor', 1, 200, '2026-06-02', '2026-06-02 15:09:03', '2026-06-02 15:09:03'),
(123, 2, 1, 'batagor', 1, 250, '2026-06-02', '2026-06-02 15:09:21', '2026-06-02 15:09:21'),
(124, 2, 1, 'makaroni', 1, 200, '2026-06-02', '2026-06-02 15:16:19', '2026-06-02 15:16:19'),
(125, 2, 1, 'telur goreng', 1, 120, '2026-06-03', '2026-06-03 12:02:21', '2026-06-03 12:02:21'),
(126, 2, 1, 'telur goreng', 1, 100, '2026-06-03', '2026-06-03 12:19:36', '2026-06-03 12:19:36'),
(127, 2, 1, 'telur goreng', 1, 100, '2026-06-03', '2026-06-03 12:36:24', '2026-06-03 12:36:24'),
(128, 2, 1, 'roti', 1, 89, '2026-06-03', '2026-06-03 12:37:42', '2026-06-03 12:37:42'),
(129, 2, 1, 'roti', 1, 89, '2026-06-03', '2026-06-03 12:37:55', '2026-06-03 12:37:55'),
(130, 2, 1, 'ayam goreng', 1, 200, '2026-06-03', '2026-06-03 12:42:34', '2026-06-03 12:42:34'),
(131, 2, 1, 'Ayam Goreng', 1, 200, '2026-06-03', '2026-06-03 12:42:36', '2026-06-03 12:42:36'),
(132, 2, 1, 'ayam goreng', 1, 200, '2026-06-03', '2026-06-03 12:42:36', '2026-06-03 12:42:36'),
(133, 2, 1, 'pizza', 1, 300, '2026-06-03', '2026-06-03 12:46:38', '2026-06-03 12:46:38'),
(134, 2, 1, 'nasi goreng', 1, 500, '2026-06-03', '2026-06-03 13:02:10', '2026-06-03 13:02:10'),
(135, 2, 1, 'ayam geprek', 1, 400, '2026-06-03', '2026-06-03 13:34:46', '2026-06-03 13:34:46'),
(136, 2, 1, 'mie ayam', 1, 550, '2026-06-03', '2026-06-03 13:41:37', '2026-06-03 13:41:37'),
(137, 2, 1, 'nasi goreng', 1, 500, '2026-06-05', '2026-06-05 11:40:49', '2026-06-05 11:40:49'),
(138, 2, 1, 'seblak', 1, 250, '2026-06-05', '2026-06-05 12:47:36', '2026-06-05 12:47:36'),
(139, 2, 1, 'nasi pecel', 1, 500, '2026-06-05', '2026-06-05 12:55:06', '2026-06-05 12:55:06'),
(140, 2, 1, 'ayam bakar', 1, 200, '2026-06-05', '2026-06-05 13:06:06', '2026-06-05 13:06:06'),
(141, 2, 1, 'mie ayam', 1, 400, '2026-06-05', '2026-06-05 13:06:58', '2026-06-05 13:06:58'),
(142, 2, 1, 'bakso', 1, 200, '2026-06-05', '2026-06-05 13:07:08', '2026-06-05 13:07:08'),
(143, 2, 1, 'ayam geprek', 1, 350, '2026-06-05', '2026-06-05 13:07:38', '2026-06-05 13:07:38'),
(144, 2, 1, 'donat', 1, 0, '2026-06-05', '2026-06-05 13:15:36', '2026-06-05 13:15:36'),
(145, 2, 1, 'ayam goreng', 1, 0, '2026-06-05', '2026-06-05 13:17:09', '2026-06-05 13:17:09'),
(146, 2, 1, 'ayam bakar', 1, 200, '2026-06-07', '2026-06-07 13:36:29', '2026-06-07 13:36:29'),
(147, 2, 1, 'ayam balado', 1, 350, '2026-06-07', '2026-06-07 13:40:53', '2026-06-07 13:40:53'),
(148, 2, 1, 'sayur bayam', 1, 20, '2026-06-07', '2026-06-07 13:50:42', '2026-06-07 13:50:42'),
(149, 2, 1, 'sayur bayam', 1, 20, '2026-06-07', '2026-06-07 13:50:58', '2026-06-07 13:50:58'),
(150, 2, 1, 'nasi goreng', 1, 500, '2026-06-08', '2026-06-08 02:45:11', '2026-06-08 02:45:11'),
(151, 9, 5, 'Es Teh Manis', 1, 85, '2026-06-08', '2026-06-08 07:58:26', '2026-06-08 07:58:26'),
(153, 9, 1, 'Nasi Padang (Ayam Pop)', 1, 700, '2026-06-09', '2026-06-09 08:51:50', '2026-06-09 08:51:50'),
(155, 12, 2, 'Nasi Pecel Madiun', 1.5, 675, '2026-06-10', '2026-06-10 02:07:24', '2026-06-10 02:07:24'),
(156, 9, 4, 'Mie Ayam Pangsit', 5, 2100, '2026-06-10', '2026-06-10 07:07:00', '2026-06-10 07:07:00'),
(157, 9, 4, 'Mie Ayam Pangsit', 1, 420, '2026-06-10', '2026-06-10 07:07:35', '2026-06-10 07:07:35'),
(158, 2, 6, 'Ayam Geprek & Nasi', 2.5, 1625, '2026-06-11', '2026-06-10 21:54:12', '2026-06-10 21:54:12'),
(159, 2, 6, 'Ayam Geprek & Nasi', 1, 650, '2026-06-11', '2026-06-10 22:01:31', '2026-06-10 22:01:31'),
(162, 9, 3, 'Bakso Sapi Urat', 1, 380, '2026-06-11', '2026-06-11 04:50:58', '2026-06-11 04:50:58'),
(163, 9, 6, 'Ayam Geprek & Nasi', 1, 650, '2026-06-11', '2026-06-11 07:58:06', '2026-06-11 07:58:06'),
(164, 9, 6, 'Ayam Geprek & Nasi', 1, 650, '2026-06-11', '2026-06-11 07:58:49', '2026-06-11 07:58:49'),
(165, 9, 6, 'Ayam Geprek & Nasi', 1, 650, '2026-06-11', '2026-06-11 07:58:53', '2026-06-11 07:58:53'),
(166, 16, 1, 'Nasi Padang (Ayam Pop)', 1, 700, '2026-06-11', '2026-06-11 09:20:14', '2026-06-11 09:20:14'),
(167, 17, 6, 'Ayam Geprek & Nasi', 2, 1300, '2026-06-12', '2026-06-12 09:44:42', '2026-06-12 09:44:42'),
(168, 18, 1, 'Nasi Padang (Ayam Pop)', 1, 700, '2026-06-12', '2026-06-12 05:25:11', '2026-06-12 05:25:11'),
(169, 18, 2, 'Nasi Pecel Madiun', 2, 900, '2026-06-12', '2026-06-12 05:25:20', '2026-06-12 05:25:20'),
(170, 18, 3, 'Bakso Sapi Urat', 2, 760, '2026-06-12', '2026-06-12 05:25:29', '2026-06-12 05:25:29'),
(171, 18, 3, 'Bakso Sapi Urat', 1, 380, '2026-06-13', '2026-06-12 21:37:28', '2026-06-12 21:37:28'),
(172, 18, 3, 'Bakso Sapi Urat', 1, 380, '2026-06-16', '2026-06-16 08:11:23', '2026-06-16 08:11:23'),
(174, 18, 1, 'Nasi Padang (Ayam Pop)', 1, 700, '2026-06-16', '2026-06-16 08:55:14', '2026-06-16 08:55:14'),
(175, 18, 2, 'Nasi Pecel Madiun', 1, 450, '2026-06-16', '2026-06-16 08:55:38', '2026-06-16 08:55:38'),
(176, 9, 1, 'Nasi Padang (Ayam Pop)', 1, 700, '2026-06-16', '2026-06-16 09:34:35', '2026-06-16 09:34:35'),
(177, 9, 1, 'Nasi Padang (Ayam Pop)', 2, 1400, '2026-06-16', '2026-06-16 09:36:30', '2026-06-16 09:36:30'),
(178, 9, 1, 'Nasi Padang (Ayam Pop)', 0.5, 350, '2026-06-16', '2026-06-16 09:36:47', '2026-06-16 09:36:47'),
(180, 19, 2, 'Nasi Pecel Madiun', 5, 2250, '2026-06-16', '2026-06-16 10:21:30', '2026-06-16 10:21:30'),
(181, 19, 1, 'Nasi Padang (Ayam Pop)', 2, 1400, '2026-06-16', '2026-06-16 10:21:51', '2026-06-16 10:21:51'),
(182, 18, 1, 'Nasi Padang (Ayam Pop)', 1, 700, '2026-06-18', '2026-06-18 05:36:20', '2026-06-18 05:36:20'),
(183, 9, 1, 'Nasi Padang (Ayam Pop)', 1, 700, '2026-06-18', '2026-06-18 05:37:14', '2026-06-18 05:37:14'),
(184, 9, 1, 'Nasi Padang (Ayam Pop)', 2.5, 1750, '2026-06-18', '2026-06-18 05:38:18', '2026-06-18 05:38:18'),
(185, 9, 1, 'Nasi Padang (Ayam Pop)', 0.5, 350, '2026-06-18', '2026-06-18 05:39:15', '2026-06-18 05:39:15'),
(186, 18, 2, 'Nasi Pecel Madiun', 1, 450, '2026-06-18', '2026-06-18 05:41:12', '2026-06-18 05:41:12'),
(187, 18, 1, 'Nasi Padang (Ayam Pop)', 1, 700, '2026-06-18', '2026-06-18 05:44:44', '2026-06-18 05:44:44'),
(188, 18, 1, 'Nasi Padang (Ayam Pop)', 1, 700, '2026-06-18', '2026-06-18 05:50:14', '2026-06-18 05:50:14'),
(189, 18, 2, 'Nasi Pecel Madiun', 2, 900, '2026-06-18', '2026-06-18 05:50:26', '2026-06-18 05:50:26'),
(190, 18, 1, 'Nasi Padang (Ayam Pop)', 1, 700, '2026-06-18', '2026-06-18 06:17:15', '2026-06-18 06:17:15'),
(191, 18, 2, 'Nasi Pecel Madiun', 1, 450, '2026-06-18', '2026-06-18 06:17:30', '2026-06-18 06:17:30'),
(192, 18, 3, 'Bakso Sapi Urat', 1, 380, '2026-06-18', '2026-06-18 06:17:37', '2026-06-18 06:17:37'),
(193, 18, 8, 'Seblak Kuah Pedas', 1, 480, '2026-06-18', '2026-06-18 08:38:33', '2026-06-18 08:38:33'),
(194, 18, 2, 'Nasi Pecel Madiun', 1, 450, '2026-06-19', '2026-06-19 05:49:01', '2026-06-19 05:49:01'),
(198, 9, 8, 'Seblak Kuah Pedas', 1, 480, '2026-06-19', '2026-06-19 05:54:07', '2026-06-19 05:54:07'),
(199, 19, 4, 'Mie Ayam Pangsit', 1, 420, '2026-06-19', '2026-06-19 06:43:57', '2026-06-19 06:43:57'),
(200, 2, 1, 'Nasi Padang (Ayam Pop)', 1, 700, '2026-06-19', '2026-06-19 06:45:23', '2026-06-19 06:45:23'),
(201, 19, 1, 'Nasi Padang (Ayam Pop)', 1, 700, '2026-06-19', '2026-06-19 06:55:51', '2026-06-19 06:55:51'),
(202, 15, 3, 'Bakso Sapi Urat', 2, 760, '2026-06-24', '2026-06-24 06:41:55', '2026-06-24 06:41:55'),
(203, 15, 6, 'Ayam Geprek & Nasi', 1, 650, '2026-06-24', '2026-06-24 06:42:21', '2026-06-24 06:42:21'),
(204, 18, 2, 'Nasi Pecel Madiun', 1, 450, '2026-06-25', '2026-06-25 08:46:39', '2026-06-25 08:46:39'),
(205, 18, 2, 'Nasi Pecel Madiun', 1, 450, '2026-06-26', '2026-06-25 22:53:38', '2026-06-25 22:53:38'),
(206, 18, 1, 'Nasi Padang (Ayam Pop)', 1, 700, '2026-06-26', '2026-06-25 23:34:25', '2026-06-25 23:34:25'),
(207, 18, 5, 'Es Teh Manis', 1, 85, '2026-06-26', '2026-06-25 23:34:48', '2026-06-25 23:34:48'),
(208, 19, 1, 'Nasi Padang (Ayam Pop)', 1, 700, '2026-07-01', '2026-06-30 20:31:27', '2026-06-30 20:31:27'),
(209, 17, 1, 'Nasi Padang (Ayam Pop)', 1, 700, '2026-07-01', '2026-06-30 22:10:37', '2026-06-30 22:10:37'),
(210, 14, 2, 'Nasi Pecel Madiun', 1, 450, '2026-07-01', '2026-06-30 22:23:24', '2026-06-30 22:23:24'),
(211, 18, 5, 'Es Teh Manis', 1, 85, '2026-07-01', '2026-06-30 22:46:34', '2026-06-30 22:46:34'),
(212, 18, 1, 'Nasi Padang (Ayam Pop)', 1, 700, '2026-07-02', '2026-07-02 07:39:57', '2026-07-02 07:39:57'),
(213, 18, 1, 'Nasi Padang (Ayam Pop)', 1, 700, '2026-07-03', '2026-07-02 18:51:02', '2026-07-02 18:51:02');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `meal_swaps`
--

CREATE TABLE `meal_swaps` (
  `id` bigint NOT NULL,
  `user_id` bigint DEFAULT NULL,
  `original_food` text COLLATE utf8mb4_general_ci,
  `swap_recommendation` text COLLATE utf8mb4_general_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `meal_swaps`
--

INSERT INTO `meal_swaps` (`id`, `user_id`, `original_food`, `swap_recommendation`, `created_at`, `updated_at`) VALUES
(1, 18, 'Ayam Geprek', 'Nasi setengah porsi, sambal sedikit, ganti es teh manis menjadi air putih', '2026-06-18 11:42:17', '2026-06-18 11:42:17'),
(2, 18, 'Bakso', 'Kurangi mie, tambah sayur, pilih air putih', '2026-06-18 11:42:54', '2026-06-18 11:42:54'),
(3, 18, 'Mie Ayam', 'Setengah porsi mie dan tambahkan sawi', '2026-06-18 11:43:14', '2026-06-18 11:43:14'),
(4, 18, 'Nasi Padang (Ayam Pop)', 'Pilih nasi setengah porsi, tambah sayur, dan kurangi kuah santan.', NULL, NULL),
(5, 18, 'Bakso Sapi Urat', 'Kurangi mie, tambah sayur, dan pilih air putih.', NULL, NULL),
(6, 18, 'Mie Ayam Pangsit', 'Setengah porsi mie dan tambahkan sawi.', NULL, NULL),
(7, 18, 'Ayam Geprek & Nasi', 'Sambal sedikit, nasi setengah porsi, ganti es teh manis menjadi air putih.', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_05_06_115518_create_tasks_table', 1),
(5, '2026_05_06_133741_add_health_data_to_users_table', 2),
(6, '2026_05_06_145544_create_foods_table', 3),
(7, '2026_05_07_120025_create_screenings_table', 4);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(3, 'App\\Models\\Admin', 1, 'admin-token', '79f85338f1ea64e70e3db22fcdc314d3719b5225f0963e695e00ee9c430b3568', '[\"*\"]', NULL, NULL, '2026-07-02 07:11:35', '2026-07-02 07:11:35');

-- --------------------------------------------------------

--
-- Table structure for table `screenings`
--

CREATE TABLE `screenings` (
  `id` bigint UNSIGNED NOT NULL,
  `weight` double NOT NULL,
  `height` double NOT NULL,
  `gender` enum('male','female') COLLATE utf8mb4_unicode_ci NOT NULL,
  `waist` double NOT NULL,
  `sarc_f_score` int DEFAULT NULL,
  `imt_value` double NOT NULL,
  `imt_classification` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `risk_level` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `central_obesity_status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sarcopenia_status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `age` int DEFAULT NULL,
  `activity_level` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sweet_drink` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fast_food` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sleep_duration` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sitting_duration` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fatigue` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `conditions` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `screenings`
--

INSERT INTO `screenings` (`id`, `weight`, `height`, `gender`, `waist`, `sarc_f_score`, `imt_value`, `imt_classification`, `risk_level`, `central_obesity_status`, `sarcopenia_status`, `created_at`, `updated_at`, `user_id`, `age`, `activity_level`, `sweet_drink`, `fast_food`, `sleep_duration`, `sitting_duration`, `fatigue`, `conditions`) VALUES
(2, 60, 163, 'female', 150, 10, 22.58, 'Normal', 'Berat', 'Obesitas Sentral', 'Kemungkinan Sarkopenia', '2026-05-07 06:46:05', '2026-05-07 06:46:05', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(4, 100, 160, 'male', 100, 5, 39.06, 'Obesitas II', 'Berat', 'Obesitas Sentral', 'Kemungkinan Sarkopenia', '2026-05-07 08:34:40', '2026-05-07 08:34:40', 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(6, 60, 160, 'female', 89, 0, 23.44, 'Berat badan lebih', 'Rendah', 'Obesitas Sentral', 'Normal', '2026-05-07 19:40:07', '2026-05-07 19:40:07', 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12, 59, 163, 'male', 75, NULL, 22.2, 'Normal', 'Normal', 'Normal', NULL, '2026-06-08 06:34:25', '2026-06-08 06:34:25', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(13, 50, 163, 'male', 75, NULL, 18.8, 'Normal', 'Normal', 'Normal', NULL, '2026-06-08 07:21:04', '2026-06-08 07:21:04', 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(14, 59, 163, 'male', 75, NULL, 22.2, 'Normal', 'Normal', 'Normal', NULL, '2026-06-09 05:25:28', '2026-06-09 05:25:28', 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(17, 50, 170, 'male', 75, NULL, 17.3, 'Underweight', 'Low', 'Normal', NULL, '2026-06-09 07:22:51', '2026-06-09 07:22:51', 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(19, 100, 163, 'female', 100, NULL, 37.6, 'Obesity II', 'Very High', 'Central Obesity', NULL, '2026-06-09 07:56:46', '2026-06-09 07:56:46', 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(20, 100, 170, 'male', 100, NULL, 34.6, 'Obesity II', 'Very High', 'Central Obesity', NULL, '2026-06-09 08:07:01', '2026-06-09 08:07:01', 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(21, 59, 163, 'male', 75, NULL, 22.2, 'Normal', 'Normal', 'Normal', NULL, '2026-06-09 08:22:55', '2026-06-09 08:22:55', 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(24, 52, 158, 'female', 90, NULL, 20.8, 'Normal', 'Normal', 'Central Obesity', NULL, '2026-06-09 20:45:06', '2026-06-09 20:45:06', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(25, 45, 160, 'female', 89, NULL, 17.6, 'Underweight', 'Low', 'Central Obesity', NULL, '2026-06-10 02:06:52', '2026-06-10 02:06:52', 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(26, 52, 160, 'female', 90, NULL, 20.3, 'Normal', 'Normal', 'Central Obesity', NULL, '2026-06-10 02:09:23', '2026-06-10 02:09:23', 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(27, 100, 170, 'male', 150, NULL, 34.6, 'Obesity II', 'Very High', 'Central Obesity', NULL, '2026-06-10 07:02:23', '2026-06-10 07:02:23', 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(28, 43, 173, 'male', 75, NULL, 14.4, 'Underweight', 'Low', 'Normal', NULL, '2026-06-10 21:40:22', '2026-06-10 21:40:22', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29, 100, 169, 'male', 120, NULL, 35, 'Obesity II', 'Very High', 'Central Obesity', NULL, '2026-06-10 21:42:44', '2026-06-10 21:42:44', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30, 59, 163, 'male', 90, NULL, 22.2, 'Normal', 'Normal', 'Normal', NULL, '2026-06-11 04:53:39', '2026-06-11 04:53:39', 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31, 100, 170, 'male', 130, NULL, 34.6, 'Obesity II', 'Very High', 'Central Obesity', NULL, '2026-06-11 05:47:21', '2026-06-11 05:47:21', 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32, 100, 160, 'male', 150, NULL, 39.1, 'Obesity II', 'Very High', 'Central Obesity', NULL, '2026-06-11 06:42:27', '2026-06-11 06:42:27', 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(34, 1201, 170, 'female', 160, NULL, 415.6, 'Obesity II', 'Very High', 'Central Obesity', NULL, '2026-06-11 07:36:42', '2026-06-11 07:36:42', 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(35, 60, 170, 'male', 90, NULL, 20.8, 'Normal', 'Normal', 'Normal', NULL, '2026-06-11 07:56:34', '2026-06-11 07:56:34', 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(36, 59, 163, 'male', 85, NULL, 22.2, 'Normal', 'Normal', 'Normal', NULL, '2026-06-11 09:24:05', '2026-06-11 09:24:05', 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(37, 100, 160, 'male', 150, NULL, 39.1, 'Obesity II', 'Very High', 'Central Obesity', NULL, '2026-06-11 09:45:44', '2026-06-11 09:45:44', 17, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(38, 100, 170, 'male', 150, NULL, 34.6, 'Obesity II', 'Very High', 'Central Obesity', NULL, '2026-06-12 02:00:05', '2026-06-12 02:00:05', 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(39, 50, 170, 'female', 80, NULL, 17.3, 'Underweight', 'Low', 'Normal', NULL, '2026-06-12 05:24:36', '2026-06-12 05:24:36', 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(40, 60, 170, 'male', 80, NULL, 20.8, 'Normal', 'Normal', 'Normal', NULL, '2026-06-12 22:21:37', '2026-06-12 22:21:37', 18, 20, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(43, 50, 160, 'male', 75, NULL, 19.5, 'Normal', 'Normal', 'Normal', NULL, '2026-06-16 08:13:03', '2026-06-16 08:13:03', 18, 21, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(47, 59, 160, 'male', 89, NULL, 23, 'Overweight', 'Moderate', 'Normal', NULL, '2026-06-16 08:56:37', '2026-06-16 08:56:37', 18, 20, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(48, 70, 50, 'male', 60, NULL, 280, 'Obesity II', 'Very High', 'Normal', NULL, '2026-06-16 09:35:55', '2026-06-16 09:35:55', 9, 20, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(49, 100, 170, 'female', 150, NULL, 34.6, 'Obesity II', 'Very High', 'Central Obesity', NULL, '2026-06-24 03:58:01', '2026-06-24 03:58:01', 18, 20, 'Jarang', 'Kadang', 'Sering', '<5 jam', 'Ya', 'Kadang', '[\"diabetes\"]'),
(50, 60, 160, 'female', 90, NULL, 23.4, 'Overweight', 'Moderate', 'Central Obesity', NULL, '2026-06-24 04:56:49', '2026-06-24 04:56:49', 9, 21, 'Sering', 'Jarang', 'Jarang', '>7 jam', 'Kadang', 'Kadang', '[]'),
(51, 50, 170, 'male', 100, NULL, 17.3, 'Underweight', 'Low', 'Central Obesity', NULL, '2026-06-29 09:04:19', '2026-06-29 09:04:19', 15, 20, 'Sering', 'Jarang', 'Jarang', '>7 jam', 'Tidak', 'Tidak', '[]'),
(52, 60, 170, 'male', 100, NULL, 20.8, 'Normal', 'Normal', 'Central Obesity', NULL, '2026-06-29 09:06:57', '2026-06-29 09:06:57', 18, 20, 'Sering', 'Jarang', 'Jarang', '>7 jam', 'Tidak', 'Tidak', '[]'),
(53, 601, 70, 'male', 100, NULL, 1226.5, 'Obesity II', 'Very High', 'Central Obesity', NULL, '2026-06-30 00:14:16', '2026-06-30 00:14:16', 19, 20, 'Kadang', 'Jarang', NULL, '6-7 jam', 'Tidak', 'Tidak', '[]'),
(54, 60, 170, 'male', 100, NULL, 20.8, 'Normal', 'Normal', 'Central Obesity', NULL, '2026-06-30 00:15:35', '2026-06-30 00:15:35', 19, 20, 'Sering', 'Jarang', 'Jarang', '6-7 jam', 'Kadang', 'Tidak', '[]');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('4zTCwlvLXSx9e9YKjVEHc8VxzaUXddoV9oaUDCX7', NULL, '192.168.1.5', 'Thunder Client (https://www.thunderclient.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOGFlc2k2V1E1ekt2ODdJeWFLSENRcDFEWlE1NEVTZWE1RFM5WkJ4MCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly8xOTIuMTY4LjEuNTo4MDAwIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1782745022),
('7WzR1fzLeVJd9PeImiaBg6gbeL6QlJeP39j3JCN0', NULL, '192.168.1.5', 'Thunder Client (https://www.thunderclient.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMUZhOFdxbjRrVXZQZmxid3pieFYxZDFQa1dac3pKRzYwSXJkbG5hYyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly8xOTIuMTY4LjEuNTo4MDAwIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1782903372),
('eqtc64a0dRm506eN9k93KKi616imdVsuDli0IY1v', NULL, '192.168.1.5', 'Thunder Client (https://www.thunderclient.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRGJyRXN3SXY3Vk1ubHY0ck01MTRibjdIcVZuTFNmaHZIQ2doemx1VyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly8xOTIuMTY4LjEuNTo4MDAwIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1782730854),
('FKaMtHmJQVlMns8UvAZUqr68VQvt1EOt9ZUh7lZS', NULL, '192.168.1.5', 'Thunder Client (https://www.thunderclient.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiN0FrRTVKUERScjZVVGptZWlYUHB6TnBMQkR4RzBBb2hJN0VWcUhDcCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly8xOTIuMTY4LjEuNTo4MDAwIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1782911670),
('GRugM0Dm1sLfpUGOrd73yrrlgKHzmcrW2Mp44aw0', NULL, '192.168.1.5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSEg3NDI3ejJIREtGOGVMVmpzUnc3ZFYxcFBOV3pTdXppWUNZVFNudSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly8xOTIuMTY4LjEuNTo4MDAwIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1780921992),
('T4f0K1liaFoQhrn4ooVx2t4PByqL1weWqUVN3HLL', NULL, '192.168.1.6', 'Thunder Client (https://www.thunderclient.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWW5OZ3FZbFhSZXlkeGUyMmxwTWdibVY2ZU9iR3BZREpyRlo4WWQzZCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly8xOTIuMTY4LjEuNjo4MDAwIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1782276914),
('XfNMhWYFx62QAj84OGVwl02l6PThUU96cjVNLAtC', NULL, '192.168.1.6', 'Thunder Client (https://www.thunderclient.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicllIT2docDd2Nm5QUUhLV3F0OVlCY2FqZEphaU1idGo3dkZPUEFJciI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly8xOTIuMTY4LjEuNjo4MDAwIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1782393773);

-- --------------------------------------------------------

--
-- Table structure for table `smart_reminders`
--

CREATE TABLE `smart_reminders` (
  `id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `title` varchar(150) DEFAULT NULL,
  `message` text,
  `reminder_time` time DEFAULT NULL,
  `reminder_type` varchar(50) DEFAULT NULL,
  `is_completed` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `generated_for_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `smart_reminders`
--

INSERT INTO `smart_reminders` (`id`, `user_id`, `title`, `message`, `reminder_time`, `reminder_type`, `is_completed`, `created_at`, `updated_at`, `generated_for_date`) VALUES
(1, 18, 'Sarapan Sehat', 'Sarapan dengan porsi yang tepat dan hindari makanan tinggi gula dan lemak.', '07:00:00', 'meal', 1, '2026-06-24 23:20:48', '2026-06-25 00:44:11', '2026-06-25'),
(2, 18, 'Minum Air', 'Minum 500 ml air putih untuk menjaga hidrasi tubuh.', '10:00:00', 'water', 1, '2026-06-24 23:20:48', '2026-06-25 00:44:28', '2026-06-25'),
(3, 18, 'Bersepeda', 'Lakukan bersepeda selama 30 menit untuk meningkatkan aktivitas fisik.', '17:30:00', 'exercise', 0, '2026-06-24 23:20:48', '2026-06-24 23:20:48', '2026-06-25'),
(4, 18, 'Tidur Nyenyak', 'Tidur lebih awal dan pastikan durasi tidur minimal 7 jam.', '21:00:00', 'sleep', 0, '2026-06-24 23:20:48', '2026-06-24 23:20:48', '2026-06-25'),
(5, 18, 'Motivasi', 'Ingatlah bahwa mengontrol diabetes dan menjaga berat badan sangat penting untuk kesehatanmu, jadi tetap semangat dan fokus pada tujuanmu!', '15:00:00', 'motivation', 0, '2026-06-24 23:20:48', '2026-06-24 23:20:48', '2026-06-25'),
(6, 18, 'Sarapan Sehat', 'Pilih sarapan rendah karbohidrat dan tinggi protein untuk mengontrol gula darah.', '07:00:00', 'meal', 1, '2026-06-25 22:52:46', '2026-06-25 22:56:38', '2026-06-26'),
(7, 18, 'Minum Air', 'Minum setidaknya 500 ml air putih untuk menjaga hidrasi tubuh.', '10:00:00', 'water', 0, '2026-06-25 22:52:46', '2026-06-25 22:52:46', '2026-06-26'),
(8, 18, 'Olahraga Ringan', 'Lakukan jalan kaki santai selama 30 menit untuk meningkatkan aktivitas fisik.', '17:00:00', 'exercise', 0, '2026-06-25 22:52:46', '2026-06-25 22:52:46', '2026-06-26'),
(9, 18, 'Tidur Nyenyak', 'Pastikan untuk tidur lebih awal malam ini dan targetkan 7-8 jam tidur.', '21:30:00', 'sleep', 0, '2026-06-25 22:52:46', '2026-06-25 22:52:46', '2026-06-26'),
(10, 18, 'Motivasi', 'Ingat, kontrol gula darah dan penurunan berat badan membutuhkan kedisiplinan dan kesabaran. Jaga semangat!', '12:00:00', 'motivation', 0, '2026-06-25 22:52:46', '2026-06-25 22:52:46', '2026-06-26'),
(11, 19, 'Sarapan Seimbang', 'Konsumsi sarapan dengan karbohidrat, protein, dan lemak seimbang untuk memulai hari dengan energi.', '08:00:00', 'meal', 0, '2026-06-26 01:18:26', '2026-06-26 01:18:26', '2026-06-26'),
(12, 19, 'Istirahat dan Minum Air', 'Minum setidaknya 300 ml air putih dan istirahat sejenak dari aktivitas.', '12:00:00', 'water', 0, '2026-06-26 01:18:26', '2026-06-26 01:18:26', '2026-06-26'),
(13, 19, 'Aktivitas Fisik Ringan', 'Lakukan peregangan atau jalan kaki ringan selama 10-15 menit untuk meningkatkan sirkulasi darah.', '15:00:00', 'exercise', 0, '2026-06-26 01:18:26', '2026-06-26 01:18:26', '2026-06-26'),
(14, 19, 'Makan Malam Sehat', 'Pilih makan malam dengan sayuran, protein, dan karbohidrat kompleks untuk mendukung kesehatan.', '19:00:00', 'meal', 0, '2026-06-26 01:18:26', '2026-06-26 01:18:26', '2026-06-26'),
(15, 19, 'Persiapan Tidur', 'Matikan semua perangkat elektronik dan siapkan diri untuk tidur nyenyak malam ini.', '21:30:00', 'sleep', 0, '2026-06-26 01:18:26', '2026-06-26 01:18:26', '2026-06-26'),
(16, 18, 'Sarapan Sehat', 'Hindari makanan tinggi gula dan karbohidrat, pilih sarapan dengan protein dan serat yang tinggi.', '07:00:00', 'meal', 0, '2026-06-29 08:57:24', '2026-06-29 08:57:24', '2026-06-29'),
(17, 18, 'Minum Air', 'Minum setidaknya 500 ml air putih untuk menjaga hidrasi tubuh.', '10:00:00', 'water', 0, '2026-06-29 08:57:24', '2026-06-29 08:57:24', '2026-06-29'),
(18, 18, 'Olahraga Ringan', 'Lakukan olahraga ringan seperti berjalan kaki selama 30 menit untuk meningkatkan aktivitas fisik.', '17:00:00', 'exercise', 0, '2026-06-29 08:57:24', '2026-06-29 08:57:24', '2026-06-29'),
(19, 18, 'Tidur Nyenyak', 'Pastikan Anda tidur lebih awal dan cukup untuk membantu mengontrol gula darah dan meningkatkan kesehatan.', '21:30:00', 'sleep', 0, '2026-06-29 08:57:24', '2026-06-29 08:57:24', '2026-06-29'),
(20, 18, 'Motivasi Sehat', 'Ingat, setiap langkah kecil menuju gaya hidup sehat sangat berharga, jangan menyerah!', '12:00:00', 'motivation', 0, '2026-06-29 08:57:24', '2026-06-29 08:57:24', '2026-06-29'),
(21, 15, 'Sarapan Sehat', 'Konsumsi sarapan rendah kalori dan tinggi serat untuk mengontrol berat badan.', '07:00:00', 'meal', 0, '2026-06-29 09:01:40', '2026-06-29 09:01:40', '2026-06-29'),
(22, 15, 'Hydrasi', 'Minum setidaknya 500 ml air putih untuk menjaga hidrasi tubuh.', '10:00:00', 'water', 0, '2026-06-29 09:01:40', '2026-06-29 09:01:40', '2026-06-29'),
(23, 15, 'Jalan Kaki', 'Lakukan jalan kaki selama 20 menit untuk membakar kalori dan meningkatkan kesehatan.', '17:30:00', 'exercise', 0, '2026-06-29 09:01:40', '2026-06-29 09:01:40', '2026-06-29'),
(24, 15, 'Tidur Nyenyak', 'Tidur yang cukup sangat penting untuk kesehatan, pastikan Anda tidur lebih awal malam ini.', '21:00:00', 'sleep', 0, '2026-06-29 09:01:40', '2026-06-29 09:01:40', '2026-06-29'),
(25, 15, 'Motivasi', 'Ingat, setiap langkah kecil menuju gaya hidup sehat akan membawa Anda lebih dekat kepada tujuan, jangan menyerah!', '15:00:00', 'motivation', 0, '2026-06-29 09:01:40', '2026-06-29 09:01:40', '2026-06-29'),
(26, 18, 'Sarapan Sehat', 'Konsumsi sarapan bergizi dengan protein dan serat yang cukup untuk mengawali hari dengan energi.', '07:00:00', 'meal', 0, '2026-06-29 23:11:51', '2026-06-29 23:11:51', '2026-06-30'),
(27, 18, 'Hidrasi', 'Minum setidaknya 500 ml air putih untuk menjaga hidrasi tubuh.', '10:00:00', 'water', 0, '2026-06-29 23:11:51', '2026-06-29 23:11:51', '2026-06-30'),
(28, 18, 'Olahraga Rutin', 'Lakukan aktivitas fisik seperti bersepeda atau berjalan kaki selama 30 menit untuk meningkatkan kesehatan.', '17:00:00', 'exercise', 0, '2026-06-29 23:11:51', '2026-06-29 23:11:51', '2026-06-30'),
(29, 18, 'Makan Malam Seimbang', 'Pilih makan malam yang seimbang dengan sayuran, protein, dan karbohidrat kompleks untuk mendukung kesehatan.', '20:00:00', 'meal', 0, '2026-06-29 23:11:51', '2026-06-29 23:11:51', '2026-06-30'),
(30, 18, 'Tidur Nyenyak', 'Pastikan untuk tidur lebih awal dan dapatkan tidur yang cukup untuk pemulihan tubuh.', '21:30:00', 'sleep', 0, '2026-06-29 23:11:51', '2026-06-29 23:11:51', '2026-06-30'),
(31, 19, 'Sarapan Sehat', 'Mulai hari dengan sarapan seimbang untuk meningkatkan energi.', '07:00:00', 'meal', 0, '2026-06-30 00:12:56', '2026-06-30 00:12:56', '2026-06-30'),
(32, 19, 'Minum Air', 'Pastikan untuk minum setidaknya 500 ml air putih untuk menjaga hidrasi.', '10:00:00', 'water', 0, '2026-06-30 00:12:56', '2026-06-30 00:12:56', '2026-06-30'),
(33, 19, 'Makan Siang', 'Pilih makanan yang bergizi dan hindari makanan berlemak tinggi.', '12:00:00', 'meal', 0, '2026-06-30 00:12:56', '2026-06-30 00:12:56', '2026-06-30'),
(34, 19, 'Olahraga Ringan', 'Lakukan aktivitas fisik ringan seperti jalan kaki atau peregangan untuk meningkatkan kesehatan.', '17:00:00', 'exercise', 0, '2026-06-30 00:12:56', '2026-06-30 00:12:56', '2026-06-30'),
(35, 19, 'Persiapan Tidur', 'Mulai persiapan tidur dengan mengurangi penggunaan gadget dan menciptakan suasana tenang.', '20:00:00', 'sleep', 0, '2026-06-30 00:12:56', '2026-06-30 00:12:56', '2026-06-30'),
(36, 18, 'Sarapan Sehat', 'Mulai hari dengan sarapan bergizi, hindari makanan berat dan manis seperti Es Teh Manis.', '07:00:00', 'meal', 0, '2026-06-30 20:27:26', '2026-06-30 20:27:26', '2026-07-01'),
(37, 18, 'Makan Siang Seimbang', 'Pilih makan siang dengan kalori seimbang, jangan terlalu banyak nasi seperti Nasi Padang atau Nasi Pecel Madiun.', '12:00:00', 'meal', 0, '2026-06-30 20:27:26', '2026-06-30 20:27:26', '2026-07-01'),
(38, 18, 'Minum Air Putih', 'Pastikan untuk minum setidaknya 500 ml air putih untuk menjaga hidrasi tubuh.', '15:00:00', 'water', 0, '2026-06-30 20:27:26', '2026-06-30 20:27:26', '2026-07-01'),
(39, 18, 'Olahraga Ringan', 'Lakukan olahraga ringan seperti bersepeda atau jalan kaki santai selama 30 menit untuk meningkatkan aktivitas fisik.', '18:00:00', 'exercise', 0, '2026-06-30 20:27:26', '2026-06-30 20:27:26', '2026-07-01'),
(40, 18, 'Persiapan Tidur', 'Mulai persiapan tidur lebih awal dan pastikan untuk tidur selama 7 jam atau lebih untuk kesehatan yang optimal.', '20:00:00', 'sleep', 0, '2026-06-30 20:27:26', '2026-06-30 20:27:26', '2026-07-01'),
(41, 19, 'Sarapan Sehat', 'Mulai hari dengan sarapan seimbang, pilih makanan tinggi protein dan serat untuk meningkatkan energi.', '07:00:00', 'meal', 0, '2026-06-30 20:30:47', '2026-06-30 20:30:47', '2026-07-01'),
(42, 19, 'Istirahat dan Minum', 'Minum setidaknya 500 ml air putih dan istirahat sejenak untuk menghindari dehidrasi.', '12:00:00', 'water', 0, '2026-06-30 20:30:47', '2026-06-30 20:30:47', '2026-07-01'),
(43, 19, 'Olahraga Ringan', 'Lakukan olahraga ringan seperti jalan kaki atau peregangan untuk meningkatkan sirkulasi darah.', '16:00:00', 'exercise', 0, '2026-06-30 20:30:47', '2026-06-30 20:30:47', '2026-07-01'),
(44, 19, 'Tidur Nyenyak', 'Pastikan untuk tidur 6-7 jam malam ini untuk memulihkan tubuh dan meningkatkan kesehatan.', '21:30:00', 'sleep', 0, '2026-06-30 20:30:47', '2026-06-30 20:30:47', '2026-07-01'),
(45, 19, 'Motivasi Harian', 'Ingatlah bahwa setiap langkah kecil menuju gaya hidup sehat akan berdampak besar pada kesehatan Anda.', '09:00:00', 'motivation', 0, '2026-06-30 20:30:47', '2026-06-30 20:30:47', '2026-07-01'),
(46, 17, 'Sarapan Sehat', 'Sarapan dengan porsi yang tepat dan hindari makanan berkalori tinggi seperti Ayam Geprek.', '07:00:00', 'meal', 0, '2026-06-30 22:09:03', '2026-06-30 22:09:03', '2026-07-01'),
(47, 17, 'Minum Air', 'Minum 500 ml air putih untuk menjaga hidrasi tubuh.', '10:00:00', 'water', 0, '2026-06-30 22:09:03', '2026-06-30 22:09:03', '2026-07-01'),
(48, 17, 'Jalan Kaki', 'Lakukan jalan kaki santai 20 menit untuk membakar kalori dan meningkatkan kesehatan.', '17:30:00', 'exercise', 0, '2026-06-30 22:09:03', '2026-06-30 22:09:03', '2026-07-01'),
(49, 17, 'Tidur Nyenyak', 'Tidur lebih awal malam ini untuk membantu proses penyembuhan dan pemulihan tubuh.', '21:00:00', 'sleep', 0, '2026-06-30 22:09:03', '2026-06-30 22:09:03', '2026-07-01'),
(50, 17, 'Motivasi', 'Ingat, mengurangi berat badan dan meningkatkan kesehatan membutuhkan waktu dan usaha, tetap semangat dan konsisten!', '15:00:00', 'motivation', 0, '2026-06-30 22:09:03', '2026-06-30 22:09:03', '2026-07-01'),
(56, 14, 'Sarapan Sehat', 'Mulai hari dengan sarapan bergizi, seperti oatmeal dengan buah-buahan.', '08:00:00', 'meal', 0, '2026-06-30 22:25:29', '2026-06-30 22:25:29', '2026-07-01'),
(57, 14, 'Istirahat dan Minum', 'Minum 500 ml air putih dan istirahat sejenak dari aktivitas.', '12:00:00', 'water', 0, '2026-06-30 22:25:29', '2026-06-30 22:25:29', '2026-07-01'),
(58, 14, 'Olahraga Ringan', 'Lakukan peregangan atau jalan kaki santai selama 15 menit.', '16:00:00', 'exercise', 0, '2026-06-30 22:25:29', '2026-06-30 22:25:29', '2026-07-01'),
(59, 14, 'Persiapan Tidur', 'Mulai mempersiapkan diri untuk tidur, seperti mandi dan mengenakan pakaian tidur.', '20:00:00', 'sleep', 0, '2026-06-30 22:25:29', '2026-06-30 22:25:29', '2026-07-01'),
(60, 14, 'Motivasi Sehat', 'Ingatlah bahwa pola hidup sehat akan membawa dampak positif pada kesehatan dan kebahagiaan Anda.', '09:00:00', 'motivation', 0, '2026-06-30 22:25:29', '2026-06-30 22:25:29', '2026-07-01'),
(61, 9, 'Sarapan Sehat', 'Mulai hari dengan sarapan seimbang, pilih nasi merah dengan ayam panggang dan sayuran untuk mendapatkan nutrisi yang lebih baik.', '07:00:00', 'meal', 0, '2026-06-30 23:29:50', '2026-06-30 23:29:50', '2026-07-01'),
(62, 9, 'Minum Air', 'Minum 500 ml air putih untuk menjaga hidrasi tubuh.', '10:00:00', 'water', 0, '2026-06-30 23:29:50', '2026-06-30 23:29:50', '2026-07-01'),
(63, 9, 'Jalan Kaki', 'Lakukan jalan kaki selama 30 menit untuk meningkatkan aktivitas fisik dan membakar kalori.', '17:30:00', 'exercise', 0, '2026-06-30 23:29:50', '2026-06-30 23:29:50', '2026-07-01'),
(64, 9, 'Tidur Nyenyak', 'Pastikan tidur lebih awal malam ini untuk mendapatkan istirahat yang cukup dan membantu proses penurunan berat badan.', '21:00:00', 'sleep', 0, '2026-06-30 23:29:50', '2026-06-30 23:29:50', '2026-07-01'),
(65, 9, 'Motivasi', 'Ingat, setiap langkah kecil menuju hidup sehat akan membawa dampak besar pada kesehatan dan kebahagiaanmu, jadi tetap semangat!', '15:00:00', 'motivation', 0, '2026-06-30 23:29:50', '2026-06-30 23:29:50', '2026-07-01'),
(66, 18, 'Sarapan Sehat', 'Mulai hari dengan sarapan sehat dan bergizi, seperti oatmeal dengan buah-buahan.', '07:00:00', 'meal', 0, '2026-07-02 07:57:11', '2026-07-02 07:57:11', '2026-07-02'),
(67, 18, 'Minum Air Putih', 'Minum 500 ml air putih untuk menjaga hidrasi tubuh.', '10:00:00', 'water', 0, '2026-07-02 07:57:11', '2026-07-02 07:57:11', '2026-07-02'),
(68, 18, 'Bersepeda', 'Lakukan bersepeda selama 30 menit untuk meningkatkan aktivitas fisik.', '17:00:00', 'exercise', 0, '2026-07-02 07:57:11', '2026-07-02 07:57:11', '2026-07-02'),
(69, 18, 'Tidur Nyenyak', 'Pastikan Anda tidur lebih awal malam ini untuk mendapatkan 7-8 jam tidur nyenyak.', '21:30:00', 'sleep', 0, '2026-07-02 07:57:11', '2026-07-02 07:57:11', '2026-07-02'),
(70, 18, 'Motivasi', 'Ingatlah bahwa pola hidup sehat yang konsisten akan membantu Anda mencapai tujuan kesehatan Anda.', '12:00:00', 'motivation', 0, '2026-07-02 07:57:11', '2026-07-02 07:57:11', '2026-07-02'),
(71, 9, 'Sarapan Sehat', 'Mulai hari dengan sarapan seimbang, pilih nasi merah dengan ayam panggang dan sayuran untuk mendapatkan nutrisi yang lebih seimbang dan rendah kalori.', '07:00:00', 'meal', 0, '2026-07-02 08:13:00', '2026-07-02 08:13:00', '2026-07-02'),
(72, 9, 'Minum Air', 'Minum 500 ml air putih untuk menjaga hidrasi tubuh.', '10:00:00', 'water', 0, '2026-07-02 08:13:00', '2026-07-02 08:13:00', '2026-07-02'),
(73, 9, 'Jalan Kaki', 'Lakukan jalan kaki selama 30 menit untuk meningkatkan aktivitas fisik dan membakar kalori.', '17:30:00', 'exercise', 0, '2026-07-02 08:13:00', '2026-07-02 08:13:00', '2026-07-02'),
(74, 9, 'Tidur Nyenyak', 'Pastikan untuk tidur lebih awal malam ini dan mendapatkan istirahat yang cukup, minimal 7 jam.', '21:00:00', 'sleep', 0, '2026-07-02 08:13:00', '2026-07-02 08:13:00', '2026-07-02'),
(75, 9, 'Motivasi', 'Ingat, tujuanmu adalah mengurangi konsumsi makanan tinggi kalori dan lemak, serta meningkatkan aktivitas fisik untuk menurunkan berat badan dan mengurangi risiko penyakit. Jaga semangatmu!', '15:00:00', 'motivation', 0, '2026-07-02 08:13:00', '2026-07-02 08:13:00', '2026-07-02'),
(76, 18, 'Sarapan Sehat', 'Mulai hari dengan sarapan seimbang, pilihlah makanan kaya serat dan protein.', '07:00:00', 'meal', 0, '2026-07-02 18:43:49', '2026-07-02 18:43:49', '2026-07-03'),
(77, 18, 'Minum Air', 'Pastikan untuk minum setidaknya 500 ml air putih untuk menjaga hidrasi tubuh.', '10:00:00', 'water', 0, '2026-07-02 18:43:50', '2026-07-02 18:43:50', '2026-07-03'),
(78, 18, 'Olahraga Ringan', 'Lakukan aktivitas fisik ringan seperti berjalan kaki atau bersepeda selama 30 menit untuk meningkatkan kesehatan.', '17:00:00', 'exercise', 0, '2026-07-02 18:43:50', '2026-07-02 18:43:50', '2026-07-03'),
(79, 18, 'Persiapan Tidur', 'Mulai persiapan tidur dengan mengurangi penggunaan gadget dan menciptakan suasana yang nyaman.', '20:00:00', 'sleep', 0, '2026-07-02 18:43:50', '2026-07-02 18:43:50', '2026-07-03'),
(80, 18, 'Motivasi', 'Ingatlah bahwa setiap langkah kecil menuju gaya hidup sehat sangat berharga, jaga motivasi dan teruslah berusaha!', '12:00:00', 'motivation', 0, '2026-07-02 18:43:50', '2026-07-02 18:43:50', '2026-07-03');

-- --------------------------------------------------------

--
-- Table structure for table `tasks`
--

CREATE TABLE `tasks` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `is_completed` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tasks`
--

INSERT INTO `tasks` (`id`, `title`, `description`, `is_completed`, `created_at`, `updated_at`) VALUES
(1, 'Belajar Backend Laravel', 'Menyelesaikan setup awal API', 0, '2026-05-06 05:13:37', '2026-05-06 05:13:37'),
(2, 'Makan Siang', 'Makan nasi goreng di depan kampus', 1, '2026-05-06 05:13:37', '2026-05-06 05:13:37');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('user','expert','admin') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user',
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `whatsapp_number` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `goal` enum('weight_loss','maintenance','weight_gain') COLLATE utf8mb4_unicode_ci DEFAULT 'weight_loss',
  `profile_picture` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `role`, `remember_token`, `created_at`, `updated_at`, `whatsapp_number`, `goal`, `profile_picture`) VALUES
(2, 'zulfikar pacarnya jeongyeon', 'zul@gmail.com', NULL, '$2y$12$TKkTYJP7aPTCMUMDR.i14u1CW/lRJVeaRgSO2HIpV/MPGI8q5R75a', 'user', NULL, '2026-05-06 06:22:37', '2026-05-06 06:22:37', '6287852330624', 'maintenance', NULL),
(4, 'zul', 'zul@gmail', NULL, '$2y$12$x3NLjWl/OrNGxW4b3Hr9EOMu0tb1EAWn.0kptrDC2ZUFNfg0Ocz5u', 'user', NULL, '2026-05-06 07:19:30', '2026-05-06 07:19:30', NULL, 'weight_loss', NULL),
(6, 'lia', 'lia@gmail.com', NULL, '$2y$12$Mn3Lg5HOx/mBznXD19/y2eZt6CufoYKamQATGUBALLvXPAT9UE0kC', 'user', NULL, '2026-05-07 00:10:51', '2026-05-07 00:10:51', '6282337458738', 'weight_loss', NULL),
(8, 'fs', 'sf@g', NULL, '$2y$12$RVGwaUGGkPj4phVMOVdOceDfvthgk4LyMDEqS0tAg2suvJZZ/m7GG', 'user', NULL, '2026-06-08 05:33:00', '2026-06-08 05:33:00', NULL, 'weight_loss', NULL),
(9, 'jeongyeon', 'jy@email.com', NULL, '$2y$12$hNASuddJ0xQsHI9HAgIx6ORJLz40tB1tOn7m0wMR3QBZtvFhITJAq', 'user', NULL, '2026-06-08 07:17:08', '2026-06-11 05:45:49', '0000', 'weight_loss', NULL),
(11, 'Liana Anna', 'lianaanna968@gmail.com', NULL, '$2y$12$UYEdh01sGbHUC8eSgf/B3uYne57M0FM8TPHHXUc3tf8Yh0WPSRFBe', 'user', NULL, '2026-06-09 20:42:23', '2026-06-09 20:42:23', '082337458738', 'weight_loss', NULL),
(12, 'Anna A', 'anna@gmail.com', NULL, '$2y$12$hNVE4qk6SLOAq8PdqfFM2.i1eKkUW2nQOmywy4PyzFdjBzGbB83PO', 'user', NULL, '2026-06-10 02:05:47', '2026-06-10 02:08:36', '6282143127541', 'weight_loss', NULL),
(13, 'HIT', 'HIT@G', NULL, '$2y$12$JTzb1OMxJ61TV.7vfmXh5uChzQB27u62VfiN7TycQ5I/ENfUM40ly', 'user', NULL, '2026-06-11 01:57:25', '2026-06-11 01:57:25', '0', 'weight_loss', NULL),
(14, 'zul', 'tw@gmail.com', NULL, '$2y$12$naKWdpwGGNpdm60m5RMdeOsZ.mk2zHLKOI7QyiRGZpfGqP5DXvJbu', 'user', NULL, '2026-06-11 02:07:40', '2026-06-11 02:07:40', '123', 'weight_loss', NULL),
(15, 'ai', 'ai@gmail.com', NULL, '$2y$12$HArE3AiWBZwSYXIDdjHLYuqLJzOGh4Id3hQgaQZ8q8b5HtL9GBn0K', 'user', NULL, '2026-06-11 07:32:56', '2026-06-11 07:32:56', 'ai@gmail.com', 'weight_loss', NULL),
(16, 'rizki', 'rizkichy2005@gmail.com', NULL, '$2y$12$DKGtEpT8FHyz6hcPrxAzKOYy.MhXwY1Pu2BcSnhirQO52R4tyL1RS', 'user', NULL, '2026-06-11 09:15:19', '2026-06-11 09:15:19', '0857', 'weight_loss', NULL),
(17, 'rizki cz', 'rrzkai@gmail.com', NULL, '$2y$12$T0UlPeedweGh0SJrqt/Mk.WDv5LNjp5QF2NHNRBOMpU5KfsFHgxW2', 'user', NULL, '2026-06-11 09:42:54', '2026-06-11 09:44:08', '000', 'weight_loss', NULL),
(18, 'iaman', 'iaman@gmail.com', NULL, '$2y$12$wh7593xp09bXTDxHQ01wl.2Z6fqRaJw19i7UCTrnaWngcFouXWX1.', 'user', NULL, '2026-06-12 05:21:31', '2026-07-02 18:27:05', '080000000', 'weight_loss', 'http://192.168.1.6:8000/storage/profile_pictures/7yH3ubWGvYu5q5ZEYD1CRjnJnqu1XkUoRUNJiRIB.jpg'),
(19, 'tes', 'tes@e', NULL, '$2y$12$kB2/4Ux.1CMg6vqmOtse5ez27q5bdMurn58gXkHIy6SqKFjavTOCe', 'user', NULL, '2026-06-13 00:42:39', '2026-06-13 00:42:39', '0', 'weight_loss', NULL),
(20, 'Dr Rizki', 'expert@gmail.com', NULL, '$2y$12$Ln.QXm/iEy9jaeXVVzYsqOqLbNejMvweOceZ/2zPhHqEbd4khHoum', 'expert', NULL, '2026-06-29 14:35:27', '2026-06-29 08:06:52', NULL, 'weight_loss', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_achievements`
--

CREATE TABLE `user_achievements` (
  `id` bigint NOT NULL,
  `user_id` bigint DEFAULT NULL,
  `achievement_id` bigint DEFAULT NULL,
  `achieved_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_points`
--

CREATE TABLE `user_points` (
  `id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `activity` varchar(50) DEFAULT NULL,
  `points` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user_points`
--

INSERT INTO `user_points` (`id`, `user_id`, `activity`, `points`, `created_at`, `updated_at`) VALUES
(1, 2, 'food_log', 10, '2026-06-16 14:19:09', '2026-06-16 16:09:47'),
(2, 18, 'food_log', 20, '2026-06-16 15:01:37', '2026-06-16 16:09:47'),
(3, 18, 'food_log', 20, '2026-06-16 15:01:40', '2026-06-16 16:09:47'),
(4, 9, 'food_log', 10, '2026-06-16 09:34:35', '2026-06-16 09:34:35'),
(5, 9, 'screening', 15, '2026-06-16 09:35:55', '2026-06-16 09:35:55'),
(6, 9, 'food_log', 10, '2026-06-16 09:36:30', '2026-06-16 09:36:30'),
(7, 9, 'food_log', 10, '2026-06-16 09:36:47', '2026-06-16 09:36:47'),
(8, 10, 'food_log', 10, '2026-06-16 10:19:26', '2026-06-16 10:19:26'),
(9, 19, 'food_log', 10, '2026-06-16 10:21:30', '2026-06-16 10:21:30'),
(10, 19, 'food_log', 10, '2026-06-16 10:21:51', '2026-06-16 10:21:51'),
(11, 18, 'food_log', 10, '2026-06-18 05:36:20', '2026-06-18 05:36:20'),
(12, 9, 'food_log', 10, '2026-06-18 05:37:14', '2026-06-18 05:37:14'),
(13, 9, 'food_log', 10, '2026-06-18 05:38:18', '2026-06-18 05:38:18'),
(14, 9, 'food_log', 10, '2026-06-18 05:39:15', '2026-06-18 05:39:15'),
(15, 18, 'food_log', 10, '2026-06-18 05:41:12', '2026-06-18 05:41:12'),
(16, 18, 'food_log', 10, '2026-06-18 05:44:44', '2026-06-18 05:44:44'),
(17, 18, 'food_log', 10, '2026-06-18 05:50:14', '2026-06-18 05:50:14'),
(18, 18, 'food_log', 10, '2026-06-18 05:50:26', '2026-06-18 05:50:26'),
(19, 18, 'food_log', 10, '2026-06-18 06:17:15', '2026-06-18 06:17:15'),
(20, 18, 'food_log', 10, '2026-06-18 06:17:30', '2026-06-18 06:17:30'),
(21, 18, 'food_log', 10, '2026-06-18 06:17:37', '2026-06-18 06:17:37'),
(22, 18, 'food_log', 10, '2026-06-18 08:38:33', '2026-06-18 08:38:33'),
(23, 18, 'food_log', 10, '2026-06-19 05:49:01', '2026-06-19 05:49:01'),
(24, 10, 'food_log', 10, '2026-06-19 05:50:44', '2026-06-19 05:50:44'),
(25, 10, 'food_log', 10, '2026-06-19 05:51:10', '2026-06-19 05:51:10'),
(26, 10, 'food_log', 10, '2026-06-19 05:52:49', '2026-06-19 05:52:49'),
(27, 9, 'food_log', 10, '2026-06-19 05:54:07', '2026-06-19 05:54:07'),
(28, 19, 'food_log', 10, '2026-06-19 06:43:57', '2026-06-19 06:43:57'),
(29, 2, 'food_log', 10, '2026-06-19 06:45:23', '2026-06-19 06:45:23'),
(30, 19, 'food_log', 10, '2026-06-19 06:55:51', '2026-06-19 06:55:51'),
(31, 18, 'screening', 15, '2026-06-24 03:58:01', '2026-06-24 03:58:01'),
(32, 9, 'screening', 15, '2026-06-24 04:56:49', '2026-06-24 04:56:49'),
(33, 15, 'food_log', 10, '2026-06-24 06:41:55', '2026-06-24 06:41:55'),
(34, 15, 'food_log', 10, '2026-06-24 06:42:21', '2026-06-24 06:42:21'),
(35, 18, 'food_log', 10, '2026-06-25 08:46:39', '2026-06-25 08:46:39'),
(36, 18, 'food_log', 10, '2026-06-25 22:53:38', '2026-06-25 22:53:38'),
(37, 18, 'food_log', 10, '2026-06-25 23:34:25', '2026-06-25 23:34:25'),
(38, 18, 'food_log', 10, '2026-06-25 23:34:48', '2026-06-25 23:34:48'),
(39, 15, 'screening', 15, '2026-06-29 09:04:19', '2026-06-29 09:04:19'),
(40, 18, 'screening', 15, '2026-06-29 09:06:57', '2026-06-29 09:06:57'),
(41, 19, 'screening', 15, '2026-06-30 00:14:16', '2026-06-30 00:14:16'),
(42, 19, 'screening', 15, '2026-06-30 00:15:35', '2026-06-30 00:15:35'),
(43, 19, 'food_log', 10, '2026-06-30 20:31:27', '2026-06-30 20:31:27'),
(44, 17, 'food_log', 10, '2026-06-30 22:10:37', '2026-06-30 22:10:37'),
(45, 14, 'food_log', 10, '2026-06-30 22:23:24', '2026-06-30 22:23:24'),
(46, 18, 'food_log', 10, '2026-06-30 22:46:34', '2026-06-30 22:46:34'),
(47, 18, 'food_log', 10, '2026-07-02 07:39:57', '2026-07-02 07:39:57'),
(48, 18, 'food_log', 10, '2026-07-02 18:51:02', '2026-07-02 18:51:02');

-- --------------------------------------------------------

--
-- Table structure for table `user_streaks`
--

CREATE TABLE `user_streaks` (
  `id` bigint NOT NULL,
  `user_id` bigint DEFAULT NULL,
  `current_streak` int DEFAULT '0',
  `best_streak` int DEFAULT '0',
  `last_activity_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user_streaks`
--

INSERT INTO `user_streaks` (`id`, `user_id`, `current_streak`, `best_streak`, `last_activity_date`, `created_at`, `updated_at`) VALUES
(1, 2, 1, 1, '2026-06-19', '2026-06-16 14:20:02', '2026-06-19 06:45:23'),
(3, 9, 1, 2, '2026-06-24', '2026-06-16 09:34:35', '2026-06-24 04:56:49'),
(5, 19, 2, 11, '2026-07-01', '2026-06-16 10:21:30', '2026-06-30 20:31:27'),
(6, 18, 3, 3, '2026-07-03', '2026-06-18 05:36:20', '2026-07-02 18:51:02'),
(7, 15, 1, 1, '2026-06-29', '2026-06-24 06:41:55', '2026-06-29 09:04:19'),
(8, 17, 1, 1, '2026-07-01', '2026-06-30 22:10:37', '2026-06-30 22:10:37'),
(9, 14, 1, 1, '2026-07-01', '2026-06-30 22:23:24', '2026-06-30 22:23:24');

-- --------------------------------------------------------

--
-- Table structure for table `weekly_challenges`
--

CREATE TABLE `weekly_challenges` (
  `id` bigint NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `target_days` int DEFAULT NULL,
  `reward_points` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `weekly_challenges`
--

INSERT INTO `weekly_challenges` (`id`, `title`, `target_days`, `reward_points`) VALUES
(1, 'No Sweet Drink Challenge', 7, 100),
(2, 'Food Logging Challenge', 7, 70),
(3, 'Walking Challenge', 5, 80);

-- --------------------------------------------------------

--
-- Table structure for table `weekly_plans`
--

CREATE TABLE `weekly_plans` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `focus` text COLLATE utf8mb4_general_ci NOT NULL,
  `activity_target` text COLLATE utf8mb4_general_ci NOT NULL,
  `small_habit` text COLLATE utf8mb4_general_ci NOT NULL,
  `menu_recommendation` text COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `weekly_plans`
--

INSERT INTO `weekly_plans` (`id`, `user_id`, `focus`, `activity_target`, `small_habit`, `menu_recommendation`, `created_at`, `updated_at`) VALUES
(2, 9, 'Mengurangi konsumsi makanan tinggi kalori dan lemak, serta meningkatkan aktivitas fisik untuk menurunkan berat badan dan mengurangi risiko penyakit.', 'Berjalan kaki selama 30 menit setiap hari dan melakukan olahraga ringan 2 kali seminggu.', 'Mengganti minyak goreng dengan minyak zaitun dan mengurangi porsi makanan berat.', 'Ganti Mie Ayam Pangsit dengan Nasi Merah dengan Ayam Panggang dan Sayuran, atau Soto Betawi dengan nasi merah dan sayuran, untuk mendapatkan nutrisi yang lebih seimbang dan rendah kalori.', '2026-06-10 21:25:21', '2026-06-10 21:25:21'),
(3, 2, 'Penurunan berat badan bertahap untuk mengurangi risiko kesehatan terkait obesitas, dengan target penurunan 0,5-1 kg per minggu.', '30 menit berjalan kaki ringan per hari, 3 kali seminggu, dan 2 kali seminggu olahraga ringan seperti yoga atau peregangan untuk meningkatkan fleksibilitas dan mengurangi stres.', 'Mengurangi porsi nasi dan menggantinya dengan sayuran atau buah-buahan, serta meminum setidaknya 8 gelas air per hari untuk membantu mengontrol nafsu makan dan meningkatkan metabolisme.', 'Ganti Ayam Geprek dengan Ayam Panggang, konsumsi Nasi Merah atau Nasi Jagung sebagai alternatif nasi putih, tambahkan Sayur Asem', '2026-06-10 21:44:12', '2026-06-10 22:49:30');

-- --------------------------------------------------------

--
-- Table structure for table `weekly_reports`
--

CREATE TABLE `weekly_reports` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `report_text` text COLLATE utf8mb4_general_ci,
  `expert_note` text COLLATE utf8mb4_general_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `period_start` date DEFAULT NULL,
  `period_end` date DEFAULT NULL,
  `avg_calories` int DEFAULT NULL,
  `weight_change` double DEFAULT NULL,
  `frequent_food` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `recommendation` text COLLATE utf8mb4_general_ci,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `weekly_reports`
--

INSERT INTO `weekly_reports` (`id`, `user_id`, `report_text`, `expert_note`, `created_at`, `period_start`, `period_end`, `avg_calories`, `weight_change`, `frequent_food`, `recommendation`, `updated_at`) VALUES
(1, 9, 'Minggu ini rata-rata kalori harianmu 704 kcal. Makanan yang paling sering dikonsumsi adalah Ayam Geprek & Nasi. Perubahan berat badan minggu ini sebesar 50 kg.', NULL, '2026-06-09 21:14:45', '2026-06-08', '2026-06-14', 704, 50, 'Ayam Geprek & Nasi', 'Kurangi minuman manis dan lakukan jalan kaki 20 menit setiap hari.', '2026-06-12 06:23:30'),
(2, 4, 'Minggu ini rata-rata kalori harianmu 0 kcal. Makanan yang paling sering dikonsumsi adalah -. Perubahan berat badan minggu ini sebesar 0 kg.', NULL, '2026-06-09 21:16:59', '2026-06-08', '2026-06-14', 0, 0, '-', 'Pertahankan pola makan sehat.', '2026-06-09 21:17:42'),
(3, 6, 'Minggu ini rata-rata kalori harianmu 0 kcal. Makanan yang paling sering dikonsumsi adalah -. Perubahan berat badan minggu ini sebesar 0 kg.', NULL, '2026-06-09 21:17:12', '2026-06-08', '2026-06-14', 0, 0, '-', 'Pertahankan pola makan sehat.', '2026-06-09 21:17:12'),
(5, 12, 'Minggu ini rata-rata kalori harianmu 675 kcal. Makanan yang paling sering dikonsumsi adalah Nasi Pecel Madiun. Perubahan berat badan minggu ini sebesar 0 kg.', NULL, '2026-06-10 02:07:03', '2026-06-08', '2026-06-14', 675, 0, 'Nasi Pecel Madiun', 'Pertahankan pola makan sehat.', '2026-06-10 02:07:43'),
(6, 2, 'Minggu ini rata-rata kalori harianmu 925 kcal. Makanan yang paling sering dikonsumsi adalah Ayam Geprek & Nasi. Perubahan berat badan minggu ini sebesar 41 kg.', NULL, '2026-06-10 21:35:52', '2026-06-08', '2026-06-14', 925, 41, 'Ayam Geprek & Nasi', 'Kurangi minuman manis dan lakukan jalan kaki 20 menit setiap hari.', '2026-06-10 22:01:38'),
(7, 15, 'Minggu ini rata-rata kalori harianmu 0 kcal. Makanan yang paling sering dikonsumsi adalah -. Perubahan berat badan minggu ini sebesar 0 kg.', NULL, '2026-06-11 07:34:19', '2026-06-08', '2026-06-14', 0, 0, '-', 'Kurangi minuman manis dan lakukan jalan kaki 20 menit setiap hari.', '2026-06-11 07:37:05'),
(8, 16, 'Minggu ini rata-rata kalori harianmu 700 kcal. Makanan yang paling sering dikonsumsi adalah Nasi Padang (Ayam Pop). Perubahan berat badan minggu ini sebesar 0 kg.', NULL, '2026-06-11 09:20:35', '2026-06-08', '2026-06-14', 700, 0, 'Nasi Padang (Ayam Pop)', 'Pertahankan pola makan sehat.', '2026-06-11 09:27:21'),
(9, 17, 'Minggu ini rata-rata kalori harianmu 1300 kcal. Makanan yang paling sering dikonsumsi adalah Ayam Geprek & Nasi. Perubahan berat badan minggu ini sebesar 0 kg.', NULL, '2026-06-11 09:46:39', '2026-06-08', '2026-06-14', 1300, 0, 'Ayam Geprek & Nasi', 'Kurangi minuman manis dan lakukan jalan kaki 20 menit setiap hari.', '2026-06-11 09:46:39'),
(10, 18, 'Minggu ini rata-rata kalori harianmu 685 kcal. Makanan yang paling sering dikonsumsi adalah Bakso Sapi Urat. Perubahan berat badan minggu ini sebesar 10 kg.', NULL, '2026-06-12 05:26:53', '2026-06-08', '2026-06-14', 685, 10, 'Bakso Sapi Urat', 'Pertahankan pola makan sehat.', '2026-06-12 22:23:55'),
(11, 18, 'Minggu ini rata-rata kalori harianmu 592 kcal. Makanan yang paling sering dikonsumsi adalah Nasi Padang (Ayam Pop). Perubahan berat badan minggu ini sebesar 9 kg.', NULL, '2026-06-15 20:27:14', '2026-06-15', '2026-06-21', 592, 9, 'Nasi Padang (Ayam Pop)', 'Kurangi camilan tinggi gula dan perbanyak aktivitas.', '2026-06-18 07:41:01'),
(12, 9, 'Minggu ini rata-rata kalori harianmu 817 kcal. Makanan yang paling sering dikonsumsi adalah Nasi Padang (Ayam Pop). Perubahan berat badan minggu ini sebesar 0 kg.', NULL, '2026-06-16 09:37:06', '2026-06-15', '2026-06-21', 817, 0, 'Nasi Padang (Ayam Pop)', 'Kurangi minuman manis dan lakukan jalan kaki 20 menit setiap hari.', '2026-06-16 09:37:06'),
(13, 18, 'Minggu ini rata-rata kalori harianmu 393 kcal. Makanan yang paling sering dikonsumsi adalah Es Teh Manis. Perubahan berat badan minggu ini sebesar 0 kg.', NULL, '2026-06-29 23:12:56', '2026-06-29', '2026-07-05', 393, 0, 'Es Teh Manis', 'Pertahankan pola makan sehat.', '2026-07-02 18:28:52'),
(14, 14, 'Minggu ini rata-rata kalori harianmu 450 kcal. Makanan yang paling sering dikonsumsi adalah Nasi Pecel Madiun. Perubahan berat badan minggu ini sebesar 0 kg.', NULL, '2026-06-30 22:23:59', '2026-06-29', '2026-07-05', 450, 0, 'Nasi Pecel Madiun', 'Pertahankan pola makan sehat.', '2026-06-30 22:23:59'),
(15, 2, 'Minggu ini rata-rata kalori harianmu 0 kcal. Makanan yang paling sering dikonsumsi adalah -. Perubahan berat badan minggu ini sebesar 0 kg.', NULL, '2026-07-02 05:53:19', '2026-06-29', '2026-07-05', 0, 0, '-', 'Kurangi minuman manis dan lakukan jalan kaki 20 menit setiap hari.', '2026-07-02 07:04:33');

-- --------------------------------------------------------

--
-- Table structure for table `weight_loss_plans`
--

CREATE TABLE `weight_loss_plans` (
  `id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `plan_text` longtext NOT NULL,
  `generated_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `weight_loss_plans`
--

INSERT INTO `weight_loss_plans` (`id`, `user_id`, `plan_text`, `generated_at`, `created_at`, `updated_at`) VALUES
(1, 18, 'Focus: Mempertahankan berat badan dengan menjaga pola makan seimbang dan aktivitas fisik teratur.\nActivity Target: Melakukan aktivitas fisik secara teratur dengan intensitas sedang untuk menjaga kesehatan dan mempertahankan berat badan.\nSmall Habit: Mengonsumsi buah dan sayuran secara teratur untuk meningkatkan asupan nutrisi dan mempertahankan kesehatan.\nMenu Recommendation: Mengonsumsi makanan seimbang dengan kombinasi karbohidrat, protein, dan lemak sehat, seperti nasi merah, ayam panggang, dan sayuran, untuk mempertahankan berat badan dan menjaga kesehatan.', '2026-07-03 01:51:11', '2026-06-24 03:23:29', '2026-07-02 18:51:11'),
(2, 9, 'Focus: Mempertahankan berat badan dengan menjaga pola makan seimbang dan aktivitas fisik yang teratur.\nActivity Target: Melakukan aktivitas fisik secara teratur setidaknya 30 menit sehari untuk menjaga kesehatan dan mempertahankan berat badan.\nSmall Habit: Mengonsumsi buah dan sayuran segar setiap hari untuk meningkatkan nutrisi dan mengurangi konsumsi makanan yang tidak sehat.\nMenu Recommendation: Mengganti Nasi Padang dengan pilihan makanan yang lebih seimbang seperti nasi merah, ayam panggang, dan sayuran untuk mengurangi konsumsi kalori dan meningkatkan nutrisi.', '2026-07-02 15:13:40', '2026-06-24 04:52:45', '2026-07-02 08:13:40'),
(3, 15, 'Focus: Penurunan berat badan bertahap dengan mengatur pola makan dan meningkatkan aktivitas fisik, mengingat BMI pengguna yang termasuk obesitas.\n\nActivity Target: Mengambil langkah kecil dengan berjalan kaki selama 30 menit, 3 kali seminggu, untuk memulai peningkatan aktivitas fisik.\n\nSmall Habit: Mengurangi konsumsi makanan cepat saji dan minuman manis, serta mengganti dengan pilihan yang lebih sehat seperti buah dan sayuran.\n\nMenu Recommendation: Mengonsumsi makanan lokal seperti nasi merah dengan lauk ikan bakar, sayur lodeh, dan buah-buahan seperti pisang atau apel, untuk memulai pola makan yang lebih seimbang.', '2026-06-29 16:01:49', '2026-06-29 09:01:49', '2026-06-29 09:01:49'),
(4, 19, 'Focus: Mempertahankan berat badan dengan pola hidup sehat dan seimbang karena BMI pengguna berada dalam kategori normal.\nActivity Target: Melanjutkan aktivitas fisik secara teratur untuk menjaga keseimbangan kalori dan meningkatkan kesehatan secara keseluruhan.\nSmall Habit: Mengonsumsi buah atau sayuran setiap hari untuk meningkatkan asupan nutrisi dan serat.\nMenu Recommendation: Mengganti Nasi Padang dengan pilihan makanan yang lebih seimbang seperti nasi merah, ayam panggang, dan sayuran untuk meningkatkan kualitas nutrisi.', '2026-07-01 04:15:18', '2026-06-30 20:30:54', '2026-06-30 21:15:18'),
(5, 17, 'Focus: Mengurangi konsumsi kalori dan meningkatkan aktivitas fisik untuk menurunkan berat badan dan mengatasi obesitas.\nActivity Target: Berolahraga ringan selama 30 menit setiap hari untuk meningkatkan pembakaran kalori dan mengurangi risiko penyakit.\nSmall Habit: Mengganti minuman manis dengan air putih dan mengurangi konsumsi makanan cepat saji untuk mengurangi asupan kalori tambahan.\nMenu Recommendation: Mengonsumsi makanan seimbang dengan sayuran, buah, dan protein seperti ayam panggang tanpa kulit dan nasi merah untuk mengurangi kalori dan meningkatkan nutrisi.', '2026-07-01 05:10:47', '2026-06-30 22:09:17', '2026-06-30 22:10:47');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `achievements`
--
ALTER TABLE `achievements`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `activity_programs`
--
ALTER TABLE `activity_programs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `activity_recommendations`
--
ALTER TABLE `activity_recommendations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `behavior_coaching_history`
--
ALTER TABLE `behavior_coaching_history`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `challenge_progress`
--
ALTER TABLE `challenge_progress`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `coaching_histories`
--
ALTER TABLE `coaching_histories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `coaching_templates`
--
ALTER TABLE `coaching_templates`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `craving_histories`
--
ALTER TABLE `craving_histories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `education_contents`
--
ALTER TABLE `education_contents`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `expert_reviews`
--
ALTER TABLE `expert_reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_expert_review_user` (`user_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `foods`
--
ALTER TABLE `foods`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `food_logs`
--
ALTER TABLE `food_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `food_logs_user_id_foreign` (`user_id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `meal_swaps`
--
ALTER TABLE `meal_swaps`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `screenings`
--
ALTER TABLE `screenings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `smart_reminders`
--
ALTER TABLE `smart_reminders`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Indexes for table `user_achievements`
--
ALTER TABLE `user_achievements`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_points`
--
ALTER TABLE `user_points`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_streaks`
--
ALTER TABLE `user_streaks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `weekly_challenges`
--
ALTER TABLE `weekly_challenges`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `weekly_plans`
--
ALTER TABLE `weekly_plans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_weekly_plan_user` (`user_id`);

--
-- Indexes for table `weekly_reports`
--
ALTER TABLE `weekly_reports`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `weight_loss_plans`
--
ALTER TABLE `weight_loss_plans`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `achievements`
--
ALTER TABLE `achievements`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `activity_programs`
--
ALTER TABLE `activity_programs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `activity_recommendations`
--
ALTER TABLE `activity_recommendations`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `behavior_coaching_history`
--
ALTER TABLE `behavior_coaching_history`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `challenge_progress`
--
ALTER TABLE `challenge_progress`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `coaching_histories`
--
ALTER TABLE `coaching_histories`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=270;

--
-- AUTO_INCREMENT for table `coaching_templates`
--
ALTER TABLE `coaching_templates`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `craving_histories`
--
ALTER TABLE `craving_histories`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `education_contents`
--
ALTER TABLE `education_contents`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `expert_reviews`
--
ALTER TABLE `expert_reviews`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `foods`
--
ALTER TABLE `foods`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `food_logs`
--
ALTER TABLE `food_logs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=214;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `meal_swaps`
--
ALTER TABLE `meal_swaps`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `screenings`
--
ALTER TABLE `screenings`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `smart_reminders`
--
ALTER TABLE `smart_reminders`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- AUTO_INCREMENT for table `tasks`
--
ALTER TABLE `tasks`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `user_achievements`
--
ALTER TABLE `user_achievements`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_points`
--
ALTER TABLE `user_points`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `user_streaks`
--
ALTER TABLE `user_streaks`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `weekly_challenges`
--
ALTER TABLE `weekly_challenges`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `weekly_plans`
--
ALTER TABLE `weekly_plans`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `weekly_reports`
--
ALTER TABLE `weekly_reports`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `weight_loss_plans`
--
ALTER TABLE `weight_loss_plans`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD CONSTRAINT `activity_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `activity_programs`
--
ALTER TABLE `activity_programs`
  ADD CONSTRAINT `fk_activity_program_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `expert_reviews`
--
ALTER TABLE `expert_reviews`
  ADD CONSTRAINT `fk_expert_review_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `food_logs`
--
ALTER TABLE `food_logs`
  ADD CONSTRAINT `food_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `weekly_plans`
--
ALTER TABLE `weekly_plans`
  ADD CONSTRAINT `fk_weekly_plan_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
