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
-- Table structure for table `4yi3uwye_arm_membership_setup`
--

CREATE TABLE `4yi3uwye_arm_membership_setup` (
  `arm_setup_id` int(11) NOT NULL,
  `arm_setup_name` varchar(255) NOT NULL,
  `arm_setup_type` tinyint(1) NOT NULL DEFAULT 0,
  `arm_setup_modules` longtext DEFAULT NULL,
  `arm_setup_labels` longtext DEFAULT NULL,
  `arm_status` int(1) NOT NULL DEFAULT 1,
  `arm_created_date` datetime NOT NULL DEFAULT '1970-01-01 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

--
-- Dumping data for table `4yi3uwye_arm_membership_setup`
--

INSERT INTO `4yi3uwye_arm_membership_setup` (`arm_setup_id`, `arm_setup_name`, `arm_setup_type`, `arm_setup_modules`, `arm_setup_labels`, `arm_status`, `arm_created_date`) VALUES
(1, 'Expertgroep', 0, 'a:7:{s:7:\"modules\";a:8:{s:5:\"plans\";a:1:{i:0;s:1:\"2\";}s:5:\"forms\";s:3:\"101\";s:8:\"gateways\";a:1:{i:0;s:13:\"bank_transfer\";}s:12:\"payment_mode\";a:2:{s:13:\"bank_transfer\";s:19:\"manual_subscription\";s:6:\"mollie\";s:4:\"both\";}s:7:\"coupons\";s:1:\"1\";s:20:\"coupon_as_invitation\";s:1:\"1\";s:11:\"plans_order\";a:4:{i:2;s:1:\"1\";i:1;s:1:\"2\";i:3;s:1:\"3\";i:4;s:1:\"4\";}s:14:\"gateways_order\";a:6:{s:6:\"paypal\";s:1:\"1\";s:6:\"stripe\";s:1:\"2\";s:13:\"authorize_net\";s:1:\"3\";s:9:\"2checkout\";s:1:\"4\";s:13:\"bank_transfer\";s:1:\"5\";s:6:\"mollie\";s:1:\"6\";}}s:5:\"style\";a:32:{s:9:\"plan_skin\";s:5:\"skin1\";s:18:\"hide_current_plans\";s:1:\"1\";s:10:\"hide_plans\";s:1:\"1\";s:18:\"plan_area_position\";s:6:\"before\";s:12:\"gateway_skin\";s:5:\"radio\";s:13:\"content_width\";s:3:\"800\";s:13:\"form_position\";s:6:\"center\";s:11:\"font_family\";s:13:\"IBM Plex Sans\";s:15:\"title_font_size\";s:2:\"20\";s:15:\"title_font_bold\";s:1:\"1\";s:17:\"title_font_italic\";s:0:\"\";s:21:\"title_font_decoration\";s:0:\"\";s:21:\"description_font_size\";s:2:\"15\";s:21:\"description_font_bold\";s:1:\"0\";s:23:\"description_font_italic\";s:0:\"\";s:27:\"description_font_decoration\";s:0:\"\";s:15:\"price_font_size\";s:2:\"28\";s:15:\"price_font_bold\";s:1:\"0\";s:17:\"price_font_italic\";s:0:\"\";s:21:\"price_font_decoration\";s:0:\"\";s:17:\"summary_font_size\";s:2:\"16\";s:17:\"summary_font_bold\";s:1:\"0\";s:19:\"summary_font_italic\";s:0:\"\";s:23:\"summary_font_decoration\";s:0:\"\";s:21:\"plan_title_font_color\";s:7:\"#2C2D42\";s:20:\"plan_desc_font_color\";s:7:\"#555F70\";s:16:\"price_font_color\";s:7:\"#2C2D42\";s:18:\"summary_font_color\";s:7:\"#555F70\";s:30:\"selected_plan_title_font_color\";s:7:\"#005AEE\";s:29:\"selected_plan_desc_font_color\";s:7:\"#2C2D42\";s:25:\"selected_price_font_color\";s:7:\"#FFFFFF\";s:15:\"bg_active_color\";s:7:\"#005AEE\";}s:13:\"plans_columns\";s:1:\"3\";s:13:\"selected_plan\";s:1:\"2\";s:13:\"cycle_columns\";s:1:\"1\";s:16:\"gateways_columns\";s:1:\"1\";s:10:\"custom_css\";s:155:\".arm_membership_setup_form .arm_setup_gatewaybox_wrapper, .arm_membership_setup_form .arm_setup_paymentcyclebox_wrapper {\r\n    display: none !important;\r\n}\";}', 'a:12:{s:13:\"button_labels\";a:6:{s:6:\"submit\";s:21:\"Activeer mijn account\";s:12:\"coupon_title\";s:43:\"Gebruik de code die u van ons hebt gekregen\";s:13:\"coupon_button\";s:9:\"Toepassen\";s:24:\"sub_user_selection_label\";s:17:\"Select Child User\";s:4:\"next\";s:4:\"Next\";s:8:\"previous\";s:8:\"Previous\";}s:23:\"member_plan_field_title\";s:18:\"Selecteer een plan\";s:27:\"payment_cycle_section_title\";s:25:\"Select Your Payment Cycle\";s:25:\"payment_cycle_field_title\";s:25:\"Select Your Payment Cycle\";s:21:\"payment_section_title\";s:27:\"Select Your Payment Gateway\";s:27:\"payment_gateway_field_title\";s:18:\"Manier van betalen\";s:22:\"payment_gateway_labels\";a:6:{s:6:\"paypal\";s:6:\"Paypal\";s:6:\"stripe\";s:6:\"Stripe\";s:13:\"authorize_net\";s:13:\"Authorize.net\";s:9:\"2checkout\";s:9:\"2Checkout\";s:13:\"bank_transfer\";s:13:\"Bank Transfer\";s:6:\"mollie\";s:6:\"Mollie\";}s:22:\"payment_mode_selection\";s:18:\"Hoe wilt u betalen\";s:22:\"automatic_subscription\";s:18:\"Auto Debit Payment\";s:27:\"semi_automatic_subscription\";s:14:\"Manual Payment\";s:17:\"credit_card_logos\";s:90:\"https://rijksuitgaven.nl/wp-content/plugins/armember/images/arm_default_card_image_url.png\";s:12:\"summary_text\";s:0:\"\";}', 1, '2024-12-04 16:37:20'),
(2, 'Pro', 0, 'a:7:{s:7:\"modules\";a:9:{s:5:\"plans\";a:2:{i:0;s:1:\"5\";i:1;s:1:\"3\";}s:5:\"forms\";s:3:\"101\";s:8:\"gateways\";a:1:{i:0;s:13:\"bank_transfer\";}s:12:\"payment_mode\";a:2:{s:13:\"bank_transfer\";s:19:\"manual_subscription\";s:6:\"mollie\";s:23:\"auto_debit_subscription\";}s:12:\"stripe_plans\";a:2:{i:6;a:1:{s:4:\"arm0\";s:0:\"\";}i:3;a:1:{s:4:\"arm0\";s:0:\"\";}}s:7:\"coupons\";s:1:\"1\";s:20:\"coupon_as_invitation\";s:1:\"1\";s:11:\"plans_order\";a:7:{i:5;s:1:\"1\";i:3;s:1:\"2\";i:2;s:1:\"3\";i:1;s:1:\"4\";i:4;s:1:\"5\";i:6;s:1:\"6\";i:7;s:1:\"7\";}s:14:\"gateways_order\";a:6:{s:6:\"paypal\";s:1:\"1\";s:6:\"stripe\";s:1:\"2\";s:13:\"authorize_net\";s:1:\"3\";s:9:\"2checkout\";s:1:\"4\";s:13:\"bank_transfer\";s:1:\"5\";s:6:\"mollie\";s:1:\"6\";}}s:5:\"style\";a:31:{s:9:\"plan_skin\";s:5:\"skin1\";s:18:\"hide_current_plans\";s:1:\"1\";s:18:\"plan_area_position\";s:6:\"before\";s:12:\"gateway_skin\";s:8:\"dropdown\";s:13:\"content_width\";s:3:\"800\";s:13:\"form_position\";s:4:\"left\";s:11:\"font_family\";s:14:\"Libre Franklin\";s:15:\"title_font_size\";s:2:\"20\";s:15:\"title_font_bold\";s:1:\"1\";s:17:\"title_font_italic\";s:0:\"\";s:21:\"title_font_decoration\";s:0:\"\";s:21:\"description_font_size\";s:2:\"15\";s:21:\"description_font_bold\";s:1:\"0\";s:23:\"description_font_italic\";s:0:\"\";s:27:\"description_font_decoration\";s:0:\"\";s:15:\"price_font_size\";s:2:\"28\";s:15:\"price_font_bold\";s:1:\"0\";s:17:\"price_font_italic\";s:0:\"\";s:21:\"price_font_decoration\";s:0:\"\";s:17:\"summary_font_size\";s:2:\"16\";s:17:\"summary_font_bold\";s:1:\"0\";s:19:\"summary_font_italic\";s:0:\"\";s:23:\"summary_font_decoration\";s:0:\"\";s:21:\"plan_title_font_color\";s:7:\"#0e3261\";s:20:\"plan_desc_font_color\";s:7:\"#0e3261\";s:16:\"price_font_color\";s:7:\"#0e3261\";s:18:\"summary_font_color\";s:7:\"#0e3261\";s:30:\"selected_plan_title_font_color\";s:7:\"#e62d75\";s:29:\"selected_plan_desc_font_color\";s:7:\"#0e3261\";s:25:\"selected_price_font_color\";s:7:\"#FFFFFF\";s:15:\"bg_active_color\";s:7:\"#e62d75\";}s:13:\"plans_columns\";s:1:\"3\";s:13:\"selected_plan\";s:1:\"5\";s:13:\"cycle_columns\";s:1:\"1\";s:16:\"gateways_columns\";s:1:\"1\";s:10:\"custom_css\";s:342:\".arm_membership_setup_form .arm_setup_gatewaybox_wrapper, .arm_membership_setup_form .arm_setup_paymentcyclebox_wrapper {\r\n    display: none !important;\r\n}\r\n\r\n.arm_setup_gatewaybox_wrapper {\r\n    display: none !important;\r\n}\r\n\r\n.arm_plan_skin1.arm_setup_column_item .arm_module_plan_option .arm_module_plan_price_type {\r\n    display: none;\r\n}\";}', 'a:12:{s:13:\"button_labels\";a:6:{s:6:\"submit\";s:21:\"Activeer mijn account\";s:12:\"coupon_title\";s:68:\"Gebruik de activatiecode uit uw factuur om het abonnement te starten\";s:13:\"coupon_button\";s:9:\"Toepassen\";s:24:\"sub_user_selection_label\";s:17:\"Select Child User\";s:4:\"next\";s:8:\"Volgende\";s:8:\"previous\";s:6:\"Vorige\";}s:23:\"member_plan_field_title\";s:18:\"Selecteer een plan\";s:27:\"payment_cycle_section_title\";s:25:\"Selecteer betalingscyclus\";s:25:\"payment_cycle_field_title\";s:28:\"Selecteer Uw Betaling Cyclus\";s:21:\"payment_section_title\";s:16:\"Uw betaalmethode\";s:27:\"payment_gateway_field_title\";s:16:\"Uw betaalmethode\";s:22:\"payment_gateway_labels\";a:6:{s:6:\"paypal\";s:6:\"Paypal\";s:6:\"stripe\";s:6:\"Stripe\";s:13:\"authorize_net\";s:13:\"Authorize.net\";s:9:\"2checkout\";s:9:\"2Checkout\";s:13:\"bank_transfer\";s:11:\"Per factuur\";s:6:\"mollie\";s:6:\"Mollie\";}s:22:\"payment_mode_selection\";s:16:\"Uw betaalmethode\";s:22:\"automatic_subscription\";s:19:\"Automatisch incasso\";s:27:\"semi_automatic_subscription\";s:29:\"Handmatige bankoverschrijving\";s:17:\"credit_card_logos\";s:90:\"https://rijksuitgaven.nl/wp-content/plugins/armember/images/arm_default_card_image_url.png\";s:12:\"summary_text\";s:0:\"\";}', 1, '2024-12-04 20:06:40');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `4yi3uwye_arm_membership_setup`
--
ALTER TABLE `4yi3uwye_arm_membership_setup`
  ADD PRIMARY KEY (`arm_setup_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `4yi3uwye_arm_membership_setup`
--
ALTER TABLE `4yi3uwye_arm_membership_setup`
  MODIFY `arm_setup_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
