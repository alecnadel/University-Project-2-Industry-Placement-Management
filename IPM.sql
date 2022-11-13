-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema IPM
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `IPM`.`AdminSemester`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `IPM`.`AdminSemester` (
  `Year` YEAR NOT NULL,
  `Semester` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Year`,`Semester`),
  CHECK (`Semester` in (1,2)),
  )
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Schema IPM
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `IPM` DEFAULT CHARACTER SET utf8mb4 ;
USE `IPM` ;

-- -----------------------------------------------------
-- Table `IPM`.`Users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `IPM`.`Users` (
  `Users_id` INT UNSIGNED NOT NULL,
  `user_name` VARCHAR(64) NOT NULL,
  `password` VARCHAR(64) NOT NULL,
  `role` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`Users_id`),
  CHECK (`role` in (1,2,3)),
  UNIQUE INDEX `User_name_UNIQUE` (`user_name` ASC) ,
  UNIQUE INDEX `Users_id_UNIQUE` (`Users_id` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `IPM`.`Students`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `IPM`.`Students` (
  `student_id` INT UNSIGNED NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `placement_status` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `Photo` VARCHAR(256) ,
  `phone_number` VARCHAR(25) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `interests` TINYINT UNSIGNED NOT NULL,
  `ideal_Project` MEDIUMTEXT NOT NULL,
  `CV` VARCHAR(256) ,
  `Student_background` MEDIUMTEXT NOT NULL,
  `post_study_goal` MEDIUMTEXT NOT NULL,
  `project_city` VARCHAR(45) NOT NULL DEFAULT 'Christchurch',
  `attendance` TINYINT UNSIGNED NOT NULL,
  `year` YEAR NOT NULL,
  `semester` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`student_id`),
  CHECK (`semester` in (1,2)),
  UNIQUE INDEX `user_id` (`student_id` ASC),
  CONSTRAINT `fk_Students_Users1`
    FOREIGN KEY (`student_id`)
    REFERENCES `IPM`.`Users` (`Users_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `IPM`.`Industry_host`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `IPM`.`Industry_host` (
  `Industry_host_id` INT UNSIGNED NOT NULL,
  `organization_name` VARCHAR(64) NOT NULL,
  `contact_name` VARCHAR(80) NOT NULL,
  `contact_phone` VARCHAR(25),
  `contact_email` VARCHAR(100) NOT NULL,
  UNIQUE INDEX `contact_email_UNIQUE` (`contact_email` ASC) ,
  UNIQUE INDEX `contact_number_UNIQUE` (`contact_phone` ASC) ,
  PRIMARY KEY (`Industry_host_id`),
  CONSTRAINT `fk_Industry_host_Users1`
    FOREIGN KEY (`Industry_host_id`)
    REFERENCES `IPM`.`Users` (`Users_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `IPM`.`Tech_person`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `IPM`.`Tech_person` (
  `Tech_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Industry_host_id` INT UNSIGNED NOT NULL,
  `tech_name` VARCHAR(80) NOT NULL,
  `tech_phone` VARCHAR(25),
  `tech_email` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`Tech_id`),
  INDEX `fk_Tech_person_Industry_host1_idx` (`Industry_host_id` ASC),
  CONSTRAINT `fk_Tech_person_Industry_host1`
    FOREIGN KEY (`Industry_host_id`)
    REFERENCES `IPM`.`Industry_host` (`Industry_host_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `IPM`.`Projects`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `IPM`.`Projects` (
  `Projects_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Industry_host_id` INT UNSIGNED NOT NULL,
  `Tech_id` INT UNSIGNED NULL,
  `project_description` MEDIUMTEXT NOT NULL,
  `potential_placements` INT UNSIGNED NOT NULL DEFAULT 1,
  `year` YEAR NOT NULL,
  `semester` INT NOT NULL,
  PRIMARY KEY (`Projects_id`),
  CHECK (`semester` in (1,2)),
  INDEX `fk_Projects_Companies1_idx` (`Industry_host_id` ASC) ,
  INDEX `fk_Projects_Tech_person1_idx` (`Tech_id` ASC) ,
  CONSTRAINT `fk_Projects_Companies1`
    FOREIGN KEY (`Industry_host_id`)
    REFERENCES `IPM`.`Industry_host` (`Industry_host_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Projects_Tech_person1`
    FOREIGN KEY (`Tech_id`)
    REFERENCES `IPM`.`Tech_person` (`Tech_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `IPM`.`Student_selections`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `IPM`.`Student_selections` (
  `Students_id` INT UNSIGNED NOT NULL,
  `Industry_host_id` INT UNSIGNED NOT NULL,
  INDEX `fk_Responses_Students1_idx` (`Students_id` ASC) ,
  INDEX `fk_Responses_Companies1_idx` (`Industry_host_id` ASC) ,
  PRIMARY KEY (`Students_id`, `Industry_host_id`),
  CONSTRAINT `fk_Responses_Students1`
    FOREIGN KEY (`Students_id`)
    REFERENCES `IPM`.`Students` (`student_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Responses_Companies1`
    FOREIGN KEY (`Industry_host_id`)
    REFERENCES `IPM`.`Industry_host` (`Industry_host_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `IPM`.`Company_selections`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `IPM`.`Company_selections` (
  `Industry_host_id` INT UNSIGNED NOT NULL,
  `Students_id` INT UNSIGNED NOT NULL,
  `responses` INT UNSIGNED NOT NULL,
  `additional_note` MEDIUMTEXT NULL,
  `match_confirmation` TINYINT DEFAULT 0,
  INDEX `fk_Selections_Students1_idx` (`Students_id` ASC) ,
  PRIMARY KEY (`Students_id`, `Industry_host_id`),
  INDEX `fk_Selections_Companies1_idx` (`Industry_host_id` ASC) ,
  CHECK (`responses` in (1,2,3)), 
  CONSTRAINT `fk_Selections_Students1`
    FOREIGN KEY (`Students_id`)
    REFERENCES `IPM`.`Students` (`student_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Selections_Companies1`
    FOREIGN KEY (`Industry_host_id`)
    REFERENCES `IPM`.`Industry_host` (`Industry_host_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `IPM`.`Placement`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `IPM`.`Placement` (
  `Students_id` INT UNSIGNED NOT NULL,
  `Projects_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Students_id`, `Projects_id`),
  INDEX `fk_Placement_Projects1_idx` (`Projects_id` ASC) ,
  CONSTRAINT `fk_Placement_Students1`
    FOREIGN KEY (`Students_id`)
    REFERENCES `IPM`.`Students` (`student_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Placement_Projects1`
    FOREIGN KEY (`Projects_id`)
    REFERENCES `IPM`.`Projects` (`Projects_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `IPM`.`Technology`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `IPM`.`Technology` (
  `Technologies_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`Technologies_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `IPM`.`Elective`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `IPM`.`Elective` (
  `Elective_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL,
  `course_description` MEDIUMTEXT NULL,
  PRIMARY KEY (`Elective_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `IPM`.`Student_tech_rank`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `IPM`.`Student_tech_rank` (
  `Students_id` INT UNSIGNED NOT NULL,
  `Technologies_id` INT UNSIGNED NOT NULL,
  `rank_number` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Students_id`, `Technologies_id`),
  INDEX `fk_Technology_rank_Technology1_idx` (`Technologies_id` ASC) ,
  CONSTRAINT `fk_Technology_rank_Students1`
    FOREIGN KEY (`Students_id`)
    REFERENCES `IPM`.`Students` (`student_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Technology_rank_Technology1`
    FOREIGN KEY (`Technologies_id`)
    REFERENCES `IPM`.`Technology` (`Technologies_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION) 
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `IPM`.`Student_electives`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `IPM`.`Student_electives` (
  `Students_id` INT UNSIGNED NOT NULL,
  `Elective_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Students_id`, `Elective_id`),
  INDEX `fk_Student_electives_Elective1_idx` (`Elective_id` ASC) ,
  CONSTRAINT `fk_Student_electives_Students1`
    FOREIGN KEY (`Students_id`)
    REFERENCES `IPM`.`Students` (`student_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Student_electives_Elective1`
    FOREIGN KEY (`Elective_id`)
    REFERENCES `IPM`.`Elective` (`Elective_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `IPM`.`project_tech_rank`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `IPM`.`project_tech_rank` (
  `Projects_id` INT UNSIGNED NOT NULL,
  `Technologies_id` INT UNSIGNED NOT NULL,
  `rank_number` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Projects_id`, `Technologies_id`),
  INDEX `fk_project_tech_rank_Technology1_idx` (`Technologies_id` ASC) ,
  CONSTRAINT `fk_project_tech_rank_Projects1`
    FOREIGN KEY (`Projects_id`)
    REFERENCES `IPM`.`Projects` (`Projects_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_project_tech_rank_Technology1`
    FOREIGN KEY (`Technologies_id`)
    REFERENCES `IPM`.`Technology` (`Technologies_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `IPM`.`Interviews`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `IPM`.`Interviews` (
  `Interviews_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Students_id` INT UNSIGNED NOT NULL,
  `Industry_host_id` INT UNSIGNED NOT NULL,
  `comments` MEDIUMTEXT NOT NULL,
  `rating` INT UNSIGNED NOT NULL,
  `date` DATE NOT NULL,
  PRIMARY KEY (`Interviews_id`),
  UNIQUE INDEX `Interviews_id_UNIQUE` (`Interviews_id` ASC) ,
  INDEX `fk_Interviews_Students1_idx` (`Students_id` ASC) ,
  INDEX `fk_Interviews_Companies1_idx` (`Industry_host_id` ASC) ,
  CONSTRAINT `fk_Interviews_Students1`
    FOREIGN KEY (`Students_id`)
    REFERENCES `IPM`.`Students` (`student_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Interviews_Companies1`
    FOREIGN KEY (`Industry_host_id`)
    REFERENCES `IPM`.`Industry_host` (`Industry_host_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `IPM`.`host_attendance`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `IPM`.`host_attendance` (
  `Industry_host_id` INT UNSIGNED NOT NULL,
  `Year` YEAR NOT NULL,
  `Semester` INT UNSIGNED NOT NULL,
  `selection_status` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`Industry_host_id`, `Year`, `Semester`),
  CHECK (`semester` in (1,2)),
  CONSTRAINT `fk_host_attendance_Industry_host1`
    FOREIGN KEY (`Industry_host_id`)
    REFERENCES `IPM`.`Industry_host` (`Industry_host_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `IPM`.`Users`
-- -----------------------------------------------------
START TRANSACTION;
USE `IPM`;
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (11, 'branden', 'SYZ85RCH0FT', 1);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (12, 'wadebennett', 'ULF00RCY7YT', 1);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (13, 'quembychang', 'OWZ63GFO5GN', 1);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (14, 'ferdinand', 'FEU82PNK9LG', 1);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (25, 'consilium', 'EkR57YrG6lM', 2);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (26, 'jix_reality', 'RyT43BoU8jO', 2);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (27, 'amuri_irrigation', 'NfC94HzI2vD', 2);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (28, 'orion_health', 'TgC63MxP7wY', 2);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (19, 'fallon', 'FSQ88WTA6TX', 1);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (210, 'flooring_centre', 'YfL64EzU5jG', 2);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (111, 'octavius', 'TNB64OGS2TP', 1);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (212, '4_technology', 'TsV69PpE2iY', 2);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (113, 'vernon', 'FRO27SHC7VY', 1);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (114, 'brody_anthony', 'CWA66YTY2CK', 1);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (215, 'plant_&_food_research', 'XsS36KoS5tB', 2);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (216, 'onside', 'RiX25FsF4dJ', 2);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (117, 'shafira', 'EUR75GLX1PS', 1);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (218, 'optitrac', 'UvP21BrF4nF', 2);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (119, 'maile_frazier', 'OVM83OKC8CT', 1);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (220, 'virtual_medical', 'FuT32BsZ7nC', 2);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (221, 'meta_digital', 'XvA73CjW8jU', 2);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (222, 'rcg_creations', 'QwY58PmU9mZ', 2);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (223, 'ed_potential', 'EiQ22HuQ8mI', 2);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (224, 'nufarm ', 'PsS48BsA7dN', 2);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (125, 'yoshi01', 'BND09KMO1DH', 1);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (126, 'ivybarron', 'VTX38ZYK7UT', 1);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (127, 'kirestin02', 'FME82XWW6VE', 1);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (128, 'ayanna', 'UVQ42VLO3OH', 1);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (129, 'roanna', 'JVH68NDH6SG', 1);
INSERT INTO `IPM`.`Users` (`Users_id`, `user_name`, `password`, `role`) VALUES (330, 'pat', 'password1', 3);

COMMIT;


-- -----------------------------------------------------
-- Data for table `IPM`.`Students`
-- -----------------------------------------------------
START TRANSACTION;
USE `IPM`;
INSERT INTO `IPM`.`Students` (`student_id`, `first_name`, `last_name`, `placement_status`, `Photo`, `phone_number`, `email`, `interests`, `ideal_Project`, `CV`, `Student_background`, `post_study_goal`, `project_city`, `attendance`, `year`, `semester`) VALUES (11, 'Branden ', 'Leblanc', 0, '../../static/img/bl.png', '(0775) 616 120', 'Branden Leblanc@lincolnuni.ac.nz', 0, '*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.', '../../static/CV/bl.pdf', 'Graduate Diploma in Commerce                                                                                                                Work experience in Banking', '*I want to use a new skills I have developed during this Masters of applied computing to further my career even my current employment or to find new employer or to start a new career and a new field.', 'Christchurch', 1, 2022, 1);
INSERT INTO `IPM`.`Students` (`student_id`, `first_name`, `last_name`, `placement_status`, `Photo`, `phone_number`, `email`, `interests`, `ideal_Project`, `CV`, `Student_background`, `post_study_goal`, `project_city`, `attendance`, `year`, `semester`) VALUES (12, 'Wade ', 'Bennett', 0, '../../static/img/wb.png', '(04) 905 7626', 'Wade Bennett@lincolnuni.ac.nz', 1, '*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.', '../../static/CV/wb.pdf', 'Passionate Audio & Electronics Engineer with strong embedded systems / plc and low level programming skills. Fashionable yet Functional PCB Design experience.                                                                                                                                                        PG Cert Applied Science â€“ Lincoln University                                                                                Bachelor of Engineering in Electronic Technology Degree                                                          Certificate in Audio Engineering & Music Production  - MAINZ', '*I want to use a new skills I have developed during this Masters of applied computing to further my career even my current employment or to find new employer or to start a new career and a new field.', 'Balclutha', 1, 2022, 1);
INSERT INTO `IPM`.`Students` (`student_id`, `first_name`, `last_name`, `placement_status`, `Photo`, `phone_number`, `email`, `interests`, `ideal_Project`, `CV`, `Student_background`, `post_study_goal`, `project_city`, `attendance`, `year`, `semester`) VALUES (13, 'Quemby ', 'Chang', 0, '../../static/img/qc.png', '(0180) 636 812', 'Quemby Chang@lincolnuni.ac.nz', 0, '*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.', '../../static/CV/qc.pdf', 'Bachelor of Science  - Food Science                                                                                                       Medical receptionist              ', '*I want to use a new skills I have developed during this Masters of applied computing to further my career even my current employment or to find new employer or to start a new career and a new field.', 'Westport', 1, 2022, 1);
INSERT INTO `IPM`.`Students` (`student_id`, `first_name`, `last_name`, `placement_status`, `Photo`, `phone_number`, `email`, `interests`, `ideal_Project`, `CV`, `Student_background`, `post_study_goal`, `project_city`, `attendance`, `year`, `semester`) VALUES (14, 'Ferdinand ', 'Black', 0, '../../static/img/fb.png', '(0184) 456 161', 'Ferdinand Black@lincolnuni.ac.nz', 0, '*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.', '../../static/CV/fb.pdf', 'Analyst and Scrum Master                                                                                             \nFreelance Artist - photography, musician, music teacher\nHealth Service Consultant                                                                                                                Education:  Bachelor of Medicine & Bachelor of Surgery                                                               Diploma in Commercial Music                                                                                                 Volunteering:  musician, musical director, non-profit board (vestry), youth leader                                                                                                                                                                           ', '*I want to use a new skills I have developed during this Masters of applied computing to further my career even my current employment or to find new employer or to start a new career and a new field.', 'Blenheim', 0, 2022, 1);
INSERT INTO `IPM`.`Students` (`student_id`, `first_name`, `last_name`, `placement_status`, `Photo`, `phone_number`, `email`, `interests`, `ideal_Project`, `CV`, `Student_background`, `post_study_goal`, `project_city`, `attendance`, `year`, `semester`) VALUES (19, 'Fallon ', 'Cabrera', 0, '../../static/img/fc.png', '(023) 573 8642', 'Fallon Cabrera@lincolnuni.ac.nz', 0, '*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.', '../../static/CV/fc.pdf', 'Bachelor of Commerce                                                                                                                          Business Manager - plastics manufacturing                                                                        Accountant/Administrator - Fire Engineering', 'With my background and commerce I would like to find a career utilising this new knowledge and technology to be involved in further projects around the development of transaction manager systems.', 'Christchurch', 1, 2022, 1);
INSERT INTO `IPM`.`Students` (`student_id`, `first_name`, `last_name`, `placement_status`, `Photo`, `phone_number`, `email`, `interests`, `ideal_Project`, `CV`, `Student_background`, `post_study_goal`, `project_city`, `attendance`, `year`, `semester`) VALUES (111, 'Octavius ', 'Juarez', 0, '../../static/img/oj.png', '(083) 913 1486', 'Octavius Juarez@lincolnuni.ac.nz', 1, '*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.', '../../static/CV/oj.pdf', 'Master of Computer Assisted Language Learning - UC                                                                         Diploma in Teaching    - CPIT                                                                                                                Bachelor of Science: Geology and Geography - UC                                                                                                                  Taught for 20 years.  In charge of ICT and responsible for staff development and implementing google docs and calendar school wide', '*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.', 'Christchurch', 1, 2022, 1);
INSERT INTO `IPM`.`Students` (`student_id`, `first_name`, `last_name`, `placement_status`, `Photo`, `phone_number`, `email`, `interests`, `ideal_Project`, `CV`, `Student_background`, `post_study_goal`, `project_city`, `attendance`, `year`, `semester`) VALUES (113, 'Vernon ', 'Barton', 0, '../../static/img/vb.png', '(05) 984 8271', 'Vernon Barton@lincolnuni.ac.nz', 1, '*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.', '../../static/CV/vb.pdf', 'Bachelor of Informations System Management - UC , with computer science papers as electives.                                                ', '*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.', 'Whakatane', 1, 2022, 1);
INSERT INTO `IPM`.`Students` (`student_id`, `first_name`, `last_name`, `placement_status`, `Photo`, `phone_number`, `email`, `interests`, `ideal_Project`, `CV`, `Student_background`, `post_study_goal`, `project_city`, `attendance`, `year`, `semester`) VALUES (114, 'Brody ', 'Anthony', 0, '../../static/img/ba.png', '(0424) 013 681', 'Brody Anthony@lincolnuni.ac.nz', 1, '*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.', '../../static/CV/ba.pdf', 'Master of Management - 2007 NMU Institute of Economics and Management, Ukraine Diploma in Computing (Level 7) -  NTEC Tertiary Group (Aspire2 International)                            Work experience: Programme Manager - Learning management system SIAPO (CDHB)                                                                                                                               Co-founder/Business Analyst - Caterway Limited, Christchurch                                                   Trainer - Enable Networks (Enable Fibre Broadband)                                                                            Trainer - Canterbury District Health Board                                                                                  Programme Manager - Ntec Tertiary Group (Aspire2 International)                                                     Web Developer - Massey University, Auckland.', '*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.', 'Timaru', 1, 2022, 1);
INSERT INTO `IPM`.`Students` (`student_id`, `first_name`, `last_name`, `placement_status`, `Photo`, `phone_number`, `email`, `interests`, `ideal_Project`, `CV`, `Student_background`, `post_study_goal`, `project_city`, `attendance`, `year`, `semester`) VALUES (117, 'Shafira ', 'Benjamin', 0, '../../static/img/sb.png', '(01) 783 5263', 'Shafira Benjamin@lincolnuni.ac.nz', 1, '*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.', '../../static/CV/sb.pdf', 'IT Help Desk - Lincoln University                                                                                                                    IT Support Engineer - CNZ Property Group                                                                                   Software Developer Intern - Gun City                                                                                             Bachelor of Information & Communication Technology (programming pathway)  -  Ara                                                                                                                                                      Diploma of Computer Networking - Ara (formerly CPIT)                                    ', '*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.', 'Oamaru', 1, 2022, 1);
INSERT INTO `IPM`.`Students` (`student_id`, `first_name`, `last_name`, `placement_status`, `Photo`, `phone_number`, `email`, `interests`, `ideal_Project`, `CV`, `Student_background`, `post_study_goal`, `project_city`, `attendance`, `year`, `semester`) VALUES (119, 'Maile ', 'Frazier', 0, '../../static/img/mf.png', '(07) 392 2345', 'Maile Frazier@lincolnuni.ac.nz', 1, '*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.', '../../static/CV/mf.pdf', 'Intern at Fidway Electronic Tech (HK) - software development,                                                 Bachelor of Phamaceutical Chemistry                                                                                                   IELTS & PTE English tutor                                                                                                                Competitor in the P&G CEO Challenge - Product modelling and design', '*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.', 'Christchurch', 0, 2022, 1);
INSERT INTO `IPM`.`Students` (`student_id`, `first_name`, `last_name`, `placement_status`, `Photo`, `phone_number`, `email`, `interests`, `ideal_Project`, `CV`, `Student_background`, `post_study_goal`, `project_city`, `attendance`, `year`, `semester`) VALUES (125, 'Yoshi ', 'Hayden', 0, '../../static/img/yh.png', '(03) 374 8345', 'Yoshi Hayden@lincolnuni.ac.nz', 1, '*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.', '../../static/CV/yh.pdf', "Master of Applied Finance - Unitec Institute of Technology                                                  Bachelor's degree in Accountancy                                                                                                     Diploma of Accountancy                                                                                                                                                    6 years experience as a Tax Accountant", '*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.', 'Invercargill', 1, 2022, 1);
INSERT INTO `IPM`.`Students` (`student_id`, `first_name`, `last_name`, `placement_status`, `Photo`, `phone_number`, `email`, `interests`, `ideal_Project`, `CV`, `Student_background`, `post_study_goal`, `project_city`, `attendance`, `year`, `semester`) VALUES (126, 'Ivy ', 'Barron', 0, '../../static/img/ib.png', '(064) 874 8933', 'Ivy Barron@lincolnuni.ac.nz', 1, '*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.', '../../static/CV/ib.pdf', 'Bachelor of Computer Science                                                                                                                                                                  Orion Health software developer maintaining a web application product created in react and Java.                                                                                                                                                  Confident with javascript/typescript                                                                                               Familiar  developing tools, like Jest for unit testing & NPM for package management.                                                                                                                     Good experience with programming in Python, PHP & SQL', '*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.', 'Lower Hutt', 1, 2022, 1);
INSERT INTO `IPM`.`Students` (`student_id`, `first_name`, `last_name`, `placement_status`, `Photo`, `phone_number`, `email`, `interests`, `ideal_Project`, `CV`, `Student_background`, `post_study_goal`, `project_city`, `attendance`, `year`, `semester`) VALUES (127, 'Kirestin ', 'Solomon', 0, '../../static/img/ks.png', '(038) 581 0717', 'Kirestin Solomon@lincolnuni.ac.nz', 0, '*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.', '../../static/CV/ks.pdf', 'Graduate Diploma in Hospitality Management                                                                          Bachelor of Arts                                                                                                                                                  Yes Car Rentals, Christchurch Branch | Car Rental Agency Manager\nFerry Motel, Christchurch | Motel Manager\n Heartland Hotel, Auckland | Food and Beverage Assistant', '*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.', 'Christchurch', 1, 2022, 1);
INSERT INTO `IPM`.`Students` (`student_id`, `first_name`, `last_name`, `placement_status`, `Photo`, `phone_number`, `email`, `interests`, `ideal_Project`, `CV`, `Student_background`, `post_study_goal`, `project_city`, `attendance`, `year`, `semester`) VALUES (128, 'Ayanna ', 'Holman', 0, '../../static/img/ah.png', '(07) 338 7657', 'Ayanna Holman@lincolnuni.ac.nz', 0, '*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.', '../../static/CV/ah.pdf', "Bachelor's degree in Design Innovation, majoring in industrial design. Attended Nanyang University of Technology as an exchange student.                                                                         Team project experience: Museum Sight Line for Visually Impaired People and Product Design WOOSH - Fruit Bowls Ltd. Experienced in analyzing the product brand positioning and formulating the development direction, as well as new product development.", '*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.', 'Greymouth', 1, 2022, 1);
INSERT INTO `IPM`.`Students` (`student_id`, `first_name`, `last_name`, `placement_status`, `Photo`, `phone_number`, `email`, `interests`, `ideal_Project`, `CV`, `Student_background`, `post_study_goal`, `project_city`, `attendance`, `year`, `semester`) VALUES (129, 'Roanna ', 'Abbott', 0, '../../static/img/ra.png', '(068) 417 4721', 'Roanna Abbott@lincolnuni.ac.nz', 0, '*My ideal project we take the skills that I currently possess and those that I have started developing during this course to help me push these skills further and allow me to use them to enhance the success of my future endeavours.', '../../static/CV/ra.pdf', 'Bachelor of Environment and Society                                                                                                           Occupational Health and Safety Diploma level 6', '*I want to use a new skills I have developed during this Masters of applied computing to further my career/current employment or to find new employer or to start a new career in a new field.', 'Christchurch', 0, 2022, 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `IPM`.`Industry_host`
-- -----------------------------------------------------
START TRANSACTION;
USE `IPM`;
INSERT INTO `IPM`.`Industry_host` (`Industry_host_id`, `organization_name`, `contact_name`, `contact_phone`, `contact_email`) VALUES (25, 'CONSILIUM', 'Rebbecca Didio', '03-8174-9123', 'Rebbecca.Didio@consilium.co.nz');
INSERT INTO `IPM`.`Industry_host` (`Industry_host_id`, `organization_name`, `contact_name`, `contact_phone`, `contact_email`) VALUES (26, 'JIX INNOVATION LAB / JIX REALITY', 'Stevie Hallo', '08-9997-3366', 'Stevie.Hallo@jix.co.nz');
INSERT INTO `IPM`.`Industry_host` (`Industry_host_id`, `organization_name`, `contact_name`, `contact_phone`, `contact_email`) VALUES (27, 'AMURI IRRIGATION', 'Mariko Stayer', '07-5558-9019', 'Mariko.Stayer@amuri.co.nz');
INSERT INTO `IPM`.`Industry_host` (`Industry_host_id`, `organization_name`, `contact_name`, `contact_phone`, `contact_email`) VALUES (28, 'ORION HEALTH', 'Gerardo Woodka', '07-6044-4682', 'Gerardo.Woodka@orion.co.nz');
INSERT INTO `IPM`.`Industry_host` (`Industry_host_id`, `organization_name`, `contact_name`, `contact_phone`, `contact_email`) VALUES (210, 'THE FLOORING CENTRE', 'Mayra Bena', '03-1455-6085', 'Mayra.Bena@flooring.co.nz');
INSERT INTO `IPM`.`Industry_host` (`Industry_host_id`, `organization_name`, `contact_name`, `contact_phone`, `contact_email`) VALUES (212, '4 TECHNOLOGY', 'Idella Scotland', '08-7868-1355', 'Idella.Scotland@4tech.co.nz');
INSERT INTO `IPM`.`Industry_host` (`Industry_host_id`, `organization_name`, `contact_name`, `contact_phone`, `contact_email`) VALUES (215, 'PLANT & FOOD RESEARCH', 'Sherill Klar', '06-6522-8931', 'Sherill.Klar@pfr.co.nz');
INSERT INTO `IPM`.`Industry_host` (`Industry_host_id`, `organization_name`, `contact_name`, `contact_phone`, `contact_email`) VALUES (216, 'ONSIDE', 'Tom Hawk', '02-5226-9402', 'Tom.Hawk@onside.co.nz');
INSERT INTO `IPM`.`Industry_host` (`Industry_host_id`, `organization_name`, `contact_name`, `contact_phone`, `contact_email`) VALUES (218, 'OPTITRAC', 'Vince Siena', '07-3184-9989', 'Vince.Siena@optitrac.co.nz');
INSERT INTO `IPM`.`Industry_host` (`Industry_host_id`, `organization_name`, `contact_name`, `contact_phone`, `contact_email`) VALUES (220, 'VIRTUAL MEDICAL COACHING', 'Theron Jarding', '08-6890-4661', 'Theron.Jarding@vmc.co.nz');
INSERT INTO `IPM`.`Industry_host` (`Industry_host_id`, `organization_name`, `contact_name`, `contact_phone`, `contact_email`) VALUES (221, 'META DIGITAL', 'Amy Liu', '07-8135-3271', 'Amy.Liu@meta.co.nz');
INSERT INTO `IPM`.`Industry_host` (`Industry_host_id`, `organization_name`, `contact_name`, `contact_phone`, `contact_email`) VALUES (222, 'RCG CREATIONS', 'Mary Smith', '03-1174-6817', 'Mary.Smith@rcg.co.nz');
INSERT INTO `IPM`.`Industry_host` (`Industry_host_id`, `organization_name`, `contact_name`, `contact_phone`, `contact_email`) VALUES (223, 'ED POTENTIAL', 'Shane Hooker', '07-7977-6039', 'Shane.Hooker@ed.co.nz');
INSERT INTO `IPM`.`Industry_host` (`Industry_host_id`, `organization_name`, `contact_name`, `contact_phone`, `contact_email`) VALUES (224, 'NUFARM - Auckland', 'Paulina Maker', '08-8344-8929', 'Paulina.Maker@nufarm.co.nz');

COMMIT;


-- -----------------------------------------------------
-- Data for table `IPM`.`Tech_person`
-- -----------------------------------------------------
START TRANSACTION;
USE `IPM`;
INSERT INTO `IPM`.`Tech_person` (`Tech_id`, `Industry_host_id`, `tech_name`, `tech_phone`, `tech_email`) VALUES (1, 25, 'Zeph Flynn', '02-7276-1754', 'Zeph.Flynn@consilium.co.nz');
INSERT INTO `IPM`.`Tech_person` (`Tech_id`, `Industry_host_id`, `tech_name`, `tech_phone`, `tech_email`) VALUES (2, 26, 'Brenda Burgess', '05-2698-5667', 'Brenda.Burgess@jix.co.nz');
INSERT INTO `IPM`.`Tech_person` (`Tech_id`, `Industry_host_id`, `tech_name`, `tech_phone`, `tech_email`) VALUES (3, 27, 'Daria Guzman', '05-7542-4970', 'Daria.Guzman@amuri.co.nz');
INSERT INTO `IPM`.`Tech_person` (`Tech_id`, `Industry_host_id`, `tech_name`, `tech_phone`, `tech_email`) VALUES (4, 28, 'Linda Hayes', '05-5528-0518', 'Linda.Hayes@orion.co.nz');
INSERT INTO `IPM`.`Tech_person` (`Tech_id`, `Industry_host_id`, `tech_name`, `tech_phone`, `tech_email`) VALUES (5, 210, 'Jin Rowland', '05-5835-7113', 'Jin.Rowland@flooring.co.nz');
INSERT INTO `IPM`.`Tech_person` (`Tech_id`, `Industry_host_id`, `tech_name`, `tech_phone`, `tech_email`) VALUES (6, 212, 'Pearl Manning', '03-2026-3364', 'Pearl.Manning@4tech.co.nz');
INSERT INTO `IPM`.`Tech_person` (`Tech_id`, `Industry_host_id`, `tech_name`, `tech_phone`, `tech_email`) VALUES (7, 215, 'Ronan Bright', '07-3024-8451', 'Ronan.Bright@pfr.co.nz');
INSERT INTO `IPM`.`Tech_person` (`Tech_id`, `Industry_host_id`, `tech_name`, `tech_phone`, `tech_email`) VALUES (8, 216, 'Mercedes Robbins', '03-6061-7698', 'Mercedes.Robbins@onside.co.nz');
INSERT INTO `IPM`.`Tech_person` (`Tech_id`, `Industry_host_id`, `tech_name`, `tech_phone`, `tech_email`) VALUES (9, 218, 'Theodore Mccarty', '08-5941-6485', 'Theodore.Mccarty@optitrac.co.nz');
INSERT INTO `IPM`.`Tech_person` (`Tech_id`, `Industry_host_id`, `tech_name`, `tech_phone`, `tech_email`) VALUES (10, 220, 'Alika Weiss', '06-2018-7513', 'Alika.Weiss@vmc.co.nz');
INSERT INTO `IPM`.`Tech_person` (`Tech_id`, `Industry_host_id`, `tech_name`, `tech_phone`, `tech_email`) VALUES (11, 221, 'Zenia Mayer', '07-0302-2140', 'Zenia.Mayer@meta.co.nz');
INSERT INTO `IPM`.`Tech_person` (`Tech_id`, `Industry_host_id`, `tech_name`, `tech_phone`, `tech_email`) VALUES (12, 222, 'Reed Spears', '07-4146-0588', 'Reed.Spears@rcg.co.nz');
INSERT INTO `IPM`.`Tech_person` (`Tech_id`, `Industry_host_id`, `tech_name`, `tech_phone`, `tech_email`) VALUES (13, 223, 'Frances Summers', '04-9223-4158', 'Frances.Summers@ed.co.nz');
INSERT INTO `IPM`.`Tech_person` (`Tech_id`, `Industry_host_id`, `tech_name`, `tech_phone`, `tech_email`) VALUES (14, 224, 'Lael Vang', '09-7264-7037', 'Lael.Vang@nufarm.co.nz');

COMMIT;


-- -----------------------------------------------------
-- Data for table `IPM`.`Projects`
-- -----------------------------------------------------
START TRANSACTION;
USE `IPM`;
INSERT INTO `IPM`.`Projects` (`Projects_id`, `Industry_host_id`, `Tech_id`, `project_description`, `potential_placements`, `year`, `semester`) VALUES (1, 25, 1, 'FINANCE:  a bespoke portfolio management tool to allow our advisers to customise and store their own asset allocation models', 1, 2022, 1);
INSERT INTO `IPM`.`Projects` (`Projects_id`, `Industry_host_id`, `Tech_id`, `project_description`, `potential_placements`, `year`, `semester`) VALUES (2, 26, 2, 'VIRTUAL REALITY: machine learning for computer vision and audio analysis - Proficiency in programming languages such as C++, JAVA and C#,  3D tools like 3D MAX and Autodesk 3D, Strong UX/UI', 1, 2022, 1);
INSERT INTO `IPM`.`Projects` (`Projects_id`, `Industry_host_id`, `Tech_id`, `project_description`, `potential_placements`, `year`, `semester`) VALUES (3, 27, 3, 'AGRICULTURE:  Irrigation Efficiency Real-time reporting,dashboard - GIS,User Experience Skills,MySQL, SQL, Postgres,UI Design', 1, 2022, 1);
INSERT INTO `IPM`.`Projects` (`Projects_id`, `Industry_host_id`, `Tech_id`, `project_description`, `potential_placements`, `year`, `semester`) VALUES (4, 28, 4, 'MEDICAL: Very interested in a student Business Analyst  or one with Advanced JavaScript skills', 1, 2022, 1);
INSERT INTO `IPM`.`Projects` (`Projects_id`, `Industry_host_id`, `Tech_id`, `project_description`, `potential_placements`, `year`, `semester`) VALUES (5, 210, 5, 'ACCOUNTANCY PROJECT:  Automation of data reporting for Carpet & Flooring business - Microsoft POWER BI, POWER PIVOT or CRYSTAL REPORTING. Get data from flat excel spreadsheet (Delphi - but could be any format) â€“ student would work alongside Anthony, 2-3 days a month, Will need good understanding of Excel and pivot tables - (currently use ERP - \'Baysoft\' custom carpet & flooring industry)\n~2000 active jobs, with ~500 jobs requiring further action, current ERP provides 70,000 rows of data â€“ Project is to automate the repurposing of this data using VLOOKUPâ€™s, data checks and pivot tables to produce meaningful data. ', 2, 2022, 1);
INSERT INTO `IPM`.`Projects` (`Projects_id`, `Industry_host_id`, `Tech_id`, `project_description`, `potential_placements`, `year`, `semester`) VALUES (6, 212, 6, 'FOOD &  BEV: providiong solutions at the core of every factory process impacting track and trace.  We specialise in industries requiring full visibility throughout the chain, focused mainly on Food & Beverage Mechanical Eng /machine data, Food related project automating the Testing in an electronic sense. (have you done what is required to killed the pathogens,  is this paperwork correct? etc) ', 2, 2022, 1);
INSERT INTO `IPM`.`Projects` (`Projects_id`, `Industry_host_id`, `Tech_id`, `project_description`, `potential_placements`, `year`, `semester`) VALUES (7, 215, 7, 'SCIENCE TECHNOLOGIES /AGRICULTURAL SCIENCE: a background in Chemistry &/or spectroscopy would be useful, project involves - crop modelling, data engineering, data integration, tracking & training data for modelling and mining, more concerned with relevant background experience over strong tech skills - will teach the tech.', 1, 2022, 1);
INSERT INTO `IPM`.`Projects` (`Projects_id`, `Industry_host_id`, `Tech_id`, `project_description`, `potential_placements`, `year`, `semester`) VALUES (8, 216, 8, 'AGRICULTURAL: Onside provides rural based managers with the digital tools to keep their staff safe while working on rural properties. Project involves:  Bio-security and pest identification, potentially 2 projects', 1, 2022, 1);
INSERT INTO `IPM`.`Projects` (`Projects_id`, `Industry_host_id`, `Tech_id`, `project_description`, `potential_placements`, `year`, `semester`) VALUES (9, 218, 9, 'IoT:  Optitrac IoT products are suited for tracking valuable goods within but not limited to these industries; construction, healthcare, agriculture, hospitality, utilities, transportation and logistics, retail, manufacturing, smart buildings.', 1, 2022, 1);
INSERT INTO `IPM`.`Projects` (`Projects_id`, `Industry_host_id`, `Tech_id`, `project_description`, `potential_placements`, `year`, `semester`) VALUES (10, 220, 10, 'VR / EDUCATION: Radiology training:  Advanced maths or physics skills or an interest in Testing', 1, 2022, 1);
INSERT INTO `IPM`.`Projects` (`Projects_id`, `Industry_host_id`, `Tech_id`, `project_description`, `potential_placements`, `year`, `semester`) VALUES (11, 221, 11, 'WEB DEVELOPMENT:   WordPress  -  UX / Website evaluation / UI / prototyping', 1, 2022, 1);
INSERT INTO `IPM`.`Projects` (`Projects_id`, `Industry_host_id`, `Tech_id`, `project_description`, `potential_placements`, `year`, `semester`) VALUES (12, 222, 12, 'EDUCATION: Prototyping projects - business logic, user interface - platform business , uses  \'elm\' on frontend which can be picked up easily. Additional TECH: a lot of  UI interaction,  Business Analysis, UI Design, HTML / CSS, User Experience Skills, Python', 1, 2022, 1);
INSERT INTO `IPM`.`Projects` (`Projects_id`, `Industry_host_id`, `Tech_id`, `project_description`, `potential_placements`, `year`, `semester`) VALUES (13, 223, 13, 'EDUCATION:  SaaS product for schools and othersâ€¦ project is a a subproduct - \'questionaire capability\' for the platform - wireframe and concept is complete - could be involved in nuts and bolts (coding) or product management, main app is Java, othermodules could be AWS in differenta  language, could use langermann functions, could also use a BA or UI student', 1, 2022, 1);
INSERT INTO `IPM`.`Projects` (`Projects_id`, `Industry_host_id`, `Tech_id`, `project_description`, `potential_placements`, `year`, `semester`) VALUES (14, 224, 14, 'AGRICULTURE: the provision of a wide range of top quality crop protection products for farmers and growers including Herbicides, Insecticides, Fungicides and Plant Growth Regulators.  TECH: MySQL, SQL, Postgres, BA, ERP Systems', 1, 2022, 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `IPM`.`Technology`
-- -----------------------------------------------------
START TRANSACTION;
USE `IPM`;
INSERT INTO `IPM`.`Technology` (`Technologies_id`, `name`) VALUES (1, 'Python');
INSERT INTO `IPM`.`Technology` (`Technologies_id`, `name`) VALUES (2, 'HTML/CSS');
INSERT INTO `IPM`.`Technology` (`Technologies_id`, `name`) VALUES (3, 'JavaScript');
INSERT INTO `IPM`.`Technology` (`Technologies_id`, `name`) VALUES (4, 'SQL/MySQL/Postgres');
INSERT INTO `IPM`.`Technology` (`Technologies_id`, `name`) VALUES (5, 'User Experience');
INSERT INTO `IPM`.`Technology` (`Technologies_id`, `name`) VALUES (6, 'Business Analysis');
INSERT INTO `IPM`.`Technology` (`Technologies_id`, `name`) VALUES (7, 'Content Creation');
INSERT INTO `IPM`.`Technology` (`Technologies_id`, `name`) VALUES (8, 'UI Design');
INSERT INTO `IPM`.`Technology` (`Technologies_id`, `name`) VALUES (9, 'GIS');
INSERT INTO `IPM`.`Technology` (`Technologies_id`, `name`) VALUES (10, 'Neural Networks');
INSERT INTO `IPM`.`Technology` (`Technologies_id`, `name`) VALUES (11, 'ERP');
INSERT INTO `IPM`.`Technology` (`Technologies_id`, `name`) VALUES (12, 'C++');
INSERT INTO `IPM`.`Technology` (`Technologies_id`, `name`) VALUES (13, 'C#');

COMMIT;


-- -----------------------------------------------------
-- Data for table `IPM`.`Elective`
-- -----------------------------------------------------
START TRANSACTION;
USE `IPM`;
INSERT INTO `IPM`.`Elective` (`Elective_id`, `name`, `course_description`) VALUES (1, 'User Experience', 'This is a practical exploration of the foundations, evolution and principles (including theory)\n that define and measure how humans interact with computers and computer-based information. ');
INSERT INTO `IPM`.`Elective` (`Elective_id`, `name`, `course_description`) VALUES (2, 'User Engagement & Business Analysis', '');
INSERT INTO `IPM`.`Elective` (`Elective_id`, `name`, `course_description`) VALUES (3, 'Neural Networks', "You'll be immersed in neural network fundamentals, looking at network architectures and learning \r methods and how to apply it.");
INSERT INTO `IPM`.`Elective` (`Elective_id`, `name`, `course_description`) VALUES (4, 'Advanced Programming', '');
INSERT INTO `IPM`.`Elective` (`Elective_id`, `name`, `course_description`) VALUES (5, 'Geographic Information Systems (GIS)', 'A course to introduce you to how Geographic Information Systems are used in the modelling and \nanalysis of spatial problems. ');
INSERT INTO `IPM`.`Elective` (`Elective_id`, `name`, `course_description`) VALUES (6, 'Advanced Database Management', 'In this course, you will develop advanced database management skill in designing, implementing \nand administering database.');
INSERT INTO `IPM`.`Elective` (`Elective_id`, `name`, `course_description`) VALUES (7, 'Other', '');

COMMIT;


-- -----------------------------------------------------
-- Data for table `IPM`.`Student_tech_rank`
-- -----------------------------------------------------
START TRANSACTION;
USE `IPM`;
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (11, 6, 1);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (11, 12, 2);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (11, 2, 3);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (11, 1, 4);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (11, 4, 5);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (11, 5, 6);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (11, 7, 7);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (11, 8, 8);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (11, 10, 9);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (11, 9, 10);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (12, 1, 1);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (12, 4, 2);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (12, 2, 3);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (12, 3, 4);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (12, 5, 5);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (12, 7, 6);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (12, 6, 7);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (12, 10, 8);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (12, 9, 9);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (12, 8, 10);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (13, 6, 1);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (13, 5, 2);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (13, 8, 3);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (13, 7, 4);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (13, 2, 5);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (13, 1, 6);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (13, 4, 7);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (13, 3, 8);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (13, 10, 9);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (13, 9, 10);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (14, 7, 1);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (14, 5, 2);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (14, 8, 3);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (14, 2, 4);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (14, 4, 5);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (14, 1, 6);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (14, 6, 7);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (14, 3, 8);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (14, 9, 9);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (14, 10, 10);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (19, 6, 1);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (19, 7, 2);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (19, 2, 3);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (19, 10, 4);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (19, 5, 5);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (19, 4, 6);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (19, 8, 7);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (19, 1, 8);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (19, 3, 9);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (19, 9, 10);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (111, 9, 1);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (111, 1, 2);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (111, 4, 3);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (111, 8, 4);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (111, 6, 5);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (111, 7, 6);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (111, 5, 7);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (111, 12, 8);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (111, 2, 9);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (111, 3, 10);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (113, 1, 1);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (113, 4, 2);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (113, 3, 3);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (113, 2, 4);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (113, 10, 5);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (113, 6, 6);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (113, 5, 7);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (113, 8, 8);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (113, 7, 9);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (113, 9, 10);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (114, 6, 1);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (114, 7, 2);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (114, 1, 3);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (114, 2, 4);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (114, 4, 5);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (114, 8, 6);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (114, 5, 7);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (114, 3, 8);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (114, 10, 9);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (114, 9, 10);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (117, 4, 1);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (117, 1, 2);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (117, 6, 3);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (117, 5, 4);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (117, 8, 5);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (117, 2, 6);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (117, 7, 7);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (117, 3, 8);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (117, 10, 9);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (117, 9, 10);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (119, 1, 1);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (119, 3, 2);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (119, 4, 3);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (119, 2, 4);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (119, 6, 5);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (119, 7, 6);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (119, 8, 7);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (119, 5, 8);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (119, 9, 9);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (119, 10, 10);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (125, 4, 1);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (125, 1, 2);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (125, 5, 3);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (125, 6, 4);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (125, 2, 5);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (125, 3, 6);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (125, 7, 7);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (125, 8, 8);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (125, 10, 9);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (125, 9, 10);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (126, 3, 1);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (126, 1, 2);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (126, 2, 3);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (126, 6, 4);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (126, 9, 5);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (126, 4, 6);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (126, 5, 7);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (126, 7, 8);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (126, 8, 9);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (126, 10, 10);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (127, 6, 1);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (127, 5, 2);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (127, 8, 3);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (127, 2, 4);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (127, 1, 5);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (127, 7, 6);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (127, 4, 7);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (127, 3, 8);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (127, 10, 9);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (127, 9, 10);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (128, 7, 1);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (128, 6, 2);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (128, 5, 3);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (128, 12, 4);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (128, 8, 5);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (128, 4, 6);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (128, 1, 7);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (128, 2, 8);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (128, 3, 9);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (128, 10, 10);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (129, 6, 1);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (129, 5, 2);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (129, 9, 3);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (129, 1, 4);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (129, 4, 5);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (129, 7, 6);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (129, 3, 7);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (129, 2, 8);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (129, 8, 9);
INSERT INTO `IPM`.`Student_tech_rank` (`Students_id`, `Technologies_id`, `rank_number`) VALUES (129, 10, 10);

COMMIT;


-- -----------------------------------------------------
-- Data for table `IPM`.`Student_electives`
-- -----------------------------------------------------
START TRANSACTION;
USE `IPM`;
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (11, 2);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (11, 6);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (12, 1);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (12, 5);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (13, 2);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (13, 4);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (14, 1);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (14, 2);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (19, 3);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (19, 4);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (111, 5);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (111, 7);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (113, 2);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (113, 3);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (114, 3);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (114, 6);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (117, 1);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (117, 6);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (119, 2);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (119, 4);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (125, 1);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (125, 6);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (126, 2);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (126, 5);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (127, 2);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (127, 4);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (128, 1);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (128, 2);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (129, 2);
INSERT INTO `IPM`.`Student_electives` (`Students_id`, `Elective_id`) VALUES (129, 5);

COMMIT;


-- -----------------------------------------------------
-- Data for table `IPM`.`project_tech_rank`
-- -----------------------------------------------------
START TRANSACTION;
USE `IPM`;
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (1, 1, 1);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (1, 2, 2);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (2, 11, 1);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (2, 12, 2);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (2, 13, 3);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (2, 8, 4);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (3, 9, 1);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (3, 5, 2);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (3, 4, 3);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (3, 8, 4);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (4, 3, 1);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (4, 6, 2);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (5, 10, 1);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (5, 4, 2);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (6, 1, 1);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (6, 3, 2);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (7, 4, 1);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (7, 1, 2);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (8, 2, 1);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (8, 8, 2);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (9, 2, 1);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (9, 3, 2);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (10, 13, 1);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (10, 1, 2);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (11, 5, 1);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (11, 8, 2);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (12, 6, 1);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (12, 8, 2);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (12, 2, 3);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (12, 5, 4);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (12, 1, 5);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (13, 6, 1);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (13, 8, 2);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (14, 4, 1);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (14, 6, 2);
INSERT INTO `IPM`.`project_tech_rank` (`Projects_id`, `Technologies_id`, `rank_number`) VALUES (14, 10, 3);

COMMIT;


-- -----------------------------------------------------
-- Data for table `IPM`.`host_attendance`
-- -----------------------------------------------------
START TRANSACTION;
USE `IPM`;
INSERT INTO `IPM`.`host_attendance` (`Industry_host_id`, `Year`, `Semester`) VALUES (25, 2022, 1);
INSERT INTO `IPM`.`host_attendance` (`Industry_host_id`, `Year`, `Semester`) VALUES (26, 2022, 1);
INSERT INTO `IPM`.`host_attendance` (`Industry_host_id`, `Year`, `Semester`) VALUES (27, 2022, 1);
INSERT INTO `IPM`.`host_attendance` (`Industry_host_id`, `Year`, `Semester`) VALUES (28, 2022, 1);
INSERT INTO `IPM`.`host_attendance` (`Industry_host_id`, `Year`, `Semester`) VALUES (210, 2022, 1);
INSERT INTO `IPM`.`host_attendance` (`Industry_host_id`, `Year`, `Semester`) VALUES (212, 2022, 1);
INSERT INTO `IPM`.`host_attendance` (`Industry_host_id`, `Year`, `Semester`) VALUES (215, 2022, 1);
INSERT INTO `IPM`.`host_attendance` (`Industry_host_id`, `Year`, `Semester`) VALUES (216, 2022, 1);
INSERT INTO `IPM`.`host_attendance` (`Industry_host_id`, `Year`, `Semester`) VALUES (218, 2022, 1);
INSERT INTO `IPM`.`host_attendance` (`Industry_host_id`, `Year`, `Semester`) VALUES (220, 2022, 1);
INSERT INTO `IPM`.`host_attendance` (`Industry_host_id`, `Year`, `Semester`) VALUES (221, 2022, 1);
INSERT INTO `IPM`.`host_attendance` (`Industry_host_id`, `Year`, `Semester`) VALUES (222, 2022, 1);
INSERT INTO `IPM`.`host_attendance` (`Industry_host_id`, `Year`, `Semester`) VALUES (223, 2022, 1);
INSERT INTO `IPM`.`host_attendance` (`Industry_host_id`, `Year`, `Semester`) VALUES (224, 2022, 1);

COMMIT;

-- -----------------------------------------------------
-- Data for table `IPM`.`company_selections`
-- -----------------------------------------------------
START TRANSACTION;
USE `IPM`;
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('25',	'11',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('26',	'11',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('27',	'11',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('210',	'11',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('218',	'11',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('220',	'11',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('222',	'11',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('223',	'11',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('25',	'12',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('26',	'12',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('28',	'12',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('210',	'12',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('212',	'12',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('216',	'12',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('218',	'12',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('220',	'12',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('221',	'12',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('222',	'12',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('223',	'12',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('25',	'13',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('26',	'13',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('28',	'13',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('210',	'13',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('212',	'13',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('216',	'13',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('218',	'13',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('220',	'13',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('221',	'13',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('222',	'13',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('223',	'13',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('25',	'14',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('26',	'14',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('28',	'14',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('212',	'14',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('218',	'14',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('220',	'14',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('221',	'14',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('222',	'14',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('223',	'14',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('25',	'19',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('28',	'19',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('210',	'19',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('212',	'19',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('215',	'19',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('216',	'19',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('218',	'19',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('220',	'19',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('222',	'19',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('223',	'19',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('25',	'111',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('26',	'111',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('27',	'111',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('210',	'111',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('25',	'113',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('28',	'113',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('210',	'113',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('212',	'113',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('216',	'113',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('218',	'113',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('221',	'113',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('222',	'113',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('223',	'113',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('25',	'114',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('26',	'114',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('27',	'114',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('215',	'114',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('216',	'114',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('220',	'114',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('25',	'117',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('27',	'117',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('212',	'117',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('215',	'117',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('218',	'117',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('221',	'117',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('223',	'117',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('25',	'119',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('28',	'119',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('210',	'119',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('215',	'119',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('216',	'119',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('218',	'119',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('221',	'119',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('223',	'119',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('25',	'125',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('26',	'125',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('27',	'125',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('210',	'125',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('216',	'125',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('220',	'125',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('221',	'125',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('223',	'125',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('27',	'126',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('28',	'126',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('212',	'126',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('216',	'126',	'2',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('218',	'126',	'1',	NULL);
INSERT INTO `IPM`.`company_selections` (`Industry_host_id`, `Students_id`, `responses`, `additional_note`) VALUES ('221',	'126',	'1',	NULL);

COMMIT;

-- -----------------------------------------------------
-- Data for table `IPM`.`student_selections`
-- -----------------------------------------------------
START TRANSACTION;
USE `IPM`;
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('11',	'25');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('11',	'26');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('11',	'27');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('11',	'210');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('11',	'212');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('11',	'218');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('11',	'220');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('11',	'221');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('11',	'223');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('12',	'25');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('12',	'26');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('12',	'212');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('12',	'216');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('12',	'218');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('12',	'220');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('12',	'221');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('12',	'222');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('12',	'223');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('13',	'25');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('13',	'26');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('13',	'221');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('13',	'223');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('14',	'25');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('14',	'26');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('14',	'28');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('14',	'212');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('14',	'218');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('14',	'220');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('14',	'221');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('14',	'222');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('14',	'223');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('19',	'25');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('19',	'215');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('19',	'218');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('19',	'222');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('19',	'223');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('111',	'26');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('111',	'27');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('111',	'212');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('111',	'218');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('111',	'221');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('113',	'25');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('113',	'26');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('113',	'221');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('113',	'223');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('114',	'25');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('114',	'27');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('114',	'28');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('114',	'210');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('114',	'212');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('114',	'215');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('114',	'218');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('114',	'220');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('114',	'221');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('114',	'223');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('117',	'26');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('117',	'27');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('119',	'25');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('119',	'26');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('119',	'28');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('119',	'212');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('119',	'216');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('119',	'218');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('119',	'221');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('119',	'222');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('119',	'223');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('125',	'25');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('125',	'26');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('125',	'210');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('125',	'223');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('126',	'27');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('126',	'212');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('126',	'218');
INSERT INTO `IPM`.`student_selections` (`Students_id`,`Industry_host_id`) VALUES ('126',	'221');

COMMIT