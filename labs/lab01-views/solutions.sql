-- Lab 01: Views and Materialized Views - Complete Solutions
-- Student Name: [Your Name]
-- Date: [Date]

-- ==========================================
-- Exercise 1: Simple Views (20 points)
-- ==========================================

-- 1.1: Create customer_info view
CREATE OR REPLACE VIEW customer_info AS
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    CONCAT(a.address, ', ', ci.city, ', ', co.country) AS full_address,
    c.active
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;

-- 1.2: Create film_catalog view
CREATE OR REPLACE VIEW film_catalog AS
SELECT 
    f.film_id,
    f.title,
    f.description,
    f.release_year,
    f.rating,
    ROUND(f.length / 60.0, 2) AS length_hours,
    f.rental_rate,
    f.replacement_cost
FROM film f;

-- 1.3: Create staff_overview view
CREATE OR REPLACE VIEW staff_overview AS
SELECT 
    s.staff_id,
    CONCAT(s.first_name, ' ', s.last_name) AS full_name,
    s.store_id,
    CONCAT(a.address, ', ', c.city, ', ', co.country) AS store_address,
    s.active,
    s.last_update
FROM staff s
JOIN store st ON s.store_id = st.store_id
JOIN address a ON st.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id;

-- ==========================================
-- Exercise 2: Complex Multi-table Views (25 points)
-- ==========================================

-- 2.1: Create rental_details view
CREATE OR REPLACE VIEW rental_details AS
SELECT 
    r.rental_id,
    r.rental_date,
    r.return_date,
    r.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email AS customer_email,
    f.film_id,
    f.title AS film_title,
    cat.name AS category,
    r.staff_id,
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    p.amount,
    p.payment_date
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
JOIN staff s ON r.staff_id = s.staff_id
LEFT JOIN payment p ON r.rental_id = p.rental_id;

-- 2.2: Create customer_activity view
CREATE OR REPLACE VIEW customer_activity AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    COUNT(r.rental_id) AS total_rentals,
    COALESCE(SUM(p.amount), 0) AS total_paid,
    COALESCE(AVG(p.amount), 0) AS avg_payment,
    RANK() OVER (ORDER BY COALESCE(SUM(p.amount), 0) DESC) AS spending_rank
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
LEFT JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 2.3: Create inventory_status view
CREATE OR REPLACE VIEW inventory_status AS
SELECT 
    f.title AS film_title,
    cat.name AS category,
    i.store_id,
    CONCAT(a.address, ', ', c.city) AS store_address,
    COUNT(i.inventory_id) AS total_copies,
    COUNT(i.inventory_id) - COUNT(r.rental_id) AS available_copies,
    COUNT(r.rental_id) AS rented_copies,
    ROUND(
        (COUNT(r.rental_id)::numeric / COUNT(i.inventory_id)::numeric) * 100, 2
    ) AS utilization_percentage
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
JOIN inventory i ON f.film_id = i.film_id
JOIN store s ON i.store_id = s.store_id
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id AND r.return_date IS NULL
GROUP BY f.film_id, f.title, cat.name, i.store_id, a.address, c.city;

-- ==========================================
-- Exercise 3: Security and Restricted Views (15 points)
-- ==========================================

-- 3.1: Create public_customer_list view
CREATE OR REPLACE VIEW public_customer_list AS
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    a.phone,
    ci.city,
    co.country,
    c.active
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;

-- 3.2: Create film_summary view
CREATE OR REPLACE VIEW film_summary AS
SELECT 
    f.title,
    f.description,
    cat.name AS category,
    f.rating,
    f.release_year,
    ROUND(f.length / 60.0, 2) AS length_hours
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id;

-- ==========================================
-- Exercise 4: Basic Materialized Views (20 points)
-- ==========================================

