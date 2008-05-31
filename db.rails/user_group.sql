-- MySQL dump 10.10
--
-- Host: localhost    Database: playground_forum
-- ------------------------------------------------------
-- Server version	5.0.20-Debian_1-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `php_forum_user_group`
--

DROP TABLE IF EXISTS `php_forum_user_group`;
CREATE TABLE `php_forum_user_group` (
  `group_id` mediumint(8) NOT NULL default '0',
  `user_id` mediumint(8) NOT NULL default '0',
  `user_pending` tinyint(1) default NULL,
  KEY `group_id` (`group_id`),
  KEY `user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `php_forum_user_group`
--


/*!40000 ALTER TABLE `php_forum_user_group` DISABLE KEYS */;
LOCK TABLES `php_forum_user_group` WRITE;
INSERT INTO `php_forum_user_group` VALUES (1,-1,0),(2,2,0),(3,3,0),(4,4,0),(3,5,0),(4,6,0),(5,7,0),(6,8,0),(7,9,0),(8,10,0),(9,11,0),(10,12,0),(11,13,0),(12,14,0),(13,15,0),(14,16,0),(15,17,0),(16,18,0),(17,19,0),(18,20,0),(19,21,0),(20,22,0),(21,23,0),(22,24,0),(23,25,0),(24,26,0),(25,27,0),(26,28,0),(27,29,0),(28,30,0),(29,31,0),(30,32,0),(31,33,0),(32,34,0),(33,35,0),(34,36,0),(35,37,0),(36,38,0),(37,39,0),(38,40,0),(39,41,0),(40,42,0),(41,43,0),(42,44,0),(43,45,0),(44,46,0),(45,47,0),(46,48,0),(47,49,0),(48,50,0),(89,90,0),(49,51,0),(711,90,0),(50,52,0),(88,89,0),(51,53,0),(711,89,0),(52,54,0),(87,88,0),(53,55,0),(711,88,0),(54,56,0),(86,87,0),(55,57,0),(711,87,0),(56,58,0),(85,86,0),(57,59,0),(711,86,0),(58,60,0),(84,85,0),(59,61,0),(711,85,0),(60,62,0),(83,84,0),(61,63,0),(711,84,0),(62,64,0),(82,83,0),(63,65,0),(711,83,0),(64,66,0),(81,82,0),(65,67,0),(711,82,0),(66,68,0),(80,81,0),(67,69,0),(711,81,0),(68,70,0),(79,80,0),(69,71,0),(711,80,0),(70,72,0),(78,79,0),(71,73,0),(711,79,0),(72,74,0),(77,78,0),(73,75,0),(711,78,0),(74,76,0),(76,17,0),(75,77,0),(76,3,0),(76,4,0);
UNLOCK TABLES;
/*!40000 ALTER TABLE `php_forum_user_group` ENABLE KEYS */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

