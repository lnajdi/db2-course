-- Quiz 01: Views and Materialized Views - Practical Test File
-- Database: Pagila
-- Instructions: Execute these commands to test your quiz solutions

-- ============================================================================
-- SETUP: Ensure you're connected to the Pagila database
-- ============================================================================

-- Check connection
SELECT current_database() as connected_database;

-- Verify key tables exist
SELECT 
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
    AND table_name IN ('customer', 'rental', 'film', 'inventory', 'payment', 'staff')
ORDER BY table_name;

-- ============================================================================
-- TEST YOUR SOLUTIONS HERE
-- ============================================================================

-- Exercise 1 Test: customer_contact view
-- After creating your view, run this to test it:

-- SELECT * FROM customer_contact LIMIT 5;
-- Expected: 4 columns (customer_id, first_name, last_name, email)

-- ============================================================================

-- Exercise 2 Test: rental_details view  
-- After creating your view, run this to test it:

-- SELECT * FROM rental_details LIMIT 5;
-- Expected: 5 columns (rental_id, customer_full_name, film_title, rental_date, return_date)

-- ============================================================================

-- Exercise 3 Test: active_recent_customers view
-- After creating your view, run this to test it:

-- SELECT COUNT(*) as total_active_recent_customers FROM active_recent_customers;
-- Expected: Some number > 0 (depends on your date range)

-- SELECT * FROM active_recent_customers LIMIT 5;
-- Expected: Only active customers with recent rentals

-- ============================================================================

-- Exercise 4 Test: film_rental_stats materialized view
-- After creating your materialized view, run these tests:

-- Check if materialized view was created
-- SELECT matviewname FROM pg_matviews WHERE matviewname = 'film_rental_stats';

-- Test the data
-- SELECT * FROM film_rental_stats ORDER BY total_rentals DESC LIMIT 10;
-- Expected: Films with rental statistics

-- ============================================================================

-- Exercise 5 Test: staff_public_info view
-- After creating your view, run this to test it:

-- SELECT * FROM staff_public_info;
-- Expected: Staff info WITHOUT password column
-- Should have: staff_id, first_name, last_name, email, active

-- ============================================================================
-- CLEANUP (Run after testing to clean up your views)
-- ============================================================================

/*
-- Uncomment these lines to clean up after testing:

DROP VIEW IF EXISTS customer_contact CASCADE;
DROP VIEW IF EXISTS rental_details CASCADE;
DROP VIEW IF EXISTS active_recent_customers CASCADE;
DROP MATERIALIZED VIEW IF EXISTS film_rental_stats CASCADE;
DROP VIEW IF EXISTS staff_public_info CASCADE;
*/

-- ============================================================================
-- ADDITIONAL PRACTICE QUERIES
-- ============================================================================

-- Practice 1: Create a view showing film categories with film count
-- CREATE VIEW category_film_count AS ...

-- Practice 2: Create a materialized view for customer payment summaries
-- CREATE MATERIALIZED VIEW customer_payment_summary AS ...

-- Practice 3: Create an updatable view for active customers only
-- CREATE VIEW active_customers_updatable AS ...

-- ============================================================================
-- PERFORMANCE COMPARISON DEMO
-- ============================================================================

-- Compare performance between view and materialized view
-- (Run EXPLAIN ANALYZE on both to see the difference)

-- Regular view (recalculates every time)
-- EXPLAIN ANALYZE 
-- SELECT title, total_rentals FROM rental_details_view WHERE total_rentals > 20;

-- Materialized view (uses stored results)  
-- EXPLAIN ANALYZE
-- SELECT title, total_rentals FROM film_rental_stats WHERE total_rentals > 20;

-- ============================================================================
-- COMMON MISTAKES TO AVOID
-- ============================================================================

/*
1. Forgetting to use MATERIALIZED keyword for materialized views
2. Not handling NULL values in aggregations (use COALESCE)
3. Missing proper JOINs in complex views
4. Forgetting to refresh materialized views after data changes
5. Creating non-updatable views when updates are needed
6. Not considering performance implications of nested views
*/
