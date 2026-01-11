/* ================================
   CREATE DATABASE
   ================================ */
CREATE DATABASE college_db2;
USE college_db2;

/* ================================
   TABLE CREATION (DDL)
   ================================ */

CREATE TABLE Departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    gender ENUM('Male','Female','Other'),
    dob DATE,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    department_id INT,
    credits INT CHECK (credits > 0),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Marks (
    mark_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    marks_obtained INT CHECK (marks_obtained BETWEEN 0 AND 100),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

/* ================================
   DATA INSERTION (DML)
   ================================ */

INSERT INTO Departments (department_name) VALUES
('Computer Science'),
('Mechanical'),
('Electrical'),
('Civil'),
('Electronics');

INSERT INTO Students (name, email, gender, dob, department_id) VALUES
('Alice','alice@gmail.com','Female','2002-05-10',1),
('Bob','bob@gmail.com','Male','2001-08-15',2),
('Charlie','charlie@gmail.com','Male','2002-01-20',1),
('Diana','diana@gmail.com','Female','2003-03-18',3),
('Eve','eve@gmail.com','Female','2002-07-22',4),
('Frank','frank@gmail.com','Male','2001-11-11',5),
('Grace','grace@gmail.com','Female','2002-09-05',1),
('Henry','henry@gmail.com','Male','2003-04-14',2),
('Ivy','ivy@gmail.com','Female','2002-12-01',3),
('Jack','jack@gmail.com','Male','2001-06-30',4);

INSERT INTO Courses (course_name, department_id, credits) VALUES
('Data Structures',1,4),
('DBMS',1,3),
('Thermodynamics',2,4),
('Machine Design',2,3),
('Power Systems',3,4),
('Circuits',3,3),
('Structural Engineering',4,4),
('Digital Electronics',5,3);

INSERT INTO Enrollments (student_id, course_id, enrollment_date) VALUES
(1,1,'2024-01-10'),
(1,2,'2024-01-10'),
(2,3,'2024-01-11'),
(3,1,'2024-01-12'),
(3,2,'2024-01-12'),
(4,5,'2024-01-13'),
(5,7,'2024-01-14'),
(6,8,'2024-01-14'),
(7,1,'2024-01-15'),
(7,2,'2024-01-15'),
(8,3,'2024-01-16'),
(9,5,'2024-01-17'),
(10,7,'2024-01-18'),
(2,4,'2024-01-19'),
(4,6,'2024-01-20');

INSERT INTO Marks (student_id, course_id, marks_obtained) VALUES
(1,1,85),
(1,2,78),
(2,3,65),
(3,1,90),
(3,2,88),
(4,5,72),
(5,7,81),
(6,8,60),
(7,1,95),
(7,2,89),
(8,3,70),
(9,5,76),
(10,7,68),
(2,4,74),
(4,6,80);

/* ================================
   BASIC QUERIES
   ================================ */

-- 1. Display all students
SELECT * FROM Students;

-- 2. Students belonging to a specific department
SELECT s.*
FROM Students s
JOIN Departments d ON s.department_id = d.department_id
WHERE d.department_name = 'Computer Science';

-- 3. Courses with department names
SELECT c.course_name, d.department_name
FROM Courses c
JOIN Departments d ON c.department_id = d.department_id;

-- 4. Students enrolled in more than one course
SELECT s.student_id, s.name, COUNT(e.course_id) AS total_courses
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.name
HAVING COUNT(e.course_id) > 1;

-- 5. Students with marks greater than 75
SELECT DISTINCT s.student_id, s.name
FROM Students s
JOIN Marks m ON s.student_id = m.student_id
WHERE m.marks_obtained > 75;

/* ================================
   JOIN QUERIES
   ================================ */

-- 1. Student name, course name, marks
SELECT s.name AS student_name, c.course_name, m.marks_obtained
FROM Marks m
JOIN Students s ON m.student_id = s.student_id
JOIN Courses c ON m.course_id = c.course_id;

-- 2. Students who have not received marks
SELECT s.student_id, s.name
FROM Students s
LEFT JOIN Marks m ON s.student_id = m.student_id
WHERE m.mark_id IS NULL;

-- 3. Department-wise student count
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM Departments d
LEFT JOIN Students s ON d.department_id = s.department_id
GROUP BY d.department_name;

-- 4. Course-wise average marks
SELECT c.course_name, AVG(m.marks_obtained) AS average_marks
FROM Courses c
JOIN Marks m ON c.course_id = m.course_id
GROUP BY c.course_name;