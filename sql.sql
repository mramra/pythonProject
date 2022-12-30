-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.6.11-MariaDB-0ubuntu0.22.04.1 - Ubuntu 22.04
-- Server OS:                    debian-linux-gnu
-- HeidiSQL Version:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for Students
CREATE DATABASE IF NOT EXISTS `Students` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `Students`;

-- Dumping structure for table Students.addresss
CREATE TABLE IF NOT EXISTS `addresss` (
  `address_id` int(11) NOT NULL AUTO_INCREMENT,
  `address_name` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`address_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table Students.addresss: ~2 rows (approximately)
INSERT INTO `addresss` (`address_id`, `address_name`) VALUES
	(1, 'Gaza'),
	(2, 'Jabalya'),
	(3, 'Khan Younes');

-- Dumping structure for table Students.contacts
CREATE TABLE IF NOT EXISTS `contacts` (
  `contact_id` int(11) NOT NULL AUTO_INCREMENT,
  `mobile_number` varchar(40) DEFAULT NULL,
  `email` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`contact_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table Students.contacts: ~3 rows (approximately)
INSERT INTO `contacts` (`contact_id`, `mobile_number`, `email`) VALUES
	(1, 'mmm@ff.com', '0599999999'),
	(2, 'ali@ali.com', '059766666'),
	(3, 'ahmed@ahmed.com', '05555555544');

-- Dumping structure for table Students.courses
CREATE TABLE IF NOT EXISTS `courses` (
  `course_id` int(11) NOT NULL AUTO_INCREMENT,
  `level_id` int(11) DEFAULT NULL,
  `cource_name` varchar(40) DEFAULT NULL,
  `max_capacity` int(11) DEFAULT NULL,
  `rate_per_hour` decimal(10,2) DEFAULT NULL,
  `total_hours` int(11) DEFAULT NULL,
  PRIMARY KEY (`course_id`),
  KEY `courses_levels_level_id_fk` (`level_id`),
  CONSTRAINT `courses_levels_level_id_fk` FOREIGN KEY (`level_id`) REFERENCES `levels` (`level_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table Students.courses: ~2 rows (approximately)
INSERT INTO `courses` (`course_id`, `level_id`, `cource_name`, `max_capacity`, `rate_per_hour`, `total_hours`) VALUES
	(2, 1, 'ENG', 5, 2.00, 3),
	(3, 2, 'Eng 2', 3, 30.00, 4),
	(4, 4, 'Eng 4', 6, 20.00, 3),
	(5, 1, 'Eng Eng', 3, 3.00, 3);

-- Dumping structure for table Students.course_schedules
CREATE TABLE IF NOT EXISTS `course_schedules` (
  `course_schedule_id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) DEFAULT NULL,
  `day` varchar(40) DEFAULT NULL,
  `duration` time DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  PRIMARY KEY (`course_schedule_id`),
  KEY `course_schedules_courses_course_id_fk` (`course_id`),
  CONSTRAINT `course_schedules_courses_course_id_fk` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table Students.course_schedules: ~0 rows (approximately)
INSERT INTO `course_schedules` (`course_schedule_id`, `course_id`, `day`, `duration`, `start_time`, `end_time`) VALUES
	(5, 2, 'Tuesday', '01:45:00', '10:00:00', '11:45:00');

-- Dumping structure for table Students.enrollment_historys
CREATE TABLE IF NOT EXISTS `enrollment_historys` (
  `enroll_id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) DEFAULT NULL,
  `student_id` int(11) DEFAULT NULL,
  `enrol_date` datetime DEFAULT NULL,
  `total` decimal(10,2),
  PRIMARY KEY (`enroll_id`),
  KEY `enrollment_historys_courses_course_id_fk` (`course_id`),
  KEY `enrollment_historys_students_student_id_fk` (`student_id`),
  CONSTRAINT `enrollment_historys_courses_course_id_fk` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`),
  CONSTRAINT `enrollment_historys_students_student_id_fk` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table Students.enrollment_historys: ~2 rows (approximately)
INSERT INTO `enrollment_historys` (`enroll_id`, `course_id`, `student_id`, `enrol_date`, `total`) VALUES
	(2, 2, 1, '1999-05-08 00:00:00', 6.00),
	(3, 3, 2, '1950-06-06 00:00:00', 120.00);

-- Dumping structure for table Students.levels
CREATE TABLE IF NOT EXISTS `levels` (
  `level_id` int(11) NOT NULL AUTO_INCREMENT,
  `level_name` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`level_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table Students.levels: ~2 rows (approximately)
INSERT INTO `levels` (`level_id`, `level_name`) VALUES
	(1, 'A'),
	(2, 'B'),
	(3, 'C'),
	(4, 'D');

-- Dumping structure for table Students.students
CREATE TABLE IF NOT EXISTS `students` (
  `student_id` int(11) NOT NULL AUTO_INCREMENT,
  `student_name` varchar(40) DEFAULT NULL,
  `contact_id` int(11) DEFAULT NULL,
  `address_id` int(11) DEFAULT NULL,
  `level_id` int(11) DEFAULT NULL,
  `BOD` date DEFAULT NULL,
  PRIMARY KEY (`student_id`),
  KEY `students_contacts_contact_id_fk` (`contact_id`),
  KEY `students_levels_level_id_fk` (`level_id`),
  KEY `students_addresss_address_id_fk` (`address_id`),
  CONSTRAINT `students_addresss_address_id_fk` FOREIGN KEY (`address_id`) REFERENCES `addresss` (`address_id`),
  CONSTRAINT `students_contacts_contact_id_fk` FOREIGN KEY (`contact_id`) REFERENCES `contacts` (`contact_id`),
  CONSTRAINT `students_levels_level_id_fk` FOREIGN KEY (`level_id`) REFERENCES `levels` (`level_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table Students.students: ~3 rows (approximately)
INSERT INTO `students` (`student_id`, `student_name`, `contact_id`, `address_id`, `level_id`, `BOD`) VALUES
	(1, 'Mahmoud', 1, 1, 1, '1999-05-05'),
	(2, 'Ali', 2, 3, 2, '1980-06-09'),
	(3, 'Ahmed', 3, 2, 3, '1970-05-05');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
