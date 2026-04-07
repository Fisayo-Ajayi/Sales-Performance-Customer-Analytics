SELECT COUNT(*) FROM customers;
SELECT * FROM customers LIMIT 5;

SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;

SELECT COUNT(*) 
FROM customers
WHERE country = '';

First execution
-- ============================================
-- DATA VALIDATION: TABLE ROW COUNTS
-- Purpose: Ensure all tables loaded correctly
-- ============================================

SELECT COUNT(*) AS total_customers FROM customers;

SELECT COUNT(*) AS total_orders FROM orders;

SELECT COUNT(*) AS total_order_items FROM order_items;

SELECT COUNT(*) AS total_products FROM products;

Second execution
-- ============================================
-- DATA VALIDATION: ORDER STATUS DISTRIBUTION
-- Purpose: Understand how many orders are valid vs cancelled
-- ============================================

SELECT 
    status,
    COUNT(*) AS order_count
FROM orders
GROUP BY status;







Third execution
-- ============================================
-- DATA CLEANING: STANDARDIZE CATEGORY NAMES
-- Purpose: Ensure consistency (e.g., 'Tech', 'tech', 'TECH')
-- ============================================

UPDATE products
SET category = LOWER(category);


Fourth execution
-- ============================================
-- KPI ANALYSIS: MONTHLY REVENUE TREND
-- Purpose: Track revenue performance over time
-- ============================================

SELECT 
    strftime('%Y-%m', order_date) AS month,
    SUM(total_amount) AS revenue
FROM orders
WHERE status != 'cancelled'
GROUP BY month
ORDER BY month;


-- ============================================
-- KPI ANALYSIS: MONTHLY ORDER VOLUME
-- Purpose: Understand sales activity trends
-- ============================================

SELECT 
    strftime('%Y-%m', order_date) AS month,
    COUNT(*) AS total_orders
FROM orders
WHERE status != 'cancelled'
GROUP BY month
ORDER BY month;




-- ============================================
-- CUSTOMER ANALYSIS: LIFETIME VALUE (CLV)
-- Purpose: Identify high-value customers
-- ============================================

SELECT 
    customer_id,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS lifetime_value,
    AVG(total_amount) AS avg_order_value
FROM orders
WHERE status != 'cancelled'
GROUP BY customer_id
ORDER BY lifetime_value DESC;



-- ============================================
-- PRODUCT ANALYSIS: TOP PERFORMING PRODUCTS
-- Purpose: Identify products driving revenue
-- ============================================

SELECT 
    p.product_name,
    SUM(oi.quantity * oi.price) AS revenue
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;




-- ============================================
-- RETENTION ANALYSIS: MONTHLY ACTIVE CUSTOMERS
-- Purpose: Count unique customers per month
-- ============================================

SELECT 
    strftime('%Y-%m', order_date) AS month,
    COUNT(DISTINCT customer_id) AS active_customers
FROM orders
WHERE status != 'cancelled'
GROUP BY month
ORDER BY month;



-- ============================================
-- RETENTION ANALYSIS: REPEAT CUSTOMERS
-- Purpose: Identify customers with more than one purchase
-- ============================================

SELECT 
    COUNT(*) AS repeat_customers
FROM (
    SELECT customer_id
    FROM orders
    WHERE status != 'cancelled'
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
);



-- ============================================
-- RETENTION ANALYSIS: FIRST VS REPEAT PURCHASES
-- Purpose: Measure customer retention behavior
-- ============================================

SELECT 
    CASE 
        WHEN order_count = 1 THEN 'One-time buyers'
        ELSE 'Repeat customers'
    END AS customer_type,
    COUNT(*) AS total_customers
FROM (
    SELECT 
        customer_id,
        COUNT(order_id) AS order_count
    FROM orders
    WHERE status != 'cancelled'
    GROUP BY customer_id
)
GROUP BY customer_type;


-- ============================================
-- CHURN ANALYSIS: LAST PURCHASE DATE
-- Purpose: Identify inactivity period per customer
-- ============================================

SELECT 
    customer_id,
    MAX(order_date) AS last_purchase_date
FROM orders
WHERE status != 'cancelled'
GROUP BY customer_id;



-- ============================================
-- CHURN ANALYSIS: CUSTOMER INACTIVITY
-- Purpose: Measure how long customers have been inactive
-- ============================================

