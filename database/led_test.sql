-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 16, 2025 at 02:10 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `led_test`
--

-- --------------------------------------------------------

--
-- Table structure for table `led`
--

CREATE TABLE `led` (
  `id` int(11) NOT NULL,
  `rfid_tag` varchar(50) NOT NULL,
  `led_pin` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `registered_rfid`
--

CREATE TABLE `registered_rfid` (
  `id` int(11) NOT NULL,
  `rfid_tag` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `registration_state`
--

CREATE TABLE `registration_state` (
  `id` int(11) NOT NULL,
  `state` tinyint(1) NOT NULL DEFAULT 0,
  `start_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `registration_state`
--

INSERT INTO `registration_state` (`id`, `state`, `start_time`) VALUES
(1, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `solenoid_locks`
--

CREATE TABLE `solenoid_locks` (
  `id` int(11) NOT NULL,
  `rfid_tag` varchar(50) NOT NULL,
  `locker_number` int(11) NOT NULL,
  `led_pin` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `led`
--
ALTER TABLE `led`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rfid_tag` (`rfid_tag`);

--
-- Indexes for table `registered_rfid`
--
ALTER TABLE `registered_rfid`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `rfid_tag` (`rfid_tag`);

--
-- Indexes for table `registration_state`
--
ALTER TABLE `registration_state`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `solenoid_locks`
--
ALTER TABLE `solenoid_locks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rfid_tag` (`rfid_tag`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `led`
--
ALTER TABLE `led`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `registered_rfid`
--
ALTER TABLE `registered_rfid`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `registration_state`
--
ALTER TABLE `registration_state`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `solenoid_locks`
--
ALTER TABLE `solenoid_locks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `led`
--
ALTER TABLE `led`
  ADD CONSTRAINT `led_ibfk_1` FOREIGN KEY (`rfid_tag`) REFERENCES `registered_rfid` (`rfid_tag`);

--
-- Constraints for table `solenoid_locks`
--
ALTER TABLE `solenoid_locks`
  ADD CONSTRAINT `solenoid_locks_ibfk_1` FOREIGN KEY (`rfid_tag`) REFERENCES `registered_rfid` (`rfid_tag`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
