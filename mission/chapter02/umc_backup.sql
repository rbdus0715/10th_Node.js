-- MySQL dump 10.13  Distrib 8.4.6, for macos15 (arm64)
--
-- Host: localhost    Database: umc
-- ------------------------------------------------------
-- Server version	8.4.6

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `food_category`
--

DROP TABLE IF EXISTS `food_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_category` (
  `id` bigint NOT NULL,
  `name` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_category`
--

LOCK TABLES `food_category` WRITE;
/*!40000 ALTER TABLE `food_category` DISABLE KEYS */;
INSERT INTO `food_category` VALUES (1,'한식'),(2,'일식'),(3,'중식'),(4,'양식'),(5,'치킨'),(6,'분식'),(7,'고기'),(8,'도시락'),(9,'야식'),(10,'디저트');
/*!40000 ALTER TABLE `food_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `image`
--

DROP TABLE IF EXISTS `image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `image` (
  `id` bigint NOT NULL,
  `org_name` varchar(100) NOT NULL,
  `stored_name` varchar(100) NOT NULL,
  `url` varchar(255) NOT NULL,
  `order` int NOT NULL,
  `target_type` enum('REVIEW','STORE','INQUIRY') NOT NULL,
  `target_id` bigint NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `image`
--

LOCK TABLES `image` WRITE;
/*!40000 ALTER TABLE `image` DISABLE KEYS */;
/*!40000 ALTER TABLE `image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inquiry`
--

DROP TABLE IF EXISTS `inquiry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inquiry` (
  `Id` bigint NOT NULL,
  `user_id` bigint NOT NULL COMMENT '누가 썼는지 역할',
  `category_id` bigint NOT NULL,
  `title` char(20) NOT NULL,
  `content` varchar(255) NOT NULL,
  `answer` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `answered_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_user_TO_inquiry_1` (`user_id`),
  KEY `FK_inquiry_category_TO_inquiry_1` (`category_id`),
  CONSTRAINT `FK_inquiry_category_TO_inquiry_1` FOREIGN KEY (`category_id`) REFERENCES `inquiry_category` (`id`),
  CONSTRAINT `FK_user_TO_inquiry_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inquiry`
--

LOCK TABLES `inquiry` WRITE;
/*!40000 ALTER TABLE `inquiry` DISABLE KEYS */;
INSERT INTO `inquiry` VALUES (1,1,1,'로그인이 안돼요','비밀번호를 잊어버렸습니다.',NULL,'2026-03-26 17:16:13.000000',NULL,NULL);
/*!40000 ALTER TABLE `inquiry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inquiry_category`
--

DROP TABLE IF EXISTS `inquiry_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inquiry_category` (
  `id` bigint NOT NULL,
  `name` char(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inquiry_category`
--

LOCK TABLES `inquiry_category` WRITE;
/*!40000 ALTER TABLE `inquiry_category` DISABLE KEYS */;
INSERT INTO `inquiry_category` VALUES (1,'계정문의'),(2,'결제문의'),(3,'이벤트문의');
/*!40000 ALTER TABLE `inquiry_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `location` (
  `id` bigint NOT NULL,
  `name` char(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `location`
--

LOCK TABLES `location` WRITE;
/*!40000 ALTER TABLE `location` DISABLE KEYS */;
INSERT INTO `location` VALUES (1,'서울'),(2,'경기'),(3,'부산');
/*!40000 ALTER TABLE `location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mission`
--

DROP TABLE IF EXISTS `mission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mission` (
  `id` bigint NOT NULL,
  `price` int NOT NULL,
  `point` int NOT NULL,
  `end_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL COMMENT '특정 과거시점 1999년을 넣어 null 피하기',
  `store_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_store_TO_mission_1` (`store_id`),
  CONSTRAINT `FK_store_TO_mission_1` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mission`
--

LOCK TABLES `mission` WRITE;
/*!40000 ALTER TABLE `mission` DISABLE KEYS */;
INSERT INTO `mission` VALUES (1,15000,1000,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,1),(2,30000,2500,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,1),(3,20000,1500,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,2),(4,50000,4000,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,2),(5,18000,1200,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,3),(6,40000,3000,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,3),(7,12000,800,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,4),(8,25000,2000,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,4),(9,10000,500,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,5),(10,22000,1800,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,5),(11,15000,1000,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,6),(12,35000,3000,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,6),(13,60000,5000,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,7),(14,100000,10000,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,7),(15,20000,1500,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,8),(16,45000,3500,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,8),(17,30000,2500,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,9),(18,55000,4500,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,9),(19,15000,1000,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,10),(20,28000,2200,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,10),(21,12000,500,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,1),(22,22000,1200,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,1),(23,35000,3000,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,1),(24,45000,4500,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,1),(25,13000,600,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,2),(26,26000,2000,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,2),(27,38000,3500,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,2),(28,11000,400,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,3),(29,29000,2500,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,3),(30,42000,4000,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,3),(31,16000,900,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,4),(32,31000,2800,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,4),(33,19000,1100,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,5),(34,55000,5000,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,5),(35,15000,1000,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,6),(36,25000,2000,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,6),(37,35000,3000,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,7),(38,45000,4500,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,7),(39,18000,1200,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,8),(40,28000,2200,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,8),(41,14000,700,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,9),(42,24000,1400,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,9),(43,34000,3200,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,10),(44,44000,4200,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,10),(45,17000,1000,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,1),(46,27000,2200,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,2),(47,37000,3200,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,3),(48,47000,4200,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,4),(49,18000,1300,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,5),(50,28000,2300,'2026-12-31 00:00:00','2026-03-26 17:16:12',NULL,NULL,6);
/*!40000 ALTER TABLE `mission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `id` bigint NOT NULL,
  `note_type` enum('INQUIRY','REVIEW','EVENT','MISSION') NOT NULL,
  `target_id` bigint NOT NULL,
  `title` char(20) NOT NULL,
  `content` varchar(255) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `receiver_id` bigint NOT NULL COMMENT 'null이라면 모두에게 전송',
  `sender_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_user_TO_notification_1` (`receiver_id`),
  KEY `FK_user_TO_notification_2` (`sender_id`),
  CONSTRAINT `FK_user_TO_notification_1` FOREIGN KEY (`receiver_id`) REFERENCES `user` (`id`),
  CONSTRAINT `FK_user_TO_notification_2` FOREIGN KEY (`sender_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
INSERT INTO `notification` VALUES (1,'MISSION',1,'미션 시작!','새로운 미션이 시작되었습니다.','2026-03-26 17:16:13.000000',1,2);
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_read`
--

DROP TABLE IF EXISTS `notification_read`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_read` (
  `id` bigint NOT NULL,
  `read_at` datetime(6) DEFAULT NULL,
  `user_id` bigint NOT NULL,
  `notification_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_user_TO_notification_read_1` (`user_id`),
  KEY `FK_notification_TO_notification_read_1` (`notification_id`),
  CONSTRAINT `FK_notification_TO_notification_read_1` FOREIGN KEY (`notification_id`) REFERENCES `notification` (`id`),
  CONSTRAINT `FK_user_TO_notification_read_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_read`
--

LOCK TABLES `notification_read` WRITE;
/*!40000 ALTER TABLE `notification_read` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_read` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `point`
--

DROP TABLE IF EXISTS `point`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `point` (
  `id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `amount` int NOT NULL,
  `source_type` enum('MISSION_COMPLETE','PURCHASE','EVENT','RETURN') NOT NULL,
  `source_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`,`user_id`),
  KEY `FK_user_TO_point_1` (`user_id`),
  CONSTRAINT `FK_user_TO_point_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `point`
--

LOCK TABLES `point` WRITE;
/*!40000 ALTER TABLE `point` DISABLE KEYS */;
INSERT INTO `point` VALUES (1,1,1000,'MISSION_COMPLETE',1,'2026-03-26 17:16:12.000000'),(2,2,1500,'MISSION_COMPLETE',3,'2026-03-26 17:16:12.000000'),(3,4,800,'MISSION_COMPLETE',7,'2026-03-26 17:16:12.000000'),(4,6,1000,'MISSION_COMPLETE',11,'2026-03-26 17:16:12.000000'),(5,8,1500,'MISSION_COMPLETE',15,'2026-03-26 17:16:12.000000'),(6,9,2500,'MISSION_COMPLETE',17,'2026-03-26 17:16:12.000000'),(7,11,2500,'MISSION_COMPLETE',2,'2026-03-26 17:16:12.000000'),(8,12,4000,'MISSION_COMPLETE',4,'2026-03-26 17:16:12.000000'),(9,13,3000,'MISSION_COMPLETE',6,'2026-03-26 17:16:12.000000'),(10,14,2000,'MISSION_COMPLETE',8,'2026-03-26 17:16:12.000000'),(11,15,1800,'MISSION_COMPLETE',10,'2026-03-26 17:16:12.000000'),(12,1,3000,'MISSION_COMPLETE',12,'2026-03-26 17:16:12.000000'),(13,2,10000,'MISSION_COMPLETE',14,'2026-03-26 17:16:12.000000'),(14,3,1500,'MISSION_COMPLETE',16,'2026-03-26 17:16:12.000000'),(15,4,4500,'MISSION_COMPLETE',18,'2026-03-26 17:16:12.000000'),(16,5,2200,'MISSION_COMPLETE',20,'2026-03-26 17:16:12.000000'),(17,1,500,'EVENT',1,'2026-03-26 17:16:12.000000'),(18,2,500,'EVENT',1,'2026-03-26 17:16:12.000000'),(19,3,500,'EVENT',1,'2026-03-26 17:16:12.000000'),(20,4,500,'EVENT',1,'2026-03-26 17:16:12.000000'),(21,1,1200,'MISSION_COMPLETE',22,'2026-03-26 17:16:12.000000'),(22,1,3000,'MISSION_COMPLETE',23,'2026-03-26 17:16:12.000000'),(23,1,4500,'MISSION_COMPLETE',24,'2026-03-26 17:16:12.000000'),(24,1,2000,'MISSION_COMPLETE',26,'2026-03-26 17:16:12.000000'),(25,1,400,'MISSION_COMPLETE',28,'2026-03-26 17:16:12.000000'),(26,1,2500,'MISSION_COMPLETE',29,'2026-03-26 17:16:12.000000'),(27,1,2800,'MISSION_COMPLETE',32,'2026-03-26 17:16:12.000000'),(28,1,5000,'MISSION_COMPLETE',34,'2026-03-26 17:16:12.000000'),(29,1,1000,'PURCHASE',101,'2026-03-26 17:16:12.000000'),(30,1,5000,'EVENT',202,'2026-03-26 17:16:12.000000');
/*!40000 ALTER TABLE `point` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `user_mission_id` bigint NOT NULL,
  `content` varchar(100) NOT NULL,
  `answer` varchar(100) DEFAULT NULL,
  `score` int DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `answered_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `user_id` bigint NOT NULL,
  `store_id` bigint NOT NULL,
  KEY `FK_user_mission_TO_review_1` (`user_mission_id`),
  KEY `FK_user_TO_review_1` (`user_id`),
  KEY `FK_store_TO_review_1` (`store_id`),
  CONSTRAINT `FK_store_TO_review_1` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`),
  CONSTRAINT `FK_user_mission_TO_review_1` FOREIGN KEY (`user_mission_id`) REFERENCES `user_mission` (`id`),
  CONSTRAINT `FK_user_TO_review_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
INSERT INTO `review` VALUES (1,'백다방 치킨 너무 바삭해요!',NULL,5,'2026-03-26 17:16:12',NULL,NULL,1,1),(2,'새마을 식당 연탄불고기 최고',NULL,5,'2026-03-26 17:16:12',NULL,NULL,1,2),(13,'목란 짜장면 면발이 살아있네요',NULL,4,'2026-03-26 17:16:12',NULL,NULL,1,3),(16,'또 시켜먹었습니다. 역시나 맛있음',NULL,5,'2026-03-26 17:16:12',NULL,NULL,1,1),(14,'교자 만두 속이 꽉 찼어요',NULL,5,'2026-03-26 17:16:12',NULL,NULL,1,4),(15,'집밥 생각날 때 딱입니다',NULL,4,'2026-03-26 17:16:12',NULL,NULL,1,5),(11,'가성비 좋은 식당입니다',NULL,3,'2026-03-26 17:16:12',NULL,NULL,1,2),(6,'한식 뷔페처럼 푸짐해요',NULL,5,'2026-03-26 17:16:12',NULL,NULL,1,6),(17,'분위기 내기 좋은 스테이크',NULL,5,'2026-03-26 17:16:12',NULL,NULL,1,7),(18,'파스타 소스가 꾸덕하니 제 스타일',NULL,4,'2026-03-26 17:16:12',NULL,NULL,1,8),(19,'딤섬 비주얼이 예술입니다',NULL,5,'2026-03-26 17:16:12',NULL,NULL,1,9),(20,'가족 외식으로 추천해요',NULL,5,'2026-03-26 17:16:12',NULL,NULL,1,10),(21,'치킨은 역시 여기가 1등',NULL,5,'2026-03-26 17:16:12',NULL,NULL,1,1),(22,'김치찌개 국물이 진해요',NULL,4,'2026-03-26 17:16:12',NULL,NULL,1,2),(23,'짬뽕 국물 시원합니다',NULL,5,'2026-03-26 17:16:12',NULL,NULL,1,3),(24,'서비스 만두 감사합니다!',NULL,5,'2026-03-26 17:16:12',NULL,NULL,1,4),(25,'반찬 구성이 매일 바뀌어서 좋아요',NULL,4,'2026-03-26 17:16:12',NULL,NULL,1,5),(26,'제육볶음 불맛 대박',NULL,5,'2026-03-26 17:16:12',NULL,NULL,1,6),(27,'와인 페어링이 완벽했어요',NULL,5,'2026-03-26 17:16:12',NULL,NULL,1,7),(28,'재방문 의사 100%입니다',NULL,5,'2026-03-26 17:16:12',NULL,NULL,1,8);
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `store`
--

DROP TABLE IF EXISTS `store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `store` (
  `id` bigint NOT NULL,
  `user_id` bigint NOT NULL COMMENT '비식별관계 - 사장님이 바뀔 수 있음',
  `name` varchar(20) NOT NULL,
  `open_at` time NOT NULL,
  `closed_at` time NOT NULL,
  `created_at` datetime NOT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_user_TO_store_1` (`user_id`),
  CONSTRAINT `FK_user_TO_store_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `store`
--

LOCK TABLES `store` WRITE;
/*!40000 ALTER TABLE `store` DISABLE KEYS */;
INSERT INTO `store` VALUES (1,16,'백다방 치킨','09:00:00','21:00:00','2026-03-26 17:16:12',NULL),(2,16,'새마을 식당','10:00:00','22:00:00','2026-03-26 17:16:12',NULL),(3,17,'목란 중식','11:00:00','21:00:00','2026-03-26 17:16:12',NULL),(4,17,'이연복 교자','11:30:00','20:00:00','2026-03-26 17:16:12',NULL),(5,18,'소희네 밥상','08:00:00','19:00:00','2026-03-26 17:16:12',NULL),(6,18,'만능 한식','10:00:00','22:00:00','2026-03-26 17:16:12',NULL),(7,19,'엘본 더 테이블','12:00:00','22:00:00','2026-03-26 17:16:12',NULL),(8,19,'최셰프 파스타','11:00:00','21:00:00','2026-03-26 17:16:12',NULL),(9,20,'티엔미미','11:00:00','22:00:00','2026-03-26 17:16:12',NULL),(10,20,'딤섬 왕국','10:30:00','21:00:00','2026-03-26 17:16:12',NULL);
/*!40000 ALTER TABLE `store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `store_category`
--

DROP TABLE IF EXISTS `store_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `store_category` (
  `category_id` bigint NOT NULL,
  `store_id` bigint NOT NULL,
  PRIMARY KEY (`category_id`,`store_id`),
  KEY `FK_store_TO_store_category_1` (`store_id`),
  CONSTRAINT `FK_food_category_TO_store_category_1` FOREIGN KEY (`category_id`) REFERENCES `food_category` (`id`),
  CONSTRAINT `FK_store_TO_store_category_1` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `store_category`
--

LOCK TABLES `store_category` WRITE;
/*!40000 ALTER TABLE `store_category` DISABLE KEYS */;
INSERT INTO `store_category` VALUES (1,1);
/*!40000 ALTER TABLE `store_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `term`
--

DROP TABLE IF EXISTS `term`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `term` (
  `id` bigint NOT NULL,
  `title` varchar(20) NOT NULL,
  `content` text NOT NULL,
  `is_required` tinyint NOT NULL,
  `user_type` enum('USER','STORE') DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `term`
--

LOCK TABLES `term` WRITE;
/*!40000 ALTER TABLE `term` DISABLE KEYS */;
INSERT INTO `term` VALUES (1,'이용약관','서비스 이용 약관 내용...',1,'USER'),(2,'개인정보처리방침','개인정보 관련 내용...',1,'USER');
/*!40000 ALTER TABLE `term` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` bigint NOT NULL,
  `nickname` varchar(10) NOT NULL,
  `gender` enum('MALE','FEMALE','NONE') NOT NULL,
  `birth` datetime DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `social_id` varchar(255) NOT NULL,
  `social_type` enum('KAKAO','NAVER','APPLE','GOOGLE') DEFAULT NULL,
  `phone_number` char(11) DEFAULT NULL,
  `Is_phone_verified` tinyint DEFAULT NULL,
  `phone_verified_at` datetime DEFAULT NULL,
  `address_doro` varchar(20) DEFAULT NULL,
  `address_detail` varchar(20) DEFAULT NULL,
  `profile_url` varchar(255) DEFAULT NULL,
  `role` enum('ADMIN','USER','STORE') DEFAULT NULL,
  `inquiry_answer_on` tinyint NOT NULL DEFAULT '0',
  `review_on` tinyint NOT NULL DEFAULT '0' COMMENT '유저라면 리뷰답변, 사장님이라면 리뷰알림',
  `event_on` tinyint NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'김철수','MALE',NULL,'user1@test.com','kakao_1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,'2026-03-26 17:16:12',NULL),(2,'이영희','FEMALE',NULL,'user2@test.com','kakao_2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,'2026-03-26 17:16:12',NULL),(3,'박민준','MALE',NULL,'user3@test.com','kakao_3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,'2026-03-26 17:16:12',NULL),(4,'최서연','FEMALE',NULL,'user4@test.com','kakao_4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,'2026-03-26 17:16:12',NULL),(5,'정예준','MALE',NULL,'user5@test.com','kakao_5',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,'2026-03-26 17:16:12',NULL),(6,'강지우','FEMALE',NULL,'user6@test.com','kakao_6',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,'2026-03-26 17:16:12',NULL),(7,'조도윤','MALE',NULL,'user7@test.com','kakao_7',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,'2026-03-26 17:16:12',NULL),(8,'윤서아','FEMALE',NULL,'user8@test.com','kakao_8',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,'2026-03-26 17:16:12',NULL),(9,'장하준','MALE',NULL,'user9@test.com','kakao_9',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,'2026-03-26 17:16:12',NULL),(10,'임지유','FEMALE',NULL,'user10@test.com','kakao_10',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,'2026-03-26 17:16:12',NULL),(11,'한주원','MALE',NULL,'user11@test.com','kakao_11',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,'2026-03-26 17:16:12',NULL),(12,'오소윤','FEMALE',NULL,'user12@test.com','kakao_12',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,'2026-03-26 17:16:12',NULL),(13,'서우진','MALE',NULL,'user13@test.com','kakao_13',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,'2026-03-26 17:16:12',NULL),(14,'권하윤','FEMALE',NULL,'user14@test.com','kakao_14',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,'2026-03-26 17:16:12',NULL),(15,'황민서','MALE',NULL,'user15@test.com','kakao_15',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USER',0,0,0,'2026-03-26 17:16:12',NULL),(16,'백종원','MALE',NULL,'owner1@test.com','naver_1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'STORE',0,0,0,'2026-03-26 17:16:12',NULL),(17,'이연복','MALE',NULL,'owner2@test.com','naver_2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'STORE',0,0,0,'2026-03-26 17:16:12',NULL),(18,'김소희','FEMALE',NULL,'owner3@test.com','naver_3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'STORE',0,0,0,'2026-03-26 17:16:12',NULL),(19,'최현석','MALE',NULL,'owner4@test.com','naver_4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'STORE',0,0,0,'2026-03-26 17:16:12',NULL),(20,'정지선','FEMALE',NULL,'owner5@test.com','naver_5',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'STORE',0,0,0,'2026-03-26 17:16:12',NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_favorite_food`
--

DROP TABLE IF EXISTS `user_favorite_food`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_favorite_food` (
  `food_category_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`food_category_id`,`user_id`),
  KEY `FK_user_TO_user_favorite_food_1` (`user_id`),
  CONSTRAINT `FK_food_category_TO_user_favorite_food_1` FOREIGN KEY (`food_category_id`) REFERENCES `food_category` (`id`),
  CONSTRAINT `FK_user_TO_user_favorite_food_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_favorite_food`
--

LOCK TABLES `user_favorite_food` WRITE;
/*!40000 ALTER TABLE `user_favorite_food` DISABLE KEYS */;
INSERT INTO `user_favorite_food` VALUES (1,1),(2,1);
/*!40000 ALTER TABLE `user_favorite_food` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_location`
--

DROP TABLE IF EXISTS `user_location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_location` (
  `location_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `selected` tinyint NOT NULL DEFAULT '0',
  KEY `FK_location_TO_user_location_1` (`location_id`),
  KEY `FK_user_TO_user_location_1` (`user_id`),
  CONSTRAINT `FK_location_TO_user_location_1` FOREIGN KEY (`location_id`) REFERENCES `location` (`id`),
  CONSTRAINT `FK_user_TO_user_location_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_location`
--

LOCK TABLES `user_location` WRITE;
/*!40000 ALTER TABLE `user_location` DISABLE KEYS */;
INSERT INTO `user_location` VALUES (1,1,1),(2,1,0);
/*!40000 ALTER TABLE `user_location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_mission`
--

DROP TABLE IF EXISTS `user_mission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_mission` (
  `id` bigint NOT NULL,
  `created_at` datetime NOT NULL,
  `status` enum('PROGRESS','PENDING','SUCCESS') NOT NULL DEFAULT 'PROGRESS' COMMENT 'pending:  신고 조치 등',
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `mission_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_mission_TO_user_mission_1` (`mission_id`),
  KEY `FK_user_TO_user_mission_1` (`user_id`),
  CONSTRAINT `FK_mission_TO_user_mission_1` FOREIGN KEY (`mission_id`) REFERENCES `mission` (`id`),
  CONSTRAINT `FK_user_TO_user_mission_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_mission`
--

LOCK TABLES `user_mission` WRITE;
/*!40000 ALTER TABLE `user_mission` DISABLE KEYS */;
INSERT INTO `user_mission` VALUES (1,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,1,1),(2,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,3,2),(3,'2026-03-26 17:16:12','PROGRESS',NULL,NULL,5,3),(4,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,7,4),(5,'2026-03-26 17:16:12','PENDING',NULL,NULL,9,5),(6,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,11,6),(7,'2026-03-26 17:16:12','PROGRESS',NULL,NULL,13,7),(8,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,15,8),(9,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,17,9),(10,'2026-03-26 17:16:12','PROGRESS',NULL,NULL,19,10),(11,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,2,11),(12,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,4,12),(13,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,6,13),(14,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,8,14),(15,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,10,15),(16,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,12,1),(17,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,14,2),(18,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,16,3),(19,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,18,4),(20,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,20,5),(21,'2026-03-26 17:16:12','PROGRESS',NULL,NULL,2,1),(22,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,4,3),(23,'2026-03-26 17:16:12','PENDING',NULL,NULL,6,5),(24,'2026-03-26 17:16:12','PROGRESS',NULL,NULL,8,7),(25,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,10,9),(26,'2026-03-26 17:16:12','PROGRESS',NULL,NULL,12,11),(27,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,14,13),(28,'2026-03-26 17:16:12','PENDING',NULL,NULL,16,15),(29,'2026-03-26 17:16:12','PROGRESS',NULL,NULL,18,2),(30,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,20,4),(31,'2026-03-26 17:16:12','PROGRESS',NULL,NULL,1,6),(32,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,3,8),(33,'2026-03-26 17:16:12','PENDING',NULL,NULL,5,10),(34,'2026-03-26 17:16:12','PROGRESS',NULL,NULL,7,12),(35,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,9,14),(36,'2026-03-26 17:16:12','PROGRESS',NULL,NULL,11,1),(37,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,13,3),(38,'2026-03-26 17:16:12','PENDING',NULL,NULL,15,5),(39,'2026-03-26 17:16:12','PROGRESS',NULL,NULL,17,7),(40,'2026-03-26 17:16:12','SUCCESS',NULL,NULL,19,9),(41,'2026-03-26 17:16:13','SUCCESS',NULL,NULL,2,1),(42,'2026-03-26 17:16:13','SUCCESS',NULL,NULL,3,1),(43,'2026-03-26 17:16:13','SUCCESS',NULL,NULL,4,1),(44,'2026-03-26 17:16:13','PROGRESS',NULL,NULL,5,1),(45,'2026-03-26 17:16:13','PROGRESS',NULL,NULL,6,1),(46,'2026-03-26 17:16:13','SUCCESS',NULL,NULL,7,1),(47,'2026-03-26 17:16:13','SUCCESS',NULL,NULL,8,1),(48,'2026-03-26 17:16:13','PENDING',NULL,NULL,9,1),(49,'2026-03-26 17:16:13','SUCCESS',NULL,NULL,10,1),(50,'2026-03-26 17:16:13','PROGRESS',NULL,NULL,11,1),(51,'2026-03-26 17:16:13','SUCCESS',NULL,NULL,13,1),(52,'2026-03-26 17:16:13','SUCCESS',NULL,NULL,14,1),(53,'2026-03-26 17:16:13','PROGRESS',NULL,NULL,15,1),(54,'2026-03-26 17:16:13','SUCCESS',NULL,NULL,16,1),(55,'2026-03-26 17:16:13','SUCCESS',NULL,NULL,17,1),(56,'2026-03-26 17:16:13','PROGRESS',NULL,NULL,18,1),(57,'2026-03-26 17:16:13','SUCCESS',NULL,NULL,19,1),(58,'2026-03-26 17:16:13','SUCCESS',NULL,NULL,20,1),(59,'2026-03-26 17:16:13','PROGRESS',NULL,NULL,21,1),(60,'2026-03-26 17:16:13','SUCCESS',NULL,NULL,22,1),(61,'2026-03-26 17:16:13','SUCCESS',NULL,NULL,23,1),(62,'2026-03-26 17:16:13','PROGRESS',NULL,NULL,24,1),(63,'2026-03-26 17:16:13','SUCCESS',NULL,NULL,25,1),(64,'2026-03-26 17:16:13','SUCCESS',NULL,NULL,26,1),(65,'2026-03-26 17:16:13','PROGRESS',NULL,NULL,27,1),(66,'2026-03-26 17:16:13','SUCCESS',NULL,NULL,28,1),(67,'2026-03-26 17:16:13','SUCCESS',NULL,NULL,29,1),(68,'2026-03-26 17:16:13','PROGRESS',NULL,NULL,30,1),(69,'2026-03-26 17:16:13','SUCCESS',NULL,NULL,31,1),(70,'2026-03-26 17:16:13','SUCCESS',NULL,NULL,32,1);
/*!40000 ALTER TABLE `user_mission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_term`
--

DROP TABLE IF EXISTS `user_term`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_term` (
  `term_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `agree_at` datetime NOT NULL,
  `cancel_at` datetime DEFAULT NULL,
  PRIMARY KEY (`term_id`,`user_id`),
  KEY `FK_user_TO_user_term_1` (`user_id`),
  CONSTRAINT `FK_term_TO_user_term_1` FOREIGN KEY (`term_id`) REFERENCES `term` (`id`),
  CONSTRAINT `FK_user_TO_user_term_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_term`
--

LOCK TABLES `user_term` WRITE;
/*!40000 ALTER TABLE `user_term` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_term` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-26 17:16:24
