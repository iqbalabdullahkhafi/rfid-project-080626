-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:8111
-- Waktu pembuatan: 19 Jul 2026 pada 07.23
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rfid_db`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `access_control`
--

CREATE TABLE `access_control` (
  `id` int(11) NOT NULL,
  `user_uid` varchar(64) NOT NULL,
  `device_id` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `access_control`
--

INSERT INTO `access_control` (`id`, `user_uid`, `device_id`) VALUES
(43, '66E84306', 'door_2'),
(122, 'AD629121', 'door_2'),
(125, 'AD6DD321', 'door_1'),
(126, 'AD6DD321', 'door_2'),
(131, 'BD9BD421', 'door_1');

-- --------------------------------------------------------

--
-- Struktur dari tabel `app_settings`
--

CREATE TABLE `app_settings` (
  `setting_key` varchar(64) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `app_settings`
--

INSERT INTO `app_settings` (`setting_key`, `setting_value`, `updated_at`) VALUES
('auto_refresh', '1', '2026-05-22 17:03:21'),
('enable_logging', '0', '2026-06-23 11:16:21'),
('login_attempt_limit', '5', '2026-05-03 04:33:39'),
('mode', 'hybrid', '2026-07-12 10:48:42'),
('refresh_interval', '15', '2026-05-02 14:06:22'),
('session_timeout', '60', '2026-05-03 04:33:30'),
('system_name', 'Smart Door System', '2026-05-23 09:58:15'),
('timezone', 'Asia/Jakarta', '2026-05-03 04:49:39');

-- --------------------------------------------------------

--
-- Struktur dari tabel `commands`
--

CREATE TABLE `commands` (
  `id` int(11) NOT NULL,
  `device_id` varchar(64) NOT NULL,
  `command` varchar(32) NOT NULL,
  `payload` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `consumed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `commands`
--

