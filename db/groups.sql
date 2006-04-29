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
-- Table structure for table `php_forum_groups`
--

DROP TABLE IF EXISTS `php_forum_groups`;
CREATE TABLE `php_forum_groups` (
  `group_id` mediumint(8) NOT NULL auto_increment,
  `group_type` tinyint(4) NOT NULL default '1',
  `group_name` varchar(40) NOT NULL default '',
  `group_description` varchar(255) NOT NULL default '',
  `group_moderator` mediumint(8) NOT NULL default '0',
  `group_single_user` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`group_id`),
  KEY `group_single_user` (`group_single_user`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `php_forum_groups`
--


/*!40000 ALTER TABLE `php_forum_groups` DISABLE KEYS */;
LOCK TABLES `php_forum_groups` WRITE;
INSERT INTO `php_forum_groups` VALUES (1,1,'Anonymous','Personal User',0,1),(2,1,'Admin','Personal User',0,1),(3,1,'','Personal User',0,1),(4,1,'','Personal User',0,1),(5,1,'','Personal User',0,1),(6,1,'','Personal User',0,1),(7,1,'','Personal User',0,1),(8,1,'','Personal User',0,1),(9,1,'','Personal User',0,1),(10,1,'','Personal User',0,1),(11,1,'','Personal User',0,1),(12,1,'','Personal User',0,1),(13,1,'','Personal User',0,1),(14,1,'','Personal User',0,1),(15,1,'','Personal User',0,1),(16,1,'','Personal User',0,1),(17,1,'','Personal User',0,1),(18,1,'','Personal User',0,1),(19,1,'','Personal User',0,1),(20,1,'','Personal User',0,1),(21,1,'','Personal User',0,1),(22,1,'','Personal User',0,1),(23,1,'','Personal User',0,1),(24,1,'','Personal User',0,1),(25,1,'','Personal User',0,1),(26,1,'','Personal User',0,1),(27,1,'','Personal User',0,1),(28,1,'','Personal User',0,1),(29,1,'','Personal User',0,1),(30,1,'','Personal User',0,1),(31,1,'','Personal User',0,1),(32,1,'','Personal User',0,1),(33,1,'','Personal User',0,1),(34,1,'','Personal User',0,1),(35,1,'','Personal User',0,1),(36,1,'','Personal User',0,1),(37,1,'','Personal User',0,1),(38,1,'','Personal User',0,1),(39,1,'','Personal User',0,1),(40,1,'','Personal User',0,1),(41,1,'','Personal User',0,1),(42,1,'','Personal User',0,1),(43,1,'','Personal User',0,1),(44,1,'','Personal User',0,1),(45,1,'','Personal User',0,1),(46,1,'','Personal User',0,1),(47,1,'','Personal User',0,1),(48,1,'','Personal User',0,1),(49,1,'','Personal User',0,1),(50,1,'','Personal User',0,1),(51,1,'','Personal User',0,1),(52,1,'','Personal User',0,1),(53,1,'','Personal User',0,1),(54,1,'','Personal User',0,1),(55,1,'','Personal User',0,1),(56,1,'','Personal User',0,1),(57,1,'','Personal User',0,1),(58,1,'','Personal User',0,1),(59,1,'','Personal User',0,1),(60,1,'','Personal User',0,1),(61,1,'','Personal User',0,1),(62,1,'','Personal User',0,1),(63,1,'','Personal User',0,1),(64,1,'','Personal User',0,1),(65,1,'','Personal User',0,1),(66,1,'','Personal User',0,1),(67,1,'','Personal User',0,1),(68,1,'','Personal User',0,1),(69,1,'','Personal User',0,1),(70,1,'','Personal User',0,1),(71,1,'','Personal User',0,1),(72,1,'','Personal User',0,1),(73,1,'','Personal User',0,1),(74,1,'','Personal User',0,1),(75,1,'','Personal User',0,1),(76,2,'beta_readers','have beta reader privileges',3,0),(77,1,'','Personal User',0,1),(78,1,'','Personal User',0,1),(79,1,'','Personal User',0,1),(80,1,'','Personal User',0,1),(81,1,'','Personal User',0,1),(82,1,'','Personal User',0,1),(83,1,'','Personal User',0,1),(84,1,'','Personal User',0,1),(85,1,'','Personal User',0,1),(86,1,'','Personal User',0,1),(87,1,'','Personal User',0,1),(88,1,'','Personal User',0,1),(89,1,'','Personal User',0,1);
UNLOCK TABLES;
/*!40000 ALTER TABLE `php_forum_groups` ENABLE KEYS */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

