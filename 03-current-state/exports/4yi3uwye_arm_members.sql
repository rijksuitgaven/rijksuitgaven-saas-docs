-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: wpdb-ru
-- Generation Time: Jan 13, 2026 at 10:03 PM
-- Server version: 12.1.2-MariaDB-ubu2404
-- PHP Version: 8.3.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Wordpress-ru`
--

-- --------------------------------------------------------

--
-- Table structure for table `4yi3uwye_arm_members`
--

CREATE TABLE `4yi3uwye_arm_members` (
  `arm_member_id` bigint(20) UNSIGNED NOT NULL,
  `arm_user_id` bigint(20) UNSIGNED NOT NULL,
  `arm_user_login` varchar(60) NOT NULL DEFAULT '',
  `arm_user_nicename` varchar(50) NOT NULL DEFAULT '',
  `arm_user_email` varchar(100) NOT NULL DEFAULT '',
  `arm_user_url` varchar(100) NOT NULL DEFAULT '',
  `arm_user_registered` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `arm_user_activation_key` varchar(60) NOT NULL DEFAULT '',
  `arm_user_status` int(11) NOT NULL DEFAULT 0,
  `arm_display_name` varchar(250) NOT NULL DEFAULT '',
  `arm_user_type` int(1) NOT NULL DEFAULT 0,
  `arm_primary_status` int(1) NOT NULL DEFAULT 1,
  `arm_secondary_status` int(1) NOT NULL DEFAULT 0,
  `arm_user_plan_ids` text DEFAULT NULL,
  `arm_user_suspended_plan_ids` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

--
-- Dumping data for table `4yi3uwye_arm_members`
--

INSERT INTO `4yi3uwye_arm_members` (`arm_member_id`, `arm_user_id`, `arm_user_login`, `arm_user_nicename`, `arm_user_email`, `arm_user_url`, `arm_user_registered`, `arm_user_activation_key`, `arm_user_status`, `arm_display_name`, `arm_user_type`, `arm_primary_status`, `arm_secondary_status`, `arm_user_plan_ids`, `arm_user_suspended_plan_ids`) VALUES
(4, 4, 'demo88', 'demo88', 'info@rijksuitgaven.nl', '', '2024-12-04 17:10:13', '', 0, 'Demo Account', 1, 1, 0, 'a:1:{i:0;i:3;}', 'a:1:{i:0;i:3;}'),
(21, 21, 'koen@koenverhagen.com', 'koenkoenverhagen-com', 'koen@koenverhagen.com', '', '2024-12-13 14:45:36', '1734101137:$P$BoiUt9afHQ3n5jY0dGxjZzbIbCa4w30', 0, 'Koen Verhagen', 1, 1, 0, '', ''),
(25, 25, 'leon@kuunders.com', 'leonkuunders-com', 'leon@kuunders.com', '', '2024-12-15 09:38:26', '1740131540:$P$Bpj6RwtWVpBgjcSUCsxyLY/dpxHhyS0', 0, 'Leon Kuunders', 1, 1, 0, 'a:1:{i:0;i:7;}', ''),
(26, 26, 'roger.lomme@planet.nl', 'roger-lommeplanet-nl', 'roger.lomme@planet.nl', '', '2024-12-15 13:19:25', '1739281761:$P$B24iXLIR6lr4OohyV9t/x9PdmjfWvJ0', 0, 'Roger Lomme', 1, 1, 0, '', ''),
(27, 27, 'michiel@mondaybrand.com', 'michielmondaybrand-com', 'michiel@mondaybrand.com', '', '2024-12-17 10:29:54', '1748966167:$generic$TjiQimJXfaQ7VD_H5TFkiX2VFHudGYOlG1yDuvLz', 0, 'Michiel Maandag', 1, 1, 0, 'a:1:{i:0;i:3;}', ''),
(28, 28, 'bert.brussen@gmail.com', 'bert-brussengmail-com', 'bert.brussen@gmail.com', '', '2024-12-21 10:10:09', '1740131540:$P$Bf16En5n/Q1xLljI4MIh4I8B9okMLT/', 0, 'Bert Brussen', 1, 1, 0, 'a:1:{i:0;i:7;}', ''),
(29, 29, 'beckmankarel@protonmail.com', 'beckmankarelprotonmail-com', 'beckmankarel@protonmail.com', '', '2024-12-23 11:12:42', '1740131539:$P$BMYsuoRiEeN45KeQDV8/n9FyXZGQ/X.', 0, 'Karel Beckman', 1, 1, 0, 'a:1:{i:0;i:7;}', ''),
(30, 30, 'Edward_Kleinjan@Hotmail.com', 'edward_kleinjanhotmail-com', 'Edward_Kleinjan@Hotmail.com', '', '2024-12-25 18:19:50', '1740131539:$P$BorNZbat6YxzMleOJiEGtI.ma4ni.21', 0, 'Edward Kleinjan', 1, 1, 0, 'a:1:{i:0;i:7;}', ''),
(31, 31, 'lex.hoogduin@gmail.com', 'lex-hoogduingmail-com', 'lex.hoogduin@gmail.com', '', '2024-12-27 15:00:13', '1740131539:$P$BU5f3aPZ0NI7pqvasbhdff20Az760Y1', 0, 'Lex Hoogduin', 1, 1, 0, 'a:1:{i:0;i:7;}', ''),
(32, 32, 'hello@dsewell.com', 'hellodsewell-com', 'hello@dsewell.com', '', '2024-12-31 15:38:57', '1740131247:$P$BYOcQfu2DLW0oWywy0B2k2yKkmA6M5/', 0, 'David Sewell', 1, 1, 0, 'a:1:{i:0;i:7;}', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `4yi3uwye_arm_members`
--
ALTER TABLE `4yi3uwye_arm_members`
  ADD PRIMARY KEY (`arm_member_id`),
  ADD KEY `arm_user_login_key` (`arm_user_login`),
  ADD KEY `arm_user_nicename` (`arm_user_nicename`),
  ADD KEY `arm-user-id` (`arm_user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `4yi3uwye_arm_members`
--
ALTER TABLE `4yi3uwye_arm_members`
  MODIFY `arm_member_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=99;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
