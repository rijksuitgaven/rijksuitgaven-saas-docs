-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: wpdb-ru
-- Generation Time: Jan 13, 2026 at 10:01 PM
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
-- Table structure for table `4yi3uwye_users`
--

CREATE TABLE `4yi3uwye_users` (
  `ID` bigint(20) UNSIGNED NOT NULL,
  `user_login` varchar(60) NOT NULL DEFAULT '',
  `user_pass` varchar(255) NOT NULL DEFAULT '',
  `user_nicename` varchar(50) NOT NULL DEFAULT '',
  `user_email` varchar(100) NOT NULL DEFAULT '',
  `user_url` varchar(100) NOT NULL DEFAULT '',
  `user_registered` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user_activation_key` varchar(255) NOT NULL DEFAULT '',
  `user_status` int(11) NOT NULL DEFAULT 0,
  `display_name` varchar(250) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

--
-- Dumping data for table `4yi3uwye_users`
--

INSERT INTO `4yi3uwye_users` (`ID`, `user_login`, `user_pass`, `user_nicename`, `user_email`, `user_url`, `user_registered`, `user_activation_key`, `user_status`, `display_name`) VALUES
(4, 'demo88', '$wp$2y$10$tUXAXmg7IcaD4fe7EHcK1uMK0h04yhoS/uMWR4Vv4/aovoPdHxyhe', 'demo88', 'info@rijksuitgaven.nl', '', '2024-12-04 17:10:13', '', 0, 'Demo Account'),
(21, 'koen@koenverhagen.com', '$P$B9vZp1ED5PnY4omTg1SJmUTSxeMfRY.', 'koenkoenverhagen-com', 'koen@koenverhagen.com', '', '2024-12-13 14:45:36', '1734101137:$P$BoiUt9afHQ3n5jY0dGxjZzbIbCa4w30', 0, 'Koen Verhagen'),
(25, 'leon@kuunders.com', '$wp$2y$10$SQmLsS8Jn9G2lcIVEBHsX.bbg5rNPWxrnuXNqJh19qW28LSuAIqZW', 'leonkuunders-com', 'leon@kuunders.com', '', '2024-12-15 09:38:26', '', 0, 'Leon Kuunders');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `4yi3uwye_users`
--
ALTER TABLE `4yi3uwye_users`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `user_login_key` (`user_login`),
  ADD KEY `user_nicename` (`user_nicename`),
  ADD KEY `user_email` (`user_email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `4yi3uwye_users`
--
ALTER TABLE `4yi3uwye_users`
  MODIFY `ID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=99;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
