CREATE DATABASE IF NOT EXISTS pwskills_assignment;
USE pwskills_assignment;

-- Create Students Table

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    course VARCHAR(50),
    score INT,
    attendance INT,
    join_date DATE,
    city VARCHAR(50)
);

-- Insert Sample Data

INSERT INTO students VALUES
(1, 'Amit', 'Data Science', 85, 90, '2023-06-15', 'Mumbai'),
(2, 'Priya', 'Data Science', 92, 95, '2023-07-10', 'Delhi'),
(3, 'Rahul', 'Web Development', 78, 88, '2023-08-05', 'Mumbai'),
(4, 'Sneha', 'Web Development', 88, 91, '2023-06-20', 'Chennai'),
(5, 'Karan', 'Data Science', 95, 97, '2023-09-01', 'Mumbai'),
(6, 'Neha', 'Cyber Security', 80, 85, '2023-07-18', 'Delhi'),
(7, 'Arjun', 'Cyber Security', 89, 93, '2023-08-25', 'Mumbai'),
(8, 'Meera', 'Web Development', 76, 82, '2023-09-12', 'Kolkata');

-- Question 1:
-- Create a ranking of students based on score (highest first).

SELECT 
    student_name,
    score,
    RANK() OVER (ORDER BY score DESC) AS student_rank
FROM students;

-- Question 2:
-- Show each student's score and the previous student’s score (based on score order).

SELECT 
    student_name,
    score,
    LAG(score) OVER (ORDER BY score DESC) AS previous_score
FROM students;

-- Question 3:
-- Convert all student names to uppercase and extract the month name from join_date.

SELECT 
    UPPER(student_name) AS student_name_upper,
    MONTHNAME(join_date) AS join_month
FROM students;

-- Question 4:
-- Show each student's name and the next student’s attendance (ordered by attendance).

SELECT 
    student_name,
    attendance,
    LEAD(attendance) OVER (ORDER BY attendance DESC) AS next_student_attendance
FROM students;

-- Question 5:
-- Assign students into 4 performance groups using NTILE().

SELECT 
    student_name,
    score,
    NTILE(4) OVER (ORDER BY score DESC) AS performance_group
FROM students;

-- Question 6:
-- For each course, assign a row number based on attendance (highest first).

SELECT 
    student_name,
    course,
    attendance,
    ROW_NUMBER() OVER (PARTITION BY course ORDER BY attendance DESC) AS row_num
FROM students;

-- Question 7:
-- Calculate the number of days each student has been enrolled 
-- (Assume current date = '2025-01-01')

SELECT 
    student_name,
    join_date,
    DATEDIFF('2025-01-01', join_date) AS days_enrolled
FROM students;

-- Question 8:
-- Format join_date as “Month Year” (e.g., “June 2023”).

SELECT 
    student_name,
    DATE_FORMAT(join_date, '%M %Y') AS formatted_join_date
FROM students;

-- Question 9:
-- Replace the city ‘Mumbai’ with ‘MUM’ for display purposes.

SELECT 
    student_name,
    REPLACE(city, 'Mumbai', 'MUM') AS city_display
FROM students;

-- Question 10:
-- For each course, find the highest score using FIRST_VALUE().

SELECT 
    student_name,
    course,
    score,
    FIRST_VALUE(score) OVER (PARTITION BY course ORDER BY score DESC) AS highest_score_in_course
FROM students;