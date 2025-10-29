# SECTION 1: DATABASE SETUP-
CREATE DATABASE ecommercedb;
USE ecommercedb;

-- View all tables:
SELECT*FROM customers;
SELECT*FROM orders;
SELECT*FROM order_items;
SELECT*FROM products;
SELECT*FROM returns;


# SECTION 2: DATA PREVIEW & INITIAL EXPLORATION-
-- Preview first 5:
SELECT*FROM customers LIMIT 5;
SELECT*FROM orders LIMIT 5;
SELECT*FROM order_items LIMIT 5;
SELECT*FROM products LIMIT 5;
SELECT*FROM returns LIMIT 5;


-- Data Counts:
SELECT 'customers' AS table_name, COUNT(*) AS myrows FROM customers
UNION ALL
SELECT 'orders' AS table_name, COUNT(*) FROM orders
UNION ALL
SELECT 'order_items' AS table_name, COUNT(*) FROM order_items
UNION ALL
SELECT 'products' AS table_name, COUNT(*) FROM products
UNION ALL
SELECT 'returns' AS table_name, COUNT(*) FROM returns
UNION ALL
SELECT 'returns', COUNT(*) FROM returns;


# SECTION 3: DATA QUALITY-- NULL & MISSING VALUE CHECKS-
-- Count NULLs in customers:
SELECT 
SUM(customer_id IS NULL) AS nulls_customer_id,
SUM(name IS NULL) AS nulls_name,
SUM(email IS NULL) AS nulls_email,
SUM(signup_date IS NULL) AS nulls_signup_date,
SUM(region IS NULL) AS nulls_region
FROM customers;


-- Count NULLs in orders:
SELECT 
SUM(order_id IS NULL) AS nulls_order_id,
SUM(customer_id IS NULL) AS nulls_customer_id,
SUM(order_date IS NULL) AS nulls_order_date,
SUM(total_amount IS NULL) AS nulls_total_amount
FROM orders;


-- Count NULLs in order_items:
SELECT 
SUM(order_item_id IS NULL) AS nulls_order_item_id,
SUM(order_id IS NULL) AS nulls_order_id,
SUM(product_id IS NULL) AS nulls_product_id,
SUM(quantity IS NULL) AS nulls_quantity,
SUM(item_price IS NULL) AS nulls_item_price
FROM order_items;


-- Count NULLs in products:
SELECT 
SUM(product_id IS NULL) AS nulls_product_id,
SUM(name IS NULL) AS nulls_name,
SUM(category IS NULL) AS nulls_category,
SUM(price IS NULL) AS nulls_price
FROM products;


-- Count NULLs in returns:
SELECT 
SUM(return_id IS NULL) AS nulls_return_id,
SUM(order_id IS NULL) AS nulls_order_id,
SUM(return_date IS NULL) AS nulls_return_date,
SUM(reason IS NULL) AS nulls_reason
FROM returns;


-- Percent NULLs by column in customers:
SELECT 
100 * SUM(name IS NULL) / COUNT(*) AS pct_null_name,
100 * SUM(email IS NULL) / COUNT(*) AS pct_null_email,
100 * SUM(signup_date IS NULL) / COUNT(*) AS pct_null_signup_date,
100 * SUM(region IS NULL) / COUNT(*) AS pct_null_region
FROM customers;


# SECTION 4: BASIC STATISTICS & SUMMARY METRICS-
-- Basic statistics for order amounts:
SELECT 
MIN(total_amount) AS min_amt,
MAX(total_amount) AS max_amt,
AVG(total_amount) AS avg_amt,
SUM(total_amount) AS sum_amt
FROM orders;


-- Basic statistics for order item prices and quantities:
SELECT 
MIN(item_price) AS min_price,
MAX(item_price) AS max_price,
AVG(item_price) AS avg_price,
MIN(quantity) AS min_qty,
MAX(quantity) AS max_qty,
AVG(quantity) AS qvg_qty
FROM order_items;


# SECTION 5: DUPLICATE DATA HANDLING-
-- Find customers with duploicate emails:
SELECT email, COUNT(*) AS dup_count
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;


-- Find duplicate orders by customer and date:
SELECT customer_id, order_date, COUNT(*) AS dup_count
FROM orders
GROUP BY customer_id, order_date
HAVING COUNT(*) > 1;


-- Find duplicate order_items for same product in same order:
SELECT order_id, product_id, COUNT(*) AS dup_count
FROM order_items
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;


-- Disable safe mode for deletion operations:
SET SQL_SAFE_UPDATES = 0; 

-- Delete duplicate customers by email (keep earliest signup): # CTE - Common Table Expression in window function
WITH ranked AS (
SELECT*, ROW_NUMBER() OVER (PARTITION BY email ORDER BY signup_date) AS rn
FROM customers
)
DELETE FROM customers
WHERE customer_id IN (SELECT customer_id FROM ranked WHERE rn > 1);


-- Delete duplicate order_items by order-product combination: 
WITH ranked AS (
SELECT order_item_id, ROW_NUMBER() OVER (PARTITION BY order_id, product_id ORDER BY order_item_id) AS rn
FROM order_items
)
DELETE FROM order_items
WHERE order_item_id IN (SELECT order_item_id FROM ranked WHERE rn > 1);


