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
INSERT INTO `company_selections` VALUES (25,11,2,NULL,0),(26,11,2,NULL,0),(27,11,2,NULL,0),(210,11,2,NULL,1),(218,11,1,NULL,0),(220,11,1,NULL,0),(222,11,1,NULL,1),(223,11,2,NULL,0),(25,12,1,NULL,0),(26,12,1,NULL,0),(28,12,2,NULL,0),(210,12,1,NULL,0),(212,12,1,NULL,1),(216,12,1,NULL,1),(218,12,1,NULL,1),(220,12,1,NULL,1),(221,12,1,NULL,0),(222,12,1,NULL,0),(223,12,1,NULL,0),(25,13,1,NULL,0),(26,13,2,NULL,0),(28,13,1,NULL,0),(210,13,1,NULL,0),(212,13,1,NULL,0),(216,13,1,NULL,0),(218,13,2,NULL,0),(220,13,2,NULL,0),(221,13,1,NULL,1),(222,13,1,NULL,0),(223,13,2,NULL,1),(25,14,1,NULL,0),(26,14,1,NULL,0),(28,14,1,NULL,1),(212,14,2,NULL,0),(218,14,1,NULL,0),(220,14,1,NULL,1),(221,14,1,NULL,1),(222,14,2,NULL,0),(223,14,2,NULL,0),(25,19,1,NULL,0),(28,19,1,NULL,0),(210,19,1,NULL,0),(212,19,1,NULL,0),(215,19,1,NULL,1),(216,19,2,NULL,0),(218,19,1,NULL,0),(220,19,2,NULL,0),(222,19,1,NULL,1),(223,19,1,NULL,0),(224,19,2,'',0),(25,111,2,NULL,0),(26,111,2,NULL,0),(27,111,2,NULL,1),(210,111,1,NULL,0),(224,111,1,'',0),(25,113,2,NULL,0),(28,113,2,NULL,0),(210,113,1,NULL,0),(212,113,1,NULL,0),(216,113,2,NULL,0),(218,113,2,NULL,0),(221,113,1,NULL,1),(222,113,1,NULL,0),(223,113,1,NULL,1),(25,114,2,NULL,0),(26,114,2,NULL,0),(27,114,2,NULL,0),(215,114,2,NULL,0),(216,114,1,NULL,0),(220,114,2,NULL,0),(224,114,1,'',0),(25,117,1,NULL,0),(27,117,1,NULL,1),(212,117,1,NULL,0),(215,117,2,NULL,0),(218,117,1,NULL,0),(221,117,1,NULL,0),(223,117,1,NULL,0),(25,119,1,NULL,0),(28,119,1,NULL,1),(210,119,1,NULL,0),(215,119,2,NULL,0),(216,119,1,NULL,1),(218,119,2,NULL,0),(221,119,2,NULL,0),(223,119,2,NULL,0),(25,125,1,NULL,0),(26,125,1,NULL,0),(27,125,2,NULL,0),(210,125,2,NULL,1),(216,125,1,NULL,0),(220,125,1,NULL,0),(221,125,2,NULL,0),(223,125,1,NULL,1),(27,126,2,NULL,0),(28,126,2,NULL,0),(212,126,1,NULL,1),(216,126,2,NULL,0),(218,126,1,NULL,1),(221,126,1,NULL,1),(224,126,2,'',0),(224,127,2,'',1),(224,128,1,'',1);
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
INSERT INTO `host_attendance` VALUES (27,2022,1,0),(28,2022,1,0),(210,2022,1,0),(212,2022,1,0),(215,2022,1,0),(216,2022,1,0),(218,2022,1,0),(220,2022,1,0),(221,2022,1,0),(222,2022,1,0),(223,2022,1,0),(224,2022,1,1);
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
  `contact_phone` varchar(25) NOT NULL,
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
INSERT INTO `industry_host` VALUES (25,'CONSILIUM','Rebbecca Didio','03-8174-9123','Rebbecca.Didio@consilium.co.nz'),(26,'JIX INNOVATION LAB / JIX REALITY','Stevie Hallo','08-9997-3366','Stevie.Hallo@jix.co.nz'),(27,'AMURI IRRIGATION','Mariko Stayer','07-5558-9019','Mariko.Stayer@amuri.co.nz'),(28,'ORION HEALTH','Gerardo Woodka','07-6044-4682','Gerardo.Woodka@orion.co.nz'),(210,'THE FLOORING CENTRE','Mayra Bena','03-1455-6085','Mayra.Bena@flooring.co.nz'),(212,'4 TECHNOLOGY','Idella Scotland','08-7868-1355','Idella.Scotland@4tech.co.nz'),(215,'PLANT & FOOD RESEARCH','Sherill Klar','06-6522-8931','Sherill.Klar@pfr.co.nz'),(216,'ONSIDE','Tom Hawk','02-5226-9402','Tom.Hawk@onside.co.nz'),(218,'OPTITRAC','Vince Siena','07-3184-9989','Vince.Siena@optitrac.co.nz'),(220,'VIRTUAL MEDICAL COACHING','Theron Jarding','08-6890-4661','Theron.Jarding@vmc.co.nz'),(221,'META DIGITAL','Amy Liu','07-8135-3271','Amy.Liu@meta.co.nz'),(222,'RCG CREATIONS','Mary Smith','03-1174-6817','Mary.Smith@rcg.co.nz'),(223,'ED POTENTIAL','Shane Hooker','07-7977-6039','Shane.Hooker@ed.co.nz'),(224,'NUFARM - Auckland','Paulina Maker','08-8344-8929','Paulina.Maker@nufarm.co.nz');
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
INSERT INTO `interviews` VALUES (1203292,11,210,'stuff and things',4,'2022-06-23'),(711806622,11,220,'when well, cool project',4,'2022-06-21'),(2668842243,11,218,'stuff and things 2',4,'2022-06-23');
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
INSERT INTO `placement` VALUES (11,9);
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
  CONSTRAINT `fk_project_tech_rank_Projects1` FOREIGN KEY (`Projects_id`) REFERENCES `projects` (`Projects_id`),
  CONSTRAINT `fk_project_tech_rank_Technology1` FOREIGN KEY (`Technologies_id`) REFERENCES `technology` (`Technologies_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_tech_rank`
--

LOCK TABLES `project_tech_rank` WRITE;
/*!40000 ALTER TABLE `project_tech_rank` DISABLE KEYS */;
INSERT INTO `project_tech_rank` VALUES (1,1,1),(1,2,2),(2,8,4),(2,11,1),(2,12,2),(2,13,3),(3,4,3),(3,5,2),(3,8,4),(3,9,1),(4,3,1),(4,6,2),(5,4,2),(5,10,1),(6,1,1),(6,3,2),(7,1,2),(7,4,1),(8,2,1),(8,8,2),(9,2,1),(9,3,2),(10,1,2),(10,13,1),(11,5,1),(11,8,2),(12,1,5),(12,2,3),(12,5,4),(12,6,1),(12,8,2),(13,6,1),(13,8,2),(14,4,1),(14,6,2),(14,10,3);
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projects`
--

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
INSERT INTO `projects` VALUES (1,25,1,'FINANCE:  a bespoke portfolio management tool to allow our advisers to customise and store their own asset allocation models\r\n                            ',1,2022,2),(2,26,2,'VIRTUAL REALITY: machine learning for computer vision and audio analysis - Proficiency in programming languages such as C++, JAVA and C#,  3D tools like 3D MAX and Autodesk 3D, Strong UX/UI\r\n                            ',1,2022,2),(3,27,3,'AGRICULTURE:  Irrigation Efficiency Real-time reporting,dashboard - GIS,User Experience Skills,MySQL, SQL, Postgres,UI Design\r\n                            ',1,2022,2),(4,28,4,'MEDICAL: Very interested in a student Business Analyst  or one with Advanced JavaScript skills\r\n                            ',1,2022,2),(5,210,5,'ACCOUNTANCY PROJECT:  Automation of data reporting for Carpet & Flooring business - Microsoft POWER BI, POWER PIVOT or CRYSTAL REPORTING. Get data from flat excel spreadsheet (Delphi - but could be any format)“ student would work alongside Anthony, 2-3 days a month, Will need good understanding of Excel and pivot tables - (currently use ERP - \'Baysoft\' custom carpet & flooring industry)\r\n~2000 active jobs, with ~500 jobs requiring further action, current ERP provides 70,000 rows of data“ Project is to automate the repurposing of this data using VLOOKUP™s, data checks and pivot tables to produce meaningful data. \r\n                            ',1,2022,2),(6,212,6,'FOOD &  BEV: providiong solutions at the core of every factory process impacting track and trace.  We specialise in industries requiring full visibility throughout the chain, focused mainly on Food & Beverage Mechanical Eng /machine data, Food related project automating the Testing in an electronic sense. (have you done what is required to killed the pathogens,  is this paperwork correct? etc) \r\n                            ',1,2022,2),(7,215,7,'SCIENCE TECHNOLOGIES /AGRICULTURAL SCIENCE: a background in Chemistry &/or spectroscopy would be useful, project involves - crop modelling, data engineering, data integration, tracking & training data for modelling and mining, more concerned with relevant background experience over strong tech skills - will teach the tech.\r\n                            ',1,2022,2),(8,216,8,'AGRICULTURAL: Onside provides rural based managers with the digital tools to keep their staff safe while working on rural properties. Project involves:  Bio-security and pest identification, potentially 2 projects\r\n                            ',1,2022,2),(9,218,9,'IoT:  Optitrac IoT products are suited for tracking valuable goods within but not limited to these industries; construction, healthcare, agriculture, hospitality, utilities, transportation and logistics, retail, manufacturing, smart buildings.\r\n                            ',1,2022,2),(10,220,10,'VR / EDUCATION: Radiology training:  Advanced maths or physics skills or an interest in Testing\r\n                            ',1,2022,2),(11,221,11,'WEB DEVELOPMENT:   WordPress  -  UX / Website evaluation / UI / prototyping\r\n                            ',2,2022,2),(12,222,12,'EDUCATION: Prototyping projects - business logic, user interface - platform business , uses  \'elm\' on frontend which can be picked up easily. Additional TECH: a lot of  UI interaction,  Business Analysis, UI Design, HTML / CSS, User Experience Skills, Python\r\n                            ',1,2022,2),(13,223,13,'EDUCATION:  SaaS product for schools and other projects is a a subproduct - \'questionaire capability\' for the platform - wireframe and concept is complete - could be involved in nuts and bolts (coding) or product management, main app is Java, othermodules could be AWS in differenta  language, could use langermann functions, could also use a BA or UI student\r\n                            ',1,2022,2),(14,224,14,'AGRICULTURE: the provision of a wide range of top quality crop protection products for farmers and growers including Herbicides, Insecticides, Fungicides and Plant Growth Regulators.  TECH: MySQL, SQL, Postgres, BA, ERP Systems\r\n                            ',1,2022,2),(17,224,14,'stuff and things 3.0\r\n                            ',1,2022,2);
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
INSERT INTO `student_selections` VALUES (11,27),(11,28),(11,210),(11,215),(11,216),(11,222),(11,223),(11,224),(12,25),(12,26),(12,212),(12,216),(12,218),(12,220),(12,221),(12,222),(12,223),(13,25),(13,26),(13,221),(13,223),(14,25),(14,26),(14,28),(14,212),(14,218),(14,220),(14,221),(14,222),(14,223),(19,25),(19,215),(19,218),(19,222),(19,223),(111,26),(111,27),(111,212),(111,218),(111,221),(113,25),(113,26),(113,221),(113,223),(114,25),(114,27),(114,28),(114,210),(114,212),(114,215),(114,218),(114,220),(114,221),(114,223),(117,26),(117,27),(119,25),(119,26),(119,28),(119,212),(119,216),(119,218),(119,221),(119,222),(119,223),(125,25),(125,26),(125,210),(125,223),(126,27),(126,212),(126,218),(126,221),(127,27),(127,28),(127,222),(127,223),(127,224),(128,27),(128,28),(128,218),(128,220),(128,224);
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
  CONSTRAINT `fk_Technology_rank_Students1` FOREIGN KEY (`Students_id`) REFERENCES `students` (`student_id`),
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
INSERT INTO `students` VALUES (11,'Branden ','Leblanc',1,'../../static/img/bl.png','(0775) 616 120','Branden Leblanc@lincolnuni.ac.nz',0,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/bl.pdf','Graduate Diploma in Commerce                                                                                                                Work experience in Banking','*I want to use a new skills I have developed during this Masters of applied computing to further my career even my current employment or to find new employer or to start a new career and a new field.','Christchurch',1,2022,1),(12,'Wade ','Bennett',0,'../../static/img/wb.png','(04) 905 7626','Wade Bennett@lincolnuni.ac.nz',1,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/wb.pdf','Passionate Audio & Electronics Engineer with strong embedded systems / plc and low level programming skills. Fashionable yet Functional PCB Design experience.                                                                                                                                                        PG Cert Applied Science â€“ Lincoln University                                                                                Bachelor of Engineering in Electronic Technology Degree                                                          Certificate in Audio Engineering & Music Production  - MAINZ','*I want to use a new skills I have developed during this Masters of applied computing to further my career even my current employment or to find new employer or to start a new career and a new field.','Balclutha',1,2022,1),(13,'Quemby ','Chang',0,'../../static/img/qc.png','(0180) 636 812','Quemby Chang@lincolnuni.ac.nz',0,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/qc.pdf','Bachelor of Science  - Food Science                                                                                                       Medical receptionist              ','*I want to use a new skills I have developed during this Masters of applied computing to further my career even my current employment or to find new employer or to start a new career and a new field.','Westport',1,2022,1),(14,'Ferdinand ','Black',0,'../../static/img/fb.png','(0184) 456 161','Ferdinand Black@lincolnuni.ac.nz',0,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/fb.pdf','Analyst and Scrum Master                                                                                             \nFreelance Artist - photography, musician, music teacher\nHealth Service Consultant                                                                                                                Education:  Bachelor of Medicine & Bachelor of Surgery                                                               Diploma in Commercial Music                                                                                                 Volunteering:  musician, musical director, non-profit board (vestry), youth leader                                                                                                                                                                           ','*I want to use a new skills I have developed during this Masters of applied computing to further my career even my current employment or to find new employer or to start a new career and a new field.','Blenheim',1,2022,1),(19,'Fallon ','Cabrera',0,'../../static/img/fc.png','(023) 573 8642','Fallon Cabrera@lincolnuni.ac.nz',0,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/fc.pdf','Bachelor of Commerce                                                                                                                          Business Manager - plastics manufacturing                                                                        Accountant/Administrator - Fire Engineering','With my background and commerce I would like to find a career utilising this new knowledge and technology to be involved in further projects around the development of transaction manager systems.','Christchurch',1,2022,1),(111,'Octavius ','Juarez',0,'../../static/img/oj.png','(083) 913 1486','Octavius Juarez@lincolnuni.ac.nz',1,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/oj.pdf','Master of Computer Assisted Language Learning - UC                                                                         Diploma in Teaching    - CPIT                                                                                                                Bachelor of Science: Geology and Geography - UC                                                                                                                  Taught for 20 years.  In charge of ICT and responsible for staff development and implementing google docs and calendar school wide','*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.','Christchurch',1,2022,1),(113,'Vernon ','Barton',0,'../../static/img/vb.png','(05) 984 8271','Vernon Barton@lincolnuni.ac.nz',1,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/vb.pdf','Bachelor of Informations System Management - UC , with computer science papers as electives.                                                ','*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.','Whakatane',1,2022,1),(114,'Brody ','Anthony',0,'../../static/img/ba.png','(0424) 013 681','Brody Anthony@lincolnuni.ac.nz',1,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/ba.pdf','Master of Management - 2007 NMU Institute of Economics and Management, Ukraine Diploma in Computing (Level 7) -  NTEC Tertiary Group (Aspire2 International)                            Work experience: Programme Manager - Learning management system SIAPO (CDHB)                                                                                                                               Co-founder/Business Analyst - Caterway Limited, Christchurch                                                   Trainer - Enable Networks (Enable Fibre Broadband)                                                                            Trainer - Canterbury District Health Board                                                                                  Programme Manager - Ntec Tertiary Group (Aspire2 International)                                                     Web Developer - Massey University, Auckland.','*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.','Timaru',1,2022,1),(117,'Shafira ','Benjamin',0,'../../static/img/sb.png','(01) 783 5263','Shafira Benjamin@lincolnuni.ac.nz',1,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/sb.pdf','IT Help Desk - Lincoln University                                                                                                                    IT Support Engineer - CNZ Property Group                                                                                   Software Developer Intern - Gun City                                                                                             Bachelor of Information & Communication Technology (programming pathway)  -  Ara                                                                                                                                                      Diploma of Computer Networking - Ara (formerly CPIT)                                    ','*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.','Oamaru',1,2022,1),(119,'Maile ','Frazier',0,'../../static/img/mf.png','(07) 392 2345','Maile Frazier@lincolnuni.ac.nz',1,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/mf.pdf','Intern at Fidway Electronic Tech (HK) - software development,                                                 Bachelor of Phamaceutical Chemistry                                                                                                   IELTS & PTE English tutor                                                                                                                Competitor in the P&G CEO Challenge - Product modelling and design','*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.','Christchurch',1,2022,1),(125,'Yoshi ','Hayden',0,'../../static/img/yh.png','(03) 374 8345','Yoshi Hayden@lincolnuni.ac.nz',1,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/yh.pdf','Master of Applied Finance - Unitec Institute of Technology                                                  Bachelor\'s degree in Accountancy                                                                                                     Diploma of Accountancy                                                                                                                                                    6 years experience as a Tax Accountant','*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.','Invercargill',1,2022,1),(126,'Ivy ','Barron',0,'../../static/img/ib.png','(064) 874 8933','Ivy Barron@lincolnuni.ac.nz',1,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/ib.pdf','Bachelor of Computer Science                                                                                                                                                                  Orion Health software developer maintaining a web application product created in react and Java.                                                                                                                                                  Confident with javascript/typescript                                                                                               Familiar  developing tools, like Jest for unit testing & NPM for package management.                                                                                                                     Good experience with programming in Python, PHP & SQL','*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.','Lower Hutt',1,2022,1),(127,'Kirestin ','Solomon',0,'../../static/img/ks.png','(038) 581 0717','Kirestin Solomon@lincolnuni.ac.nz',0,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/ks.pdf','Graduate Diploma in Hospitality Management                                                                          Bachelor of Arts                                                                                                                                                  Yes Car Rentals, Christchurch Branch | Car Rental Agency Manager\nFerry Motel, Christchurch | Motel Manager\n Heartland Hotel, Auckland | Food and Beverage Assistant','*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.','Christchurch',1,2022,1),(128,'Ayanna ','Holman',0,'../../static/img/ah.png','(07) 338 7657','Ayanna Holman@lincolnuni.ac.nz',0,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/ah.pdf','Bachelor\'s degree in Design Innovation, majoring in industrial design. Attended Nanyang University of Technology as an exchange student.                                                                         Team project experience: Museum Sight Line for Visually Impaired People and Product Design WOOSH - Fruit Bowls Ltd. Experienced in analyzing the product brand positioning and formulating the development direction, as well as new product development.','*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.','Greymouth',1,2022,1),(129,'Roanna ','Abbott',0,'../../static/img/ra.png','(068) 417 4721','Roanna Abbott@lincolnuni.ac.nz',0,'*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.','../../static/CV/ra.pdf','Bachelor of Environment and Society                                                                                                           Occupational Health and Safety Diploma level 6','*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.','Christchurch',0,2022,1);
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
  `tech_phone` varchar(25) NOT NULL,
  `tech_email` varchar(100) NOT NULL,
  PRIMARY KEY (`Tech_id`),
  KEY `fk_Tech_person_Industry_host1_idx` (`Industry_host_id`),
  CONSTRAINT `fk_Tech_person_Industry_host1` FOREIGN KEY (`Industry_host_id`) REFERENCES `industry_host` (`Industry_host_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tech_person`
--

LOCK TABLES `tech_person` WRITE;
/*!40000 ALTER TABLE `tech_person` DISABLE KEYS */;
INSERT INTO `tech_person` VALUES (1,25,'Zeph Flynn','02-7276-1754','Zeph.Flynn@consilium.co.nz'),(2,26,'Brenda Burgess','05-2698-5667','Brenda.Burgess@jix.co.nz'),(3,27,'Daria Guzman','05-7542-4970','Daria.Guzman@amuri.co.nz'),(4,28,'Linda Hayes','05-5528-0518','Linda.Hayes@orion.co.nz'),(5,210,'Jin Rowland','05-5835-7113','Jin.Rowland@flooring.co.nz'),(6,212,'Pearl Manning','03-2026-3364','Pearl.Manning@4tech.co.nz'),(7,215,'Ronan Bright','07-3024-8451','Ronan.Bright@pfr.co.nz'),(8,216,'Mercedes Robbins','03-6061-7698','Mercedes.Robbins@onside.co.nz'),(9,218,'Theodore Mccarty','08-5941-6485','Theodore.Mccarty@optitrac.co.nz'),(10,220,'Alika Weiss','06-2018-7513','Alika.Weiss@vmc.co.nz'),(11,221,'Zenia Mayer','07-0302-2140','Zenia.Mayer@meta.co.nz'),(12,222,'Reed Spears','07-4146-0588','Reed.Spears@rcg.co.nz'),(13,223,'Frances Summers','04-9223-4158','Frances.Summers@ed.co.nz'),(14,224,'Lael Vang','09-7264-7037','Lael.Vang@nufarm.co.nz');
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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `technology`
--

LOCK TABLES `technology` WRITE;
/*!40000 ALTER TABLE `technology` DISABLE KEYS */;
INSERT INTO `technology` VALUES (1,'Python'),(2,'HTML/CSS'),(3,'JavaScript'),(4,'SQL/MySQL/Postgres'),(5,'User Experience'),(6,'Business Analysis'),(7,'Content Creation'),(8,'UI Design'),(9,'GIS'),(10,'Neural Networks'),(11,'ERP'),(12,'C++'),(13,'C#');
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
INSERT INTO `users` VALUES (11,'branden','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(12,'wadebennett','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(13,'quembychang','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(14,'ferdinand','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(19,'fallon','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(25,'consilium','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',2),(26,'jix_reality','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',2),(27,'amuri_irrigation','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',2),(28,'orion_health','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',2),(111,'octavius','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(113,'vernon','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(114,'brody_anthony','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(117,'shafira','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(119,'maile_frazier','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(125,'yoshi01','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(126,'ivybarron','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(127,'kirestin02','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(128,'ayanna','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(129,'roanna','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',1),(210,'flooring_centre','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',2),(212,'4_technology','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',2),(215,'plant_&_food_research','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',2),(216,'onside','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',2),(218,'optitrac','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',2),(220,'virtual_medical','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',2),(221,'meta_digital','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',2),(222,'rcg_creations','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',2),(223,'ed_potential','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',2),(224,'nufarm','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',2),(330,'pat','ec38063c881f0a5edfef6a5233925fe7e555746ebdc0865af3eb13c4e1805f46',3),(1331,'cam','6e8cbf640d31b910af5c3ffc6a52a90eda6ff9ce2dc1c5251e217e4bbe39484d',1);
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

-- Dump completed on 2022-07-08 10:10:13
