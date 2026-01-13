-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: wpdb-rult
-- Generation Time: Jan 13, 2026 at 09:46 PM
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
-- Database: `instrumenten`
--

-- --------------------------------------------------------

--
-- Table structure for table `apparaat`
--

DROP TABLE IF EXISTS `apparaat`;
CREATE TABLE `apparaat` (
  `Begrotingsjaar` int(11) DEFAULT NULL,
  `Begrotingshoofdstuk` varchar(255) DEFAULT NULL,
  `Begrotingsnaam` varchar(255) DEFAULT NULL,
  `RIS_IBOS_nummer` varchar(255) DEFAULT NULL,
  `Artikel` varchar(255) DEFAULT NULL,
  `Artikelonderdeel` varchar(255) DEFAULT NULL,
  `Instrument` varchar(255) DEFAULT NULL,
  `Detail` varchar(255) DEFAULT NULL,
  `Kostensoort` varchar(255) DEFAULT NULL,
  `Bedrag` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL,
  `Bedrag_normalized` bigint(20) DEFAULT NULL,
  `Source` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `apparaat_id`
--

DROP TABLE IF EXISTS `apparaat_id`;
CREATE TABLE `apparaat_id` (
  `id` int(11) NOT NULL,
  `rand_key` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `apparaat_pivot`
--

DROP TABLE IF EXISTS `apparaat_pivot`;
CREATE TABLE `apparaat_pivot` (
  `id` int(11) NOT NULL DEFAULT 0,
  `Begrotingshoofdstuk` varchar(255) DEFAULT NULL,
  `Begrotingsnaam` varchar(255) DEFAULT NULL,
  `RIS_IBOS_nummer` varchar(255) DEFAULT NULL,
  `Artikel` varchar(255) DEFAULT NULL,
  `Artikelonderdeel` varchar(255) DEFAULT NULL,
  `Instrument` varchar(255) DEFAULT NULL,
  `Detail` varchar(255) DEFAULT NULL,
  `Kostensoort` varchar(255) DEFAULT NULL,
  `Jaar` int(11) DEFAULT NULL,
  `2016` int(18) DEFAULT NULL,
  `2017` int(18) DEFAULT NULL,
  `2018` int(18) DEFAULT NULL,
  `2019` int(18) DEFAULT NULL,
  `2020` int(18) DEFAULT NULL,
  `2021` int(18) DEFAULT NULL,
  `2022` int(18) DEFAULT NULL,
  `2023` int(18) DEFAULT NULL,
  `2024` int(18) DEFAULT NULL,
  `Totaal` int(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `apparaat_pivot_geconsolideerd`
--

DROP TABLE IF EXISTS `apparaat_pivot_geconsolideerd`;
CREATE TABLE `apparaat_pivot_geconsolideerd` (
  `Kostensoort` varchar(255) DEFAULT NULL,
  `Begrotingshoofdstuk` longtext DEFAULT NULL,
  `Begrotingsnaam` longtext DEFAULT NULL,
  `RIS_IBOS_nummer` longtext DEFAULT NULL,
  `Artikel` longtext DEFAULT NULL,
  `Artikelonderdeel` longtext DEFAULT NULL,
  `Instrument` longtext DEFAULT NULL,
  `Detail` longtext DEFAULT NULL,
  `2016` int(18) DEFAULT NULL,
  `2017` int(18) DEFAULT NULL,
  `2018` int(18) DEFAULT NULL,
  `2019` int(18) DEFAULT NULL,
  `2020` int(18) DEFAULT NULL,
  `2021` int(18) DEFAULT NULL,
  `2022` int(18) DEFAULT NULL,
  `2023` int(18) DEFAULT NULL,
  `2024` int(18) DEFAULT NULL,
  `Totaal` int(32) DEFAULT NULL,
  `id` int(11) NOT NULL,
  `row_count` int(11) DEFAULT NULL,
  `year_count` tinyint(3) UNSIGNED GENERATED ALWAYS AS (case when `2016` is not null and `2016` <> 0 then 1 else 0 end + case when `2017` is not null and `2017` <> 0 then 1 else 0 end + case when `2018` is not null and `2018` <> 0 then 1 else 0 end + case when `2019` is not null and `2019` <> 0 then 1 else 0 end + case when `2020` is not null and `2020` <> 0 then 1 else 0 end + case when `2021` is not null and `2021` <> 0 then 1 else 0 end + case when `2022` is not null and `2022` <> 0 then 1 else 0 end + case when `2023` is not null and `2023` <> 0 then 1 else 0 end + case when `2024` is not null and `2024` <> 0 then 1 else 0 end) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inkoop`
--

DROP TABLE IF EXISTS `inkoop`;
CREATE TABLE `inkoop` (
  `Jaar` int(11) DEFAULT NULL,
  `Ministerie` varchar(255) DEFAULT NULL,
  `Leverancier` varchar(255) DEFAULT NULL,
  `Categorie` longtext DEFAULT NULL,
  `Staffel` int(11) DEFAULT NULL,
  `Totaal_Avg` double DEFAULT 0,
  `id` int(11) NOT NULL,
  `Source` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inkoop_pivot`
--

DROP TABLE IF EXISTS `inkoop_pivot`;
CREATE TABLE `inkoop_pivot` (
  `Jaar` int(11) DEFAULT NULL,
  `Leverancier` varchar(255) DEFAULT NULL,
  `Ministerie` varchar(255) DEFAULT NULL,
  `Categorie` varchar(255) DEFAULT NULL,
  `Staffel` int(11) DEFAULT NULL,
  `2017` int(11) DEFAULT NULL,
  `2018` int(11) DEFAULT NULL,
  `2019` int(11) DEFAULT NULL,
  `2020` int(11) DEFAULT NULL,
  `2021` int(11) DEFAULT NULL,
  `2022` int(11) DEFAULT NULL,
  `2023` int(11) DEFAULT NULL,
  `2024` int(11) DEFAULT NULL,
  `Totaal_Avg` int(11) DEFAULT 0,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inkoop_pivot_geconsolideerd`
--

DROP TABLE IF EXISTS `inkoop_pivot_geconsolideerd`;
CREATE TABLE `inkoop_pivot_geconsolideerd` (
  `id` int(11) NOT NULL,
  `Ministerie` longtext DEFAULT NULL,
  `Leverancier` varchar(255) DEFAULT NULL,
  `Categorie` longtext DEFAULT NULL,
  `Staffel` mediumtext DEFAULT NULL,
  `2017` int(11) DEFAULT NULL,
  `2018` int(11) DEFAULT NULL,
  `2019` int(11) DEFAULT NULL,
  `2020` int(11) DEFAULT NULL,
  `2021` int(11) DEFAULT NULL,
  `2022` int(11) DEFAULT NULL,
  `2023` int(11) DEFAULT NULL,
  `2024` int(11) DEFAULT NULL,
  `Totaal_Avg` int(11) DEFAULT NULL,
  `row_count` int(11) DEFAULT NULL,
  `year_count` tinyint(3) UNSIGNED GENERATED ALWAYS AS (case when `2017` is not null and `2017` <> 0 then 1 else 0 end + case when `2018` is not null and `2018` <> 0 then 1 else 0 end + case when `2019` is not null and `2019` <> 0 then 1 else 0 end + case when `2020` is not null and `2020` <> 0 then 1 else 0 end + case when `2021` is not null and `2021` <> 0 then 1 else 0 end + case when `2022` is not null and `2022` <> 0 then 1 else 0 end + case when `2023` is not null and `2023` <> 0 then 1 else 0 end + case when `2024` is not null and `2024` <> 0 then 1 else 0 end) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inkoop_source_pivot`
--

DROP TABLE IF EXISTS `inkoop_source_pivot`;
CREATE TABLE `inkoop_source_pivot` (
  `Jaar` int(11) DEFAULT NULL,
  `Ministerie` varchar(255) DEFAULT NULL,
  `Leverancier` varchar(255) DEFAULT NULL,
  `1000` int(11) DEFAULT NULL,
  `1110` int(11) DEFAULT NULL,
  `1120` int(11) DEFAULT NULL,
  `1130` int(11) DEFAULT NULL,
  `1140` int(11) DEFAULT NULL,
  `1150` int(11) DEFAULT NULL,
  `1160` int(11) DEFAULT NULL,
  `1170` int(11) DEFAULT NULL,
  `1180` int(11) DEFAULT NULL,
  `3000` int(11) DEFAULT NULL,
  `3110` int(11) DEFAULT NULL,
  `3120` int(11) DEFAULT NULL,
  `3130` int(11) DEFAULT NULL,
  `3140` int(11) DEFAULT NULL,
  `3150` int(11) DEFAULT NULL,
  `3160` int(11) DEFAULT NULL,
  `4000` int(11) DEFAULT NULL,
  `4110` int(11) DEFAULT NULL,
  `4120` int(11) DEFAULT NULL,
  `4130` int(11) DEFAULT NULL,
  `4210` int(11) DEFAULT NULL,
  `4310` int(11) DEFAULT NULL,
  `4410` int(11) DEFAULT NULL,
  `4510` int(11) DEFAULT NULL,
  `4610` int(11) DEFAULT NULL,
  `4710` int(11) DEFAULT NULL,
  `5000` int(11) DEFAULT NULL,
  `5110` int(11) DEFAULT NULL,
  `5210` int(11) DEFAULT NULL,
  `6000` int(11) DEFAULT NULL,
  `6110` int(11) DEFAULT NULL,
  `6120` int(11) DEFAULT NULL,
  `6210` int(11) DEFAULT NULL,
  `6220` int(11) DEFAULT NULL,
  `6310` int(11) DEFAULT NULL,
  `6410` int(11) DEFAULT NULL,
  `6510` int(11) DEFAULT NULL,
  `7000` int(11) DEFAULT NULL,
  `7110` int(11) DEFAULT NULL,
  `7210` int(11) DEFAULT NULL,
  `7310` int(11) DEFAULT NULL,
  `7410` int(11) DEFAULT NULL,
  `8000` int(11) DEFAULT NULL,
  `8110` int(11) DEFAULT NULL,
  `8210` int(11) DEFAULT NULL,
  `8310` int(11) DEFAULT NULL,
  `8410` int(11) DEFAULT NULL,
  `8510` int(11) DEFAULT NULL,
  `9000` int(11) DEFAULT NULL,
  `9100` int(11) DEFAULT NULL,
  `9301` int(11) DEFAULT NULL,
  `9302` int(11) DEFAULT NULL,
  `9303` int(11) DEFAULT NULL,
  `9304` int(11) DEFAULT NULL,
  `9305` int(11) DEFAULT NULL,
  `9410` int(11) DEFAULT NULL,
  `9500` int(11) DEFAULT NULL,
  `9510` int(11) DEFAULT NULL,
  `9520` int(11) DEFAULT NULL,
  `9530` int(11) DEFAULT NULL,
  `9540` int(11) DEFAULT NULL,
  `9550` int(11) DEFAULT NULL,
  `9560` int(11) DEFAULT NULL,
  `9570` int(11) DEFAULT NULL,
  `9580` int(11) DEFAULT NULL,
  `9590` int(11) DEFAULT NULL,
  `9600` int(11) DEFAULT NULL,
  `Staffel0` int(11) DEFAULT 0,
  `Staffel1` int(11) DEFAULT 0,
  `Staffel2` int(11) DEFAULT 0,
  `Staffel3` int(11) DEFAULT 0,
  `Staffel4` int(11) DEFAULT 0,
  `Staffel5` int(11) DEFAULT 0,
  `Staffel6` int(11) DEFAULT 0,
  `Staffel7` int(11) DEFAULT 0,
  `Staffel8` int(11) DEFAULT 0,
  `Staffel9` int(11) DEFAULT 0,
  `Staffel10` int(11) DEFAULT 0,
  `Staffel11` int(11) DEFAULT 0,
  `Staffel12` int(11) DEFAULT 0,
  `Staffel13` int(11) DEFAULT 0,
  `Totaal_Min` double DEFAULT 0,
  `Totaal_Avg` double DEFAULT 0,
  `Totaal_Max` double DEFAULT 0,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `instrumenten`
--

DROP TABLE IF EXISTS `instrumenten`;
CREATE TABLE `instrumenten` (
  `id` int(11) NOT NULL,
  `Begrotingsjaar` int(11) DEFAULT NULL,
  `Begrotingshoofdstuk` varchar(255) DEFAULT NULL,
  `Begrotingsnaam` varchar(255) DEFAULT NULL,
  `RIS_IBOS_nummer` varchar(255) DEFAULT NULL,
  `Artikel` varchar(255) DEFAULT NULL,
  `Artikelonderdeel` varchar(255) DEFAULT NULL,
  `Instrument` varchar(255) DEFAULT NULL,
  `Detail` varchar(255) DEFAULT NULL,
  `Regeling` varchar(255) DEFAULT NULL,
  `Ontvanger` varchar(255) DEFAULT NULL,
  `Bedrag` int(11) DEFAULT NULL,
  `KvK_nummer` int(11) DEFAULT NULL,
  `Rechtsvorm` varchar(255) DEFAULT NULL,
  `ID_nummer` int(11) DEFAULT NULL,
  `Register_ID_nummer` varchar(255) DEFAULT NULL,
  `Plaats` varchar(255) DEFAULT NULL,
  `Bedrag_normalized` bigint(20) DEFAULT NULL,
  `Source` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `instrumenten_inzichten_deviation`
--

DROP TABLE IF EXISTS `instrumenten_inzichten_deviation`;
CREATE TABLE `instrumenten_inzichten_deviation` (
  `id` int(11) DEFAULT NULL,
  `Standardized_Ontvanger` varchar(255) DEFAULT NULL,
  `Begrotingshoofdstuk` longtext DEFAULT NULL,
  `Begrotingsnaam` longtext DEFAULT NULL,
  `RIS_IBOS_nummer` longtext DEFAULT NULL,
  `Artikel` longtext DEFAULT NULL,
  `Artikelonderdeel` longtext DEFAULT NULL,
  `Instrument` longtext DEFAULT NULL,
  `Regeling` longtext DEFAULT NULL,
  `Grand_Total` decimal(61,0) DEFAULT NULL,
  `Average` decimal(61,2) DEFAULT NULL,
  `Deviation_2016` decimal(54,0) DEFAULT NULL,
  `Deviation_2017` decimal(54,0) DEFAULT NULL,
  `Deviation_2018` decimal(54,0) DEFAULT NULL,
  `Deviation_2019` decimal(54,0) DEFAULT NULL,
  `Deviation_2020` decimal(54,0) DEFAULT NULL,
  `Deviation_2021` decimal(54,0) DEFAULT NULL,
  `Deviation_2022` decimal(54,0) DEFAULT NULL,
  `Deviation_2023` decimal(54,0) DEFAULT NULL,
  `Percent_Deviation_2016` decimal(10,2) DEFAULT NULL,
  `Percent_Deviation_2017` decimal(10,2) DEFAULT NULL,
  `Percent_Deviation_2018` decimal(10,2) DEFAULT NULL,
  `Percent_Deviation_2019` decimal(10,2) DEFAULT NULL,
  `Percent_Deviation_2020` decimal(10,2) DEFAULT NULL,
  `Percent_Deviation_2021` decimal(10,2) DEFAULT NULL,
  `Percent_Deviation_2022` decimal(10,2) DEFAULT NULL,
  `Percent_Deviation_2023` decimal(10,2) DEFAULT NULL,
  `Years_Received_Money` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `instrumenten_inzichten_deviation_view`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `instrumenten_inzichten_deviation_view`;
CREATE TABLE `instrumenten_inzichten_deviation_view` (
`Standardized_Ontvanger` varchar(255)
,`Begrotingshoofdstuk` longtext
,`Begrotingsnaam` longtext
,`RIS_IBOS_nummer` longtext
,`Artikel` longtext
,`Artikelonderdeel` longtext
,`Instrument` longtext
,`Regeling` longtext
,`Grand_Total` decimal(61,0)
,`Average` decimal(61,2)
,`Years_Received_Money` int(11)
,`Highest_Deviation` decimal(54,0)
,`Deviation_Percentage` decimal(62,2)
,`Highest_Deviation_Year` varchar(4)
);

-- --------------------------------------------------------

--
-- Table structure for table `instrumenten_nieuwe_instrumenten`
--

DROP TABLE IF EXISTS `instrumenten_nieuwe_instrumenten`;
CREATE TABLE `instrumenten_nieuwe_instrumenten` (
  `Begrotingsjaar` int(11) NOT NULL,
  `Instrument` varchar(255) NOT NULL,
  `instrument_count` int(11) DEFAULT NULL,
  `total_bedrag` int(11) DEFAULT NULL,
  `total_count` int(11) DEFAULT NULL,
  `total_sum` int(11) DEFAULT NULL,
  `percentage_of_count` varchar(10) DEFAULT NULL,
  `percentage_of_amount` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `instrumenten_nieuwe_regelingen`
--

DROP TABLE IF EXISTS `instrumenten_nieuwe_regelingen`;
CREATE TABLE `instrumenten_nieuwe_regelingen` (
  `Begrotingsjaar` int(11) NOT NULL,
  `Regeling` varchar(255) NOT NULL,
  `regeling_count` int(11) DEFAULT NULL,
  `total_bedrag` int(11) DEFAULT NULL,
  `total_count` int(11) DEFAULT NULL,
  `total_sum` int(11) DEFAULT NULL,
  `percentage_of_count` varchar(10) DEFAULT NULL,
  `percentage_of_amount` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `instrumenten_pivot`
--

DROP TABLE IF EXISTS `instrumenten_pivot`;
CREATE TABLE `instrumenten_pivot` (
  `id` int(11) NOT NULL,
  `Begrotingshoofdstuk` varchar(255) DEFAULT NULL,
  `Begrotingsnaam` varchar(255) DEFAULT NULL,
  `RIS_IBOS_nummer` varchar(255) DEFAULT NULL,
  `Artikel` varchar(255) DEFAULT NULL,
  `Artikelonderdeel` varchar(255) DEFAULT NULL,
  `Instrument` varchar(255) DEFAULT NULL,
  `Detail` varchar(255) DEFAULT NULL,
  `Regeling` varchar(255) DEFAULT NULL,
  `Ontvanger` varchar(255) DEFAULT NULL,
  `KvK_nummer` int(11) DEFAULT NULL,
  `Rechtsvorm` varchar(255) DEFAULT NULL,
  `ID_nummer` int(11) DEFAULT NULL,
  `Register_ID_nummer` varchar(255) DEFAULT NULL,
  `Plaats` varchar(255) DEFAULT NULL,
  `Jaar` int(11) DEFAULT NULL,
  `2016` int(11) DEFAULT NULL,
  `2017` int(11) DEFAULT NULL,
  `2018` int(11) DEFAULT NULL,
  `2019` int(11) DEFAULT NULL,
  `2020` int(11) DEFAULT NULL,
  `2021` int(11) DEFAULT NULL,
  `2022` int(11) DEFAULT NULL,
  `2023` int(11) DEFAULT NULL,
  `2024` int(11) DEFAULT NULL,
  `Totaal` int(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `instrumenten_pivot_geconsolideerd`
--

DROP TABLE IF EXISTS `instrumenten_pivot_geconsolideerd`;
CREATE TABLE `instrumenten_pivot_geconsolideerd` (
  `Ontvanger` varchar(255) DEFAULT NULL,
  `Begrotingshoofdstuk` longtext DEFAULT NULL,
  `Begrotingsnaam` longtext DEFAULT NULL,
  `RIS_IBOS_nummer` longtext DEFAULT NULL,
  `Artikel` longtext DEFAULT NULL,
  `Artikelonderdeel` longtext DEFAULT NULL,
  `Instrument` longtext DEFAULT NULL,
  `Detail` longtext DEFAULT NULL,
  `Regeling` longtext DEFAULT NULL,
  `Plaats` longtext DEFAULT NULL,
  `KvK_nummer` mediumtext DEFAULT NULL,
  `Rechtsvorm` longtext DEFAULT NULL,
  `ID_nummer` mediumtext DEFAULT NULL,
  `Register_ID_nummer` longtext DEFAULT NULL,
  `2016` int(11) DEFAULT NULL,
  `2017` int(11) DEFAULT NULL,
  `2018` int(11) DEFAULT NULL,
  `2019` int(11) DEFAULT NULL,
  `2020` int(11) DEFAULT NULL,
  `2021` int(11) DEFAULT NULL,
  `2022` int(11) DEFAULT NULL,
  `2023` int(11) DEFAULT NULL,
  `2024` int(11) DEFAULT NULL,
  `Totaal` int(32) DEFAULT NULL,
  `id` int(11) NOT NULL,
  `row_count` int(11) DEFAULT NULL,
  `year_count` tinyint(3) UNSIGNED GENERATED ALWAYS AS (case when `2016` is not null and `2016` <> 0 then 1 else 0 end + case when `2017` is not null and `2017` <> 0 then 1 else 0 end + case when `2018` is not null and `2018` <> 0 then 1 else 0 end + case when `2019` is not null and `2019` <> 0 then 1 else 0 end + case when `2020` is not null and `2020` <> 0 then 1 else 0 end + case when `2021` is not null and `2021` <> 0 then 1 else 0 end + case when `2022` is not null and `2022` <> 0 then 1 else 0 end + case when `2023` is not null and `2023` <> 0 then 1 else 0 end + case when `2024` is not null and `2024` <> 0 then 1 else 0 end) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `instrumenten_pivot_geconsolideerd_backup`
--

DROP TABLE IF EXISTS `instrumenten_pivot_geconsolideerd_backup`;
CREATE TABLE `instrumenten_pivot_geconsolideerd_backup` (
  `Ontvanger` varchar(255) DEFAULT NULL,
  `Begrotingshoofdstuk` longtext DEFAULT NULL,
  `Begrotingsnaam` longtext DEFAULT NULL,
  `RIS_IBOS_nummer` longtext DEFAULT NULL,
  `Artikel` longtext DEFAULT NULL,
  `Artikelonderdeel` longtext DEFAULT NULL,
  `Instrument` longtext DEFAULT NULL,
  `Detail` longtext DEFAULT NULL,
  `Regeling` longtext DEFAULT NULL,
  `Plaats` longtext DEFAULT NULL,
  `KvK_nummer` mediumtext DEFAULT NULL,
  `Rechtsvorm` longtext DEFAULT NULL,
  `ID_nummer` mediumtext DEFAULT NULL,
  `Register_ID_nummer` longtext DEFAULT NULL,
  `2016` int(11) DEFAULT NULL,
  `2017` int(11) DEFAULT NULL,
  `2018` int(11) DEFAULT NULL,
  `2019` int(11) DEFAULT NULL,
  `2020` int(11) DEFAULT NULL,
  `2021` int(11) DEFAULT NULL,
  `2022` int(11) DEFAULT NULL,
  `2023` int(11) DEFAULT NULL,
  `2024` int(11) DEFAULT NULL,
  `Totaal` int(32) DEFAULT NULL,
  `id` int(11) NOT NULL,
  `row_count` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `instrumenten_pivot_geconsolideerd_set2024`
--

DROP TABLE IF EXISTS `instrumenten_pivot_geconsolideerd_set2024`;
CREATE TABLE `instrumenten_pivot_geconsolideerd_set2024` (
  `Ontvanger` varchar(255) DEFAULT NULL,
  `Begrotingshoofdstuk` longtext DEFAULT NULL,
  `Begrotingsnaam` longtext DEFAULT NULL,
  `RIS_IBOS_nummer` longtext DEFAULT NULL,
  `Artikel` longtext DEFAULT NULL,
  `Artikelonderdeel` longtext DEFAULT NULL,
  `Instrument` longtext DEFAULT NULL,
  `Detail` longtext DEFAULT NULL,
  `Regeling` longtext DEFAULT NULL,
  `Plaats` longtext DEFAULT NULL,
  `KvK_nummer` mediumtext DEFAULT NULL,
  `Rechtsvorm` longtext DEFAULT NULL,
  `ID_nummer` mediumtext DEFAULT NULL,
  `Register_ID_nummer` longtext DEFAULT NULL,
  `2016` int(11) DEFAULT NULL,
  `2017` int(11) DEFAULT NULL,
  `2018` int(11) DEFAULT NULL,
  `2019` int(11) DEFAULT NULL,
  `2020` int(11) DEFAULT NULL,
  `2021` int(11) DEFAULT NULL,
  `2022` int(11) DEFAULT NULL,
  `2023` int(11) DEFAULT NULL,
  `2024` int(11) DEFAULT NULL,
  `Totaal` int(32) DEFAULT NULL,
  `id` int(11) NOT NULL,
  `row_count` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `instrumenten_pivot_set2024`
--

DROP TABLE IF EXISTS `instrumenten_pivot_set2024`;
CREATE TABLE `instrumenten_pivot_set2024` (
  `id` int(11) NOT NULL,
  `Begrotingshoofdstuk` varchar(255) DEFAULT NULL,
  `Begrotingsnaam` varchar(255) DEFAULT NULL,
  `RIS_IBOS_nummer` varchar(255) DEFAULT NULL,
  `Artikel` varchar(255) DEFAULT NULL,
  `Artikelonderdeel` varchar(255) DEFAULT NULL,
  `Instrument` varchar(255) DEFAULT NULL,
  `Detail` varchar(255) DEFAULT NULL,
  `Regeling` varchar(255) DEFAULT NULL,
  `Ontvanger` varchar(255) DEFAULT NULL,
  `KvK_nummer` int(11) DEFAULT NULL,
  `Rechtsvorm` varchar(255) DEFAULT NULL,
  `ID_nummer` int(11) DEFAULT NULL,
  `Register_ID_nummer` varchar(255) DEFAULT NULL,
  `Plaats` varchar(255) DEFAULT NULL,
  `Jaar` int(11) DEFAULT NULL,
  `2016` int(11) DEFAULT NULL,
  `2017` int(11) DEFAULT NULL,
  `2018` int(11) DEFAULT NULL,
  `2019` int(11) DEFAULT NULL,
  `2020` int(11) DEFAULT NULL,
  `2021` int(11) DEFAULT NULL,
  `2022` int(11) DEFAULT NULL,
  `2023` int(11) DEFAULT NULL,
  `2024` int(11) DEFAULT NULL,
  `Totaal` int(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `instrumenten_set2024`
--

DROP TABLE IF EXISTS `instrumenten_set2024`;
CREATE TABLE `instrumenten_set2024` (
  `id` int(11) NOT NULL,
  `Begrotingsjaar` int(11) DEFAULT NULL,
  `Begrotingshoofdstuk` varchar(255) DEFAULT NULL,
  `Begrotingsnaam` varchar(255) DEFAULT NULL,
  `RIS_IBOS_nummer` varchar(255) DEFAULT NULL,
  `Artikel` varchar(255) DEFAULT NULL,
  `Artikelonderdeel` varchar(255) DEFAULT NULL,
  `Instrument` varchar(255) DEFAULT NULL,
  `Detail` varchar(255) DEFAULT NULL,
  `Regeling` varchar(255) DEFAULT NULL,
  `Ontvanger` varchar(255) DEFAULT NULL,
  `Bedrag` int(11) DEFAULT NULL,
  `KvK_nummer` int(11) DEFAULT NULL,
  `Rechtsvorm` varchar(255) DEFAULT NULL,
  `ID_nummer` int(11) DEFAULT NULL,
  `Register_ID_nummer` varchar(255) DEFAULT NULL,
  `Plaats` varchar(255) DEFAULT NULL,
  `Bedrag_normalized` bigint(20) DEFAULT NULL,
  `Source` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `instrumenten_top_artikelen`
--

DROP TABLE IF EXISTS `instrumenten_top_artikelen`;
CREATE TABLE `instrumenten_top_artikelen` (
  `Begrotingsjaar` int(11) NOT NULL,
  `Position` varchar(50) DEFAULT NULL,
  `Ontvanger` varchar(255) DEFAULT NULL,
  `Bedrag` int(15) DEFAULT NULL,
  `TotalBedragFormatted` varchar(50) DEFAULT NULL,
  `OverallRank` int(11) DEFAULT NULL,
  `YearlyRank` int(11) DEFAULT NULL,
  `TotalBedrag` int(15) DEFAULT NULL,
  `Begrotingshoofdstuk` varchar(255) DEFAULT NULL,
  `Begrotingsnaam` varchar(255) DEFAULT NULL,
  `RIS_IBOS_nummer` varchar(255) DEFAULT NULL,
  `Artikel` varchar(255) NOT NULL,
  `Artikelonderdeel` varchar(255) DEFAULT NULL,
  `Instrument` varchar(255) DEFAULT NULL,
  `Regeling` varchar(255) DEFAULT NULL,
  `KvK_nummer` int(11) DEFAULT NULL,
  `Rechtsvorm` varchar(255) DEFAULT NULL,
  `ID_nummer` int(11) DEFAULT NULL,
  `Register_ID_nummer` varchar(255) DEFAULT NULL,
  `Plaats` varchar(255) DEFAULT NULL,
  `RankType` enum('Yearly','Overall') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `instrumenten_top_artikelonderdeel`
--

DROP TABLE IF EXISTS `instrumenten_top_artikelonderdeel`;
CREATE TABLE `instrumenten_top_artikelonderdeel` (
  `Begrotingsjaar` int(11) NOT NULL,
  `Position` varchar(50) DEFAULT NULL,
  `Ontvanger` varchar(255) DEFAULT NULL,
  `Bedrag` int(15) DEFAULT NULL,
  `TotalBedragFormatted` varchar(50) DEFAULT NULL,
  `OverallRank` int(11) DEFAULT NULL,
  `YearlyRank` int(11) DEFAULT NULL,
  `TotalBedrag` int(15) DEFAULT NULL,
  `Begrotingshoofdstuk` varchar(255) DEFAULT NULL,
  `Begrotingsnaam` varchar(255) DEFAULT NULL,
  `RIS_IBOS_nummer` varchar(255) DEFAULT NULL,
  `Artikel` varchar(255) DEFAULT NULL,
  `Artikelonderdeel` varchar(255) NOT NULL,
  `Instrument` varchar(255) DEFAULT NULL,
  `Regeling` varchar(255) DEFAULT NULL,
  `KvK_nummer` int(11) DEFAULT NULL,
  `Rechtsvorm` varchar(255) DEFAULT NULL,
  `ID_nummer` int(11) DEFAULT NULL,
  `Register_ID_nummer` varchar(255) DEFAULT NULL,
  `Plaats` varchar(255) DEFAULT NULL,
  `RankType` enum('Yearly','Overall') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `instrumenten_top_instrumenten`
--

DROP TABLE IF EXISTS `instrumenten_top_instrumenten`;
CREATE TABLE `instrumenten_top_instrumenten` (
  `Begrotingsjaar` int(11) NOT NULL,
  `Position` varchar(50) DEFAULT NULL,
  `Ontvanger` varchar(255) DEFAULT NULL,
  `Bedrag` int(15) DEFAULT NULL,
  `TotalBedragFormatted` varchar(50) DEFAULT NULL,
  `OverallRank` int(11) DEFAULT NULL,
  `YearlyRank` int(11) DEFAULT NULL,
  `TotalBedrag` int(15) DEFAULT NULL,
  `Begrotingshoofdstuk` varchar(255) DEFAULT NULL,
  `Begrotingsnaam` varchar(255) DEFAULT NULL,
  `RIS_IBOS_nummer` varchar(255) DEFAULT NULL,
  `Artikel` varchar(255) DEFAULT NULL,
  `Artikelonderdeel` varchar(255) DEFAULT NULL,
  `Instrument` varchar(255) NOT NULL,
  `Regeling` varchar(255) DEFAULT NULL,
  `KvK_nummer` int(11) DEFAULT NULL,
  `Rechtsvorm` varchar(255) DEFAULT NULL,
  `ID_nummer` int(11) DEFAULT NULL,
  `Register_ID_nummer` varchar(255) DEFAULT NULL,
  `Plaats` varchar(255) DEFAULT NULL,
  `RankType` enum('Yearly','Overall') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `instrumenten_top_ontvangers`
--

DROP TABLE IF EXISTS `instrumenten_top_ontvangers`;
CREATE TABLE `instrumenten_top_ontvangers` (
  `Begrotingsjaar` int(11) NOT NULL,
  `Position` varchar(50) DEFAULT NULL,
  `Ontvanger` varchar(255) NOT NULL,
  `Bedrag` int(15) DEFAULT NULL,
  `TotalBedragFormatted` varchar(50) DEFAULT NULL,
  `OverallRank` int(11) DEFAULT NULL,
  `YearlyRank` int(11) DEFAULT NULL,
  `TotalBedrag` int(15) DEFAULT NULL,
  `Begrotingshoofdstuk` varchar(255) DEFAULT NULL,
  `Begrotingsnaam` varchar(255) DEFAULT NULL,
  `RIS_IBOS_nummer` varchar(255) DEFAULT NULL,
  `Artikel` varchar(255) DEFAULT NULL,
  `Artikelonderdeel` varchar(255) DEFAULT NULL,
  `Instrument` varchar(255) DEFAULT NULL,
  `Regeling` varchar(255) DEFAULT NULL,
  `KvK_nummer` int(11) DEFAULT NULL,
  `Rechtsvorm` varchar(255) DEFAULT NULL,
  `ID_nummer` int(11) DEFAULT NULL,
  `Register_ID_nummer` varchar(255) DEFAULT NULL,
  `Plaats` varchar(255) DEFAULT NULL,
  `RankType` enum('Yearly','Overall') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `instrumenten_top_regelingen`
--

DROP TABLE IF EXISTS `instrumenten_top_regelingen`;
CREATE TABLE `instrumenten_top_regelingen` (
  `Begrotingsjaar` int(11) DEFAULT NULL,
  `Position` varchar(45) NOT NULL,
  `Regeling` varchar(255) DEFAULT NULL,
  `Bedrag` decimal(32,0) DEFAULT NULL,
  `TotalBedragFormatted` binary(0) DEFAULT NULL,
  `OverallRank` bigint(21) NOT NULL DEFAULT 0,
  `YearlyRank` bigint(21) NOT NULL DEFAULT 0,
  `TotalBedrag` decimal(32,0) DEFAULT NULL,
  `TotalUsageCount` bigint(21) NOT NULL DEFAULT 0,
  `YearlyUsageCount` bigint(21) NOT NULL DEFAULT 0,
  `Begrotingshoofdstuk` varchar(255) DEFAULT NULL,
  `Begrotingsnaam` varchar(255) DEFAULT NULL,
  `RIS_IBOS_nummer` varchar(255) DEFAULT NULL,
  `Artikel` varchar(255) DEFAULT NULL,
  `Artikelonderdeel` varchar(255) DEFAULT NULL,
  `Instrument` varchar(255) DEFAULT NULL,
  `Ontvanger` varchar(255) DEFAULT NULL,
  `KvK_nummer` int(11) DEFAULT NULL,
  `Rechtsvorm` varchar(255) DEFAULT NULL,
  `ID_nummer` int(11) DEFAULT NULL,
  `Register_ID_nummer` varchar(255) DEFAULT NULL,
  `Plaats` varchar(255) DEFAULT NULL,
  `RankType` varchar(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `instrumenten_view_jaar`
--

DROP TABLE IF EXISTS `instrumenten_view_jaar`;
CREATE TABLE `instrumenten_view_jaar` (
  `Jaar` varchar(4) NOT NULL,
  `Top_50` int(11) DEFAULT NULL,
  `Overig` int(11) DEFAULT NULL,
  `Totaal` int(11) DEFAULT NULL,
  `Groei` decimal(10,2) DEFAULT NULL,
  `Groei_start` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lkp_instrumenten_regeling`
--

DROP TABLE IF EXISTS `lkp_instrumenten_regeling`;
CREATE TABLE `lkp_instrumenten_regeling` (
  `Regeling` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `provincie`
--

DROP TABLE IF EXISTS `provincie`;
CREATE TABLE `provincie` (
  `Provincie` varchar(255) DEFAULT NULL,
  `Nummer` varchar(255) DEFAULT NULL,
  `Jaar` int(11) DEFAULT NULL,
  `Ontvanger` varchar(255) DEFAULT NULL,
  `Omschrijving` longtext DEFAULT NULL,
  `Bedrag` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL,
  `Source` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `provincie_pivot`
--

DROP TABLE IF EXISTS `provincie_pivot`;
CREATE TABLE `provincie_pivot` (
  `id` int(11) NOT NULL DEFAULT 0,
  `Provincie` varchar(255) DEFAULT NULL,
  `Nummer` varchar(255) DEFAULT NULL,
  `Ontvanger` varchar(255) DEFAULT NULL,
  `Omschrijving` longtext DEFAULT NULL,
  `Jaar` int(11) DEFAULT NULL,
  `2018` int(11) DEFAULT NULL,
  `2019` int(11) DEFAULT NULL,
  `2020` int(11) DEFAULT NULL,
  `2021` int(11) DEFAULT NULL,
  `2022` int(11) DEFAULT NULL,
  `2023` int(11) DEFAULT NULL,
  `2024` int(11) DEFAULT NULL,
  `Totaal` int(32) DEFAULT NULL,
  `row_count` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `provincie_pivot_geconsolideerd`
--

DROP TABLE IF EXISTS `provincie_pivot_geconsolideerd`;
CREATE TABLE `provincie_pivot_geconsolideerd` (
  `id` int(11) NOT NULL,
  `Provincie` text DEFAULT NULL,
  `Nummer` text DEFAULT NULL,
  `Ontvanger` varchar(255) DEFAULT NULL,
  `Omschrijving` longtext DEFAULT NULL,
  `Staffel` varchar(2) NOT NULL,
  `2018` int(11) DEFAULT NULL,
  `2019` int(11) DEFAULT NULL,
  `2020` int(11) DEFAULT NULL,
  `2021` int(11) DEFAULT NULL,
  `2022` int(11) DEFAULT NULL,
  `2023` int(11) DEFAULT NULL,
  `2024` int(11) DEFAULT NULL,
  `Totaal` int(15) DEFAULT NULL,
  `row_count` int(11) DEFAULT NULL,
  `year_count` tinyint(3) UNSIGNED GENERATED ALWAYS AS (case when `2018` is not null and `2018` <> 0 then 1 else 0 end + case when `2019` is not null and `2019` <> 0 then 1 else 0 end + case when `2020` is not null and `2020` <> 0 then 1 else 0 end + case when `2021` is not null and `2021` <> 0 then 1 else 0 end + case when `2022` is not null and `2022` <> 0 then 1 else 0 end + case when `2023` is not null and `2023` <> 0 then 1 else 0 end + case when `2024` is not null and `2024` <> 0 then 1 else 0 end) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `publiek`
--

DROP TABLE IF EXISTS `publiek`;
CREATE TABLE `publiek` (
  `id` int(11) NOT NULL,
  `Projectnummer` varchar(255) DEFAULT NULL,
  `Jaar` int(11) DEFAULT NULL,
  `Omschrijving` text DEFAULT NULL,
  `Ontvanger` varchar(255) DEFAULT NULL,
  `KvK_nummer` varchar(50) DEFAULT NULL,
  `Regeling` varchar(255) DEFAULT NULL,
  `Bedrag` int(11) DEFAULT NULL,
  `Locatie` point DEFAULT NULL,
  `Trefwoorden` text DEFAULT NULL,
  `Sectoren` varchar(255) DEFAULT NULL,
  `EU_besluit` varchar(100) DEFAULT NULL,
  `Source` varchar(30) NOT NULL,
  `Provincie` varchar(100) DEFAULT NULL,
  `Staffel` varchar(7) DEFAULT NULL,
  `Onderdeel` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `publiekcoa`
--

DROP TABLE IF EXISTS `publiekcoa`;
CREATE TABLE `publiekcoa` (
  `id` int(11) NOT NULL,
  `Projectnummer` varchar(255) DEFAULT NULL,
  `Jaar` int(11) DEFAULT NULL,
  `Omschrijving` text DEFAULT NULL,
  `Ontvanger` varchar(255) DEFAULT NULL,
  `KvK_nummer` varchar(50) DEFAULT NULL,
  `Regeling` varchar(255) DEFAULT NULL,
  `Bedrag` int(11) DEFAULT NULL,
  `Locatie` point DEFAULT NULL,
  `Trefwoorden` text DEFAULT NULL,
  `Sectoren` varchar(255) DEFAULT NULL,
  `EU_besluit` varchar(100) DEFAULT NULL,
  `Source` varchar(30) NOT NULL,
  `Provincie` varchar(100) DEFAULT NULL,
  `Staffel` varchar(7) DEFAULT NULL,
  `Onderdeel` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `publiek_pivot`
--

DROP TABLE IF EXISTS `publiek_pivot`;
CREATE TABLE `publiek_pivot` (
  `id` int(11) NOT NULL,
  `Projectnummer` varchar(255) DEFAULT NULL,
  `Omschrijving` text DEFAULT NULL,
  `Ontvanger` varchar(255) DEFAULT NULL,
  `KvK_nummer` varchar(50) DEFAULT NULL,
  `Regeling` varchar(255) DEFAULT NULL,
  `Locatie` point DEFAULT NULL,
  `Trefwoorden` text DEFAULT NULL,
  `Sectoren` varchar(255) DEFAULT NULL,
  `EU_besluit` varchar(100) DEFAULT NULL,
  `Source` varchar(30) DEFAULT NULL,
  `2018` int(11) DEFAULT NULL,
  `2019` int(11) DEFAULT NULL,
  `2020` int(11) DEFAULT NULL,
  `2021` int(11) DEFAULT NULL,
  `2022` int(11) DEFAULT NULL,
  `2023` int(11) DEFAULT NULL,
  `2024` int(11) DEFAULT NULL,
  `Totaal` int(11) DEFAULT NULL,
  `Jaar` int(11) DEFAULT NULL,
  `Provincie` varchar(100) DEFAULT NULL,
  `Staffel` varchar(7) DEFAULT NULL,
  `Onderdeel` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `publiek_pivot_geconsolideerd`
--

DROP TABLE IF EXISTS `publiek_pivot_geconsolideerd`;
CREATE TABLE `publiek_pivot_geconsolideerd` (
  `id` int(11) NOT NULL,
  `Ontvanger` varchar(255) DEFAULT NULL,
  `KvK_nummer` text DEFAULT NULL,
  `Projectnummer` text DEFAULT NULL,
  `Omschrijving` text DEFAULT NULL,
  `Regeling` text DEFAULT NULL,
  `Trefwoorden` text DEFAULT NULL,
  `Sectoren` text DEFAULT NULL,
  `EU_besluit` text DEFAULT NULL,
  `Source` text DEFAULT NULL,
  `row_count` int(11) DEFAULT NULL,
  `2018` int(11) DEFAULT NULL,
  `2019` int(11) DEFAULT NULL,
  `2020` int(11) DEFAULT NULL,
  `2021` int(11) DEFAULT NULL,
  `2022` int(11) DEFAULT NULL,
  `2023` int(11) DEFAULT NULL,
  `2024` int(11) DEFAULT NULL,
  `Totaal` int(11) DEFAULT NULL,
  `Provincie` text DEFAULT NULL,
  `Staffel` varchar(255) DEFAULT NULL,
  `Onderdeel` text DEFAULT NULL,
  `year_count` tinyint(3) UNSIGNED GENERATED ALWAYS AS (case when `2018` is not null and `2018` <> 0 then 1 else 0 end + case when `2019` is not null and `2019` <> 0 then 1 else 0 end + case when `2020` is not null and `2020` <> 0 then 1 else 0 end + case when `2021` is not null and `2021` <> 0 then 1 else 0 end + case when `2022` is not null and `2022` <> 0 then 1 else 0 end + case when `2023` is not null and `2023` <> 0 then 1 else 0 end + case when `2024` is not null and `2024` <> 0 then 1 else 0 end) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `stad`
--

DROP TABLE IF EXISTS `stad`;
CREATE TABLE `stad` (
  `Stad` varchar(255) DEFAULT NULL,
  `Nummer` varchar(255) DEFAULT NULL,
  `Jaar` int(11) DEFAULT NULL,
  `Ontvanger` varchar(255) DEFAULT NULL,
  `Omschrijving` longtext DEFAULT NULL,
  `Bedrag` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL,
  `Beleidsterrein` varchar(255) DEFAULT NULL,
  `Beleidsnota` mediumtext DEFAULT NULL,
  `Regeling` varchar(255) DEFAULT NULL,
  `Source` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `stad222`
--

DROP TABLE IF EXISTS `stad222`;
CREATE TABLE `stad222` (
  `Stad` varchar(255) DEFAULT NULL,
  `Nummer` varchar(255) DEFAULT NULL,
  `Jaar` int(11) DEFAULT NULL,
  `Ontvanger` varchar(255) DEFAULT NULL,
  `Omschrijving` longtext DEFAULT NULL,
  `Bedrag` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL,
  `Beleidsterrein` varchar(255) DEFAULT NULL,
  `Beleidsnota` mediumtext DEFAULT NULL,
  `Regeling` varchar(255) DEFAULT NULL,
  `Source` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `stad_pivot`
--

DROP TABLE IF EXISTS `stad_pivot`;
CREATE TABLE `stad_pivot` (
  `id` int(11) NOT NULL DEFAULT 0,
  `Stad` varchar(255) DEFAULT NULL,
  `Nummer` varchar(255) DEFAULT NULL,
  `Ontvanger` varchar(255) DEFAULT NULL,
  `Omschrijving` longtext DEFAULT NULL,
  `Jaar` int(11) DEFAULT NULL,
  `2018` int(11) DEFAULT NULL,
  `2019` int(11) DEFAULT NULL,
  `2020` int(11) DEFAULT NULL,
  `2021` int(11) DEFAULT NULL,
  `2022` int(11) DEFAULT NULL,
  `2023` int(11) DEFAULT NULL,
  `2024` int(11) DEFAULT NULL,
  `Totaal` int(11) DEFAULT NULL,
  `Beleidsterrein` varchar(255) DEFAULT NULL,
  `Beleidsnota` mediumtext DEFAULT NULL,
  `Regeling` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `stad_pivot_geconsolideerd`
--

DROP TABLE IF EXISTS `stad_pivot_geconsolideerd`;
CREATE TABLE `stad_pivot_geconsolideerd` (
  `id` int(11) NOT NULL,
  `Stad` mediumtext DEFAULT NULL,
  `Nummer` mediumtext DEFAULT NULL,
  `Ontvanger` varchar(255) DEFAULT NULL,
  `Omschrijving` longtext DEFAULT NULL,
  `2018` int(11) DEFAULT NULL,
  `2019` int(11) DEFAULT NULL,
  `2020` int(11) DEFAULT NULL,
  `2021` int(11) DEFAULT NULL,
  `2022` int(11) DEFAULT NULL,
  `2023` int(11) DEFAULT NULL,
  `2024` int(11) DEFAULT NULL,
  `Totaal` int(11) DEFAULT NULL,
  `Beleidsterrein` mediumtext DEFAULT NULL,
  `Beleidsnota` mediumtext DEFAULT NULL,
  `Regeling` longtext DEFAULT NULL,
  `row_count` int(11) DEFAULT NULL,
  `year_count` tinyint(3) UNSIGNED GENERATED ALWAYS AS (case when `2018` is not null and `2018` <> 0 then 1 else 0 end + case when `2019` is not null and `2019` <> 0 then 1 else 0 end + case when `2020` is not null and `2020` <> 0 then 1 else 0 end + case when `2021` is not null and `2021` <> 0 then 1 else 0 end + case when `2022` is not null and `2022` <> 0 then 1 else 0 end + case when `2023` is not null and `2023` <> 0 then 1 else 0 end + case when `2024` is not null and `2024` <> 0 then 1 else 0 end) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `universal_search`
--

DROP TABLE IF EXISTS `universal_search`;
CREATE TABLE `universal_search` (
  `id` int(11) NOT NULL,
  `Ontvanger` varchar(255) DEFAULT NULL,
  `Sources` text DEFAULT NULL,
  `Sub_sources` text DEFAULT NULL,
  `Sub_sources_count` int(11) DEFAULT NULL,
  `Source_count` int(11) DEFAULT NULL,
  `row_count` int(11) DEFAULT NULL,
  `2016` decimal(20,6) DEFAULT NULL,
  `2017` decimal(20,6) DEFAULT NULL,
  `2018` decimal(20,6) DEFAULT NULL,
  `2019` decimal(20,6) DEFAULT NULL,
  `2020` decimal(20,6) DEFAULT NULL,
  `2021` decimal(20,6) DEFAULT NULL,
  `2022` decimal(20,6) DEFAULT NULL,
  `2023` decimal(20,6) DEFAULT NULL,
  `2024` decimal(20,6) DEFAULT NULL,
  `Totaal` decimal(20,6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `universal_search_source`
--

DROP TABLE IF EXISTS `universal_search_source`;
CREATE TABLE `universal_search_source` (
  `id` int(11) NOT NULL,
  `Ontvanger` varchar(255) DEFAULT NULL,
  `Sub_source` varchar(255) DEFAULT NULL,
  `2016` decimal(20,6) DEFAULT NULL,
  `2017` decimal(20,6) DEFAULT NULL,
  `2018` decimal(20,6) DEFAULT NULL,
  `2019` decimal(20,6) DEFAULT NULL,
  `2020` decimal(20,6) DEFAULT NULL,
  `2021` decimal(20,6) DEFAULT NULL,
  `2022` decimal(20,6) DEFAULT NULL,
  `2023` decimal(20,6) DEFAULT NULL,
  `2024` decimal(20,6) DEFAULT NULL,
  `Totaal` decimal(20,6) DEFAULT NULL,
  `Source` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `apparaat`
--
ALTER TABLE `apparaat`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Begrotingsjaar` (`Begrotingsjaar`,`Kostensoort`,`id`);

--
-- Indexes for table `apparaat_id`
--
ALTER TABLE `apparaat_id`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_rand_key` (`rand_key`);

--
-- Indexes for table `apparaat_pivot_geconsolideerd`
--
ALTER TABLE `apparaat_pivot_geconsolideerd`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Standardized_Kostensoort` (`Kostensoort`),
  ADD KEY `idx_year_count` (`year_count`);

--
-- Indexes for table `inkoop`
--
ALTER TABLE `inkoop`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Jaar` (`Jaar`),
  ADD KEY `Ministerie` (`Ministerie`),
  ADD KEY `Leverancier` (`Leverancier`),
  ADD KEY `Category` (`Categorie`(768)),
  ADD KEY `Staffel` (`Staffel`);

--
-- Indexes for table `inkoop_pivot`
--
ALTER TABLE `inkoop_pivot`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Leverancier` (`Leverancier`),
  ADD KEY `Ministerie` (`Ministerie`),
  ADD KEY `Category` (`Categorie`),
  ADD KEY `Jaar` (`Jaar`),
  ADD KEY `id` (`id`),
  ADD KEY `Staffel` (`Staffel`),
  ADD KEY `idx_leverancier_inkoop_pivot` (`Leverancier`(150));

--
-- Indexes for table `inkoop_pivot_geconsolideerd`
--
ALTER TABLE `inkoop_pivot_geconsolideerd`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Ministerie` (`Ministerie`(768)),
  ADD KEY `Leverancier` (`Leverancier`),
  ADD KEY `Category` (`Categorie`(768)),
  ADD KEY `Staffel` (`Staffel`(768)),
  ADD KEY `idx_leverancier_inkoop_pivot_geconsolideerd` (`Leverancier`(150)),
  ADD KEY `idx_year_count_id` (`year_count` DESC,`id`);

--
-- Indexes for table `inkoop_source_pivot`
--
ALTER TABLE `inkoop_source_pivot`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `instrumenten`
--
ALTER TABLE `instrumenten`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `instrumenten_nieuwe_instrumenten`
--
ALTER TABLE `instrumenten_nieuwe_instrumenten`
  ADD PRIMARY KEY (`Begrotingsjaar`,`Instrument`);

--
-- Indexes for table `instrumenten_nieuwe_regelingen`
--
ALTER TABLE `instrumenten_nieuwe_regelingen`
  ADD PRIMARY KEY (`Begrotingsjaar`,`Regeling`);

--
-- Indexes for table `instrumenten_pivot`
--
ALTER TABLE `instrumenten_pivot`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`),
  ADD KEY `idx_ontvanger_instrumenten_pivot` (`Ontvanger`(150)),
  ADD KEY `idx_ontvanger_artikel_instrumenten_pivot` (`Ontvanger`,`Artikel`),
  ADD KEY `idx_ontvanger_regeling_instrumenten_pivot` (`Ontvanger`,`Regeling`),
  ADD KEY `idx_ontvanger_instrument_instrumenten_pivot` (`Ontvanger`,`Instrument`),
  ADD KEY `idx_ontvanger_begrotingsnaam_instrumenten_pivot` (`Ontvanger`,`Begrotingsnaam`),
  ADD KEY `idx_ontvanger_artikelonderdeel_instrumenten_pivot` (`Ontvanger`,`Artikelonderdeel`);

--
-- Indexes for table `instrumenten_pivot_geconsolideerd`
--
ALTER TABLE `instrumenten_pivot_geconsolideerd`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`),
  ADD KEY `idx_ontvanger_instrumenten_pivot_geconsolideerd` (`Ontvanger`(150)),
  ADD KEY `ipg_ontvanger` (`Ontvanger`),
  ADD KEY `ipg_ontvanger_artikel` (`Ontvanger`,`Artikel`(120)),
  ADD KEY `ipg_ontvanger_regeling` (`Ontvanger`,`Regeling`(120)),
  ADD KEY `ipg_ontvanger_instrument` (`Ontvanger`,`Instrument`(120)),
  ADD KEY `ipg_ontvanger_begrotingsnaam` (`Ontvanger`,`Begrotingsnaam`(120)),
  ADD KEY `ipg_ontvanger_artikelond` (`Ontvanger`,`Artikelonderdeel`(120)),
  ADD KEY `idx_year_count_id` (`year_count` DESC,`id`);
ALTER TABLE `instrumenten_pivot_geconsolideerd` ADD FULLTEXT KEY `ft_ontvanger` (`Ontvanger`);

--
-- Indexes for table `instrumenten_pivot_geconsolideerd_backup`
--
ALTER TABLE `instrumenten_pivot_geconsolideerd_backup`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`),
  ADD KEY `Standardized_Ontvanger` (`Ontvanger`),
  ADD KEY `Standardized_Ontvanger_2` (`Ontvanger`),
  ADD KEY `idx_ontvanger` (`Ontvanger`),
  ADD KEY `Ontvanger` (`Ontvanger`),
  ADD KEY `idx_ontvanger_instrument` (`Ontvanger`(191),`Instrument`(191)),
  ADD KEY `idx_ontvanger_artikel` (`Ontvanger`(191),`Artikel`(191)),
  ADD KEY `idx_ontvanger_regeling` (`Ontvanger`(191),`Regeling`(191)),
  ADD KEY `idx_ontvanger_artikelonderdeel` (`Ontvanger`(191),`Artikelonderdeel`(191));
ALTER TABLE `instrumenten_pivot_geconsolideerd_backup` ADD FULLTEXT KEY `ft_ontvanger` (`Ontvanger`);

--
-- Indexes for table `instrumenten_pivot_geconsolideerd_set2024`
--
ALTER TABLE `instrumenten_pivot_geconsolideerd_set2024`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`),
  ADD KEY `Standardized_Ontvanger` (`Ontvanger`),
  ADD KEY `Standardized_Ontvanger_2` (`Ontvanger`),
  ADD KEY `idx_ontvanger` (`Ontvanger`);
ALTER TABLE `instrumenten_pivot_geconsolideerd_set2024` ADD FULLTEXT KEY `ft_ontvanger` (`Ontvanger`);

--
-- Indexes for table `instrumenten_pivot_set2024`
--
ALTER TABLE `instrumenten_pivot_set2024`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `instrumenten_pivot_set2024` ADD FULLTEXT KEY `ft_ontvanger` (`Ontvanger`);

--
-- Indexes for table `instrumenten_set2024`
--
ALTER TABLE `instrumenten_set2024`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `instrumenten_top_artikelen`
--
ALTER TABLE `instrumenten_top_artikelen`
  ADD PRIMARY KEY (`Begrotingsjaar`,`Artikel`,`RankType`);

--
-- Indexes for table `instrumenten_top_artikelonderdeel`
--
ALTER TABLE `instrumenten_top_artikelonderdeel`
  ADD PRIMARY KEY (`Begrotingsjaar`,`Artikelonderdeel`,`RankType`);

--
-- Indexes for table `instrumenten_top_instrumenten`
--
ALTER TABLE `instrumenten_top_instrumenten`
  ADD PRIMARY KEY (`Begrotingsjaar`,`Instrument`,`RankType`);

--
-- Indexes for table `instrumenten_top_ontvangers`
--
ALTER TABLE `instrumenten_top_ontvangers`
  ADD PRIMARY KEY (`Begrotingsjaar`,`Ontvanger`,`RankType`),
  ADD KEY `Begrotingsjaar` (`Begrotingsjaar`,`Position`,`Ontvanger`,`OverallRank`,`YearlyRank`,`RankType`);

--
-- Indexes for table `instrumenten_view_jaar`
--
ALTER TABLE `instrumenten_view_jaar`
  ADD PRIMARY KEY (`Jaar`),
  ADD KEY `Jaar` (`Jaar`);

--
-- Indexes for table `lkp_instrumenten_regeling`
--
ALTER TABLE `lkp_instrumenten_regeling`
  ADD PRIMARY KEY (`Regeling`);

--
-- Indexes for table `provincie`
--
ALTER TABLE `provincie`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `provincie_pivot`
--
ALTER TABLE `provincie_pivot`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `id_2` (`id`),
  ADD KEY `Ontvanger` (`Ontvanger`),
  ADD KEY `idx_ontvanger_provincie_pivot` (`Ontvanger`(150));

--
-- Indexes for table `provincie_pivot_geconsolideerd`
--
ALTER TABLE `provincie_pivot_geconsolideerd`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`,`Ontvanger`),
  ADD KEY `idx_ontvanger_provincie_pivot_geconsolideerd` (`Ontvanger`(150)),
  ADD KEY `idx_year_count_id` (`year_count` DESC,`id`);

--
-- Indexes for table `publiek`
--
ALTER TABLE `publiek`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `id_2` (`id`),
  ADD KEY `Ontvanger` (`Ontvanger`);

--
-- Indexes for table `publiekcoa`
--
ALTER TABLE `publiekcoa`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `id_2` (`id`),
  ADD KEY `Ontvanger` (`Ontvanger`);

--
-- Indexes for table `publiek_pivot`
--
ALTER TABLE `publiek_pivot`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `id_2` (`id`,`Ontvanger`),
  ADD KEY `idx_ontvanger_publiek_pivot` (`Ontvanger`(150));

--
-- Indexes for table `publiek_pivot_geconsolideerd`
--
ALTER TABLE `publiek_pivot_geconsolideerd`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `id_2` (`id`,`Ontvanger`),
  ADD KEY `idx_ontvanger_publiek_pivot_geconsolideerd` (`Ontvanger`(150)),
  ADD KEY `idx_year_count_id` (`year_count` DESC,`id`);

--
-- Indexes for table `stad`
--
ALTER TABLE `stad`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `stad222`
--
ALTER TABLE `stad222`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `stad_pivot`
--
ALTER TABLE `stad_pivot`
  ADD KEY `idx_ontvanger_stad_pivot` (`Ontvanger`(150));

--
-- Indexes for table `stad_pivot_geconsolideerd`
--
ALTER TABLE `stad_pivot_geconsolideerd`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ontvanger_stad_pivot_geconsolideerd` (`Ontvanger`(150)),
  ADD KEY `idx_year_count_id` (`year_count` DESC,`id`);

--
-- Indexes for table `universal_search`
--
ALTER TABLE `universal_search`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ontvanger` (`Ontvanger`);

--
-- Indexes for table `universal_search_source`
--
ALTER TABLE `universal_search_source`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ontvanger` (`Ontvanger`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `apparaat`
--
ALTER TABLE `apparaat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `apparaat_pivot_geconsolideerd`
--
ALTER TABLE `apparaat_pivot_geconsolideerd`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inkoop`
--
ALTER TABLE `inkoop`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inkoop_pivot`
--
ALTER TABLE `inkoop_pivot`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inkoop_pivot_geconsolideerd`
--
ALTER TABLE `inkoop_pivot_geconsolideerd`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inkoop_source_pivot`
--
ALTER TABLE `inkoop_source_pivot`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `instrumenten`
--
ALTER TABLE `instrumenten`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `instrumenten_pivot`
--
ALTER TABLE `instrumenten_pivot`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `instrumenten_pivot_geconsolideerd`
--
ALTER TABLE `instrumenten_pivot_geconsolideerd`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `instrumenten_pivot_geconsolideerd_backup`
--
ALTER TABLE `instrumenten_pivot_geconsolideerd_backup`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `instrumenten_pivot_geconsolideerd_set2024`
--
ALTER TABLE `instrumenten_pivot_geconsolideerd_set2024`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `instrumenten_pivot_set2024`
--
ALTER TABLE `instrumenten_pivot_set2024`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `instrumenten_set2024`
--
ALTER TABLE `instrumenten_set2024`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `provincie`
--
ALTER TABLE `provincie`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `provincie_pivot_geconsolideerd`
--
ALTER TABLE `provincie_pivot_geconsolideerd`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `publiek`
--
ALTER TABLE `publiek`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `publiekcoa`
--
ALTER TABLE `publiekcoa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `publiek_pivot_geconsolideerd`
--
ALTER TABLE `publiek_pivot_geconsolideerd`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `stad`
--
ALTER TABLE `stad`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `stad222`
--
ALTER TABLE `stad222`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `stad_pivot_geconsolideerd`
--
ALTER TABLE `stad_pivot_geconsolideerd`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `universal_search`
--
ALTER TABLE `universal_search`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `universal_search_source`
--
ALTER TABLE `universal_search_source`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- --------------------------------------------------------

--
-- Structure for view `instrumenten_inzichten_deviation_view`
--
DROP TABLE IF EXISTS `instrumenten_inzichten_deviation_view`;

DROP VIEW IF EXISTS `instrumenten_inzichten_deviation_view`;
CREATE ALGORITHM=UNDEFINED DEFINER=`Wordpress-RULT-DB`@`%` SQL SECURITY DEFINER VIEW `instrumenten_inzichten_deviation_view`  AS SELECT `instrumenten_inzichten_deviation`.`Standardized_Ontvanger` AS `Standardized_Ontvanger`, `instrumenten_inzichten_deviation`.`Begrotingshoofdstuk` AS `Begrotingshoofdstuk`, `instrumenten_inzichten_deviation`.`Begrotingsnaam` AS `Begrotingsnaam`, `instrumenten_inzichten_deviation`.`RIS_IBOS_nummer` AS `RIS_IBOS_nummer`, `instrumenten_inzichten_deviation`.`Artikel` AS `Artikel`, `instrumenten_inzichten_deviation`.`Artikelonderdeel` AS `Artikelonderdeel`, `instrumenten_inzichten_deviation`.`Instrument` AS `Instrument`, `instrumenten_inzichten_deviation`.`Regeling` AS `Regeling`, `instrumenten_inzichten_deviation`.`Grand_Total` AS `Grand_Total`, `instrumenten_inzichten_deviation`.`Average` AS `Average`, `instrumenten_inzichten_deviation`.`Years_Received_Money` AS `Years_Received_Money`, greatest(abs(`instrumenten_inzichten_deviation`.`Deviation_2016`),abs(`instrumenten_inzichten_deviation`.`Deviation_2017`),abs(`instrumenten_inzichten_deviation`.`Deviation_2018`),abs(`instrumenten_inzichten_deviation`.`Deviation_2019`),abs(`instrumenten_inzichten_deviation`.`Deviation_2020`),abs(`instrumenten_inzichten_deviation`.`Deviation_2021`),abs(`instrumenten_inzichten_deviation`.`Deviation_2022`),abs(`instrumenten_inzichten_deviation`.`Deviation_2023`)) AS `Highest_Deviation`, round(greatest(abs(`instrumenten_inzichten_deviation`.`Deviation_2016`),abs(`instrumenten_inzichten_deviation`.`Deviation_2017`),abs(`instrumenten_inzichten_deviation`.`Deviation_2018`),abs(`instrumenten_inzichten_deviation`.`Deviation_2019`),abs(`instrumenten_inzichten_deviation`.`Deviation_2020`),abs(`instrumenten_inzichten_deviation`.`Deviation_2021`),abs(`instrumenten_inzichten_deviation`.`Deviation_2022`),abs(`instrumenten_inzichten_deviation`.`Deviation_2023`)) / `instrumenten_inzichten_deviation`.`Average` * 100,2) AS `Deviation_Percentage`, CASE WHEN abs(`instrumenten_inzichten_deviation`.`Deviation_2016`) = greatest(abs(`instrumenten_inzichten_deviation`.`Deviation_2016`),abs(`instrumenten_inzichten_deviation`.`Deviation_2017`),abs(`instrumenten_inzichten_deviation`.`Deviation_2018`),abs(`instrumenten_inzichten_deviation`.`Deviation_2019`),abs(`instrumenten_inzichten_deviation`.`Deviation_2020`),abs(`instrumenten_inzichten_deviation`.`Deviation_2021`),abs(`instrumenten_inzichten_deviation`.`Deviation_2022`),abs(`instrumenten_inzichten_deviation`.`Deviation_2023`)) THEN '2016' WHEN abs(`instrumenten_inzichten_deviation`.`Deviation_2017`) = greatest(abs(`instrumenten_inzichten_deviation`.`Deviation_2016`),abs(`instrumenten_inzichten_deviation`.`Deviation_2017`),abs(`instrumenten_inzichten_deviation`.`Deviation_2018`),abs(`instrumenten_inzichten_deviation`.`Deviation_2019`),abs(`instrumenten_inzichten_deviation`.`Deviation_2020`),abs(`instrumenten_inzichten_deviation`.`Deviation_2021`),abs(`instrumenten_inzichten_deviation`.`Deviation_2022`),abs(`instrumenten_inzichten_deviation`.`Deviation_2023`)) THEN '2017' WHEN abs(`instrumenten_inzichten_deviation`.`Deviation_2018`) = greatest(abs(`instrumenten_inzichten_deviation`.`Deviation_2016`),abs(`instrumenten_inzichten_deviation`.`Deviation_2017`),abs(`instrumenten_inzichten_deviation`.`Deviation_2018`),abs(`instrumenten_inzichten_deviation`.`Deviation_2019`),abs(`instrumenten_inzichten_deviation`.`Deviation_2020`),abs(`instrumenten_inzichten_deviation`.`Deviation_2021`),abs(`instrumenten_inzichten_deviation`.`Deviation_2022`),abs(`instrumenten_inzichten_deviation`.`Deviation_2023`)) THEN '2018' WHEN abs(`instrumenten_inzichten_deviation`.`Deviation_2019`) = greatest(abs(`instrumenten_inzichten_deviation`.`Deviation_2016`),abs(`instrumenten_inzichten_deviation`.`Deviation_2017`),abs(`instrumenten_inzichten_deviation`.`Deviation_2018`),abs(`instrumenten_inzichten_deviation`.`Deviation_2019`),abs(`instrumenten_inzichten_deviation`.`Deviation_2020`),abs(`instrumenten_inzichten_deviation`.`Deviation_2021`),abs(`instrumenten_inzichten_deviation`.`Deviation_2022`),abs(`instrumenten_inzichten_deviation`.`Deviation_2023`)) THEN '2019' WHEN abs(`instrumenten_inzichten_deviation`.`Deviation_2020`) = greatest(abs(`instrumenten_inzichten_deviation`.`Deviation_2016`),abs(`instrumenten_inzichten_deviation`.`Deviation_2017`),abs(`instrumenten_inzichten_deviation`.`Deviation_2018`),abs(`instrumenten_inzichten_deviation`.`Deviation_2019`),abs(`instrumenten_inzichten_deviation`.`Deviation_2020`),abs(`instrumenten_inzichten_deviation`.`Deviation_2021`),abs(`instrumenten_inzichten_deviation`.`Deviation_2022`),abs(`instrumenten_inzichten_deviation`.`Deviation_2023`)) THEN '2020' WHEN abs(`instrumenten_inzichten_deviation`.`Deviation_2021`) = greatest(abs(`instrumenten_inzichten_deviation`.`Deviation_2016`),abs(`instrumenten_inzichten_deviation`.`Deviation_2017`),abs(`instrumenten_inzichten_deviation`.`Deviation_2018`),abs(`instrumenten_inzichten_deviation`.`Deviation_2019`),abs(`instrumenten_inzichten_deviation`.`Deviation_2020`),abs(`instrumenten_inzichten_deviation`.`Deviation_2021`),abs(`instrumenten_inzichten_deviation`.`Deviation_2022`),abs(`instrumenten_inzichten_deviation`.`Deviation_2023`)) THEN '2021' WHEN abs(`instrumenten_inzichten_deviation`.`Deviation_2022`) = greatest(abs(`instrumenten_inzichten_deviation`.`Deviation_2016`),abs(`instrumenten_inzichten_deviation`.`Deviation_2017`),abs(`instrumenten_inzichten_deviation`.`Deviation_2018`),abs(`instrumenten_inzichten_deviation`.`Deviation_2019`),abs(`instrumenten_inzichten_deviation`.`Deviation_2020`),abs(`instrumenten_inzichten_deviation`.`Deviation_2021`),abs(`instrumenten_inzichten_deviation`.`Deviation_2022`),abs(`instrumenten_inzichten_deviation`.`Deviation_2023`)) THEN '2022' ELSE '2023' END AS `Highest_Deviation_Year` FROM `instrumenten_inzichten_deviation` ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
