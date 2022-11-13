CREATE DATABASE  IF NOT EXISTS `ipm` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `ipm`;
-- MySQL dump 10.13  Distrib 8.0.28, for Win64 (x86_64)
--
-- Host: localhost    Database: ipm
-- ------------------------------------------------------
-- Server version	8.0.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `adminsemester`
--

DROP TABLE IF EXISTS `adminsemester`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `adminsemester` (
  `Year` year NOT NULL,
  `Semester` int unsigned NOT NULL,
  PRIMARY KEY (`Year`,`Semester`),
  CONSTRAINT `adminsemester_chk_1` CHECK ((`Semester` in (1,2)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adminsemester`
--

LOCK TABLES `adminsemester` WRITE;
/*!40000 ALTER TABLE `adminsemester` DISABLE KEYS */;
INSERT INTO `adminsemester` VALUES (2022,1);
/*!40000 ALTER TABLE `adminsemester` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company_selections`
--

DROP TABLE IF EXISTS `company_selections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company_selections` (
  `Industry_host_id` int unsigned NOT NULL,
  `Students_id` int unsigned NOT NULL,
  `responses` int unsigned NOT NULL,
  `additional_note` mediumtext,
  `match_confirmation` tinyint DEFAULT '0',
  PRIMARY KEY (`Students_id`,`Industry_host_id`),
  KEY `fk_Selections_Students1_idx` (`Students_id`),
  KEY `fk_Selections_Companies1_idx` (`Industry_host_id`),
  CONSTRAINT `fk_Selections_Companies1` FOREIGN KEY (`Industry_host_id`) REFERENCES `industry_host` (`Industry_host_id`),
  CONSTRAINT `fk_Selections_Students1` FOREIGN KEY (`Students_id`) REFERENCES `students` (`student_id`),
  CONSTRAINT `company_selections_chk_1` CHECK ((`responses` in (1,2,3)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_selections`
--

LOCK TABLES `company_selections` WRITE;
/*!40000 ALTER TABLE `company_selections` DISABLE KEYS */;
/*!40000 ALTER TABLE `company_selections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elective`
--

DROP TABLE IF EXISTS `elective`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elective` (
  `Elective_id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `course_description` mediumtext,
  PRIMARY KEY (`Elective_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elective`
--

LOCK TABLES `elective` WRITE;
/*!40000 ALTER TABLE `elective` DISABLE KEYS */;
INSERT INTO `elective` VALUES (1,'User Experience','This is a practical exploration of the foundations, evolution and principles (including theory)\n that define and measure how humans interact with computers and computer-based information. '),(2,'User Engagement & Business Analysis',''),(3,'Neural Networks','You\'ll be immersed in neural network fundamentals, looking at network architectures and learning \r methods and how to apply it.'),(4,'Advanced Programming',''),(5,'Geographic Information Systems (GIS)','A course to introduce you to how Geographic Information Systems are used in the modelling and \nanalysis of spatial problems. '),(6,'Advanced Database Management','In this course, you will develop advanced database management skill in designing, implementing \nand administering database.'),(7,'Other','');
/*!40000 ALTER TABLE `elective` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_attendance`
--

DROP TABLE IF EXISTS `host_attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `host_attendance` (
  `Industry_host_id` int unsigned NOT NULL,
  `Year` year NOT NULL,
  `Semester` int unsigned NOT NULL,
  `selection_status` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`Industry_host_id`,`Year`,`Semester`),
  CONSTRAINT `fk_host_attendance_Industry_host1` FOREIGN KEY (`Industry_host_id`) REFERENCES `industry_host` (`Industry_host_id`),
  CONSTRAINT `host_attendance_chk_1` CHECK ((`semester` in (1,2)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_attendance`
--

LOCK TABLES `host_attendance` WRITE;
/*!40000 ALTER TABLE `host_attendance` DISABLE KEYS */;
INSERT INTO `host_attendance` VALUES (217,2022,1,0),(218,2022,1,0),(219,2022,1,0),(220,2022,1,0),(221,2022,1,0),(222,2022,1,0),(223,2022,1,0),(224,2022,1,0),(225,2022,1,0),(226,2022,1,0),(227,2022,1,0),(229,2022,1,0),(230,2022,1,0),(231,2022,1,0),(235,2022,1,0),(237,2022,1,0);
/*!40000 ALTER TABLE `host_attendance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `industry_host`
--

DROP TABLE IF EXISTS `industry_host`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `industry_host` (
  `Industry_host_id` int unsigned NOT NULL,
  `organization_name` varchar(64) NOT NULL,
  `contact_name` varchar(80) NOT NULL,
  `contact_phone` varchar(25) DEFAULT NULL,
  `contact_email` varchar(100) NOT NULL,
  PRIMARY KEY (`Industry_host_id`),
  UNIQUE KEY `contact_email_UNIQUE` (`contact_email`),
  UNIQUE KEY `contact_number_UNIQUE` (`contact_phone`),
  CONSTRAINT `fk_Industry_host_Users1` FOREIGN KEY (`Industry_host_id`) REFERENCES `users` (`Users_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `industry_host`
--

LOCK TABLES `industry_host` WRITE;
/*!40000 ALTER TABLE `industry_host` DISABLE KEYS */;
INSERT INTO `industry_host` VALUES (217,'SERVERWORKS LTD','Kraig Winters','021433851','kraig@serverworks.co.nz'),(218,'FRIZZELL LTD','Alastair Frizzell','03 3181333','alastair@frizzell.co.nz'),(219,'WEBTOOLS AGRITECH','Melissa Baer','0210574901','melissa@webtools.co.nz'),(220,'POSBIZ LIMITED','Penny Maxwell','0272400320','penny@posbiz.co.nz'),(221,'4TECHNOLOGY','Grant Meikle','021438796','grant@4technology.net'),(222,'MOGO LABS LTD','Dave Snell','0274446927','dave@mogolabs.com'),(223,'QUEST INTEGRITY NZL LTD','Alice Young','049786666','a.young@questintegrity.com'),(224,'WEBSITE DEVELOPERS LTD','Jim Thorpe','027 322 5750','jim@website-developers.co.nz'),(225,'ORION HEALTH','Chris Borrill','021 026 03866','chris.borrill@orionhealth.com'),(226,'CORDE LTD','Barry Clark','0274065780','barry.clark@corde.nz'),(227,'OSSABILITY','Seamus Tredinnick',NULL,'seamus@ossability.com'),(228,'TIDY INTERNATIONAL (NZ) LIMITED','Kevin Mann','021555472','kevin.mann@tidyint.com'),(229,'AGRESEARCH LTD','Mos Sharifi','0211924431','mos.sharifi@agresearch.co.nz'),(230,'VIRTUAL MEDICAL COACHING','James Hayes',NULL,'james.hayes@virtualmedicalcoaching.com'),(231,'PLANT AND FOOD RESEARCH','Chetan Baadkar','0220236633','chetan.baadkar@plantandfood.co.nz'),(232,'Test ltd','Craig Melton','03319601','Craig.melton@email.com'),(233,'ORBICA','Gareth Levens',NULL,'gareth@orbica.world'),(234,'TEST 2 LTD','Mary Whitehouse','024521446','Mary_Whitehouse@OrienEnergy.com'),(235,'TEST 3 LTD','Mary Whitehouse','03312701','Mary.Whitehouse@Test3.com'),(236,'TEST 4 LTD','Anthony Smith2','03312602','Anthony.Smith2@Test4.com'),(237,'TEST 5 LTD','Anthony Smith3','03312603','Anthony.Smith3@Test5.com');
/*!40000 ALTER TABLE `industry_host` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interviews`
--

DROP TABLE IF EXISTS `interviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interviews` (
  `Interviews_id` int unsigned NOT NULL AUTO_INCREMENT,
  `Students_id` int unsigned NOT NULL,
  `Industry_host_id` int unsigned NOT NULL,
  `comments` mediumtext NOT NULL,
  `rating` int unsigned NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`Interviews_id`),
  UNIQUE KEY `Interviews_id_UNIQUE` (`Interviews_id`),
  KEY `fk_Interviews_Students1_idx` (`Students_id`),
  KEY `fk_Interviews_Companies1_idx` (`Industry_host_id`),
  CONSTRAINT `fk_Interviews_Companies1` FOREIGN KEY (`Industry_host_id`) REFERENCES `industry_host` (`Industry_host_id`),
  CONSTRAINT `fk_Interviews_Students1` FOREIGN KEY (`Students_id`) REFERENCES `students` (`student_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2668842244 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interviews`
--

LOCK TABLES `interviews` WRITE;
/*!40000 ALTER TABLE `interviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `interviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `placement`
--

DROP TABLE IF EXISTS `placement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `placement` (
  `Students_id` int unsigned NOT NULL,
  `Projects_id` int unsigned NOT NULL,
  PRIMARY KEY (`Students_id`,`Projects_id`),
  KEY `fk_Placement_Projects1_idx` (`Projects_id`),
  CONSTRAINT `fk_Placement_Projects1` FOREIGN KEY (`Projects_id`) REFERENCES `projects` (`Projects_id`),
  CONSTRAINT `fk_Placement_Students1` FOREIGN KEY (`Students_id`) REFERENCES `students` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `placement`
--

LOCK TABLES `placement` WRITE;
/*!40000 ALTER TABLE `placement` DISABLE KEYS */;
/*!40000 ALTER TABLE `placement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_tech_rank`
--

DROP TABLE IF EXISTS `project_tech_rank`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_tech_rank` (
  `Projects_id` int unsigned NOT NULL,
  `Technologies_id` int unsigned NOT NULL,
  `rank_number` int unsigned NOT NULL,
  PRIMARY KEY (`Projects_id`,`Technologies_id`),
  KEY `fk_project_tech_rank_Technology1_idx` (`Technologies_id`),
  CONSTRAINT `fk_project_tech_rank_Projects1` FOREIGN KEY (`Projects_id`) REFERENCES `projects` (`Projects_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_project_tech_rank_Technology1` FOREIGN KEY (`Technologies_id`) REFERENCES `technology` (`Technologies_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_tech_rank`
--

LOCK TABLES `project_tech_rank` WRITE;
/*!40000 ALTER TABLE `project_tech_rank` DISABLE KEYS */;
INSERT INTO `project_tech_rank` VALUES (43,5,2),(43,14,1),(43,15,3),(43,16,4),(44,14,3),(44,15,1),(44,16,2),(45,5,6),(45,6,5),(45,14,4),(45,15,1),(45,16,2),(45,17,3),(46,5,3),(46,14,1),(46,17,2),(47,17,1),(48,16,1),(49,5,2),(49,6,3),(49,9,1),(50,6,1),(50,14,2),(53,15,1),(54,5,3),(54,14,2),(54,16,1);
/*!40000 ALTER TABLE `project_tech_rank` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projects`
--

DROP TABLE IF EXISTS `projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projects` (
  `Projects_id` int unsigned NOT NULL AUTO_INCREMENT,
  `Industry_host_id` int unsigned NOT NULL,
  `Tech_id` int unsigned DEFAULT NULL,
  `project_description` mediumtext NOT NULL,
  `potential_placements` int unsigned NOT NULL DEFAULT '1',
  `year` year NOT NULL,
  `semester` int NOT NULL,
  PRIMARY KEY (`Projects_id`),
  KEY `fk_Projects_Companies1_idx` (`Industry_host_id`),
  KEY `fk_Projects_Tech_person1_idx` (`Tech_id`),
  CONSTRAINT `fk_Projects_Companies1` FOREIGN KEY (`Industry_host_id`) REFERENCES `industry_host` (`Industry_host_id`),
  CONSTRAINT `fk_Projects_Tech_person1` FOREIGN KEY (`Tech_id`) REFERENCES `tech_person` (`Tech_id`),
  CONSTRAINT `projects_chk_1` CHECK ((`semester` in (1,2)))
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projects`
--

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
INSERT INTO `projects` VALUES (40,217,132,'A proof of concept project around health and safety that involves wearable tech (generic smart watch), a hardware controller (built), and signaling via various networks (could be LTE, could be Iridium Short Burst Satellite network). We already have hardware prototypes and are now needing the software aspect complete. We are not looking for a production ready solution, we just need to get the hardware to a proof of concept in the field (literally a field - on a tractor).',1,2022,2),(41,218,133,'Front end development including design to handle data from our Smart Paddock weigher.',1,2022,2),(42,219,134,'We are designing software for the primary sector and value chain. We focus on primary processors, where we help them capture behind the gate data and then ensure processors have the visibility and data to demonstrate market access requirements as well as value add story telling for niche categories.',1,2022,2),(43,220,135,'Creating a module within our software\nOr replacing a patched piece of back end software with a proper platform',1,2022,2),(44,221,136,'We have a number of extension projects in mind in the areas that Chris Tulley\'s  and Hon Lim Choong\'s this years projects are focussed on. The technology and related solutions are massively important for Food & Beverage producers and manufacturers in New Zealand and Australia. The projects will focus on finding practical and affordable solutions for the fast growing F&B exporter, based on earlier work done.',1,2022,2),(45,222,137,'We currently have a product called GoFreight, which is a Transport Management System.\n\nWe have a number of aspects of our product that we would like to explore and can easily isolate so a student could work on them.\n\n1. OCR\n2. Prototyping for our mobile app\n3. Twin Screen functionality\n4. Analysis of work flows',1,2022,2),(46,223,138,'End goal: Develop a program to search for specific files across multiple servers using keywords etc. The basic concept is for something similar to a reference manager, but without the need to store the files within the program itself. \nWe have an existing program for searching internal reports that this could be modelled on – project scope may be extended to involve merging the two, if time allows.',1,2022,2),(47,224,139,'I could potentially provide a range of projects.\nSmall robotics project, Angular app development, iOS/Android app development.\nI\'d be keen to come along and find out more about the requirements for hosting a student.',1,2022,2),(48,225,140,'We have a web application which only works in Internet Explorer Enterprise Mode (EMIE) and does not work in modern browsers such as Chrome and Firefox. The project is understand and fix the issues which are preventing the web pages working correctly.',1,2022,2),(49,226,141,'This will be a research project focused on IOT and its uses in better managing clients assets e.g water, wastewater, Parks.\n\nThe objective will be to research and highlight how the data captured through IOT sensors could be used to facilitate better decision making for maintenance programs',1,2022,2),(50,227,142,'OssAbility is a small biomedical engineering company. We help veterinarians treat cruciate disease using 3D printed implants, clever instrumentation and ongoing case support. Over the years, we have collected plenty of clinical data for analysis. Our project consists of cleaning and processing historical data from our CRM into a consolidated database, as well as analysing and visualising data to give business insight.',1,2022,2),(51,228,142,'We have a number of possible projects however a few, I believe, could be a very good match to Lincolns degree programme:\n\nProject 1. To help build an industry vertical team model: This project would identify the skills necessary (and scope) in serving the needs of a defined industry. For instance; what is the ideal team mix to have a full service customer team? Another consideration is the optimal team size to serve a to-be-determined population of that vertical specialty. The vertical might be (say) \"tradies\" or \"manufacturers\" or \"retailers\". Can one team posses the range of skills necessary to serve this industry group? etc. This project requires research of successful and unsuccessful attempts to bring high customer experience/satisfaction with  the best economies of scale.\n\nProject 2: To design (or at least consider) all of the necessary elements to a GIS module to Tidy\'s product set. There are specific current customers of Tidy\'s who would be available to interact with on this project as they have a range of GIS-related needs.',1,2022,2),(52,229,143,'* UHF RFID Technology for on-farm identification and monitoring\n* Robotics and automation for on-farm automation',1,2022,2),(53,230,144,'Using machine learning in medical training simulations, specifically image generation, soft body physics simulation, ray tracing optimization.\n\nSkills of interest would be machine learning and graphics. Ideally someone combining those two interests.',1,2022,2),(54,231,145,'Writing  “e2e” (end-to-end) automation testing for  one of our applications.  We will require a student to write tests in Katalon suite, which is mainly Java.',1,2022,2),(55,232,146,'Stuff and things 5.0',1,2022,2);
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_electives`
--

DROP TABLE IF EXISTS `student_electives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_electives` (
  `Students_id` int unsigned NOT NULL,
  `Elective_id` int unsigned NOT NULL,
  PRIMARY KEY (`Students_id`,`Elective_id`),
  KEY `fk_Student_electives_Elective1_idx` (`Elective_id`),
  CONSTRAINT `fk_Student_electives_Elective1` FOREIGN KEY (`Elective_id`) REFERENCES `elective` (`Elective_id`),
  CONSTRAINT `fk_Student_electives_Students1` FOREIGN KEY (`Students_id`) REFERENCES `students` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_electives`
--

LOCK TABLES `student_electives` WRITE;
/*!40000 ALTER TABLE `student_electives` DISABLE KEYS */;
INSERT INTO `student_electives` VALUES (12,1),(14,1),(117,1),(125,1),(128,1),(11,2),(13,2),(14,2),(113,2),(119,2),(126,2),(127,2),(128,2),(129,2),(19,3),(113,3),(114,3),(13,4),(19,4),(119,4),(127,4),(12,5),(111,5),(126,5),(129,5),(11,6),(114,6),(117,6),(125,6),(111,7);
/*!40000 ALTER TABLE `student_electives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_selections`
--

DROP TABLE IF EXISTS `student_selections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_selections` (
  `Students_id` int unsigned NOT NULL,
  `Industry_host_id` int unsigned NOT NULL,
  PRIMARY KEY (`Students_id`,`Industry_host_id`),
  KEY `fk_Responses_Students1_idx` (`Students_id`),
  KEY `fk_Responses_Companies1_idx` (`Industry_host_id`),
  CONSTRAINT `fk_Responses_Companies1` FOREIGN KEY (`Industry_host_id`) REFERENCES `industry_host` (`Industry_host_id`),
  CONSTRAINT `fk_Responses_Students1` FOREIGN KEY (`Students_id`) REFERENCES `students` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_selections`
--

LOCK TABLES `student_selections` WRITE;
/*!40000 ALTER TABLE `student_selections` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_selections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_tech_rank`
--

DROP TABLE IF EXISTS `student_tech_rank`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_tech_rank` (
  `Students_id` int unsigned NOT NULL,
  `Technologies_id` int unsigned NOT NULL,
  `rank_number` int unsigned NOT NULL,
  PRIMARY KEY (`Students_id`,`Technologies_id`),
  KEY `fk_Technology_rank_Technology1_idx` (`Technologies_id`),
  CONSTRAINT `fk_Technology_rank_Students1` FOREIGN KEY (`Students_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_Technology_rank_Technology1` FOREIGN KEY (`Technologies_id`) REFERENCES `technology` (`Technologies_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_tech_rank`
--

LOCK TABLES `student_tech_rank` WRITE;
/*!40000 ALTER TABLE `student_tech_rank` DISABLE KEYS */;
INSERT INTO `student_tech_rank` VALUES (11,1,4),(11,2,3),(11,4,5),(11,5,6),(11,6,1),(11,7,7),(11,8,8),(11,9,10),(11,10,9),(11,12,2),(12,1,1),(12,2,3),(12,3,4),(12,4,2),(12,5,5),(12,6,7),(12,7,6),(12,8,10),(12,9,9),(12,10,8),(13,1,6),(13,2,5),(13,3,8),(13,4,7),(13,5,2),(13,6,1),(13,7,4),(13,8,3),(13,9,10),(13,10,9),(14,1,6),(14,2,4),(14,3,8),(14,4,5),(14,5,2),(14,6,7),(14,7,1),(14,8,3),(14,9,9),(14,10,10),(19,1,8),(19,2,3),(19,3,9),(19,4,6),(19,5,5),(19,6,1),(19,7,2),(19,8,7),(19,9,10),(19,10,4),(111,1,2),(111,2,9),(111,3,10),(111,4,3),(111,5,7),(111,6,5),(111,7,6),(111,8,4),(111,9,1),(111,12,8),(113,1,1),(113,2,4),(113,3,3),(113,4,2),(113,5,7),(113,6,6),(113,7,9),(113,8,8),(113,9,10),(113,10,5),(114,1,3),(114,2,4),(114,3,8),(114,4,5),(114,5,7),(114,6,1),(114,7,2),(114,8,6),(114,9,10),(114,10,9),(117,1,2),(117,2,6),(117,3,8),(117,4,1),(117,5,4),(117,6,3),(117,7,7),(117,8,5),(117,9,10),(117,10,9),(119,1,1),(119,2,4),(119,3,2),(119,4,3),(119,5,8),(119,6,5),(119,7,6),(119,8,7),(119,9,9),(119,10,10),(125,1,2),(125,2,5),(125,3,6),(125,4,1),(125,5,3),(125,6,4),(125,7,7),(125,8,8),(125,9,10),(125,10,9),(126,1,2),(126,2,3),(126,3,1),(126,4,6),(126,5,7),(126,6,4),(126,7,8),(126,8,9),(126,9,5),(126,10,10),(127,1,5),(127,2,4),(127,3,8),(127,4,7),(127,5,2),(127,6,1),(127,7,6),(127,8,3),(127,9,10),(127,10,9),(128,1,7),(128,2,8),(128,3,9),(128,4,6),(128,5,3),(128,6,2),(128,7,1),(128,8,5),(128,10,10),(128,12,4),(129,1,4),(129,2,8),(129,3,7),(129,4,5),(129,5,2),(129,6,1),(129,7,6),(129,8,9),(129,9,3),(129,10,10);
/*!40000 ALTER TABLE `student_tech_rank` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `student_id` int unsigned NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `placement_status` tinyint unsigned NOT NULL DEFAULT '0',
  `Photo` varchar(256) DEFAULT NULL,
  `phone_number` varchar(25) NOT NULL,
  `email` varchar(100) NOT NULL,
  `interests` tinyint unsigned NOT NULL,
  `ideal_Project` mediumtext NOT NULL,
  `CV` varchar(256) DEFAULT NULL,
  `Student_background` mediumtext NOT NULL,
  `post_study_goal` mediumtext NOT NULL,
  `project_city` varchar(45) NOT NULL DEFAULT 'Christchurch',
  `attendance` tinyint unsigned NOT NULL,
  `year` year NOT NULL,
  `semester` int unsigned NOT NULL,
  PRIMARY KEY (`student_id`),
  UNIQUE KEY `user_id` (`student_id`),
  CONSTRAINT `fk_Students_Users1` FOREIGN KEY (`student_id`) REFERENCES `users` (`Users_id`),
  CONSTRAINT `students_chk_1` CHECK ((`semester` in (1,2)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (11,'Branden ','Leblanc',1,'../../static/img/bl.png','(0775) 616 120','Branden Leblanc@lincolnuni.ac.nz',0,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/bl.pdf','Graduate Diploma in Commerce                                                                                                                Work experience in Banking','*I want to use a new skills I have developed during this Masters of applied computing to further my career even my current employment or to find new employer or to start a new career and a new field.','Christchurch',1,2022,1),(12,'Wade ','Bennett',0,'../../static/img/wb.png','(04) 905 7626','Wade Bennett@lincolnuni.ac.nz',1,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/wb.pdf','Passionate Audio & Electronics Engineer with strong embedded systems / plc and low level programming skills. Fashionable yet Functional PCB Design experience.                                                                                                                                                        PG Cert Applied Science â€“ Lincoln University                                                                                Bachelor of Engineering in Electronic Technology Degree                                                          Certificate in Audio Engineering & Music Production  - MAINZ','*I want to use a new skills I have developed during this Masters of applied computing to further my career even my current employment or to find new employer or to start a new career and a new field.','Balclutha',1,2022,1),(13,'Quemby ','Chang',0,'../../static/img/qc.png','(0180) 636 812','Quemby Chang@lincolnuni.ac.nz',0,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/qc.pdf','Bachelor of Science  - Food Science                                                                                                       Medical receptionist              ','*I want to use a new skills I have developed during this Masters of applied computing to further my career even my current employment or to find new employer or to start a new career and a new field.','Westport',1,2022,1),(14,'Ferdinand ','Black',0,'../../static/img/fb.png','(0184) 456 161','Ferdinand Black@lincolnuni.ac.nz',0,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/fb.pdf','Analyst and Scrum Master                                                                                             \nFreelance Artist - photography, musician, music teacher\nHealth Service Consultant                                                                                                                Education:  Bachelor of Medicine & Bachelor of Surgery                                                               Diploma in Commercial Music                                                                                                 Volunteering:  musician, musical director, non-profit board (vestry), youth leader                                                                                                                                                                           ','*I want to use a new skills I have developed during this Masters of applied computing to further my career even my current employment or to find new employer or to start a new career and a new field.','Blenheim',1,2022,1),(15,'Fallon ','Cabrera',0,'../../static/img/fc.png','(023) 573 8642','Fallon Cabrera@lincolnuni.ac.nz',0,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/fc.pdf','Bachelor of Commerce                                                                                                                          Business Manager - plastics manufacturing                                                                        Accountant/Administrator - Fire Engineering','With my background and commerce I would like to find a career utilising this new knowledge and technology to be involved in further projects around the development of transaction manager systems.','Christchurch',1,2022,1),(16,'Octavius ','Juarez',0,'../../static/img/oj.png','(083) 913 1486','Octavius Juarez@lincolnuni.ac.nz',1,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/oj.pdf','Master of Computer Assisted Language Learning - UC                                                                         Diploma in Teaching    - CPIT                                                                                                                Bachelor of Science: Geology and Geography - UC                                                                                                                  Taught for 20 years.  In charge of ICT and responsible for staff development and implementing google docs and calendar school wide','*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.','Christchurch',1,2022,1),(17,'Vernon ','Barton',0,'../../static/img/vb.png','(05) 984 8271','Vernon Barton@lincolnuni.ac.nz',1,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/vb.pdf','Bachelor of Informations System Management - UC , with computer science papers as electives.                                                ','*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.','Whakatane',1,2022,1),(18,'Brody ','Anthony',0,'../../static/img/ba.png','(0424) 013 681','Brody Anthony@lincolnuni.ac.nz',1,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/ba.pdf','Master of Management - 2007 NMU Institute of Economics and Management, Ukraine Diploma in Computing (Level 7) -  NTEC Tertiary Group (Aspire2 International)                            Work experience: Programme Manager - Learning management system SIAPO (CDHB)                                                                                                                               Co-founder/Business Analyst - Caterway Limited, Christchurch                                                   Trainer - Enable Networks (Enable Fibre Broadband)                                                                            Trainer - Canterbury District Health Board                                                                                  Programme Manager - Ntec Tertiary Group (Aspire2 International)                                                     Web Developer - Massey University, Auckland.','*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.','Timaru',1,2022,1),(19,'Shafira ','Benjamin',0,'../../static/img/sb.png','(01) 783 5263','Shafira Benjamin@lincolnuni.ac.nz',1,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/sb.pdf','IT Help Desk - Lincoln University                                                                                                                    IT Support Engineer - CNZ Property Group                                                                                   Software Developer Intern - Gun City                                                                                             Bachelor of Information & Communication Technology (programming pathway)  -  Ara                                                                                                                                                      Diploma of Computer Networking - Ara (formerly CPIT)                                    ','*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.','Oamaru',1,2022,1),(110,'Maile ','Frazier',0,'../../static/img/mf.png','(07) 392 2345','Maile Frazier@lincolnuni.ac.nz',1,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/mf.pdf','Intern at Fidway Electronic Tech (HK) - software development,                                                 Bachelor of Phamaceutical Chemistry                                                                                                   IELTS & PTE English tutor                                                                                                                Competitor in the P&G CEO Challenge - Product modelling and design','*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.','Christchurch',1,2022,1),(111,'Yoshi ','Hayden',0,'../../static/img/yh.png','(03) 374 8345','Yoshi Hayden@lincolnuni.ac.nz',1,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/yh.pdf','Master of Applied Finance - Unitec Institute of Technology                                                  Bachelor\'s degree in Accountancy                                                                                                     Diploma of Accountancy                                                                                                                                                    6 years experience as a Tax Accountant','*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.','Invercargill',1,2022,1),(112,'Ivy ','Barron',0,'../../static/img/ib.png','(064) 874 8933','Ivy Barron@lincolnuni.ac.nz',1,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/ib.pdf','Bachelor of Computer Science                                                                                                                                                                  Orion Health software developer maintaining a web application product created in react and Java.                                                                                                                                                  Confident with javascript/typescript                                                                                               Familiar  developing tools, like Jest for unit testing & NPM for package management.                                                                                                                     Good experience with programming in Python, PHP & SQL','*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.','Lower Hutt',1,2022,1),(113,'Kirestin ','Solomon',0,'../../static/img/ks.png','(038) 581 0717','Kirestin Solomon@lincolnuni.ac.nz',0,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/ks.pdf','Graduate Diploma in Hospitality Management                                                                          Bachelor of Arts                                                                                                                                                  Yes Car Rentals, Christchurch Branch | Car Rental Agency Manager\nFerry Motel, Christchurch | Motel Manager\n Heartland Hotel, Auckland | Food and Beverage Assistant','*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.','Christchurch',1,2022,1),(114,'Ayanna ','Holman',0,'../../static/img/ah.png','(07) 338 7657','Ayanna Holman@lincolnuni.ac.nz',0,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/ah.pdf','Bachelor\'s degree in Design Innovation, majoring in industrial design. Attended Nanyang University of Technology as an exchange student.                                                                         Team project experience: Museum Sight Line for Visually Impaired People and Product Design WOOSH - Fruit Bowls Ltd. Experienced in analyzing the product brand positioning and formulating the development direction, as well as new product development.','*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.','Greymouth',1,2022,1),(115,'Roanna ','Abbott',0,'../../static/img/ra.png','(068) 417 4721','Roanna Abbott@lincolnuni.ac.nz',0,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/ra.pdf','Bachelor of Environment and Society                                                                                                           Occupational Health and Safety Diploma level 6','*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.','Christchurch',0,2022,1);
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tech_person`
--

DROP TABLE IF EXISTS `tech_person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tech_person` (
  `Tech_id` int unsigned NOT NULL AUTO_INCREMENT,
  `Industry_host_id` int unsigned NOT NULL,
  `tech_name` varchar(80) NOT NULL,
  `tech_phone` varchar(25) DEFAULT NULL,
  `tech_email` varchar(100) NOT NULL,
  PRIMARY KEY (`Tech_id`),
  KEY `fk_Tech_person_Industry_host1_idx` (`Industry_host_id`),
  CONSTRAINT `fk_Tech_person_Industry_host1` FOREIGN KEY (`Industry_host_id`) REFERENCES `industry_host` (`Industry_host_id`)
) ENGINE=InnoDB AUTO_INCREMENT=147 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tech_person`
--

LOCK TABLES `tech_person` WRITE;
/*!40000 ALTER TABLE `tech_person` DISABLE KEYS */;
INSERT INTO `tech_person` VALUES (132,217,'Kraig Winters','021433851','kraig@serverworks.co.nz'),(133,218,'Andrew Errington','021 107 7903','erringtona@gmail.com'),(134,219,'Melissa Baer','0210574901','melissa@webtools.co.nz'),(135,220,'Penny Maxwell','0272400320','penny@posbiz.co.nz'),(136,221,'Grant Meikle','021438796','grant@4technology.net'),(137,222,'Graeme Muir','0212596619','graeme@mogolabs.com'),(138,223,'Alice Young','049786666','a.young@questintegrity.com'),(139,224,'Jim Thorpe','027 322 5750','jim@website-developers.co.nz'),(140,225,'Chris Borrill','021 026 03866','chris.borrill@orionhealth.com'),(141,226,'Barry Clark','0274065780','barry.clark@corde.nz'),(142,227,'Josie Shum',NULL,'josie.shum@ossability.com'),(143,229,'Mos Sharifi','0211924431','mos.sharifi@agresearch.co.nz'),(144,230,'Morne Wium',NULL,'morne@virtualmedicalcoaching.com'),(145,231,'Chetan Baadkar','0220236633','chetan.baadkar@plantandfood.co.nz'),(146,232,'Craig Melton','033391619','craigmelton@email.com');
/*!40000 ALTER TABLE `tech_person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `technology`
--

DROP TABLE IF EXISTS `technology`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `technology` (
  `Technologies_id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  PRIMARY KEY (`Technologies_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `technology`
--

LOCK TABLES `technology` WRITE;
/*!40000 ALTER TABLE `technology` DISABLE KEYS */;
INSERT INTO `technology` VALUES (1,'Python'),(2,'HTML/CSS'),(3,'JavaScript'),(4,'SQL/MySQL/Postgres'),(5,'User Experience'),(6,'Business Analysis'),(7,'Content Creation'),(8,'UI Design'),(9,'GIS'),(10,'Neural Networks'),(11,'ERP'),(12,'C++'),(13,'C#'),(14,'General Software Development'),(15,'Back End Development'),(16,'Front End Development'),(17,'Full Stack Development');
/*!40000 ALTER TABLE `technology` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `Users_id` int unsigned NOT NULL,
  `user_name` varchar(64) NOT NULL,
  `password` varchar(64) NOT NULL,
  `role` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`Users_id`),
  UNIQUE KEY `User_name_UNIQUE` (`user_name`),
  UNIQUE KEY `Users_id_UNIQUE` (`Users_id`),
  CONSTRAINT `users_chk_1` CHECK ((`role` in (1,2,3)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (11,'branden','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(12,'wadebennett','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(13,'quembychang','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(14,'ferdinand','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(15,'fallon','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(16,'octavius','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(17,'vernon','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(18,'brody_anthony','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(19,'shafira','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(110,'maile_frazier','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(111,'yoshi01','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(112,'ivybarron','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(113,'kirestin02','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(114,'ayanna','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(115,'roanna','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(217,'serverworks_ltd','19513fdc9da4fb72a4a05eb66917548d3c90ff94d5419e1f2363eea89dfee1dd',2),(218,'frizzell_ltd','19513fdc9da4fb72a4a05eb66917548d3c90ff94d5419e1f2363eea89dfee1dd',2),(219,'webtools_agritech','19513fdc9da4fb72a4a05eb66917548d3c90ff94d5419e1f2363eea89dfee1dd',2),(220,'posbiz_limited','19513fdc9da4fb72a4a05eb66917548d3c90ff94d5419e1f2363eea89dfee1dd',2),(221,'4technology','19513fdc9da4fb72a4a05eb66917548d3c90ff94d5419e1f2363eea89dfee1dd',2),(222,'mogo_labs_ltd','19513fdc9da4fb72a4a05eb66917548d3c90ff94d5419e1f2363eea89dfee1dd',2),(223,'quest_integrity_nzl_ltd','19513fdc9da4fb72a4a05eb66917548d3c90ff94d5419e1f2363eea89dfee1dd',2),(224,'website_developers_ltd','19513fdc9da4fb72a4a05eb66917548d3c90ff94d5419e1f2363eea89dfee1dd',2),(225,'orion_health','19513fdc9da4fb72a4a05eb66917548d3c90ff94d5419e1f2363eea89dfee1dd',2),(226,'corde_ltd','19513fdc9da4fb72a4a05eb66917548d3c90ff94d5419e1f2363eea89dfee1dd',2),(227,'ossability','19513fdc9da4fb72a4a05eb66917548d3c90ff94d5419e1f2363eea89dfee1dd',2),(228,'tidy_international_(nz)_limited','19513fdc9da4fb72a4a05eb66917548d3c90ff94d5419e1f2363eea89dfee1dd',2),(229,'agresearch_ltd','19513fdc9da4fb72a4a05eb66917548d3c90ff94d5419e1f2363eea89dfee1dd',2),(230,'virtual_medical_coaching','19513fdc9da4fb72a4a05eb66917548d3c90ff94d5419e1f2363eea89dfee1dd',2),(231,'plant_and_food_research','19513fdc9da4fb72a4a05eb66917548d3c90ff94d5419e1f2363eea89dfee1dd',2),(232,'test ltd','2546370040',2),(233,'orbica','19513fdc9da4fb72a4a05eb66917548d3c90ff94d5419e1f2363eea89dfee1dd',2),(234,'test 2 ltd','0b14d501a594442a01c6859541bcb3e8164d183d32937b851835442f69d5c94e',2),(235,'test 3 ltd','0b14d501a594442a01c6859541bcb3e8164d183d32937b851835442f69d5c94e',2),(236,'test 4 ltd','0b14d501a594442a01c6859541bcb3e8164d183d32937b851835442f69d5c94e',2),(237,'test 5 ltd','0b14d501a594442a01c6859541bcb3e8164d183d32937b851835442f69d5c94e',2),(316,'pat','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',3);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-07-10 10:09:20