# SECTION 6: DATA VALIDATION & CLEANING PATTERNS-
-- Find blank or invalid email addresses:
SELECT* FROM customers
WHERE email IS NULL
OR TRIM(email) = ''
OR email NOT REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$';


-- Find products with missing names:
SELECT*FROM products WHERE name IS NULL OR TRIM(name) = '';


-- Replace missing region with 'Unknown':
SELECT customer_id, name, email, signup_date,
COALESCE(region, 'UNKNOWN') AS region_imputed
FROM customers;


-- Drop rows with NULL total_amount:
SELECT*FROM orders WHERE total_amount IS NOT NULL;


# SECTION 7: REFERENTIAL INTEGRITY CHECKS-
-- Orders referencing non-existent customers:
SELECT o. *FROM orders o 
LEFT JOIN customers c ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL;


-- Order items referencing missing products:
SELECT oi. * FROM order_items oi
LEFT JOIN products p ON p.product_id = oi.product_id
WHERE p.product_id IS NULL;


-- Returns referencing missing orders:
SELECT r. * FROM returns r 
LEFT JOIN orders o ON o.order_id = r.order_id
WHERE o.order_id IS NULL;


# SECTION 8: SALES & REVENUE ANALYSIS-
-- Revenue by product category:
SELECT p.category, SUM(oi.quantity * oi.item_price) AS revenue
FROM order_items oi 
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY revenue DESC;


-- Top 5 products by revenue:
SELECT p.product_id, p.name, SUM(oi.quantity * oi.item_price) AS revenue
FROM order_items oi 
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name
ORDER BY revenue DESC
LIMIT 5;


-- Orders per customer:
SELECT c.customer_id, c.name, COUNT(o.order_id) AS orders_count
FROM customers c 
LEFT JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY orders_count DESC;


-- Average order value ( AOV):
SELECT AVG(total_amount) AS avg_order_value FROM orders;


-- Customer-level total revenue:
SELECT c.customer_id, c.name, SUM(oi.quantity * oi.item_price) AS total_revenue
FROM customers c 
JOIN orders o ON o.customer_id = c.customer_id 
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_id, c.name
ORDER BY total_revenue DESC;

# SECTION 9: TIME - BASED ANALYSIS-
-- Monthly revenue trend:
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,
SUM(oi.quantity * oi.item_price) AS revenue
FROM orders o 
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY month
ORDER BY month;


-- Daily order counts:
SELECT DATE(order_date) AS order_day, COUNT(*) AS orders
FROM orders
GROUP BY order_day
ORDER BY order_day;


# SECTION 10: PRODUCT & CATEGORY ANALYSIS-
-- Category mix by month:
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month, p.category,
SUM(oi.quantity) AS units_sold
FROM orders o 
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
GROUP BY month, p.category
ORDER BY month, units_sold DESC;


-- First order date per customer:
SELECT customer_id, MIN(order_date) AS first_order_date
FROM orders
GROUP BY customer_id;


# SECTION 11: CUSTOMER BEHAVIOR & COHORTS-
-- Cohort: customer by signup month:
SELECT DATE_FORMAT(signup_date, '%Y-%m') AS signup_month, COUNT(*) AS new_customers
FROM customers
GROUP BY signup_month
ORDER BY signup_month;


-- Orders placed within 30 days of signup (early activation):
SELECT c.customer_id, COUNT(o.order_id) AS orders_in_30d
FROM customers c 
LEFT JOIN orders o 
ON o.customer_id = c.customer_id
AND o.order_date <= DATE_ADD(c.signup_date, INTERVAL 30 DAY) 
GROUP BY c.customer_id
ORDER BY orders_in_30d DESC;


# SECTION 12: WINDOW FUNCTIONS & ANALYTICS-
-- Rank customers by total revenue:
SELECT customer_id, name, total_revenue,
DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS rank_position
FROM (
SELECT c.customer_id, c.name, SUM(oi.quantity * oi.item_price) AS total_revenue
FROM customers c 
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_id, c.name
) AS t;


#  SECTION 13: RETURN & REFUND ANALYSIS-
-- Return rate (% of total orders):
SELECT 100 * COUNT(DISTINCT r.order_id) / COUNT(DISTINCT o.order_id) AS return_rate_pct
FROM orders o 
LEFT JOIN returns r ON r.order_id = o.order_id;


-- Return reasons:
SELECT reason, COUNT(*) AS reason_count
FROM returns
GROUP BY reason
ORDER BY reason_count DESC;


-- Revenue lost to returns (assuming full refund):
SELECT SUM(o.total_amount) AS refund_value
FROM orders o 
JOIN returns r ON r.order_id = o.order_id;


# SECTION 14: GEOGRAPHICAL INSIGHTS-
-- Customers by region:
SELECT region, COUNT(*) AS customer_count
FROM customers
GROUP BY region
ORDER BY customer_count DESC;


-- Revenue by region:
SELECT c.region, SUM(oi.quantity * oi.item_price) AS regional_revenue
FROM customers c 
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.region
ORDER BY regional_revenue DESC;


 