INSERT INTO `commands` (`id`, `device_id`, `command`, `payload`, `created_at`, `consumed_at`) VALUES
(1, 'pintu_1', 'OPEN', NULL, '2026-04-22 00:51:12', '2026-04-22 00:51:12'),
(2, 'pintu_1', 'OPEN', NULL, '2026-04-22 00:52:31', '2026-04-22 00:52:32'),
(3, 'pintu_1', 'OPEN', NULL, '2026-04-22 00:53:55', '2026-04-22 00:53:55'),
(4, 'pintu_1', 'OPEN', NULL, '2026-04-22 00:55:39', '2026-04-22 00:55:39'),
(5, 'pintu_1', 'OPEN', NULL, '2026-04-22 00:55:46', '2026-04-22 00:55:47'),
(6, 'pintu_1', 'OPEN', NULL, '2026-04-22 00:57:33', '2026-04-22 00:57:34'),
(134, 'door_1', 'OPEN', NULL, '2026-04-24 21:47:38', '2026-04-24 21:47:39'),
(135, 'door_1', 'OPEN', NULL, '2026-04-24 21:50:12', '2026-04-24 21:50:12'),
(137, 'door_1', 'OPEN', NULL, '2026-04-24 21:53:26', '2026-04-24 21:53:27'),
(138, 'door_1', 'OPEN', NULL, '2026-04-24 23:40:14', '2026-04-24 23:40:14'),
(139, 'door_1', 'OPEN', NULL, '2026-04-25 00:27:37', '2026-04-25 00:27:38'),
(140, 'door_1', 'OPEN', NULL, '2026-04-25 00:28:26', '2026-04-25 00:28:26'),
(141, 'door_1', 'OPEN', NULL, '2026-04-25 00:29:04', '2026-04-25 00:29:04'),
(142, 'door_1', 'OPEN', NULL, '2026-04-25 00:55:03', '2026-04-25 00:55:03'),
(143, 'door_1', 'OPEN', NULL, '2026-04-25 00:55:11', '2026-04-25 00:55:12'),
(144, 'door_1', 'OPEN', NULL, '2026-04-25 00:55:22', '2026-04-25 00:55:23'),
(145, 'door_1', 'OPEN', NULL, '2026-04-25 01:32:41', '2026-04-25 01:32:41'),
(146, 'door_1', 'OPEN', NULL, '2026-04-25 01:46:52', '2026-04-25 01:46:52'),
(147, 'door_1', 'OPEN', NULL, '2026-04-25 01:49:59', '2026-04-25 01:49:59'),
(148, 'door_1', 'OPEN', NULL, '2026-04-25 01:50:10', '2026-04-25 01:50:11'),
(149, 'door_1', 'OPEN', NULL, '2026-04-25 01:56:05', '2026-04-25 01:56:05'),
(150, 'door_1', 'OPEN', NULL, '2026-04-25 01:57:04', '2026-04-25 01:57:05'),
(212, 'door_1', 'OPEN', NULL, '2026-05-01 20:20:11', '2026-05-01 20:20:11'),
(213, 'door_1', 'OPEN', NULL, '2026-05-01 20:21:23', '2026-05-01 20:21:23'),
(333, 'door_1', 'OPEN', NULL, '2026-05-06 08:25:10', '2026-05-06 08:25:11'),
(334, 'door_1', 'OPEN', NULL, '2026-05-06 08:28:55', '2026-05-06 08:28:56'),
(335, 'door_1', 'OPEN', NULL, '2026-05-06 08:30:21', '2026-05-06 08:30:22'),
(350, 'door_1', 'OPEN', NULL, '2026-05-13 23:47:11', '2026-05-13 23:47:11'),
(351, 'door_1', 'OPEN', NULL, '2026-05-13 23:47:37', '2026-05-13 23:47:38'),
(386, 'door_1', 'OPEN', NULL, '2026-05-26 22:54:32', '2026-05-26 22:54:32'),
(389, 'door_1', 'OPEN', NULL, '2026-05-26 23:01:38', '2026-05-26 23:01:39'),
(392, 'door_1', 'OPEN', NULL, '2026-06-03 22:05:11', '2026-06-03 22:05:11'),
(393, 'door_1', 'OPEN', NULL, '2026-06-03 22:05:21', '2026-06-03 22:05:22'),
(394, 'door_1', 'OPEN', NULL, '2026-06-03 22:06:24', '2026-06-03 22:06:24'),
(395, 'door_1', 'OPEN', NULL, '2026-06-03 22:06:33', '2026-06-03 22:06:33'),
(396, 'door_1', 'OPEN', NULL, '2026-06-03 22:38:17', '2026-06-03 22:38:17'),
(397, 'door_1', 'OPEN', NULL, '2026-06-06 22:46:25', '2026-06-06 22:46:25'),
(398, 'door_1', 'OPEN', NULL, '2026-06-06 22:46:34', '2026-06-06 22:46:34'),
(399, 'door_1', 'OPEN', NULL, '2026-06-06 22:46:43', '2026-06-06 22:46:44'),
(400, 'door_1', 'OPEN', NULL, '2026-06-06 22:57:58', '2026-06-06 22:57:58'),
(401, 'door_1', 'OPEN', NULL, '2026-06-06 23:11:22', '2026-06-06 23:11:23'),
(402, 'door_1', 'OPEN', NULL, '2026-06-06 23:46:47', '2026-06-06 23:46:47'),
(403, 'door_1', 'OPEN', NULL, '2026-06-06 23:47:29', '2026-06-06 23:47:29'),
(404, 'door_1', 'OPEN', NULL, '2026-06-06 23:49:43', '2026-06-06 23:49:44'),
(405, 'door_1', 'OPEN', NULL, '2026-06-06 23:51:02', '2026-06-06 23:51:03'),
(406, 'door_1', 'OPEN', NULL, '2026-06-07 01:19:31', '2026-06-07 01:19:32'),
(407, 'door_1', 'OPEN', NULL, '2026-06-07 01:20:04', '2026-06-07 01:20:04'),
(408, 'door_1', 'OPEN', NULL, '2026-06-07 01:20:46', '2026-06-07 01:20:46'),
(409, 'door_1', 'OPEN', NULL, '2026-06-07 01:23:37', '2026-06-07 01:23:38'),
(410, 'door_1', 'OPEN', NULL, '2026-06-07 01:40:20', '2026-06-07 01:40:21'),
(411, 'door_1', 'OPEN', NULL, '2026-06-07 01:40:32', '2026-06-07 01:40:33'),
(412, 'door_1', 'OPEN', NULL, '2026-06-07 01:40:43', '2026-06-07 01:40:43'),
(413, 'door_1', 'OPEN', NULL, '2026-06-07 01:40:54', '2026-06-07 01:40:54'),
(414, 'door_1', 'OPEN', NULL, '2026-06-07 01:43:56', '2026-06-07 01:43:56'),
(415, 'door_1', 'OPEN', NULL, '2026-06-18 12:13:15', '2026-06-18 12:13:16'),
(416, 'door_1', 'OPEN', NULL, '2026-06-18 12:13:38', '2026-06-18 12:13:38'),
(417, 'door_1', 'OPEN', NULL, '2026-06-18 12:43:43', '2026-06-18 12:43:43'),
(418, 'door_1', 'OPEN', NULL, '2026-06-18 12:48:54', '2026-06-18 12:48:55'),
(419, 'door_1', 'OPEN', NULL, '2026-06-18 12:55:46', '2026-06-18 12:55:46'),
(420, 'door_1', 'OPEN', NULL, '2026-06-18 13:19:11', '2026-06-18 13:19:11'),
(422, 'door_1', 'OPEN', NULL, '2026-06-18 13:53:18', '2026-06-18 13:53:18'),
(423, 'door_1', 'OPEN', NULL, '2026-06-18 13:53:31', '2026-06-18 13:53:31'),
(424, 'door_1', 'OPEN', NULL, '2026-06-18 13:53:40', '2026-06-18 13:53:40'),
(425, 'door_1', 'OPEN', NULL, '2026-06-18 13:53:53', '2026-06-18 13:53:54'),
(426, 'door_1', 'OPEN', NULL, '2026-06-18 13:54:14', '2026-06-18 13:54:14'),
(428, 'door_1', 'OPEN', NULL, '2026-06-23 18:22:35', '2026-06-23 18:22:35'),
(429, 'door_1', 'OPEN', NULL, '2026-06-23 18:22:41', '2026-06-23 18:22:42'),
(430, 'door_1', 'OPEN', NULL, '2026-07-01 11:42:47', '2026-07-01 11:42:59'),
(431, 'door_1', 'OPEN', NULL, '2026-07-01 11:43:05', '2026-07-01 11:43:36'),
(432, 'door_1', 'OPEN', NULL, '2026-07-01 11:43:57', '2026-07-01 11:45:47'),
(433, 'door_1', 'OPEN', NULL, '2026-07-01 12:07:16', '2026-07-01 14:13:08'),
(434, 'door_1', 'OPEN', NULL, '2026-07-01 14:13:25', '2026-07-01 14:13:25'),
(435, 'door_1', 'OPEN', NULL, '2026-07-01 14:14:11', '2026-07-01 14:14:11'),
(436, 'door_1', 'OPEN', NULL, '2026-07-01 14:14:43', '2026-07-01 14:14:45'),
(437, 'door_1', 'OPEN', NULL, '2026-07-01 14:19:55', '2026-07-01 14:19:57'),
(438, 'door_1', 'OPEN', NULL, '2026-07-01 14:28:36', '2026-07-01 14:28:37'),
(439, 'door_1', 'OPEN', NULL, '2026-07-01 16:16:16', '2026-07-01 16:16:35'),
(440, 'door_1', 'OPEN', NULL, '2026-07-01 16:22:22', '2026-07-01 16:22:26'),
(441, 'door_1', 'OPEN', NULL, '2026-07-01 17:17:35', '2026-07-01 17:17:37'),
(442, 'door_1', 'OPEN', NULL, '2026-07-01 17:54:53', '2026-07-01 17:54:53'),
(443, 'door_1', 'OPEN', NULL, '2026-07-01 20:24:32', '2026-07-01 20:24:35'),
(444, 'door_1', 'OPEN', NULL, '2026-07-01 21:22:10', '2026-07-01 21:22:10'),
(445, 'door_1', 'OPEN', NULL, '2026-07-01 21:54:58', '2026-07-01 21:54:59'),
(446, 'door_1', 'OPEN', NULL, '2026-07-02 10:55:37', '2026-07-02 10:55:38'),
(447, 'door_1', 'OPEN', NULL, '2026-07-02 11:43:01', '2026-07-02 11:43:03'),
(448, 'door_1', 'OPEN', NULL, '2026-07-02 13:40:51', '2026-07-02 13:40:52'),
(449, 'door_1', 'OPEN', NULL, '2026-07-02 16:23:14', '2026-07-02 16:23:16'),
(450, 'door_1', 'OPEN', NULL, '2026-07-02 17:36:01', '2026-07-02 17:36:03'),
(451, 'door_1', 'OPEN', NULL, '2026-07-02 17:36:19', '2026-07-02 17:36:22'),
(452, 'door_1', 'OPEN', NULL, '2026-07-02 18:24:27', '2026-07-02 18:24:29'),
(453, 'door_2', 'OPEN', NULL, '2026-07-02 18:28:50', '2026-07-02 18:28:53'),
(454, 'door_2', 'OPEN', NULL, '2026-07-02 21:42:14', '2026-07-02 21:42:15'),
(455, 'door_1', 'OPEN', NULL, '2026-07-06 11:16:33', '2026-07-06 11:16:35'),
(456, 'door_1', 'OPEN', NULL, '2026-07-06 17:36:47', '2026-07-06 17:36:50'),
(457, 'door_1', 'OPEN', NULL, '2026-07-06 17:37:07', '2026-07-06 17:37:10'),
(458, 'door_1', 'OPEN', NULL, '2026-07-06 17:37:35', '2026-07-06 17:37:40'),
(459, 'door_1', 'OPEN', NULL, '2026-07-06 18:01:35', '2026-07-06 18:01:36'),
(460, 'door_1', 'OPEN', NULL, '2026-07-09 10:15:40', '2026-07-09 10:15:44'),
(461, 'door_1', 'OPEN', NULL, '2026-07-09 20:47:26', '2026-07-09 20:47:28'),
(462, 'door_1', 'OPEN', NULL, '2026-07-09 21:56:57', '2026-07-09 21:56:57'),
(463, 'door_1', 'OPEN', NULL, '2026-07-09 23:12:50', '2026-07-09 23:12:52'),
(464, 'door_2', 'OPEN', NULL, '2026-07-10 23:46:34', '2026-07-10 23:46:35'),
(466, 'door_1', 'OPEN', NULL, '2026-07-11 15:18:15', '2026-07-11 15:26:14'),
(467, 'door_1', 'OPEN', NULL, '2026-07-11 17:18:15', '2026-07-11 17:18:16'),
(468, 'door_1', 'OPEN', NULL, '2026-07-11 17:19:29', '2026-07-11 17:19:29'),
(469, 'door_1', 'OPEN', NULL, '2026-07-11 21:21:42', '2026-07-11 21:21:44'),
(470, 'door_1', 'OPEN', NULL, '2026-07-12 00:43:48', '2026-07-12 00:43:52'),
(471, 'door_1', 'OPEN', NULL, '2026-07-12 01:22:52', '2026-07-12 01:22:53'),
(472, 'door_2', 'OPEN', NULL, '2026-07-12 10:37:26', '2026-07-12 10:37:28'),
(473, 'door_1', 'OPEN', NULL, '2026-07-12 10:51:40', '2026-07-12 10:51:40'),
(474, 'door_1', 'OPEN', NULL, '2026-07-12 11:46:08', '2026-07-12 11:46:09'),
(475, 'door_1', 'OPEN', NULL, '2026-07-12 11:53:27', '2026-07-12 11:53:29'),
(476, 'door_1', 'OPEN', NULL, '2026-07-12 11:55:54', '2026-07-12 11:55:54'),
(477, 'door_1', 'OPEN', NULL, '2026-07-12 11:56:10', '2026-07-12 11:56:14'),
(478, 'door_1', 'OPEN', NULL, '2026-07-12 11:58:41', '2026-07-12 11:58:42'),
(479, 'door_1', 'OPEN', NULL, '2026-07-12 17:18:37', '2026-07-12 17:18:38'),
(480, 'door_1', 'OPEN', NULL, '2026-07-12 17:22:11', '2026-07-12 17:22:15'),
(481, 'door_1', 'OPEN', NULL, '2026-07-12 17:22:47', '2026-07-12 17:22:49'),
(482, 'door_1', 'OPEN', NULL, '2026-07-12 17:23:47', '2026-07-12 17:23:47'),
(483, 'door_2', 'OPEN', NULL, '2026-07-12 18:30:41', '2026-07-12 18:30:42'),
(484, 'door_2', 'OPEN', NULL, '2026-07-12 18:32:15', '2026-07-12 18:32:17'),
(485, 'door_2', 'OPEN', NULL, '2026-07-12 18:34:26', '2026-07-12 18:34:28'),
(486, 'door_2', 'OPEN', NULL, '2026-07-13 11:24:41', '2026-07-13 11:24:41'),
(487, 'door_2', 'OPEN', NULL, '2026-07-13 11:26:09', '2026-07-13 11:26:13');

