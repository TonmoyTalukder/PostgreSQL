-- Active: 1729708121375@@127.0.0.1@5432@university_db
-- CREATE DATABASE university_db;
-- Create Tables 

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,       
    student_name VARCHAR(100) NOT NULL,  
    age INT,                               
    email VARCHAR(100) UNIQUE NOT NULL,    
    frontend_mark INT,                     
    backend_mark INT,                      
    status VARCHAR(50)                     
);

CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,          
    course_name VARCHAR(100) NOT NULL,     
    credits INT NOT NULL                   
);

CREATE TABLE enrollment (
    enrollment_id SERIAL PRIMARY KEY,  
    student_id INT REFERENCES students(student_id) ON DELETE RESTRICT,  
    course_id INT REFERENCES courses(course_id) ON DELETE RESTRICT    
);

-- Insert Sample Data 

INSERT INTO students (student_id, student_name, age, email, frontend_mark, backend_mark, status)
VALUES 
(1, 'Sameer', 21, 'sameer@example.com', 48, 60, NULL),
(2, 'Zoya', 23, 'zoya@example.com', 52, 58, NULL),
(3, 'Nabil', 22, 'nabil@example.com', 37, 46, NULL),
(4, 'Rafi', 24, 'rafi@example.com', 41, 40, NULL),
(5, 'Sophia', 22, 'sophia@example.com', 50, 52, NULL),
(6, 'Hasan', 23, 'hasan@gmail.com', 43, 39, NULL);

SELECT setval(pg_get_serial_sequence('students', 'student_id'), COALESCE(MAX(student_id), 0) + 1, false)
FROM students;


INSERT INTO courses (course_id, course_name, credits)
VALUES 
(1, 'Next.js', 3),
(2, 'React.js', 4),
(3, 'Databases', 3),
(4, 'Prisma', 3);

SELECT setval(pg_get_serial_sequence('courses', 'course_id'), COALESCE(MAX(course_id), 0) + 1, false)
FROM courses;


INSERT INTO enrollment (enrollment_id, student_id, course_id)
VALUES 
(1, 1, 1),
(2, 1, 2),
(3, 2, 1),
(4, 3, 2);

SELECT setval(pg_get_serial_sequence('enrollment', 'enrollment_id'), COALESCE(MAX(enrollment_id), 0) + 1, false)
FROM enrollment;


-- Query 1
-- Insert a new student record with the following details:
-- Name: YourName
-- Age: YourAge
-- Email: YourEmail
-- Frontend-Mark: YourMark
-- Backend-Mark: YourMark
-- Status: NULL
-- Note: You can choose random values for the frontend_mark, backend_mark, and other fields (except NULL for the status).

INSERT INTO students (student_name, age, email, frontend_mark, backend_mark, status)
VALUES ('Tonmoy Talukder', 26, 'tonmoy@talukder.com', 55, 60, NULL);

-- Query 2:
-- Retrieve the names of all students who are enrolled in the course titled 'Next.js'.

SELECT s.student_name FROM students s
    JOIN enrollment e ON s.student_id = e.student_id
    JOIN courses c ON e.course_id = c.course_id
        WHERE c.course_name = 'Next.js';

-- Query 3:
-- Update the status of the student with the highest total (frontend_mark + backend_mark) to 'Awarded'.
UPDATE students
SET status = 'Awarded'
WHERE student_id = (
    SELECT student_id
    FROM students
    ORDER BY (frontend_mark + backend_mark) DESC
    LIMIT 1
);

-- Query 4:
-- Delete all courses that have no students enrolled.
DELETE FROM courses
WHERE course_id NOT IN (
    SELECT DISTINCT course_id
    FROM enrollment
);

-- Query 5:
-- Retrieve the names of students using a limit of 2, starting from the 3rd student.
SELECT student_name FROM students ORDER BY student_id LIMIT 2 OFFSET 2;

-- Query 6:
-- Retrieve the course names and the number of students enrolled in each course.
SELECT c.course_name, COUNT(e.student_id) AS students_enrolled
    FROM courses c
        LEFT JOIN enrollment e ON c.course_id = e.course_id
        GROUP BY c.course_name;

-- Query 7:
-- Calculate and display the average age of all students.
SELECT AVG(age) AS average_age FROM students;

-- Query 8:
-- Retrieve the names of students whose email addresses contain 'example.com'.
SELECT student_name FROM students
    WHERE email LIKE '%example.com%';

SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM enrollment;