-- 4.1: Create film_stats materialized view
CREATE MATERIALIZED VIEW film_stats AS
SELECT 
    c.name AS category_name,
    COUNT(f.film_id) AS total_films,
    ROUND(AVG(f.rental_rate), 2) AS avg_rental_rate,
    ROUND(AVG(f.replacement_cost), 2) AS avg_replacement_cost,
    ROUND(AVG(f.length), 0) AS avg_length_minutes,
    (SELECT title FROM film f2 
     JOIN film_category fc2 ON f2.film_id = fc2.film_id 
     WHERE fc2.category_id = c.category_id 
     ORDER BY f2.replacement_cost DESC LIMIT 1) AS most_expensive_film
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.category_id, c.name;

-- 4.2: Create monthly_revenue materialized view
CREATE MATERIALIZED VIEW monthly_revenue AS
SELECT 
    DATE_TRUNC('month', p.payment_date) AS rental_month,
    COUNT(p.payment_id) AS total_transactions,
    SUM(p.amount) AS total_revenue,
    ROUND(AVG(p.amount), 2) AS avg_transaction_value,
    COUNT(DISTINCT p.customer_id) AS unique_customers
FROM payment p
GROUP BY DATE_TRUNC('month', p.payment_date)
ORDER BY rental_month;

-- 4.3: Create customer_segments materialized view
CREATE MATERIALIZED VIEW customer_segments AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    COUNT(r.rental_id) AS total_rentals,
    COALESCE(SUM(p.amount), 0) AS total_payments,
    CASE 
        WHEN COUNT(r.rental_id) > 0 THEN 
            ROUND(
                EXTRACT(epoch FROM (MAX(r.rental_date) - MIN(r.rental_date))) / 
                (86400.0 * COUNT(r.rental_id)), 2
            )
        ELSE NULL 
    END AS avg_days_between_rentals,
    CASE 
        WHEN COALESCE(SUM(p.amount), 0) >= 150 THEN 'High'
        WHEN COALESCE(SUM(p.amount), 0) >= 75 THEN 'Medium'
        ELSE 'Low'
    END AS customer_segment,
    MAX(r.rental_date) AS last_rental_date
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
LEFT JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- ==========================================
-- Exercise 5: Advanced Materialized Views (15 points)
-- ==========================================

-- 5.1: Create inventory_optimization materialized view
CREATE MATERIALIZED VIEW inventory_optimization AS
SELECT 
    f.title AS film_title,
    cat.name AS category,
    s.store_id,
    CONCAT(a.address, ', ', c.city) AS store_address,
    COUNT(i.inventory_id) AS total_inventory,
    COUNT(CASE WHEN r.return_date IS NULL THEN 1 END) AS current_rentals,
    ROUND(
        COUNT(CASE WHEN r.return_date IS NULL THEN 1 END)::numeric / 
        COUNT(i.inventory_id)::numeric, 3
    ) AS utilization_rate,
    COALESCE(SUM(p.amount), 0) / COUNT(i.inventory_id) AS revenue_per_copy,
    CASE 
        WHEN COUNT(CASE WHEN r.return_date IS NULL THEN 1 END)::numeric / 
             COUNT(i.inventory_id)::numeric > 0.8 THEN 'Need More Copies'
        WHEN COUNT(CASE WHEN r.return_date IS NULL THEN 1 END)::numeric / 
             COUNT(i.inventory_id)::numeric < 0.3 THEN 'Consider Reducing'
        ELSE 'Optimal'
    END AS recommendation
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
JOIN inventory i ON f.film_id = i.film_id
JOIN store s ON i.store_id = s.store_id
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
LEFT JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.film_id, f.title, cat.name, s.store_id, a.address, c.city;

-- 5.2: Create staff_performance_dashboard materialized view
CREATE MATERIALIZED VIEW staff_performance_dashboard AS
SELECT 
    s.staff_id,
    CONCAT(s.first_name, ' ', s.last_name) AS full_name,
    s.store_id,
    COUNT(r.rental_id) AS total_rentals_processed,
    COALESCE(SUM(p.amount), 0) AS total_revenue_generated,
    ROUND(COALESCE(AVG(p.amount), 0), 2) AS avg_transaction_value,
    RANK() OVER (ORDER BY COALESCE(SUM(p.amount), 0) DESC) AS performance_rank
FROM staff s
LEFT JOIN rental r ON s.staff_id = r.staff_id
LEFT JOIN payment p ON r.rental_id = p.rental_id
GROUP BY s.staff_id, s.first_name, s.last_name, s.store_id;

