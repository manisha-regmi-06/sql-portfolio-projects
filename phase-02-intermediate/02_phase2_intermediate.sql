-- =====================================================================
-- PROJECT: Bean & Brew Coffee Shop (Phase 2: Relational Design & Joins)
-- DESCRIPTION: Introduces Foreign Key relationships, referential 
--              integrity, and multi-table JOIN operations.
-- =====================================================================

-- 1. Database Setup
CREATE DATABASE IF NOT EXISTS bean_and_brew;
USE bean_and_brew;

-- 2. Clean up existing tables in correct order (Child tables first due to FKs)
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;

-- =====================================================================
-- 3. Data Definition Language (DDL): Tables with Foreign Key Constraints
-- =====================================================================

-- Products table (Parent)
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(5, 2) NOT NULL,
    in_stock BOOLEAN DEFAULT TRUE
);

-- Customers table (Parent)
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    join_date DATE NOT NULL
);

-- Orders table (Child) - Now with explicit Foreign Keys
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    order_date DATETIME NOT NULL,
    order_status VARCHAR(20) DEFAULT 'Completed',
    
    -- Defining Foreign Key Relationships
    CONSTRAINT fk_orders_customer 
        FOREIGN KEY (customer_id) 
        REFERENCES customers(customer_id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
        
    CONSTRAINT fk_orders_product 
        FOREIGN KEY (product_id) 
        REFERENCES products(product_id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

-- =====================================================================
-- 4. Data Manipulation Language (DML): Inserting Relational Data
-- =====================================================================

-- Populate Products
INSERT INTO products (product_name, category, price, in_stock) VALUES
('Espresso', 'Beverage', 3.00, TRUE),
('Cappuccino', 'Beverage', 4.50, TRUE),
('Latte', 'Beverage', 4.75, TRUE),
('Blueberry Muffin', 'Bakery', 3.50, TRUE),
('Almond Croissant', 'Bakery', 4.00, TRUE),
('Cold Brew', 'Beverage', 4.25, TRUE);

-- Populate Customers (Including one new customer who hasn't ordered yet)
INSERT INTO customers (first_name, last_name, email, join_date) VALUES
('Alice', 'Smith', 'alice@gmail.com', '2026-01-10'),
('Bob', 'Jones', 'bob.j@yahoo.com', '2026-01-15'),
('Charlie', 'Brown', 'charlie@outlook.com', '2026-02-01'),
('Diana', 'Prince', 'diana@amazon.org', '2026-02-14'),
('Evan', 'Wright', 'evan.w@gmail.com', '2026-03-05'); -- No orders yet!

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
-- 5. Data Query Language (DQL): Intermediate Joins
-- =====================================================================

-- Query 1: INNER JOIN - Get a detailed receipt view of all completed orders
SELECT 
    o.order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    p.product_name,
    o.quantity,
    p.price,
    (o.quantity * p.price) AS total_item_cost,
    o.order_date
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN products p ON o.product_id = p.product_id
WHERE o.order_status = 'Completed'
ORDER BY o.order_date;

-- Query 2: LEFT JOIN - Find all customers, even those who haven't placed an order yet
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.order_id) AS total_orders_placed
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_orders_placed DESC;