-- =====================================================================
-- PROJECT: Bean & Brew Coffee Shop (Phase 2: Dates, Strings & NULLs)
-- DESCRIPTION: Demonstrates string formatting, date/time extraction,
--              date math, and NULL handling using COALESCE and IFNULL.
-- =====================================================================

USE bean_and_brew;

-- =====================================================================
-- 1. String Manipulation Functions
-- =====================================================================
-- Format customer profiles: uppercase last names, extract email domains,
-- and create a clean 3-letter product code.
SELECT 
    customer_id,
    UPPER(last_name) AS last_name_caps,
    LOWER(first_name) AS first_name_lower,
    email,
    SUBSTRING_INDEX(email, '@', -1) AS email_domain,
    CHAR_LENGTH(email) AS email_length
FROM customers;

SELECT 
    product_id,
    product_name,
    UPPER(LEFT(product_name, 3)) AS short_code,
    CONCAT('$', FORMAT(price, 2)) AS formatted_price
FROM products;

-- =====================================================================
-- 2. Date & Time Manipulation Functions
-- =====================================================================
-- Extract specific time parts (day name, hour of day) to analyze peak hours,
-- and calculate how many days each customer has been a member.
SELECT 
    order_id,
    order_date,
    DATE(order_date) AS order_calendar_date,
    DAYNAME(order_date) AS day_of_week,
    HOUR(order_date) AS order_hour
FROM orders;

SELECT 
    customer_id,
    CONCAT(first_name, ' ', last_name) AS customer_name,
    join_date,
    DATEDIFF('2026-03-10', join_date) AS days_since_joining,
    DATE_ADD(join_date, INTERVAL 1 YEAR) AS one_year_anniversary
FROM customers;

-- =====================================================================
-- 3. Handling NULL Values (COALESCE & IFNULL)
-- =====================================================================
-- When we LEFT JOIN customers to orders, Evan Wright (customer_id = 5)
-- has NULL values because he hasn't ordered yet. We replace NULLs with 0
-- or fallback text so reports never show raw NULLs.
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COALESCE(MAX(DATE(o.order_date)), 'No Orders Yet') AS last_order_date,
    IFNULL(SUM(o.quantity), 0) AS total_items_purchased
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_items_purchased DESC;