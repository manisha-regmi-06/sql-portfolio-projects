-- =====================================================================
-- PROJECT: Bean & Brew Coffee Shop (Phase 2: Subqueries, Views & CASE)
-- DESCRIPTION: Explores advanced intermediate features like virtual tables,
--              conditional logic, and subqueries.
-- =====================================================================

USE bean_and_brew;

-- =====================================================================
-- 1. Conditional Logic with CASE Statements
-- =====================================================================
-- Categorize orders based on quantity purchased
SELECT 
    order_id,
    quantity,
    CASE 
        WHEN quantity = 1 THEN 'Single Item'
        WHEN quantity BETWEEN 2 AND 3 THEN 'Medium Batch'
        ELSE 'Bulk Order'
    END AS order_size_category
FROM orders;

-- =====================================================================
-- 2. Subqueries (Nested Queries)
-- =====================================================================
-- Find all products that are priced higher than the average product price
SELECT product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- =====================================================================
-- 3. Creating and Using Views
-- =====================================================================
-- Create a secure, reusable virtual table for daily sales summaries
CREATE OR REPLACE VIEW vw_customer_order_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.quantity) AS total_items_bought
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Query the view just like a normal table
SELECT * 
FROM vw_customer_order_summary 
WHERE total_orders > 0;