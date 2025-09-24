-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 24, 2025 at 03:50 PM
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
-- Database: `apartment_db`
--
CREATE DATABASE IF NOT EXISTS `apartment_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `apartment_db`;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `mobile` varchar(15) DEFAULT NULL,
  `role` varchar(20) NOT NULL COMMENT 'Can be ADMIN, OWNER, TENANT, SECURITY',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `email`, `first_name`, `last_name`, `mobile`, `role`, `created_at`) VALUES
(4, 'admin', '123456', 'rohhh3555@gmail.com', 'Praveen', 'C', '9988774455', 'ADMIN', '2025-08-13 06:52:31'),
(5, 'owner', '123456', 'channabasayyahuddar@gmail.com', 'ROHIT', 'Teguramath', '98451025', 'OWNER', '2025-08-13 07:26:18'),
(6, 'security', '123456', '01fe23mca026@kletech.ac.in', 'Tejesh', 'M', '7022263789', 'SECURITY', '2025-08-16 05:12:49'),
(7, 'tenant2', 'Rohhh@1715', 'tenant@gmail.com', 'tenant ', '2', '9988774455', 'TENANT', '2025-09-01 06:18:35'),
(8, 'pooja', 'Pooja@15', 'pooja@gmail.com', 'pooja', 'G', '9988774455', 'TENANT', '2025-09-10 15:42:01'),
(11, 'Sumant', 'Sumant@123', 'sumantkulkarni1029@gmail.com', 'Sumant', 'Kulkarni', '7022263758', 'TENANT', '2025-09-19 14:13:34'),
(12, 'Tenant', 'Tenant@1234', 'rohitbt1715@gmail.com', 'john', 'Fernandes', '9845705578', 'TENANT', '2025-09-20 16:43:33');

-- --------------------------------------------------------

--
-- Table structure for table `apartments`
--

DROP TABLE IF EXISTS `apartments`;
CREATE TABLE `apartments` (
  `apartment_id` int(11) NOT NULL,
  `block_name` varchar(50) NOT NULL,
  `flat_number` varchar(20) NOT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `tenant_id` int(11) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Vacant'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `apartments`
--

INSERT INTO `apartments` (`apartment_id`, `block_name`, `flat_number`, `owner_id`, `tenant_id`, `status`) VALUES
(1, 'A', '101', 5, 7, 'Occupied'),
(2, 'B', '201', NULL, NULL, 'Vacant'),
(3, 'C', '301', 5, NULL, 'Vacant'),
(4, 'D', '501', 5, NULL, 'Vacant'),
(5, 'A', '201', 5, 8, 'Occupied'),
(7, 'A', '401', 5, NULL, 'Vacant'),
(8, 'H', '201', 5, NULL, 'Vacant'),
(10, 'F', '201', 5, 11, 'Occupied'),
(11, 'N', '2', 5, 12, 'Occupied');


-- --------------------------------------------------------

--
-- Table structure for table `tenants`
--

DROP TABLE IF EXISTS `tenants`;
CREATE TABLE `tenants` (
  `tenant_id` int(11) NOT NULL,
  `tenant_user_id` int(11) NOT NULL,
  `apartment_id` int(11) NOT NULL,
  `move_in_date` date DEFAULT NULL,
  `monthly_rent` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tenants`
--

INSERT INTO `tenants` (`tenant_id`, `tenant_user_id`, `apartment_id`, `move_in_date`, `monthly_rent`) VALUES
(1, 7, 1, '2025-09-10', 12345.00),
(2, 8, 5, '2025-09-15', 3000.00),
(3, 11, 10, '2025-09-20', 2500.00),
(4, 12, 11, '2025-09-21', 3500.00);


