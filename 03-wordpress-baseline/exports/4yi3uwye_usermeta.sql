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
-- Table structure for table `4yi3uwye_usermeta`
--

CREATE TABLE `4yi3uwye_usermeta` (
  `umeta_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

--
-- Dumping data for table `4yi3uwye_usermeta`
--

INSERT INTO `4yi3uwye_usermeta` (`umeta_id`, `user_id`, `meta_key`, `meta_value`) VALUES
(87, 4, 'nickname', 'demo88'),
(88, 4, 'first_name', 'Demo'),
(89, 4, 'last_name', 'Account'),
(90, 4, 'description', ''),
(91, 4, 'rich_editing', 'true'),
(92, 4, 'syntax_highlighting', 'true'),
(93, 4, 'comment_shortcuts', 'false'),
(94, 4, 'admin_color', 'fresh'),
(95, 4, 'use_ssl', '0'),
(96, 4, 'show_admin_bar_front', 'true'),
(97, 4, 'locale', ''),
(98, 4, '4yi3uwye_capabilities', 'a:3:{s:10:\"subscriber\";b:1;s:22:\"armember_access_plan_3\";b:1;s:8:\"armember\";b:1;}'),
(99, 4, '4yi3uwye_user_level', '0'),
(100, 4, 'dismissed_wp_pointers', ''),
(101, 4, 'arm_form_id', '101'),
(102, 4, 'arm_user_suspended_plan_ids', 'a:1:{i:0;s:1:\"3\";}'),
(103, 4, 'arm_member_form_has_url', 'https://rijksuitgaven.nl/wp-admin/admin.php?page=arm_manage_members&action=new'),
(104, 4, 'gender', 'Male'),
(105, 4, 'country', ''),
(106, 4, 'arm_wp_nonce', 'd2bf449e7d');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `4yi3uwye_usermeta`
--
ALTER TABLE `4yi3uwye_usermeta`
  ADD PRIMARY KEY (`umeta_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `meta_key` (`meta_key`(191));

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `4yi3uwye_usermeta`
--
ALTER TABLE `4yi3uwye_usermeta`
  MODIFY `umeta_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3934;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
