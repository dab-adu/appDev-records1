CREATE TABLE IF NOT EXISTS `courses` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `program` VARCHAR(100) NOT NULL,
  `course_name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `courses` (`program`, `course_name`) VALUES
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

ALTER TABLE `users`
ADD COLUMN `course_id` INT(11) NULL AFTER `username`,
ADD CONSTRAINT `fk_users_course` FOREIGN KEY (`course_id`) REFERENCES `courses`(`id`);

UPDATE `users` u
JOIN (
    SELECT id AS course_id FROM `courses`
) c
SET u.course_id = (SELECT id FROM `courses` ORDER BY RAND() LIMIT 1)
WHERE u.course_id IS NULL;
