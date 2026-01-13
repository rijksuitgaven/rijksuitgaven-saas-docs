-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: wpdb-ru
-- Generation Time: Jan 13, 2026 at 10:04 PM
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
-- Table structure for table `4yi3uwye_arm_subscription_plans`
--

CREATE TABLE `4yi3uwye_arm_subscription_plans` (
  `arm_subscription_plan_id` int(11) NOT NULL,
  `arm_subscription_plan_name` varchar(255) NOT NULL,
  `arm_subscription_plan_description` text DEFAULT NULL,
  `arm_subscription_plan_type` varchar(50) NOT NULL,
  `arm_subscription_plan_options` longtext DEFAULT NULL,
  `arm_subscription_plan_amount` double NOT NULL DEFAULT 0,
  `arm_subscription_plan_status` int(1) NOT NULL DEFAULT 1,
  `arm_subscription_plan_role` varchar(100) DEFAULT NULL,
  `arm_subscription_plan_post_id` bigint(20) NOT NULL DEFAULT 0,
  `arm_subscription_plan_gift_status` int(1) NOT NULL DEFAULT 0,
  `arm_subscription_plan_is_delete` int(1) NOT NULL DEFAULT 0,
  `arm_subscription_plan_created_date` datetime NOT NULL DEFAULT '1970-01-01 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

--
-- Dumping data for table `4yi3uwye_arm_subscription_plans`
--

INSERT INTO `4yi3uwye_arm_subscription_plans` (`arm_subscription_plan_id`, `arm_subscription_plan_name`, `arm_subscription_plan_description`, `arm_subscription_plan_type`, `arm_subscription_plan_options`, `arm_subscription_plan_amount`, `arm_subscription_plan_status`, `arm_subscription_plan_role`, `arm_subscription_plan_post_id`, `arm_subscription_plan_gift_status`, `arm_subscription_plan_is_delete`, `arm_subscription_plan_created_date`) VALUES
(1, 'Nieuwsbrief', 'Pre-launch aanmeldingen', 'free', 'a:7:{s:9:\"pricetext\";s:19:\"Gratis Lidmaatschap\";s:5:\"limit\";i:0;s:22:\"arm_gm_enable_referral\";i:0;s:40:\"arm_gm_group_membership_disable_referral\";i:0;s:18:\"arm_gm_max_members\";s:1:\"1\";s:18:\"arm_gm_min_members\";s:1:\"1\";s:25:\"arm_gm_sub_user_seat_slot\";s:1:\"1\";}', 0, 1, 'armember', 0, 0, 0, '2024-12-04 16:35:46'),
(2, 'Expertgroep', '', 'paid_finite', 'a:15:{s:11:\"access_type\";s:6:\"finite\";s:12:\"payment_type\";s:8:\"one_time\";s:11:\"expiry_type\";s:18:\"joined_date_expiry\";s:4:\"eopa\";a:5:{s:4:\"days\";s:1:\"1\";s:5:\"weeks\";s:1:\"1\";s:6:\"months\";s:1:\"1\";s:5:\"years\";s:1:\"1\";s:4:\"type\";s:1:\"M\";}s:11:\"expiry_date\";s:19:\"2024-12-13 23:59:59\";s:3:\"eot\";s:1:\"7\";s:12:\"grace_period\";a:2:{s:11:\"end_of_term\";s:1:\"0\";s:14:\"failed_payment\";s:1:\"2\";}s:14:\"upgrade_action\";s:9:\"immediate\";s:16:\"downgrade_action\";s:9:\"immediate\";s:9:\"pricetext\";s:15:\"Free Membership\";s:5:\"limit\";i:0;s:22:\"arm_gm_enable_referral\";i:0;s:18:\"arm_gm_max_members\";s:1:\"1\";s:18:\"arm_gm_min_members\";s:1:\"1\";s:25:\"arm_gm_sub_user_seat_slot\";s:1:\"1\";}', 124.95, 1, 'subscriber', 0, 0, 0, '2024-12-04 16:37:20'),
(3, 'Per jaar', 'Ons populairste lidmaatschap. ', 'recurring', 'a:18:{s:11:\"access_type\";s:6:\"finite\";s:12:\"payment_type\";s:12:\"subscription\";s:14:\"payment_cycles\";a:1:{i:0;a:7:{s:9:\"cycle_key\";s:4:\"arm0\";s:11:\"cycle_label\";s:17:\"1250 EUR per jaar\";s:12:\"cycle_amount\";s:4:\"1250\";s:13:\"billing_cycle\";s:1:\"1\";s:12:\"billing_type\";s:1:\"Y\";s:14:\"recurring_time\";s:8:\"infinite\";s:19:\"payment_cycle_order\";s:1:\"1\";}}s:5:\"trial\";a:5:{s:6:\"amount\";s:1:\"0\";s:4:\"days\";s:1:\"7\";s:6:\"months\";s:1:\"1\";s:5:\"years\";s:1:\"1\";s:4:\"type\";s:1:\"D\";}s:9:\"recurring\";a:6:{s:4:\"days\";i:1;s:6:\"months\";i:1;s:5:\"years\";s:1:\"1\";s:4:\"type\";s:1:\"Y\";s:4:\"time\";s:8:\"infinite\";s:20:\"manual_billing_start\";s:15:\"transaction_day\";}s:13:\"cancel_action\";s:5:\"block\";s:18:\"cancel_plan_action\";s:9:\"on_expire\";s:3:\"eot\";s:1:\"7\";s:12:\"grace_period\";a:2:{s:11:\"end_of_term\";s:1:\"0\";s:14:\"failed_payment\";s:1:\"2\";}s:21:\"payment_failed_action\";s:5:\"block\";s:14:\"upgrade_action\";s:9:\"immediate\";s:16:\"downgrade_action\";s:9:\"immediate\";s:9:\"pricetext\";s:15:\"Free Membership\";s:5:\"limit\";i:0;s:22:\"arm_gm_enable_referral\";i:0;s:18:\"arm_gm_max_members\";s:1:\"1\";s:18:\"arm_gm_min_members\";s:1:\"1\";s:25:\"arm_gm_sub_user_seat_slot\";s:1:\"1\";}', 1250, 1, 'armember', 0, 0, 0, '2024-12-04 18:13:51'),
(4, '48uurs pas', '', 'paid_finite', 'a:15:{s:11:\"access_type\";s:6:\"finite\";s:12:\"payment_type\";s:8:\"one_time\";s:11:\"expiry_type\";s:18:\"joined_date_expiry\";s:4:\"eopa\";a:5:{s:4:\"days\";s:1:\"2\";s:5:\"weeks\";s:1:\"1\";s:6:\"months\";s:1:\"1\";s:5:\"years\";s:1:\"1\";s:4:\"type\";s:1:\"D\";}s:11:\"expiry_date\";s:19:\"2024-12-10 23:59:59\";s:3:\"eot\";s:5:\"block\";s:12:\"grace_period\";a:2:{s:11:\"end_of_term\";s:1:\"0\";s:14:\"failed_payment\";s:1:\"2\";}s:14:\"upgrade_action\";s:9:\"immediate\";s:16:\"downgrade_action\";s:9:\"on_expire\";s:9:\"pricetext\";s:15:\"Free Membership\";s:5:\"limit\";i:0;s:22:\"arm_gm_enable_referral\";i:0;s:18:\"arm_gm_max_members\";s:1:\"1\";s:18:\"arm_gm_min_members\";s:1:\"1\";s:25:\"arm_gm_sub_user_seat_slot\";s:1:\"1\";}', 5, 0, 'armember', 0, 0, 1, '2024-12-10 12:24:50'),
(5, 'Per maand', 'Ons flexibele lidmaatschap.', 'paid_finite', 'a:15:{s:11:\"access_type\";s:6:\"finite\";s:12:\"payment_type\";s:8:\"one_time\";s:11:\"expiry_type\";s:18:\"joined_date_expiry\";s:4:\"eopa\";a:5:{s:4:\"days\";s:1:\"1\";s:5:\"weeks\";s:1:\"1\";s:6:\"months\";s:1:\"1\";s:5:\"years\";s:1:\"1\";s:4:\"type\";s:1:\"M\";}s:11:\"expiry_date\";s:19:\"2025-02-25 23:59:59\";s:3:\"eot\";s:1:\"7\";s:12:\"grace_period\";a:2:{s:11:\"end_of_term\";s:1:\"0\";s:14:\"failed_payment\";s:1:\"2\";}s:14:\"upgrade_action\";s:9:\"immediate\";s:16:\"downgrade_action\";s:9:\"on_expire\";s:9:\"pricetext\";s:15:\"Free Membership\";s:5:\"limit\";i:0;s:22:\"arm_gm_enable_referral\";i:0;s:18:\"arm_gm_max_members\";s:1:\"1\";s:18:\"arm_gm_min_members\";s:1:\"1\";s:25:\"arm_gm_sub_user_seat_slot\";s:1:\"1\";}', 125, 1, 'armember', 0, 0, 0, '2025-02-04 10:38:39'),
(6, '24 maanden', 'Ons favoriete lidmaatschap. Hoe langer uw commitment hoe sneller wij kunnen werken. ', 'recurring', 'a:18:{s:11:\"access_type\";s:6:\"finite\";s:12:\"payment_type\";s:12:\"subscription\";s:14:\"payment_cycles\";a:1:{i:0;a:7:{s:9:\"cycle_key\";s:4:\"arm0\";s:11:\"cycle_label\";s:4:\"Twee\";s:12:\"cycle_amount\";s:3:\"600\";s:13:\"billing_cycle\";s:1:\"2\";s:12:\"billing_type\";s:1:\"Y\";s:14:\"recurring_time\";s:8:\"infinite\";s:19:\"payment_cycle_order\";s:1:\"1\";}}s:5:\"trial\";a:5:{s:6:\"amount\";s:1:\"0\";s:4:\"days\";s:1:\"7\";s:6:\"months\";s:1:\"1\";s:5:\"years\";s:1:\"1\";s:4:\"type\";s:1:\"D\";}s:9:\"recurring\";a:6:{s:4:\"days\";i:1;s:6:\"months\";i:1;s:5:\"years\";s:1:\"2\";s:4:\"type\";s:1:\"Y\";s:4:\"time\";s:8:\"infinite\";s:20:\"manual_billing_start\";s:15:\"transaction_day\";}s:13:\"cancel_action\";s:5:\"block\";s:18:\"cancel_plan_action\";s:9:\"on_expire\";s:3:\"eot\";s:5:\"block\";s:12:\"grace_period\";a:2:{s:11:\"end_of_term\";s:1:\"0\";s:14:\"failed_payment\";s:1:\"2\";}s:21:\"payment_failed_action\";s:5:\"block\";s:14:\"upgrade_action\";s:9:\"immediate\";s:16:\"downgrade_action\";s:9:\"on_expire\";s:9:\"pricetext\";s:15:\"Free Membership\";s:5:\"limit\";i:0;s:22:\"arm_gm_enable_referral\";i:0;s:18:\"arm_gm_max_members\";s:1:\"1\";s:18:\"arm_gm_min_members\";s:1:\"1\";s:25:\"arm_gm_sub_user_seat_slot\";s:1:\"1\";}', 600, 0, 'armember', 0, 0, 1, '2025-02-04 19:15:15'),
(7, 'Geen abonnement', '', 'free', 'a:7:{s:9:\"pricetext\";s:15:\"Free Membership\";s:5:\"limit\";i:0;s:22:\"arm_gm_enable_referral\";i:0;s:40:\"arm_gm_group_membership_disable_referral\";i:0;s:18:\"arm_gm_max_members\";s:1:\"1\";s:18:\"arm_gm_min_members\";s:1:\"1\";s:25:\"arm_gm_sub_user_seat_slot\";s:1:\"1\";}', 0, 1, 'armember', 0, 0, 0, '2025-02-21 09:42:06'),
(8, 'Kwartaal', '', 'paid_finite', 'a:11:{s:11:\"access_type\";s:6:\"finite\";s:12:\"payment_type\";s:8:\"one_time\";s:11:\"expiry_type\";s:18:\"joined_date_expiry\";s:4:\"eopa\";a:5:{s:4:\"days\";s:1:\"1\";s:5:\"weeks\";s:1:\"1\";s:6:\"months\";s:1:\"3\";s:5:\"years\";s:1:\"1\";s:4:\"type\";s:1:\"M\";}s:11:\"expiry_date\";s:19:\"2025-04-15 23:59:59\";s:3:\"eot\";s:5:\"block\";s:12:\"grace_period\";a:2:{s:11:\"end_of_term\";s:1:\"0\";s:14:\"failed_payment\";s:1:\"2\";}s:14:\"upgrade_action\";s:9:\"immediate\";s:16:\"downgrade_action\";s:9:\"on_expire\";s:9:\"pricetext\";s:15:\"Free Membership\";s:5:\"limit\";i:0;}', 375, 1, 'armember', 0, 0, 0, '2025-04-15 08:49:53');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `4yi3uwye_arm_subscription_plans`
--
ALTER TABLE `4yi3uwye_arm_subscription_plans`
  ADD PRIMARY KEY (`arm_subscription_plan_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `4yi3uwye_arm_subscription_plans`
--
ALTER TABLE `4yi3uwye_arm_subscription_plans`
  MODIFY `arm_subscription_plan_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
