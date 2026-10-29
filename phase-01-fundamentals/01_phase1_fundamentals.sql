-- =====================================================================
-- PROJECT: Bean & Brew Coffee Shop (Phase 1: Fundamentals)
-- DESCRIPTION: Sets up the database, creates standalone tables with 
--              constraints, and populates initial CRUD sample data.
-- SECURITY BEST PRACTICE: Avoid hardcoding sensitive user credentials 
--                         or production passwords directly in scripts.
-- =====================================================================

-- 1. Database Setup (Idempotent: drops and recreates cleanly)
DROP DATABASE IF EXISTS bean_and_brew;
CREATE DATABASE bean_and_brew;
USE bean_and_brew;

-- 2. Clean up existing tables if re-running script (Child tables first)
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;

-- =====================================================================
-- 3. Data Definition Language (DDL): Creating Tables & Constraints
-- =====================================================================

-- Products table: Stores item catalog, pricing, and stock status
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(5, 2) NOT NULL,
    in_stock BOOLEAN DEFAULT TRUE
);

-- Customers table: Stores user profiles with unique emails
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    join_date DATE NOT NULL
);

-- Orders table: Logs transaction records (Standalone for Phase 1)
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    order_date DATETIME NOT NULL,
    order_status VARCHAR(20) DEFAULT 'Completed'
);

-- =====================================================================
-- 4. Data Manipulation Language (DML): Inserting Initial Data (CRUD)
-- =====================================================================

-- Populate Products
INSERT INTO products (product_name, category, price, in_stock) VALUES
('Espresso', 'Beverage', 3.00, TRUE),
('Cappuccino', 'Beverage', 4.50, TRUE),
('Latte', 'Beverage', 4.75, TRUE),
('Blueberry Muffin', 'Bakery', 3.50, TRUE),
('Almond Croissant', 'Bakery', 4.00, TRUE),
('Cold Brew', 'Beverage', 4.25, TRUE);

-- Populate Customers
INSERT INTO customers (first_name, last_name, email, join_date) VALUES
('Alice', 'Smith', 'alice@gmail.com', '2026-01-10'),
('Bob', 'Jones', 'bob.j@yahoo.com', '2026-01-15'),
('Charlie', 'Brown', 'charlie@outlook.com', '2026-02-01'),
('Diana', 'Prince', 'diana@amazon.org', '2026-02-14');

-- Populate Orders
INSERT INTO orders (customer_id, product_id, quantity, order_date, order_status) VALUES
(1, 2, 2, '2026-03-01 08:30:00', 'Completed'),
(1, 4, 1, '2026-03-01 08:30:00', 'Completed'),
(2, 1, 1, '2026-03-02 09:15:00', 'Completed'),
(3, 3, 2, '2026-03-02 10:00:00', 'Completed'),
(3, 5, 1, '2026-03-02 10:00:00', 'Completed'),
(4, 6, 3, '2026-03-03 14:20:00', 'Completed'),
(2, 2, 1, '2026-03-03 15:00:00', 'Cancelled');

-- =====================================================================
-- 5. Data Query Language (DQL): Sample Phase 1 Verification Queries
-- =====================================================================

-- Query A: Find top 2 most expensive products
SELECT product_name, price 
FROM products 
ORDER BY price DESC 
LIMIT 2;

-- Query B: Find total quantity sold per product for completed orders
SELECT product_id, SUM(quantity) AS total_sold 
FROM orders 
WHERE order_status = 'Completed'
GROUP BY product_id 
HAVING SUM(quantity) >= 2;