-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `apartment_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_type` varchar(50) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Paid',
  `transaction_id` varchar(50) DEFAULT NULL,
  `payment_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`payment_id`, `user_id`, `apartment_id`, `amount`, `payment_type`, `status`, `transaction_id`, `payment_date`) VALUES
(8, 7, 1, 550.00, 'Rent', 'Paid', '047795CA-EA3', '2025-09-01 00:00:00'),
(10, 8, 5, 200.00, 'Credit Card', 'Paid', '862B82CB-67E8', '2025-09-11 00:00:00'),
(16, 11, 10, 2500.00, 'UPI', 'Paid', '982460D5-E9AA', '2025-09-19 00:00:00'),
(17, 12, 11, 2500.00, 'Credit Card', 'Paid', '1299E640-9B92', '2025-09-20 22:34:01'),
(18, 12, 11, 3500.00, 'UPI', 'Paid', 'FCEE4108-D27D', '2025-09-20 23:06:34');


-- --------------------------------------------------------

--
-- Table structure for table `complaints`
--

DROP TABLE IF EXISTS `complaints`;
CREATE TABLE `complaints` (
  `complaint_id` int(11) NOT NULL,
  `resident_id` int(11) NOT NULL,
  `issue_type` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Open',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `complaints`
--

INSERT INTO `complaints` (`complaint_id`, `resident_id`, `issue_type`, `description`, `status`, `created_at`, `updated_at`) VALUES
(7, 8, 'Security', 'no security at 3 pm ', 'In Progress', '2025-09-14 15:07:24', '2025-09-14 15:08:36'),
(8, 8, 'Maintenance', 'not cleaning the room ', 'Open', '2025-09-17 15:06:47', '2025-09-17 15:06:47'),
(10, 8, 'Maintenance', 'nothing has done ', 'In Progress', '2025-09-18 13:28:55', '2025-09-18 14:06:54'),
(11, 8, 'Other', 'nothing ', 'Resolved', '2025-09-18 13:58:31', '2025-09-18 14:01:32'),
(12, 8, 'Noise', 'Lot of noise due to neighbors party ', 'In Progress', '2025-09-19 13:37:39', '2025-09-19 13:46:49'),
(14, 12, 'Maintenance', 'No electricity in my house ', 'Resolved', '2025-09-21 16:32:59', '2025-09-21 16:37:52'),
(15, 12, 'Maintenance', 'water leakage ', 'In Progress', '2025-09-22 05:40:19', '2025-09-22 05:45:11');

-- --------------------------------------------------------

--
-- Table structure for table `notices`
--

DROP TABLE IF EXISTS `notices`;
CREATE TABLE `notices` (
  `notice_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `valid_till` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notices`
--

INSERT INTO `notices` (`notice_id`, `title`, `description`, `created_by`, `created_at`, `valid_till`) VALUES
(2, 'Tomorrow swimming pool will be closed', 'Due to cleaning purpose.', 4, '2025-09-11 07:39:07', '2025-09-12'),
(3, 'No parties will be allowed in the apartment', 'Effective immediately, no parties will be allowed in the apartment common areas.', 4, '2025-09-14 13:17:13', '2025-09-15'),
(5, 'DJ Party Night', 'Community DJ party will be held tomorrow evening.', 4, '2025-09-17 14:08:22', '2025-09-18'),
(12, 'Regarding Electricity Shutdown', 'Electricity is turned off due to heavy rain.', 4, '2025-09-20 16:50:28', '2025-09-21');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `link` varchar(255) DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notification_id`, `user_id`, `message`, `link`, `is_read`, `created_at`) VALUES
(29, 8, 'Admin updated status of complaint #11 to ''Resolved''.', 'complaints', 1, '2025-09-18 14:01:32'),
(30, 5, 'Status of a complaint for your property was updated to ''Resolved''.', 'owner-complaints', 1, '2025-09-18 14:01:32'),
(31, 8, 'Admin updated the status of your ''Maintenance'' complaint to ''In Progress''.', 'complaints', 1, '2025-09-18 14:06:54'),
(32, 5, 'Status of a complaint for your property was updated to ''In Progress''.', 'owner-complaints', 1, '2025-09-18 14:06:54'),
(52, 12, 'Admin updated the status of your ''Maintenance'' complaint to ''Resolved''.', 'complaints', 1, '2025-09-21 16:37:52'),
(53, 5, 'Status of a complaint for your property was updated to ''Resolved''.', 'owner-complaints', 1, '2025-09-21 16:37:52'),
(56, 12, 'Admin updated the status of your ''Maintenance'' complaint to ''In Progress''.', 'complaints', 0, '2025-09-22 05:45:11'),
(57, 5, 'Status of a complaint for your property was updated to ''In Progress''.', 'owner-complaints', 1, '2025-09-22 05:45:11');

