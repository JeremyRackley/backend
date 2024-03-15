# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 11.3.2-MariaDB-1:11.3.2+maria~ubu2204)
# Database: limble
# Generation Time: 2024-03-15 02:04:58 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table locations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `locations`;

CREATE TABLE `locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;

INSERT INTO `locations` (`id`, `name`)
VALUES
	(1,'Davison'),
	(5,'Detroit'),
	(3,'Flint'),
	(2,'Lapeer'),
	(4,'Mayville');

/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table logged_time
# ------------------------------------------------------------

DROP TABLE IF EXISTS `logged_time`;

CREATE TABLE `logged_time` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time_seconds` int(11) NOT NULL,
  `task_id` int(11) NOT NULL,
  `worker_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `task_id` (`task_id`),
  KEY `worker_id` (`worker_id`),
  CONSTRAINT `logged_time_ibfk_1` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `logged_time_ibfk_2` FOREIGN KEY (`worker_id`) REFERENCES `workers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

LOCK TABLES `logged_time` WRITE;
/*!40000 ALTER TABLE `logged_time` DISABLE KEYS */;

INSERT INTO `logged_time` (`id`, `time_seconds`, `task_id`, `worker_id`)
VALUES
	(1,360,1,3),
	(2,3675,1,3),
	(3,3675,2,2),
	(4,3675,1,2),
	(5,5285,2,4),
	(6,285,2,4),
	(7,285,4,4),
	(8,285,3,1);

/*!40000 ALTER TABLE `logged_time` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table tasks
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tasks`;

CREATE TABLE `tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL,
  `location_id` int(11) NOT NULL,
  `status` enum('complete','incomplete') NOT NULL DEFAULT 'incomplete',
  PRIMARY KEY (`id`),
  KEY `location_id` (`location_id`),
  CONSTRAINT `tasks_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;

INSERT INTO `tasks` (`id`, `description`, `location_id`, `status`)
VALUES
	(1,'this is a test task',1,'incomplete'),
	(2,'Accounting',1,'complete'),
	(3,'Marketing',2,'incomplete'),
	(4,'Fixing Appliances',3,'complete');

/*!40000 ALTER TABLE `tasks` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table workers
# ------------------------------------------------------------

DROP TABLE IF EXISTS `workers`;

CREATE TABLE `workers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `hourly_wage` decimal(5,2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

LOCK TABLES `workers` WRITE;
/*!40000 ALTER TABLE `workers` DISABLE KEYS */;

INSERT INTO `workers` (`id`, `username`, `hourly_wage`)
VALUES
	(1,'jrackley',22.00),
	(2,'vrackley',23.00),
	(3,'arackley',13.00),
	(4,'srackley',13.00);

/*!40000 ALTER TABLE `workers` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
