SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `program_id` INT(11) NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `users` (`id`, `username`, `first_name`, `last_name`, `email`, `password`, `created_at`)
VALUES
(1, 'S059713', 'gab', 'bar', 'gb@gmail.com', '$2y$10$L8J8F8tMn2YKcuYw1Bk8c.QF2T3YjHOPp7GbtoHpcxhDXqObo6kfS', '2025-11-27 12:55:49'),
(2, 'S024591', 'Juan', 'Dela Cruz', 'j_delacruz@email.com',
 '$2y$10$opYEFGgFuxmV3aNkSYuawehUdV77hqIBmwvLs6kclFC2qMaqJNF46', '2025-11-26 11:18:38');

CREATE TABLE IF NOT EXISTS `record_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `record_name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `record_types` (`id`, `record_name`) VALUES
(1, 'Change of Program/Major'),
(2, 'Dropping of Subjects'),
(3, 'Re-admission of Returning Student'),
(4, 'Simultaneous/Overload'),
(5, 'Requesting of Certificate of Enrollment');

CREATE TABLE IF NOT EXISTS `record_requests` (
  `request_id` char(36) NOT NULL DEFAULT uuid(),
  `user_id` varchar(255) NOT NULL,
  `record_type_id` int(11) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'Pending',
  `date_requested` timestamp NOT NULL DEFAULT current_timestamp(),
  `remarks` text DEFAULT NULL,
  PRIMARY KEY (`request_id`),
  KEY `user_id` (`user_id`),
  KEY `record_type_id` (`record_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `record_requests` VALUES
('52c168a3-cb97-11f0-b147-40c2ba07734b', 'S024591', 2, 'Pending', '2025-11-27 13:45:03', NULL),
('a28cbe43-cb96-11f0-b147-40c2ba07734b', 'S024591', 3, 'Pending', '2025-11-27 13:40:10', NULL),
('b47e2c5f-cab9-11f0-b147-40c2ba07734b', 'S024591', 1, 'Pending', '2025-11-26 11:18:59', NULL);

CREATE TABLE IF NOT EXISTS `courses` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `course_code` varchar(10) NOT NULL,
  `course_name` varchar(255) NOT NULL,
  `facilitator_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `course_code` (`course_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `courses` VALUES
(1, 'UI/UX', 'User Interface and Experience Design', 'Mr. Smith'),
(2, 'APPDV', 'Applications Devt & Emerging Technologies Lec & Lab', 'Ms. Jones'),
(3, 'IAS', 'Information Assurance and Security', 'Dr. Brown'),
(4, 'NET2', 'Networking II Lec & Lab', 'Ms. Garcia'),
(5, 'MOBDEV', 'Mobile Development Lec & Lab', 'Mr. Adamson');

CREATE TABLE IF NOT EXISTS `enrollments` (
  `user_id` varchar(20) NOT NULL,
  `course_id` int(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`user_id`,`course_id`),
  KEY `course_id` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `enrollments` VALUES
('S023005', 3),
('S023005', 5),
('S030213', 5),
('S030713', 1),
('S030713', 2),
('S030713', 3),
('S030713', 4),
('S059713', 5),
('S999999', 1),
('S999999', 2);

CREATE TABLE IF NOT EXISTS `subjects` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` varchar(20) NOT NULL,
  `subject_code` varchar(10) NOT NULL,
  `subject_name` varchar(255) NOT NULL,
  `schedule` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_subject` (`user_id`,`subject_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `subjects` VALUES
(1, 'S030713', 'CS101', 'Introduction to Computer Science', 'M/W 8:00 AM'),
(2, 'S030713', 'MATH202', 'Calculus II', 'T/Th 10:00 AM'),
(3, 'S030713', 'ENG305', 'Technical Writing', 'F 1:00 PM');

CREATE TABLE IF NOT EXISTS `programs` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `school` VARCHAR(100) NOT NULL,
  `program_name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT IGNORE INTO `programs` (`school`, `program_name`) VALUES
('COLLEGE OF ARCHITECTURE', 'Bachelor of Science in Architecture'),
('COLLEGE OF BUSINESS ADMINISTRATION', 'Bachelor of Science in Accountancy'),
('COLLEGE OF BUSINESS ADMINISTRATION', 'Bachelor of Science in Business Administration Major in Financial Management'),
('COLLEGE OF BUSINESS ADMINISTRATION', 'Bachelor of Science in Business Administration Major in Marketing Management'),
('COLLEGE OF BUSINESS ADMINISTRATION', 'Bachelor of Science in Business Administration Major in Operations Management'),
('COLLEGE OF BUSINESS ADMINISTRATION', 'Bachelor of Science in Customs Administration'),
('COLLEGE OF BUSINESS ADMINISTRATION', 'Bachelor of Science in Hospitality Management'),
('COLLEGE OF COMPUTING AND INFORMATION TECHNOLOGY', 'Bachelor of Science in Computer Science'),
('COLLEGE OF COMPUTING AND INFORMATION TECHNOLOGY', 'Bachelor of Science in Computer Science and Information Engineering'),
('COLLEGE OF COMPUTING AND INFORMATION TECHNOLOGY', 'Bachelor of Science in Information Systems'),
('COLLEGE OF COMPUTING AND INFORMATION TECHNOLOGY', 'Bachelor of Science in Information Technology'),
('COLLEGE OF COMPUTING AND INFORMATION TECHNOLOGY', 'Associate in Computer Technology (2-year course)'),
('COLLEGE OF ENGINEERING', 'Bachelor of Science in Chemical Engineering'),
('COLLEGE OF ENGINEERING', 'Bachelor of Science in Chemical Process Technology'),
('COLLEGE OF ENGINEERING', 'Bachelor of Science in Civil Engineering'),
('COLLEGE OF ENGINEERING', 'Bachelor of Science in Computer Engineering'),
('COLLEGE OF ENGINEERING', 'Bachelor of Science in Electrical Engineering'),
('COLLEGE OF ENGINEERING', 'Bachelor of Science in Electronics Engineering'),
('COLLEGE OF ENGINEERING', 'Bachelor of Science in Industrial Engineering'),
('COLLEGE OF ENGINEERING', 'Bachelor of Science in Mechanical Engineering'),
('COLLEGE OF ENGINEERING', 'Bachelor of Science in Mining Engineering'),
('COLLEGE OF ENGINEERING', 'Bachelor of Science in Geology'),
('COLLEGE OF ENGINEERING', 'Bachelor of Science in Petroleum Engineering'),
('COLLEGE OF ENGINEERING', 'Dual Degree of B.S. Mechanical Engineering major in Mechatronics'),
('COLLEGE OF LAW', 'Juris Doctor'),
('COLLEGE OF EDUCATION & LIBERAL ARTS', 'Bachelor of Elementary Education'),
('COLLEGE OF EDUCATION & LIBERAL ARTS', 'Bachelor of Secondary Education major in English'),
('COLLEGE OF EDUCATION & LIBERAL ARTS', 'Bachelor of Special Needs Education with specialization in Elementary School Teaching'),
('COLLEGE OF EDUCATION & LIBERAL ARTS', 'Bachelor of Physical Education'),
('COLLEGE OF EDUCATION & LIBERAL ARTS', 'Bachelor of Physical Education Major in Sports and Wellness Management'),
('COLLEGE OF EDUCATION & LIBERAL ARTS', 'Bachelor of Arts in Political Science'),
('COLLEGE OF EDUCATION & LIBERAL ARTS', 'Bachelor of Arts in Philosophy'),
('COLLEGE OF EDUCATION & LIBERAL ARTS', 'Bachelor of Arts in Communication'),
('COLLEGE OF NURSING', 'Bachelor of Science in Nursing'),
('COLLEGE OF PHARMACY', 'Bachelor of Science in Pharmacy'),
('COLLEGE OF PHARMACY', 'Doctor of Pharmacy'),
('COLLEGE OF SCIENCE', 'Bachelor of Science in Biology'),
('COLLEGE OF SCIENCE', 'Bachelor of Science in Chemistry'),
('COLLEGE OF SCIENCE', 'Bachelor of Science in Psychology');



ALTER TABLE `record_requests`
  ADD CONSTRAINT `fk_record_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`username`),
  ADD CONSTRAINT `fk_record_type` FOREIGN KEY (`record_type_id`) REFERENCES `record_types` (`id`);

ALTER TABLE `enrollments`
  ADD CONSTRAINT `enroll_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`);

ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_programs`
  FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`);

UPDATE users
SET program_id = (SELECT id FROM programs ORDER BY RAND() LIMIT 1)
WHERE program_id IS NULL;

COMMIT;