-- --------------------------------------------------------

--
-- Table structure for table `user_otps`
--

DROP TABLE IF EXISTS `user_otps`;
CREATE TABLE `user_otps` (
  `otp_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `otp_code` varchar(6) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expires_at` timestamp NULL DEFAULT NULL,
  `is_used` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_otps`
--

INSERT INTO `user_otps` (`otp_id`, `user_id`, `otp_code`, `created_at`, `expires_at`, `is_used`) VALUES
(48, 5, '621490', '2025-09-22 05:45:50', '2025-09-22 00:25:50', 1),
(49, 6, '588756', '2025-09-22 05:48:41', '2025-09-22 00:28:41', 1),
(50, 12, '783151', '2025-09-22 05:50:13', '2025-09-22 00:30:13', 1),
(51, 12, '210466', '2025-09-22 05:51:31', '2025-09-22 00:31:31', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `apartments`
--
ALTER TABLE `apartments`
  ADD PRIMARY KEY (`apartment_id`),
  ADD KEY `owner_id` (`owner_id`),
  ADD KEY `tenant_id` (`tenant_id`);

--
-- Indexes for table `tenants`
--
ALTER TABLE `tenants`
  ADD PRIMARY KEY (`tenant_id`),
  ADD UNIQUE KEY `tenant_user_id` (`tenant_user_id`),
  ADD KEY `apartment_id` (`apartment_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `apartment_id` (`apartment_id`);

--
-- Indexes for table `complaints`
--
ALTER TABLE `complaints`
  ADD PRIMARY KEY (`complaint_id`),
  ADD KEY `resident_id` (`resident_id`);

--
-- Indexes for table `notices`
--
ALTER TABLE `notices`
  ADD PRIMARY KEY (`notice_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `user_otps`
--
ALTER TABLE `user_otps`
  ADD PRIMARY KEY (`otp_id`),
  ADD KEY `user_id` (`user_id`);


--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `apartments`
--
ALTER TABLE `apartments`
  MODIFY `apartment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `tenants`
--
ALTER TABLE `tenants`
  MODIFY `tenant_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `complaints`
--
ALTER TABLE `complaints`
  MODIFY `complaint_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `notices`
--
ALTER TABLE `notices`
  MODIFY `notice_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT for table `user_otps`
--
ALTER TABLE `user_otps`
  MODIFY `otp_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;


--
-- Constraints for dumped tables
--

--
-- Constraints for table `apartments`
--
ALTER TABLE `apartments`
  ADD CONSTRAINT `apartments_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `apartments_ibfk_2` FOREIGN KEY (`tenant_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `tenants`
--
ALTER TABLE `tenants`
  ADD CONSTRAINT `tenants_ibfk_1` FOREIGN KEY (`tenant_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tenants_ibfk_2` FOREIGN KEY (`apartment_id`) REFERENCES `apartments` (`apartment_id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`apartment_id`) REFERENCES `apartments` (`apartment_id`) ON DELETE CASCADE;

--
-- Constraints for table `complaints`
--
ALTER TABLE `complaints`
  ADD CONSTRAINT `complaints_ibfk_1` FOREIGN KEY (`resident_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `notices`
--
ALTER TABLE `notices`
  ADD CONSTRAINT `notices_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `user_otps`
--
ALTER TABLE `user_otps`
  ADD CONSTRAINT `user_otps_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