-- ==========================================
-- Exercise 6: Refresh Strategies and Performance (5 points)
-- ==========================================

-- 6.1: Manual refresh of all materialized views
REFRESH MATERIALIZED VIEW film_stats;
REFRESH MATERIALIZED VIEW monthly_revenue;
REFRESH MATERIALIZED VIEW customer_segments;
REFRESH MATERIALIZED VIEW inventory_optimization;
REFRESH MATERIALIZED VIEW staff_performance_dashboard;

-- 6.2: Create refresh function
CREATE OR REPLACE FUNCTION refresh_all_materialized_views()
RETURNS TEXT AS $$
DECLARE
    start_time TIMESTAMP := NOW();
    end_time TIMESTAMP;
BEGIN
    REFRESH MATERIALIZED VIEW film_stats;
    REFRESH MATERIALIZED VIEW monthly_revenue;
    REFRESH MATERIALIZED VIEW customer_segments;
    REFRESH MATERIALIZED VIEW inventory_optimization;
    REFRESH MATERIALIZED VIEW staff_performance_dashboard;
    
    end_time := NOW();
    
    RETURN 'All materialized views refreshed in ' || 
           EXTRACT(epoch FROM (end_time - start_time)) || ' seconds';
END;
$$ LANGUAGE plpgsql;

-- 6.3: Create equivalent regular views for performance comparison
CREATE OR REPLACE VIEW film_stats_regular AS
SELECT 
    c.name AS category_name,
    COUNT(f.film_id) AS total_films,
    ROUND(AVG(f.rental_rate), 2) AS avg_rental_rate,
    ROUND(AVG(f.replacement_cost), 2) AS avg_replacement_cost,
    ROUND(AVG(f.length), 0) AS avg_length_minutes,
    (SELECT title FROM film f2 
     JOIN film_category fc2 ON f2.film_id = fc2.film_id 
     WHERE fc2.category_id = c.category_id 
     ORDER BY f2.replacement_cost DESC LIMIT 1) AS most_expensive_film
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.category_id, c.name;

CREATE OR REPLACE VIEW monthly_revenue_regular AS
SELECT 
    DATE_TRUNC('month', p.payment_date) AS rental_month,
    COUNT(p.payment_id) AS total_transactions,
    SUM(p.amount) AS total_revenue,
    ROUND(AVG(p.amount), 2) AS avg_transaction_value,
    COUNT(DISTINCT p.customer_id) AS unique_customers
FROM payment p
GROUP BY DATE_TRUNC('month', p.payment_date)
ORDER BY rental_month;

-- Performance testing queries
-- Run these to compare performance:
-- \timing
-- SELECT * FROM film_stats ORDER BY total_films DESC;
-- SELECT * FROM film_stats_regular ORDER BY total_films DESC;

-- CREATE UNIQUE INDEX ON film_stats (category_name);
-- REFRESH MATERIALIZED VIEW CONCURRENTLY film_stats;

-- ==========================================
-- Verification Queries
-- ==========================================

-- Test regular views
SELECT 'Testing regular views...' AS status;
SELECT COUNT(*) AS customer_info_count FROM customer_info;
SELECT COUNT(*) AS film_catalog_count FROM film_catalog;
SELECT COUNT(*) AS rental_details_count FROM rental_details;

-- Test materialized views
SELECT 'Testing materialized views...' AS status;
SELECT COUNT(*) AS film_stats_count FROM film_stats;
SELECT COUNT(*) AS monthly_revenue_count FROM monthly_revenue;
SELECT COUNT(*) AS customer_segments_count FROM customer_segments;

-- Performance comparison example
SELECT 'Performance comparison example:' AS info;
-- Time these queries and compare:
-- SELECT * FROM film_stats_regular;
-- SELECT * FROM film_stats;

-- Check materialized view sizes
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM pg_tables 
WHERE tablename LIKE '%_stats' OR tablename LIKE '%_revenue' OR tablename LIKE '%_segments'
   OR tablename LIKE '%_optimization' OR tablename LIKE '%_dashboard';