SELECT 
    customer_id,
    MAX(order_date) AS last_purchase_date,
    julianday('now') - julianday(MAX(order_date)) AS days_inactive
FROM orders
WHERE status != 'cancelled'
GROUP BY customer_id
ORDER BY days_inactive DESC;


-- ============================================
-- CHURN ANALYSIS: IDENTIFY CHURNED CUSTOMERS
-- Purpose: Flag customers inactive for 90+ days
-- ============================================

SELECT 
    customer_id,
    MAX(order_date) AS last_purchase_date,
    julianday('now') - julianday(MAX(order_date)) AS days_inactive
FROM orders
WHERE status != 'cancelled'
GROUP BY customer_id
HAVING days_inactive > 90;



-- ============================================
-- ADVANCED ANALYSIS: HIGH VALUE VS CHURN
-- Purpose: Identify valuable customers at risk
-- ============================================

SELECT 
    customer_id,
    SUM(total_amount) AS lifetime_value,
    julianday('now') - julianday(MAX(order_date)) AS days_inactive
FROM orders
WHERE status != 'cancelled'
GROUP BY customer_id
HAVING lifetime_value > 1000 
   AND days_inactive > 90
ORDER BY lifetime_value DESC;



-- ============================================
-- RFM ANALYSIS: BASE METRICS
-- Purpose: Calculate recency, frequency, and monetary value
-- ============================================

SELECT 
    customer_id,
    
    -- Recency: days since last purchase
    julianday('now') - julianday(MAX(order_date)) AS recency,
    
    -- Frequency: number of orders
    COUNT(order_id) AS frequency,
    
    -- Monetary: total spending
    SUM(total_amount) AS monetary
    
FROM orders
WHERE status != 'cancelled'
GROUP BY customer_id;




-- ============================================
-- RFM SEGMENTATION: CUSTOMER GROUPING
-- Purpose: Categorize customers into segments
-- ============================================

SELECT 
    customer_id,
    
    -- Recency
    julianday('now') - julianday(MAX(order_date)) AS recency,
    
    -- Frequency
    COUNT(order_id) AS frequency,
    
    -- Monetary
    SUM(total_amount) AS monetary,
    
    -- Segment Logic
    CASE
        WHEN COUNT(order_id) >= 5 AND SUM(total_amount) > 2000 THEN 'High Value'
        WHEN COUNT(order_id) >= 3 THEN 'Loyal'
        WHEN julianday('now') - julianday(MAX(order_date)) > 90 THEN 'At Risk'
        ELSE 'Low Value'
    END AS customer_segment

FROM orders
WHERE status != 'cancelled'
GROUP BY customer_id;




-- ============================================
-- RFM ANALYSIS: SEGMENT DISTRIBUTION
-- Purpose: Count customers in each segment
-- ============================================

SELECT 
    customer_segment,
    COUNT(*) AS total_customers
FROM (
    SELECT 
        customer_id,
        CASE
            WHEN COUNT(order_id) >= 5 AND SUM(total_amount) > 2000 THEN 'High Value'
            WHEN COUNT(order_id) >= 3 THEN 'Loyal'
            WHEN julianday('now') - julianday(MAX(order_date)) > 90 THEN 'At Risk'
            ELSE 'Low Value'
        END AS customer_segment
    FROM orders
    WHERE status != 'cancelled'
    GROUP BY customer_id
)
GROUP BY customer_segment
ORDER BY total_customers DESC;


-- ============================================
--  RFM SEGMENTATION
-- Purpose: Customer segmentation for BI
-- ============================================

SELECT 
    customer_id,
    
    -- Recency
    julianday('now') - julianday(MAX(order_date)) AS recency,
    
    -- Frequency
    COUNT(order_id) AS frequency,
    
    -- Monetary
    SUM(total_amount) AS monetary,
    
    CASE
        WHEN COUNT(order_id) >= 5 AND SUM(total_amount) > 2000 THEN 'High Value'
        WHEN COUNT(order_id) >= 3 THEN 'Loyal'
        WHEN julianday('now') - julianday(MAX(order_date)) > 90 THEN 'At Risk'
        ELSE 'Low Value'
    END AS segment

FROM orders
WHERE status != 'cancelled'
GROUP BY customer_id;
