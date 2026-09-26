-- ============================================================
-- Customer Cohort Retention Analysis — Olist E-Commerce Dataset
-- ============================================================
-- Purpose: Assigns each customer to a monthly cohort based on their
-- first purchase, then calculates what percentage of each cohort
-- remains active in every subsequent month.
--
-- Tables used:
--   orders    — order-level data (order_id, customer_id, order_purchase_timestamp, ...)
--   customers — customer-level data (customer_id, customer_unique_id, ...)
--
-- Note: Olist assigns a NEW customer_id for every order, so
-- customer_unique_id (the true person-level identifier) is used
-- throughout instead of customer_id.
-- ============================================================

CREATE OR REPLACE VIEW cohort_retention AS

-- Step 1: Find each customer's first order date (their cohort anchor)
WITH first_order AS (
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_order_date
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
),

-- Step 2: For every order, calculate how many months after the
-- customer's first purchase this order occurred (month_number).
-- month_number = 0 means "this is the customer's first-purchase month."
orders_with_cohort AS (
    SELECT
        c.customer_unique_id,
        TO_CHAR(f.first_order_date, 'YYYY-MM') AS cohort_month,
        (EXTRACT(YEAR  FROM o.order_purchase_timestamp)
       - EXTRACT(YEAR  FROM f.first_order_date)) * 12
       + (EXTRACT(MONTH FROM o.order_purchase_timestamp)
       - EXTRACT(MONTH FROM f.first_order_date))            AS month_number
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN first_order f ON c.customer_unique_id = f.customer_unique_id
),

-- Step 3: Count distinct active customers for every (cohort, month) pair
cohort_counts AS (
    SELECT
        cohort_month,
        month_number,
        COUNT(DISTINCT customer_unique_id) AS active_customers
    FROM orders_with_cohort
    GROUP BY cohort_month, month_number
),

-- Step 4: Pull out each cohort's original size (month_number = 0),
-- used as the denominator for retention percentage
cohort_sizes AS (
    SELECT
        cohort_month,
        active_customers AS cohort_size
    FROM cohort_counts
    WHERE month_number = 0
)

-- Final output: cohort_month | month_number | active_customers | cohort_size | retention_pct
SELECT
    cc.cohort_month,
    cc.month_number,
    cc.active_customers,
    cs.cohort_size,
    ROUND(100.0 * cc.active_customers / cs.cohort_size, 2) AS retention_pct
FROM cohort_counts cc
JOIN cohort_sizes cs ON cc.cohort_month = cs.cohort_month
ORDER BY cc.cohort_month, cc.month_number;

-- ============================================================
-- Usage:
--   SELECT * FROM cohort_retention ORDER BY cohort_month, month_number;
-- ============================================================