-- --------------------------------------------------------

--
-- Struktur dari tabel `devices`
--

CREATE TABLE `devices` (
  `device_id` varchar(64) NOT NULL,
  `api_key` varchar(128) DEFAULT NULL,
  `device_name` varchar(128) DEFAULT NULL,
  `status` varchar(16) DEFAULT 'OFFLINE',
  `name` varchar(128) DEFAULT NULL,
  `last_seen` datetime NOT NULL DEFAULT current_timestamp(),
  `last_ip` varchar(45) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `devices`
--

INSERT INTO `devices` (`device_id`, `api_key`, `device_name`, `status`, `name`, `last_seen`, `last_ip`, `created_at`, `updated_at`) VALUES
('door_1', '3995b8c904f162ec234131664e06d61b', 'RUANG NOC', 'ONLINE', 'RUANG NOC', '2026-07-12 18:13:03', '10.200.243.52', '2026-04-24 21:45:56', '2026-07-12 18:13:03'),
('door_2', 'e5360f4840b364080adf14248f57992d', 'RUANG MEETING', 'ONLINE', 'RUANG MEETING', '2026-07-13 11:27:59', '10.200.243.52', '2026-06-29 11:06:02', '2026-07-13 11:27:59');

-- --------------------------------------------------------

--
-- Struktur dari tabel `logs`
--

CREATE TABLE `logs` (
  `id` int(11) NOT NULL,
  `device_id` varchar(64) NOT NULL,
  `device_name` varchar(128) DEFAULT NULL,
  `name` varchar(64) DEFAULT NULL,
  `uid` varchar(32) NOT NULL,
  `status` varchar(16) NOT NULL,
  `method` varchar(16) NOT NULL DEFAULT 'rfid',
  `time` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `logs`
--

INSERT INTO `logs` (`id`, `device_id`, `device_name`, `name`, `uid`, `status`, `method`, `time`) VALUES
(505, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-04 18:04:05'),
(506, 'door_2', 'RUANG MEETING', NULL, '058F47225BD100', 'DENIED', 'rfid', '2026-05-04 21:01:50'),
(507, 'door_2', 'RUANG MEETING', NULL, '058F47225BD100', 'DENIED', 'rfid', '2026-05-04 21:01:50'),
(508, 'door_2', 'RUANG MEETING', NULL, '058F47225BD100', 'DENIED', 'rfid', '2026-05-04 21:01:51'),
(509, 'door_2', 'RUANG MEETING', NULL, '058F47225BD100', 'DENIED', 'rfid', '2026-05-04 21:01:52'),
(510, 'door_2', 'RUANG MEETING', NULL, '058F47225BD100', 'DENIED', 'rfid', '2026-05-04 21:01:53'),
(511, 'door_2', 'RUANG MEETING', NULL, '058F47225BD100', 'DENIED', 'rfid', '2026-05-04 21:01:53'),
(512, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'DENIED', 'rfid', '2026-05-04 21:01:53'),
(513, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'DENIED', 'rfid', '2026-05-04 21:01:53'),
(514, 'door_2', 'RUANG MEETING', NULL, 'AD629121', 'DENIED', 'rfid', '2026-05-04 21:01:53'),
(515, 'door_2', 'RUANG MEETING', NULL, 'AD629121', 'DENIED', 'rfid', '2026-05-04 21:01:53'),
(516, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-04 21:02:20'),
(517, 'door_2', 'RUANG MEETING', NULL, '058F47225BD100', 'DENIED', 'rfid', '2026-05-04 21:03:16'),
(518, 'door_2', 'RUANG MEETING', NULL, '04CE3382B91190', 'DENIED', 'rfid', '2026-05-04 21:03:58'),
(519, 'door_2', 'RUANG MEETING', NULL, '04CE3382B91190', 'DENIED', 'rfid', '2026-05-04 21:03:58'),
(520, 'door_2', 'RUANG MEETING', NULL, '04CE3382B91190', 'DENIED', 'rfid', '2026-05-04 21:04:19'),
(521, 'door_2', 'RUANG MEETING', NULL, '058A3906', 'DENIED', 'rfid', '2026-05-04 21:08:34'),
(522, 'door_2', 'RUANG MEETING', NULL, '058A3906', 'DENIED', 'rfid', '2026-05-04 21:11:25'),
(523, 'door_2', 'RUANG MEETING', NULL, '058A3906', 'GRANTED', 'rfid', '2026-05-04 21:11:39'),
(524, 'door_2', 'RUANG MEETING', 'Ojan Kocak', '-', 'GRANTED', 'web', '2026-05-04 21:12:12'),
(525, 'door_2', 'RUANG MEETING', NULL, '058A3906', 'GRANTED', 'rfid', '2026-05-04 21:13:46'),
(526, 'door_2', 'RUANG MEETING', NULL, '058A3906', 'DENIED', 'rfid', '2026-05-04 21:13:59'),
(527, 'door_2', 'RUANG MEETING', NULL, '058A3906', 'DENIED', 'rfid', '2026-05-04 21:15:55'),
(528, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'DENIED', 'rfid', '2026-05-04 21:15:55'),
(529, 'door_2', 'RUANG MEETING', NULL, 'AD629121', 'DENIED', 'rfid', '2026-05-04 21:15:55'),
(530, 'door_2', 'RUANG MEETING', NULL, 'BD9BD421', 'DENIED', 'rfid', '2026-05-04 21:15:55'),
(531, 'door_2', 'RUANG MEETING', NULL, '13E824D3', 'DENIED', 'rfid', '2026-05-04 21:15:55'),
(532, 'door_2', 'RUANG MEETING', NULL, 'AD629121', 'GRANTED', 'rfid', '2026-05-04 21:16:19'),
(533, 'door_2', 'RUANG MEETING', NULL, 'AD6DD321', 'GRANTED', 'rfid', '2026-05-04 21:18:56'),
(534, 'door_2', 'RUANG MEETING', NULL, 'BD9BD421', 'DENIED', 'rfid', '2026-05-04 21:18:56'),
(535, 'door_2', 'RUANG MEETING', NULL, 'AD6DD321', 'GRANTED', 'rfid', '2026-05-04 21:18:56'),
(536, 'door_2', 'RUANG MEETING', NULL, 'BD9BD421', 'DENIED', 'rfid', '2026-05-04 21:18:56'),
(537, 'door_2', 'RUANG MEETING', NULL, 'BD9BD421', 'DENIED', 'rfid', '2026-05-04 21:18:56'),
(538, 'door_2', 'RUANG MEETING', NULL, 'AD6DD321', 'GRANTED', 'rfid', '2026-05-04 21:18:56'),
(539, 'door_2', 'RUANG MEETING', NULL, 'BD9BD421', 'DENIED', 'rfid', '2026-05-04 21:18:56'),
(540, 'door_2', 'RUANG MEETING', NULL, 'AD6DD321', 'GRANTED', 'rfid', '2026-05-04 21:18:57'),
(541, 'door_2', 'RUANG MEETING', NULL, 'AD6DD321', 'GRANTED', 'rfid', '2026-05-04 21:18:57'),
(542, 'door_2', 'RUANG MEETING', NULL, 'AD629121', 'GRANTED', 'rfid', '2026-05-04 21:18:57'),
(543, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'GRANTED', 'rfid', '2026-05-04 21:19:14'),
(544, 'door_2', 'RUANG MEETING', NULL, 'AD6DD321', 'GRANTED', 'rfid', '2026-05-04 21:19:15'),
(545, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'GRANTED', 'rfid', '2026-05-04 21:19:15'),
(546, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'GRANTED', 'rfid', '2026-05-04 21:20:32'),
(547, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'GRANTED', 'rfid', '2026-05-04 21:20:50'),
(548, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'GRANTED', 'rfid', '2026-05-04 21:21:05'),
(549, 'door_2', 'RUANG MEETING', NULL, 'AD6DD321', 'GRANTED', 'rfid', '2026-05-04 21:21:06'),
(550, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'GRANTED', 'rfid', '2026-05-04 21:21:19'),
(551, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'GRANTED', 'rfid', '2026-05-04 21:21:29'),
(552, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'GRANTED', 'rfid', '2026-05-04 21:21:40'),
(553, 'door_2', 'RUANG MEETING', NULL, 'AD629121', 'GRANTED', 'rfid', '2026-05-04 21:21:51'),
(554, 'door_2', 'RUANG MEETING', NULL, 'AD6DD321', 'GRANTED', 'rfid', '2026-05-04 21:21:51'),
(555, 'door_2', 'RUANG MEETING', NULL, 'AD6DD321', 'GRANTED', 'rfid', '2026-05-04 21:21:59'),
(556, 'door_2', 'RUANG MEETING', NULL, 'AD629121', 'GRANTED', 'rfid', '2026-05-04 21:22:05'),
(557, 'door_2', 'RUANG MEETING', NULL, 'AD629121', 'GRANTED', 'rfid', '2026-05-04 21:22:20'),
(558, 'door_2', 'RUANG MEETING', NULL, '13E824D3', 'DENIED', 'rfid', '2026-05-04 21:22:41'),
(559, 'door_2', 'RUANG MEETING', NULL, '13E824D3', 'DENIED', 'rfid', '2026-05-04 21:22:42'),
(560, 'door_2', 'RUANG MEETING', NULL, 'AD6DD321', 'GRANTED', 'rfid', '2026-05-04 21:22:43'),
(561, 'door_2', 'RUANG MEETING', NULL, '058A3906', 'DENIED', 'rfid', '2026-05-04 21:22:58'),
(562, 'door_2', 'RUANG MEETING', NULL, '058A3906', 'DENIED', 'rfid', '2026-05-04 21:23:24'),
(563, 'door_2', 'RUANG MEETING', NULL, '058A3906', 'DENIED', 'rfid', '2026-05-04 21:23:25'),
(564, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-04 21:23:49'),
(565, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-04 21:30:44'),
(566, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-04 21:32:21'),
(567, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-04 21:34:42'),
(568, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 01:09:37'),
(569, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 01:13:24'),
(570, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 01:13:32'),
(571, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 01:39:30'),
(572, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 01:54:26'),
(573, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 01:54:34'),
(574, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 01:58:11'),
(575, 'door_2', 'RUANG MEETING', NULL, 'BD9BD421', 'DENIED', 'rfid', '2026-05-05 01:58:25'),
(576, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 01:58:35'),
(577, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 02:12:27'),
(578, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 02:12:34'),
(579, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 02:12:41'),
(580, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 02:33:50'),
(581, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 11:28:11'),
(582, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 11:30:30'),
(583, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 11:42:17'),
(584, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 11:43:04'),
(585, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 11:45:01'),
(586, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 11:50:45'),
(587, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 11:51:10'),
(588, 'door_2', 'RUANG MEETING', NULL, 'AD6DD321', 'GRANTED', 'rfid', '2026-05-05 12:08:35'),
(589, 'door_2', 'RUANG MEETING', NULL, 'BD9BD421', 'DENIED', 'rfid', '2026-05-05 12:09:03'),
(590, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 12:09:48'),
(591, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 12:11:46'),
(592, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 12:12:30'),
(593, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 12:31:53'),
(594, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 12:48:33'),
(595, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 12:48:54'),
(596, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 13:48:05'),
(597, 'door_2', 'RUANG MEETING', NULL, '13E824D3', 'DENIED', 'rfid', '2026-05-05 13:49:18'),
(598, 'door_2', 'RUANG MEETING', NULL, 'AD6DD321', 'GRANTED', 'rfid', '2026-05-05 13:49:27'),
(599, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 13:50:27'),
(600, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 14:03:50'),
(601, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 14:22:30'),
(602, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 14:22:40'),
(603, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 14:39:49'),
(604, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 14:39:54'),
(605, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 14:40:02'),
(606, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 14:45:28'),
(607, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 14:51:08'),
(608, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 14:55:00'),
(609, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 14:56:16'),
(610, 'door_2', 'RUANG MEETING', NULL, 'BD9BD421', 'DENIED', 'rfid', '2026-05-05 15:12:32'),
(611, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 15:38:03'),
(612, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 15:38:35'),
(613, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 16:24:27'),
(614, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-05 16:29:05'),
(615, 'door_1', 'RUANG NOC', 'Raden', '-', 'GRANTED', 'web', '2026-05-06 08:25:10'),
(616, 'door_1', 'RUANG NOC', NULL, 'BD9BD421', 'GRANTED', 'rfid', '2026-05-06 08:26:19'),
(617, 'door_1', 'RUANG NOC', NULL, '66E84306', 'DENIED', 'rfid', '2026-05-06 08:28:13'),
(618, 'door_1', 'RUANG NOC', NULL, '13E824D3', 'GRANTED', 'rfid', '2026-05-06 08:28:23'),
(619, 'door_1', 'RUANG NOC', 'Raden', '-', 'GRANTED', 'web', '2026-05-06 08:28:55'),
(620, 'door_1', 'RUANG NOC', 'Raden', '-', 'GRANTED', 'web', '2026-05-06 08:30:21'),
(621, 'door_2', 'RUANG MEETING', NULL, 'BD9BD421', 'DENIED', 'rfid', '2026-05-06 17:22:48'),
(622, 'door_2', 'RUANG MEETING', NULL, 'BD9BD421', 'DENIED', 'rfid', '2026-05-06 17:22:48'),
(623, 'door_2', 'RUANG MEETING', NULL, 'AD6DD321', 'DENIED', 'rfid', '2026-05-06 17:22:49'),
(624, 'door_2', 'RUANG MEETING', NULL, 'AD629121', 'DENIED', 'rfid', '2026-05-06 17:22:49'),
(625, 'door_2', 'RUANG MEETING', NULL, '13E824D3', 'DENIED', 'rfid', '2026-05-06 17:23:58'),
(626, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'GRANTED', 'rfid', '2026-05-06 17:24:02'),
(627, 'door_2', 'RUANG MEETING', NULL, '13E824D3', 'GRANTED', 'rfid', '2026-05-06 17:24:38'),
(628, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'GRANTED', 'rfid', '2026-05-06 17:24:43'),
(629, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'GRANTED', 'rfid', '2026-05-06 17:24:49'),
(630, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'GRANTED', 'rfid', '2026-05-06 17:24:49'),
(631, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-06 17:25:35'),
(632, 'door_2', 'RUANG MEETING', NULL, '058A3906', 'DENIED', 'rfid', '2026-05-06 17:26:24'),
(633, 'door_2', 'RUANG MEETING', NULL, '058065BFA8D100', 'DENIED', 'rfid', '2026-05-06 17:26:58'),
(634, 'door_2', 'RUANG MEETING', NULL, '058065BFA8D100', 'GRANTED', 'rfid', '2026-05-06 17:28:42'),
(635, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-06 17:40:45'),
(636, 'door_1', 'RUANG NOC', NULL, 'BD9BD421', 'GRANTED', 'rfid', '2026-05-06 22:46:08'),
(637, 'door_2', 'RUANG MEETING', NULL, 'AD6DD321', 'GRANTED', 'rfid', '2026-05-06 22:51:04'),
(638, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'GRANTED', 'rfid', '2026-05-06 22:51:11'),
(639, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'GRANTED', 'rfid', '2026-05-06 22:51:11'),
(640, 'door_2', 'RUANG MEETING', NULL, 'AD629121', 'GRANTED', 'rfid', '2026-05-06 23:20:49'),
(641, 'door_2', 'RUANG MEETING', NULL, 'BD9BD421', 'DENIED', 'rfid', '2026-05-06 23:20:49'),
(642, 'door_2', 'RUANG MEETING', NULL, 'AD6DD321', 'GRANTED', 'rfid', '2026-05-06 23:20:49'),
(643, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'GRANTED', 'rfid', '2026-05-06 23:20:49'),
(644, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'GRANTED', 'rfid', '2026-05-06 23:20:49'),
(645, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'GRANTED', 'rfid', '2026-05-06 23:20:50'),
(646, 'door_2', 'RUANG MEETING', NULL, 'BD9BD421', 'DENIED', 'rfid', '2026-05-06 23:20:50'),
(647, 'door_2', 'RUANG MEETING', NULL, '13E824D3', 'DENIED', 'rfid', '2026-05-06 23:20:50'),
(648, 'door_2', 'RUANG MEETING', NULL, '13E824D3', 'DENIED', 'rfid', '2026-05-06 23:20:50'),
(649, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'GRANTED', 'rfid', '2026-05-06 23:20:50'),
(650, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-06 23:21:01'),
(651, 'door_2', 'RUANG MEETING', NULL, 'AD629121', 'GRANTED', 'rfid', '2026-05-06 23:30:49'),
(652, 'door_2', 'RUANG MEETING', NULL, '13E824D3', 'DENIED', 'rfid', '2026-05-06 23:30:49'),
(653, 'door_2', 'RUANG MEETING', NULL, 'AD629121', 'GRANTED', 'rfid', '2026-05-06 23:30:49'),
(654, 'door_2', 'RUANG MEETING', NULL, 'AD6DD321', 'GRANTED', 'rfid', '2026-05-06 23:30:49'),
(655, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'GRANTED', 'rfid', '2026-05-06 23:30:49'),
(656, 'door_2', 'RUANG MEETING', NULL, 'AD629121', 'GRANTED', 'rfid', '2026-05-06 23:31:01'),
(657, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'DENIED', 'rfid', '2026-05-06 23:36:51'),
(658, 'door_2', 'RUANG MEETING', NULL, '13E824D3', 'DENIED', 'rfid', '2026-05-06 23:36:51'),
(659, 'door_2', 'RUANG MEETING', NULL, '13E824D3', 'DENIED', 'rfid', '2026-05-06 23:36:51'),
(660, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-06 23:37:11'),
(661, 'door_2', 'RUANG MEETING', NULL, '02BA7E71B11D00', 'DENIED', 'rfid', '2026-05-07 11:41:04'),
(662, 'door_2', 'RUANG MEETING', NULL, '02BA7E71B11D00', 'GRANTED', 'rfid', '2026-05-07 11:42:34'),
(663, 'door_2', 'RUANG MEETING', 'Aji Ganteng', '-', 'GRANTED', 'web', '2026-05-07 11:43:03'),
(664, 'door_2', 'RUANG MEETING', 'Aji Ganteng', '-', 'GRANTED', 'web', '2026-05-07 11:44:01'),
(665, 'door_2', 'RUANG MEETING', NULL, 'BD9BD421', 'DENIED', 'rfid', '2026-05-07 11:50:09'),
(666, 'door_2', 'RUANG MEETING', NULL, 'BD9BD421', 'DENIED', 'rfid', '2026-05-07 11:50:12'),
(667, 'door_2', 'RUANG MEETING', NULL, 'AD6DD321', 'DENIED', 'rfid', '2026-05-07 11:50:13'),
(668, 'door_2', 'RUANG MEETING', NULL, '13E824D3', 'DENIED', 'rfid', '2026-05-07 11:50:13'),
(669, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'DENIED', 'rfid', '2026-05-07 11:50:13'),
(670, 'door_2', 'RUANG MEETING', NULL, 'AD629121', 'DENIED', 'rfid', '2026-05-07 11:50:13'),
(671, 'door_2', 'RUANG MEETING', 'Aji Ganteng', '-', 'GRANTED', 'web', '2026-05-07 11:50:17'),
(672, 'door_2', 'RUANG MEETING', 'Aji Ganteng', '-', 'GRANTED', 'web', '2026-05-07 11:55:50'),
(673, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-08 01:44:49'),
(674, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-08 01:45:45'),
(675, 'door_2', 'RUANG MEETING', NULL, 'BD9BD421', 'DENIED', 'rfid', '2026-05-08 01:45:56'),
(676, 'door_2', 'RUANG MEETING', 'Raden', '-', 'GRANTED', 'web', '2026-05-08 02:19:16'),
(677, 'door_2', 'RUANG MEETING', NULL, '058A3906', 'DENIED', 'rfid', '2026-05-08 14:36:53'),
(678, 'door_2', 'RUANG MEETING', NULL, '058A3906', 'DENIED', 'rfid', '2026-05-08 14:38:52'),
(679, 'door_2', 'RUANG MEETING', NULL, '058A3906', 'GRANTED', 'rfid', '2026-05-08 14:39:11'),
(680, 'door_2', 'RUANG MEETING', 'Budi', '-', 'GRANTED', 'web', '2026-05-08 14:39:53'),
(681, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'GRANTED', 'rfid', '2026-05-08 14:41:13'),
(682, 'door_2', 'RUANG MEETING', NULL, 'BD9BD421', 'DENIED', 'rfid', '2026-05-08 14:41:33'),
(683, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'DENIED', 'rfid', '2026-05-08 14:46:53'),
(684, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'DENIED', 'rfid', '2026-05-08 14:46:53'),
(685, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'DENIED', 'rfid', '2026-05-08 14:46:55'),
(686, 'door_2', 'RUANG MEETING', NULL, '66E84306', 'GRANTED', 'rfid', '2026-05-08 14:46:56'),
(687, 'door_2', 'RUANG MEETING', NULL, '058A1BA6BAD100', 'DENIED', 'rfid', '2026-05-13 14:56:13'),
(688, 'door_2', 'RUANG MEETING', NULL, '058A1BA6BAD100', 'DENIED', 'rfid', '2026-05-13 14:58:34'),
(689, 'door_2', 'RUANG MEETING', NULL, '058A1BA6BAD100', 'GRANTED', 'rfid', '2026-05-13 14:59:23'),
(690, 'door_2', 'RUANG MEETING', NULL, '058A1BA6BAD100', 'GRANTED', 'rfid', '2026-05-13 15:00:18'),
(691, 'door_2', 'RUANG MEETING', NULL, '058A1BA6BAD100', 'GRANTED', 'rfid', '2026-05-13 15:00:41'),
(692, 'door_2', 'RUANG MEETING', 'Rafi Ganteng', '-', 'GRANTED', 'web', '2026-05-13 15:01:24'),
(693, 'door_2', 'RUANG MEETING', 'Rafi Ganteng', '-', 'GRANTED', 'web', '2026-05-13 15:02:18'),
(694, 'door_1', 'RUANG NOC', NULL, '13E824D3', 'GRANTED', 'rfid', '2026-05-13 23:46:55'),
(695, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-05-13 23:47:11'),
(696, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-05-13 23:47:37'),
(697, 'door_1', 'RUANG NOC', NULL, 'BD9BD421', 'GRANTED', 'rfid', '2026-05-13 23:47:50'),
(698, 'door_1', 'RUANG NOC', NULL, 'BD9BD421', 'GRANTED', 'rfid', '2026-05-13 23:47:50'),
(699, 'door_1', 'RUANG NOC', NULL, 'BD9BD421', 'GRANTED', 'rfid', '2026-05-13 23:47:58'),
(700, 'door_1', 'RUANG NOC', NULL, 'BD9BD421', 'GRANTED', 'rfid', '2026-05-13 23:48:06'),
(701, 'door_1', 'RUANG NOC', NULL, '13E824D3', 'GRANTED', 'rfid', '2026-05-13 23:48:13'),
(702, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-17 17:58:42'),
(703, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-17 17:59:11'),
(704, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-17 17:59:23'),
(705, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-17 17:59:39'),
(706, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-22 18:14:34'),
(707, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-22 18:15:28'),
(708, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-22 18:16:22'),
(709, 'door_2', 'RUANG MEETING', 'admin', '-', 'GRANTED', 'web', '2026-05-22 18:17:11'),
(710, 'door_2', 'RUANG MEETING', 'admin', '-', 'GRANTED', 'web', '2026-05-22 18:17:25'),
(711, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-22 18:22:16'),
(712, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-22 18:24:52'),
(713, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-22 18:44:06'),
(714, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-22 19:04:58'),
(715, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-22 19:16:09'),
(716, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-22 19:19:22'),
(717, 'door_2', 'RUANG MEETING', NULL, 'BD9BD421', 'DENIED', 'rfid', '2026-05-22 19:38:52'),
(718, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-22 19:50:04'),
(719, 'door_2', 'RUANG MEETING', NULL, '058A3906', 'DENIED', 'rfid', '2026-05-22 21:22:13'),
(720, 'door_2', 'RUANG MEETING', NULL, '058A3906', 'GRANTED', 'rfid', '2026-05-22 21:22:37'),
(721, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-22 21:38:39'),
(722, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-22 21:38:49'),
(723, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-22 21:39:01'),
(724, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-22 21:39:14'),
(725, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-22 22:14:26'),
(726, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-22 22:14:34'),
(727, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-22 23:17:26'),
(728, 'door_2', 'RUANG MEETING', NULL, 'BD9BD421', 'DENIED', 'rfid', '2026-05-23 00:03:50'),
(729, 'door_2', 'RUANG MEETING', NULL, '31ACD36E', 'DENIED', 'rfid', '2026-05-23 15:43:34'),
(730, 'door_2', 'RUANG MEETING', NULL, '31ACD36E', 'DENIED', 'rfid', '2026-05-23 15:43:37'),
(731, 'door_2', 'RUANG MEETING', NULL, '31ACD36E', 'GRANTED', 'rfid', '2026-05-23 15:45:04'),
(732, 'door_2', 'RUANG MEETING', 'Bagas', '-', 'GRANTED', 'web', '2026-05-23 15:45:59'),
(733, 'door_2', 'RUANG MEETING', NULL, 'AD629121', 'GRANTED', 'rfid', '2026-05-23 15:47:41'),
(734, 'door_2', 'RUANG MEETING', NULL, 'AD629121', 'GRANTED', 'rfid', '2026-05-23 15:48:11'),
(735, 'door_2', 'RUANG MEETING', NULL, 'AD629121', 'DENIED', 'rfid', '2026-05-23 15:49:13'),
(736, 'door_2', 'RUANG MEETING', 'Bagas', '-', 'GRANTED', 'web', '2026-05-23 15:55:09'),
(737, 'door_2', 'RUANG MEETING', 'Bagas', '-', 'GRANTED', 'web', '2026-05-23 16:04:04'),
(738, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-23 16:09:37'),
(739, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-23 16:09:44'),
(740, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-23 16:45:31'),
(741, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-05-23 16:57:09'),
(742, 'door_2', 'RUANG MEETING', NULL, '0587B114249100', 'DENIED', 'rfid', '2026-05-26 22:46:15'),
(743, 'door_2', 'RUANG MEETING', NULL, '0587B114249100', 'DENIED', 'rfid', '2026-05-26 22:46:29'),
(744, 'door_2', 'RUANG MEETING', NULL, '046F428ABE5880', 'DENIED', 'rfid', '2026-05-26 22:46:47'),
(745, 'door_2', 'RUANG MEETING', NULL, '046F428ABE5880', 'DENIED', 'rfid', '2026-05-26 22:46:57'),
(746, 'door_2', 'RUANG MEETING', NULL, '046F428ABE5880', 'GRANTED', 'rfid', '2026-05-26 22:48:42'),
(747, 'door_2', 'RUANG MEETING', 'PakDe Pur', '-', 'GRANTED', 'web', '2026-05-26 22:51:27'),
(748, 'door_2', 'RUANG MEETING', 'PakDe Pur', '-', 'GRANTED', 'web', '2026-05-26 22:51:40'),
(749, 'door_2', 'RUANG MEETING', 'PakDe Pur', '-', 'GRANTED', 'web', '2026-05-26 22:52:13'),
(750, 'door_2', 'RUANG MEETING', 'PakDe Pur', '-', 'GRANTED', 'web', '2026-05-26 22:52:33'),
(751, 'door_2', 'RUANG MEETING', NULL, '046F428ABE5880', 'GRANTED', 'rfid', '2026-05-26 22:53:00'),
(752, 'door_2', 'RUANG MEETING', NULL, '046F428ABE5880', 'DENIED', 'rfid', '2026-05-26 22:53:24'),
(753, 'door_2', 'RUANG MEETING', NULL, '046F428ABE5880', 'DENIED', 'rfid', '2026-05-26 22:53:24'),
(754, 'door_1', 'RUANG NOC', 'admin', '-', 'GRANTED', 'web', '2026-05-26 22:54:32'),
(755, 'door_2', 'RUANG MEETING', 'admin', '-', 'GRANTED', 'web', '2026-05-26 22:54:34'),
(756, 'door_2', 'RUANG MEETING', 'PakDe Pur', '-', 'GRANTED', 'web', '2026-05-26 22:54:47'),
(757, 'door_2', 'RUANG MEETING', NULL, '046F428ABE5880', 'DENIED', 'rfid', '2026-05-26 22:55:11'),
(758, 'door_2', 'RUANG MEETING', NULL, '046F428ABE5880', 'GRANTED', 'rfid', '2026-05-26 22:55:25'),
(759, 'door_1', 'RUANG NOC', 'admin', '-', 'GRANTED', 'web', '2026-05-26 23:01:38'),
(760, 'door_2', 'RUANG MEETING', 'admin', '-', 'GRANTED', 'web', '2026-05-26 23:01:39'),
(761, 'door_2', 'RUANG MEETING', NULL, '046F428ABE5880', 'DENIED', 'rfid', '2026-05-26 23:02:13'),
(762, 'door_2', 'RUANG MEETING', NULL, '046F428ABE5880', 'GRANTED', 'rfid', '2026-05-26 23:02:13'),
(763, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-06-03 15:23:00'),
(764, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-03 22:05:11'),
(765, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-03 22:05:21'),
(766, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-03 22:06:24'),
(767, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-03 22:06:33'),
(768, 'door_1', 'RUANG NOC', 'admin', '-', 'GRANTED', 'web', '2026-06-03 22:38:17'),
(769, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-06 22:46:25'),
(770, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-06 22:46:34'),
(771, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-06 22:46:43'),
(772, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-06 22:57:58'),
(773, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-06 23:11:22'),
(774, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-06 23:46:47'),
(775, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-06 23:47:29'),
(776, 'door_1', 'RUANG NOC', NULL, '8F0B7B6A', 'DENIED', 'rfid', '2026-06-06 23:48:06'),
(777, 'door_1', 'RUANG NOC', NULL, '8F0B7B6A', 'GRANTED', 'rfid', '2026-06-06 23:49:33'),
(778, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-06 23:49:43'),
(779, 'door_1', 'RUANG NOC', NULL, '8F0B7B6A', 'GRANTED', 'rfid', '2026-06-06 23:50:29'),
(780, 'door_1', 'RUANG NOC', NULL, '8F0B7B6A', 'DENIED', 'rfid', '2026-06-06 23:50:49'),
(781, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-06 23:51:02'),
(782, 'door_1', 'RUANG NOC', NULL, '8F0B7B6A', 'DENIED', 'rfid', '2026-06-06 23:52:03'),
(783, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-07 01:19:31'),
(784, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-07 01:20:04'),
(785, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-07 01:20:46'),
(786, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-07 01:23:37'),
(787, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-07 01:40:20'),
(788, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-07 01:40:32'),
(789, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-07 01:40:43'),
(790, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-07 01:40:54'),
(791, 'door_1', 'RUANG NOC', NULL, '8F0B7B6A', 'DENIED', 'rfid', '2026-06-07 01:41:11'),
(792, 'door_1', 'RUANG NOC', NULL, '8F0B7B6A', 'GRANTED', 'rfid', '2026-06-07 01:41:40'),
(793, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-07 01:43:56'),
(794, 'door_1', 'RUANG NOC', NULL, '8F0B7B6A', 'DENIED', 'rfid', '2026-06-07 01:44:54'),
(795, 'door_1', 'RUANG NOC', 'admin', '-', 'GRANTED', 'web', '2026-06-18 12:13:15'),
(796, 'door_1', 'RUANG NOC', 'admin', '-', 'GRANTED', 'web', '2026-06-18 12:13:38'),
(797, 'door_1', 'RUANG NOC', 'admin', '-', 'GRANTED', 'web', '2026-06-18 12:43:43'),
(798, 'door_1', 'RUANG NOC', 'admin', '-', 'GRANTED', 'web', '2026-06-18 12:48:54'),
(799, 'door_1', 'RUANG NOC', 'admin', '-', 'GRANTED', 'web', '2026-06-18 12:55:46'),
(800, 'door_1', 'RUANG NOC', NULL, '66E84306', 'DENIED', 'rfid', '2026-06-18 13:18:19'),
(801, 'door_1', 'RUANG NOC', NULL, 'AD6DD321', 'GRANTED', 'rfid', '2026-06-18 13:18:26'),
(802, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-18 13:19:11'),
(803, 'door_1', 'RUANG NOC', NULL, '13E824D3', 'GRANTED', 'rfid', '2026-06-18 13:20:29'),
(804, 'door_1', 'RUANG NOC', NULL, 'AD629121', 'DENIED', 'rfid', '2026-06-18 13:20:35'),
(805, 'door_1', 'RUANG NOC', NULL, 'BD9BD421', 'GRANTED', 'rfid', '2026-06-18 13:20:50'),
(806, 'door_1', 'RUANG NOC', NULL, '8F0B7B6A', 'DENIED', 'rfid', '2026-06-18 13:21:04'),
(807, 'door_1', 'RUANG NOC', NULL, '0587B114249100', 'DENIED', 'rfid', '2026-06-18 13:21:44'),
(808, 'door_1', 'RUANG NOC', NULL, 'AD629121', 'DENIED', 'rfid', '2026-06-18 13:46:58'),
(809, 'door_1', 'RUANG NOC', NULL, 'BD9BD421', 'GRANTED', 'rfid', '2026-06-18 13:47:18'),
(810, 'door_1', 'RUANG NOC', NULL, '13E824D3', 'GRANTED', 'rfid', '2026-06-18 13:47:31'),
(811, 'door_2', 'RUANG MEETING', NULL, 'AD629121', 'GRANTED', 'rfid', '2026-06-18 13:47:51'),
(812, 'door_2', 'RUANG MEETING', NULL, '8F0B7B6A', 'GRANTED', 'rfid', '2026-06-18 13:48:09'),
(813, 'door_2', 'RUANG MEETING', NULL, '0587B114249100', 'DENIED', 'rfid', '2026-06-18 13:48:17'),
(814, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-06-18 13:48:33'),
(815, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-18 13:53:18'),
(816, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-18 13:53:31'),
(817, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-18 13:53:40'),
(818, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-18 13:53:53'),
(819, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-18 13:54:14'),
(820, 'door_2', 'RUANG MEETING', 'Apip', '-', 'GRANTED', 'web', '2026-06-18 13:54:20'),
(821, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-23 18:22:35'),
(822, 'door_1', 'RUANG NOC', 'Apip', '-', 'GRANTED', 'web', '2026-06-23 18:22:41'),
(823, 'door_1', 'RUANG NOC', NULL, '058A3906', 'DENIED', 'rfid', '2026-06-23 18:31:07'),
(824, 'door_1', 'RUANG NOC', NULL, '058A3906', 'DENIED', 'rfid', '2026-06-23 18:31:10'),
(825, 'door_1', 'RUANG NOC', NULL, 'BD9BD421', 'GRANTED', 'rfid', '2026-06-23 18:31:18'),
(826, 'door_1', 'RUANG NOC', NULL, '66E84306', 'DENIED', 'rfid', '2026-06-23 18:31:31'),
(827, 'door_1', 'RUANG NOC', NULL, '13E824D3', 'GRANTED', 'rfid', '2026-06-23 18:31:53'),
(828, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-01 14:13:25'),
(829, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-01 14:14:11'),
(830, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-01 14:14:43'),
(831, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-01 14:19:55'),
(832, 'door_1', 'RUANG NOC', 'Ardi', '13E824D3', 'GRANTED', 'rfid', '2026-07-01 14:24:34'),
(833, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-01 14:28:36'),
(834, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-01 14:28:55'),
(835, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-01 14:29:43'),
(836, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-01 14:29:56'),
(837, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-01 14:30:09'),
(838, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-01 16:16:16'),
(839, 'door_1', 'RUANG NOC', 'Jejen', '66E84306', 'DENIED', 'rfid', '2026-07-01 16:19:44'),
(840, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-01 16:22:22'),
(841, 'door_1', 'RUANG NOC', 'Jejen', '66E84306', 'DENIED', 'rfid', '2026-07-01 16:22:53'),
(842, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-01 16:23:54'),
(843, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-01 16:24:16'),
(844, 'door_1', 'RUANG NOC', 'Jejen', '66E84306', 'DENIED', 'rfid', '2026-07-01 16:24:43'),
(845, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-01 16:24:57'),
(846, 'door_1', 'RUANG NOC', 'Ardi', '13E824D3', 'GRANTED', 'rfid', '2026-07-01 16:25:43'),
(847, 'door_1', 'RUANG NOC', 'Ardi', '13E824D3', 'GRANTED', 'rfid', '2026-07-01 16:25:57'),
(848, 'door_1', 'RUANG NOC', 'Azis', 'AD6DD321', 'GRANTED', 'rfid', '2026-07-01 16:26:25'),
(849, 'door_1', 'RUANG NOC', 'Azis', 'AD6DD321', 'GRANTED', 'rfid', '2026-07-01 16:26:38'),
(850, 'door_1', 'RUANG NOC', 'Azis', 'AD6DD321', 'DENIED', 'rfid', '2026-07-01 16:27:21'),
(851, 'door_1', 'RUANG NOC', 'Azis', 'AD6DD321', 'DENIED', 'rfid', '2026-07-01 16:28:01'),
(852, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-01 17:17:35'),
(853, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-01 17:54:53'),
(854, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-01 20:24:32'),
(855, 'door_1', 'RUANG NOC', 'Putri', 'AD629121', 'DENIED', 'rfid', '2026-07-01 20:24:58'),
(856, 'door_1', 'RUANG NOC', 'Putri', 'AD629121', 'GRANTED', 'rfid', '2026-07-01 20:26:02'),
(857, 'door_1', 'RUANG NOC', 'Putri', 'AD629121', 'GRANTED', 'rfid', '2026-07-01 20:26:41'),
(858, 'door_1', 'RUANG NOC', 'Jejen', '66E84306', 'DENIED', 'rfid', '2026-07-01 20:28:33'),
(859, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-01 20:38:04'),
(860, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-01 20:38:23'),
(861, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-01 20:38:49'),
(862, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-01 20:40:23'),
(863, 'door_1', 'RUANG NOC', NULL, '0587B114249100', 'DENIED', 'rfid', '2026-07-01 20:41:15'),
(864, 'door_1', 'RUANG NOC', 'Iqbal', '0587B114249100', 'GRANTED', 'rfid', '2026-07-01 20:42:39'),
(865, 'door_1', 'RUANG NOC', 'Iqbal', '0587B114249100', 'GRANTED', 'rfid', '2026-07-01 20:42:52'),
(866, 'door_1', 'RUANG NOC', 'Ardi', '13E824D3', 'GRANTED', 'rfid', '2026-07-01 20:49:56'),
(867, 'door_1', 'RUANG NOC', 'Ardi', '13E824D3', 'DENIED', 'rfid', '2026-07-01 20:51:54'),
(868, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-01 21:22:10'),
(869, 'door_1', 'RUANG NOC', 'Iqbal', 'WEB', 'GRANTED', 'web', '2026-07-01 21:54:58'),
(870, 'door_1', 'RUANG NOC', 'Iqbal', '0587B114249100', 'GRANTED', 'rfid', '2026-07-01 21:56:53'),
(871, 'door_1', 'RUANG NOC', 'Ardi', '13E824D3', 'DENIED', 'rfid', '2026-07-01 23:33:38'),
(872, 'door_1', 'RUANG NOC', 'Putri', 'AD629121', 'GRANTED', 'rfid', '2026-07-01 23:34:04'),
(873, 'door_1', 'RUANG NOC', 'ORANG', 'WEB', 'GRANTED', 'web', '2026-07-02 10:55:37'),
(874, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-02 11:43:01'),
(875, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-02 13:40:51'),
(876, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-02 16:23:14'),
(877, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-02 16:23:48'),
(878, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'DENIED', 'rfid', '2026-07-02 16:24:26'),
(879, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-02 16:28:17'),
(880, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-02 16:40:23'),
(881, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-02 16:41:23'),
(882, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-02 17:36:01'),
(883, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-02 17:36:19'),
(884, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-02 18:08:36'),
(885, 'door_1', 'RUANG NOC', NULL, '66E84306', 'DENIED', 'rfid', '2026-07-02 18:09:33'),
(886, 'door_1', 'RUANG NOC', 'Putri', 'AD629121', 'DENIED', 'rfid', '2026-07-02 18:10:36'),
(887, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-02 18:24:27'),
(888, 'door_2', 'RUANG MEETING', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-02 18:28:50'),
(889, 'door_2', 'RUANG MEETING', 'Azis', 'AD6DD321', 'GRANTED', 'rfid', '2026-07-02 18:29:27'),
(890, 'door_2', 'RUANG MEETING', 'Putri', 'AD629121', 'GRANTED', 'rfid', '2026-07-02 18:29:46'),
(891, 'door_2', 'RUANG MEETING', 'Daniel', 'BD9BD421', 'DENIED', 'rfid', '2026-07-02 18:30:24'),
(892, 'door_2', 'RUANG MEETING', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-02 21:42:14'),
(893, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-06 11:16:33'),
(894, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-06 11:17:53'),
(895, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-06 11:18:06'),
(896, 'door_1', 'RUANG NOC', 'Putri', 'AD629121', 'DENIED', 'rfid', '2026-07-06 11:18:39'),
(897, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-06 11:24:09'),
(898, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-06 17:36:47'),
(899, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-06 17:37:07'),
(900, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-06 17:37:35'),
(901, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-06 18:01:35'),
(902, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-06 18:02:04'),
(903, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-06 18:02:20'),
(909, 'door_1', 'RUANG NOC', 'Azis', 'AD6DD321', 'DENIED', 'rfid', '2026-07-09 15:13:32'),
(910, 'door_1', 'RUANG NOC', 'Azis', 'AD6DD321', 'GRANTED', 'rfid', '2026-07-09 15:14:27'),
(911, 'door_1', 'RUANG NOC', 'Azis', 'AD6DD321', 'GRANTED', 'rfid', '2026-07-09 15:23:20'),
(912, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-09 20:47:26'),
(913, 'door_1', 'RUANG NOC', 'Azis', 'AD6DD321', 'GRANTED', 'rfid', '2026-07-09 20:48:36'),
(914, 'door_1', 'RUANG NOC', 'Azis', 'AD6DD321', 'GRANTED', 'rfid', '2026-07-09 20:49:00'),
(915, 'door_1', 'RUANG NOC', 'Azis', 'AD6DD321', 'GRANTED', 'rfid', '2026-07-09 21:17:57'),
(916, 'door_1', 'RUANG NOC', 'Azis', 'AD6DD321', 'GRANTED', 'rfid', '2026-07-09 21:56:22'),
(917, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-09 21:56:57'),
(918, 'door_1', 'RUANG NOC', 'Azis', 'AD6DD321', 'GRANTED', 'rfid', '2026-07-09 23:11:56'),
(919, 'door_1', 'RUANG NOC', NULL, '66E84306', 'DENIED', 'rfid', '2026-07-09 23:12:30'),
(920, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-09 23:12:50'),
(921, 'door_1', 'RUANG NOC', 'Ardi', '13E824D3', 'GRANTED', 'rfid', '2026-07-09 23:13:49'),
(922, 'door_2', 'RUANG MEETING', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-10 23:46:34'),
(923, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-11 15:18:00'),
(924, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-11 15:18:15'),
(925, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-11 17:18:15'),
(926, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-11 17:19:29'),
(927, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-11 21:21:42'),
(928, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-12 00:43:48'),
(929, 'door_1', 'RUANG NOC', 'Azis', 'AD6DD321', 'GRANTED', 'rfid', '2026-07-12 01:17:31'),
(930, 'door_1', 'RUANG NOC', 'Azis', 'AD6DD321', 'GRANTED', 'rfid', '2026-07-12 01:17:47'),
(931, 'door_1', 'RUANG NOC', 'Azis', 'AD6DD321', 'GRANTED', 'rfid', '2026-07-12 01:19:17'),
(932, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-12 01:22:52'),
(933, 'door_1', 'RUANG NOC', 'Azis', 'AD6DD321', 'GRANTED', 'rfid', '2026-07-12 01:24:30'),
(934, 'door_1', 'RUANG NOC', 'Azis', 'AD6DD321', 'GRANTED', 'rfid', '2026-07-12 01:41:05'),
(935, 'door_1', 'RUANG NOC', 'Azis', 'AD6DD321', 'GRANTED', 'rfid', '2026-07-12 01:41:26'),
(936, 'door_2', 'RUANG MEETING', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-12 10:37:26'),
(937, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-12 10:51:40'),
(938, 'door_1', 'RUANG NOC', 'Putri', 'AD629121', 'DENIED', 'rfid', '2026-07-12 10:52:07'),
(939, 'door_1', 'RUANG NOC', 'Azis', 'AD6DD321', 'GRANTED', 'rfid', '2026-07-12 10:52:29'),
(940, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-12 11:39:40'),
(941, 'door_1', 'RUANG NOC', 'Azis', 'AD6DD321', 'GRANTED', 'rfid', '2026-07-12 11:39:59'),
(942, 'door_1', 'RUANG NOC', 'Putri', 'AD629121', 'DENIED', 'rfid', '2026-07-12 11:40:21'),
(943, 'door_1', 'RUANG NOC', 'Putri', 'AD629121', 'DENIED', 'rfid', '2026-07-12 11:41:06'),
(944, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-12 11:41:54'),
(945, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-12 11:42:39'),
(946, 'door_1', 'RUANG NOC', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-12 11:46:08'),
(947, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-12 11:47:32'),
(948, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-12 11:48:12'),
(949, 'door_1', 'RUANG NOC', 'Putri', 'AD629121', 'DENIED', 'rfid', '2026-07-12 11:48:37'),
(950, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-12 11:49:36'),
(951, 'door_1', 'RUANG NOC', 'Putri', 'AD629121', 'DENIED', 'rfid', '2026-07-12 11:49:58'),
(955, 'door_1', 'RUANG NOC', 'Apip', 'WEB', 'GRANTED', 'web', '2026-07-12 11:58:41'),
(956, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-12 12:20:06'),
(957, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-12 12:20:28'),
(958, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-12 12:20:47'),
(959, 'door_1', 'RUANG NOC', 'Daniel', 'BD9BD421', 'GRANTED', 'rfid', '2026-07-12 16:53:32'),
(960, 'door_1', 'RUANG NOC', 'Putri', 'AD629121', 'DENIED', 'rfid', '2026-07-12 16:54:14'),
(961, 'door_1', 'RUANG NOC', 'apip', 'WEB', 'GRANTED', 'web', '2026-07-12 17:18:37'),
(965, 'door_1', 'RUANG NOC', 'Iqbal', '13E824D3', 'GRANTED', 'rfid', '2026-07-12 17:36:00'),
(966, 'door_2', 'RUANG MEETING', 'Putri', 'AD629121', 'GRANTED', 'rfid', '2026-07-12 18:28:39'),
(967, 'door_2', 'RUANG MEETING', 'Daniel', 'BD9BD421', 'DENIED', 'rfid', '2026-07-12 18:28:52'),
(969, 'door_2', 'RUANG MEETING', 'apip', 'WEB', 'GRANTED', 'web', '2026-07-12 18:32:15'),
(970, 'door_2', 'RUANG MEETING', 'apip', 'WEB', 'GRANTED', 'web', '2026-07-12 18:34:26'),
(971, 'door_2', 'RUANG MEETING', 'Putri', 'AD629121', 'GRANTED', 'rfid', '2026-07-12 18:41:59'),
(972, 'door_2', 'RUANG MEETING', 'Putri', 'AD629121', 'GRANTED', 'rfid', '2026-07-12 18:42:27'),
(973, 'door_2', 'RUANG MEETING', 'Daniel', 'BD9BD421', 'DENIED', 'rfid', '2026-07-12 18:42:40'),
(974, 'door_2', 'RUANG MEETING', 'Daniel', 'BD9BD421', 'DENIED', 'rfid', '2026-07-12 18:42:49'),
(975, 'door_2', 'RUANG MEETING', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-13 11:24:41'),
(976, 'door_2', 'RUANG MEETING', 'admin', 'WEB', 'GRANTED', 'web', '2026-07-13 11:26:09');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(128) NOT NULL,
  `uid` varchar(64) DEFAULT NULL,
  `username` varchar(64) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `status` varchar(16) NOT NULL DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `name`, `uid`, `username`, `password`, `status`, `created_at`) VALUES
(4, 'Daniel', 'BD9BD421', NULL, NULL, 'Active', '2026-04-29 06:55:07'),
(5, 'Putri', 'AD629121', NULL, NULL, 'Active', '2026-04-29 13:55:26'),
(10, 'admin', NULL, 'admin', '$2y$10$fp2gsZqu7Oa8qfYoO1ORiePQvbHUpwLLD8MfbDQl7vwSgP204PV0C', 'Active', '2026-04-30 11:18:11'),
(14, 'Azis', 'AD6DD321', 'azis', '$2y$10$AZQ75j0KMzhQumqg1U8jIuko/b1QC8rU/G1aPwVLzgVsy19.rjpny', 'Active', '2026-04-30 11:25:53'),
(2830, 'apip', NULL, 'apip', '$2y$10$GNDcByS3sHIrx49FP8ihn.tij61EjEO9M27Lp2JkIELzoVUdW8Zr.', 'Active', '2026-07-12 09:56:12');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `access_control`
--
ALTER TABLE `access_control`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_user_device` (`user_uid`,`device_id`),
  ADD KEY `idx_user_uid` (`user_uid`),
  ADD KEY `idx_device_id` (`device_id`);

--
-- Indeks untuk tabel `app_settings`
--
ALTER TABLE `app_settings`
  ADD PRIMARY KEY (`setting_key`);

--
-- Indeks untuk tabel `commands`
--
ALTER TABLE `commands`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_device_pending` (`device_id`,`consumed_at`,`created_at`);

--
-- Indeks untuk tabel `devices`
--
ALTER TABLE `devices`
  ADD PRIMARY KEY (`device_id`);

--
-- Indeks untuk tabel `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_logs_device_time` (`device_id`,`time`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_uid` (`uid`),
  ADD UNIQUE KEY `uniq_username` (`username`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `access_control`
--
ALTER TABLE `access_control`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=135;

--
-- AUTO_INCREMENT untuk tabel `commands`
--
ALTER TABLE `commands`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=488;

--
-- AUTO_INCREMENT untuk tabel `logs`
--
ALTER TABLE `logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=977;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2832;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
