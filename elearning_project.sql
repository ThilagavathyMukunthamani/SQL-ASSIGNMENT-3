-- 1. Create and select the database
CREATE DATABASE IF NOT EXISTS elearning_db;
USE elearning_db;

-- 2. Create the learners table
CREATE TABLE learners (
    learner_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL
);

-- 3. Create the courses table
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL
);

-- 4. Create the purchases table with foreign key constraints
CREATE TABLE purchases (
    purchase_id INT AUTO_INCREMENT PRIMARY KEY,
    learner_id INT NOT NULL,
    course_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    purchase_date DATE NOT NULL,
    FOREIGN KEY (learner_id) REFERENCES learners(learner_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

-- Insert sample learners (5 learners)
INSERT INTO learners (full_name, country) VALUES
('RAMU', 'USA'),
('ANITHA', 'Canada'),
('VARUN', 'UK'),
('VEDA', 'USA'),
('SACHIN', 'Australia');

-- Insert sample courses (5 courses across multiple categories; 1 unpurchased)
INSERT INTO courses (course_name, category, unit_price) VALUES
('Data Science Fundamentals', 'Data Analytics', 99.99),
('Advanced MySQL Mastery', 'Database', 149.50),
('Python Web Development', 'Programming', 89.00),
('Power BI Dashboards', 'Data Analytics', 119.99),
('Advance Excel', 'Programming', 49.99); -- Unpurchased course

-- Insert sample purchase records (7 records)
INSERT INTO purchases (learner_id, course_id, quantity, purchase_date) VALUES
(1, 1, 2, '2026-10-01'),
(1, 2, 1, '2026-10-05'),
(2, 1, 1, '2026-10-02'),
(3, 3, 3, '2026-10-04'),
(4, 2, 1, '2026-10-06'),
(4, 4, 1, '2026-10-07'),
(1, 4, 1, '2026-10-08');

-- DATA EXPLORATION USING JOINS

-- INNER JOINS

SELECT 
    p.purchase_id,
    l.full_name AS learner_name,
    l.country,
    c.course_name,
    c.category,
    p.quantity,
    FORMAT(c.unit_price, 2) AS unit_price,
    FORMAT(p.quantity * c.unit_price, 2) AS total_amount,
    p.purchase_date
FROM purchases p
INNER JOIN learners l ON p.learner_id = l.learner_id
INNER JOIN courses c ON p.course_id = c.course_id
ORDER BY p.purchase_date DESC;

-- LEFT JOINS

SELECT 
    l.learner_id,
    l.full_name AS learner_name,
    l.country,
    c.course_name,
    p.quantity,
    FORMAT(IFNULL(p.quantity * c.unit_price, 0), 2) AS total_amount
FROM learners l
LEFT JOIN purchases p ON l.learner_id = p.learner_id
LEFT JOIN courses c ON p.course_id = c.course_id
ORDER BY l.learner_id ASC;

-- RIGHT JOINS

SELECT 
    c.course_id,
    c.course_name,
    c.category,
    p.purchase_id,
    p.quantity,
    p.purchase_date
FROM purchases p
RIGHT JOIN courses c ON p.course_id = c.course_id
ORDER BY c.course_id ASC;

-- Display each learner’s total spending (quantity × unit_price) along with their country.

SELECT 
    l.learner_id,
    l.full_name AS learner_name,
    l.country,
    FORMAT(SUM(p.quantity * c.unit_price), 2) AS total_spent
FROM learners l
INNER JOIN purchases p ON l.learner_id = p.learner_id
INNER JOIN courses c ON p.course_id = c.course_id
GROUP BY l.learner_id, l.full_name, l.country
ORDER BY SUM(p.quantity * c.unit_price) DESC;

--  Find the top 3 most purchased courses based on total quantity sold.

SELECT 
    c.course_id,
    c.course_name,
    c.category,
    SUM(p.quantity) AS total_quantity_sold
FROM courses c
INNER JOIN purchases p ON c.course_id = p.course_id
GROUP BY c.course_id, c.course_name, c.category
ORDER BY total_quantity_sold DESC
LIMIT 3;

-- each course category’s total revenue and the number of unique learners who purchased from that category.

SELECT 
    c.category,
    FORMAT(SUM(p.quantity * c.unit_price), 2) AS total_revenue,
    COUNT(DISTINCT p.learner_id) AS unique_learners_count
FROM courses c
INNER JOIN purchases p ON c.course_id = p.course_id
GROUP BY c.category
ORDER BY SUM(p.quantity * c.unit_price) DESC;

-- List all learners who have purchased courses from more than one category.

SELECT 
    l.learner_id,
    l.full_name AS learner_name,
    COUNT(DISTINCT c.category) AS categories_purchased_count
FROM learners l
INNER JOIN purchases p ON l.learner_id = p.learner_id
INNER JOIN courses c ON p.course_id = c.course_id
GROUP BY l.learner_id, l.full_name
HAVING COUNT(DISTINCT c.category) > 1;

--  Identify courses that have not been purchased at all.

SELECT 
    c.course_id,
    c.course_name,
    c.category,
    FORMAT(c.unit_price, 2) AS unit_price
FROM courses c
LEFT JOIN purchases p ON c.course_id = p.course_id
WHERE p.purchase_id IS NULL;


