-- ============================================================
-- PL/pgSQL Introduction - Exercise Solutions
-- For instructors and students (after attempting exercises)
-- ============================================================

-- ============================================================
-- Exercise 1 (Easy): Hello World
-- Write a block that prints "Hello World" and the current timestamp
-- ============================================================

DO $$
BEGIN
    RAISE NOTICE 'Hello World';
    RAISE NOTICE 'Current time: %', NOW();
END $$;

-- Expected Output:
-- NOTICE:  Hello World
-- NOTICE:  Current time: 2025-11-06 10:30:00.123456


-- ============================================================
-- Exercise 2 (Medium): Number Squares
-- Create a loop that prints numbers 1 to 5 with their squares
-- ============================================================

DO $$
DECLARE
    i INTEGER;
    square INTEGER;
BEGIN
    FOR i IN 1..5 LOOP
        square := i * i;
        RAISE NOTICE '% squared is %', i, square;
    END LOOP;
END $$;

-- Expected Output:
-- NOTICE:  1 squared is 1
-- NOTICE:  2 squared is 4
-- NOTICE:  3 squared is 9
-- NOTICE:  4 squared is 16
-- NOTICE:  5 squared is 25

-- Alternative solution (inline calculation):
DO $$
BEGIN
    FOR i IN 1..5 LOOP
        RAISE NOTICE '% squared is %', i, i * i;
    END LOOP;
END $$;


-- ============================================================
-- Exercise 3 (Medium): Safe Customer Lookup
-- Write a block that:
-- - Retrieves a customer by ID from Pagila (use STRICT)
-- - Handles the case where customer doesn't exist
-- - Prints the customer's full name if found
-- ============================================================

-- Solution 1: Using existing customer (ID = 1)
DO $$
DECLARE
    cust_first_name TEXT;
    cust_last_name TEXT;
    full_name TEXT;
BEGIN
    SELECT first_name, last_name 
    INTO STRICT cust_first_name, cust_last_name
    FROM customer
    WHERE customer_id = 1;
    
    full_name := cust_first_name || ' ' || cust_last_name;
    RAISE NOTICE 'Found customer: %', full_name;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'Customer not found!';
    WHEN TOO_MANY_ROWS THEN
        RAISE NOTICE 'Multiple customers found - data integrity issue!';
END $$;

-- Expected Output:
-- NOTICE:  Found customer: Mary Smith

-- Solution 2: Testing with non-existent customer
DO $$
DECLARE
    cust_first_name TEXT;
    cust_last_name TEXT;
    full_name TEXT;
BEGIN
    SELECT first_name, last_name 
    INTO STRICT cust_first_name, cust_last_name
    FROM customer
    WHERE customer_id = 99999;  -- This customer doesn't exist
    
    full_name := cust_first_name || ' ' || cust_last_name;
    RAISE NOTICE 'Found customer: %', full_name;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'Customer not found!';
    WHEN TOO_MANY_ROWS THEN
        RAISE NOTICE 'Multiple customers found - data integrity issue!';
END $$;

-- Expected Output:
-- NOTICE:  Customer not found!

-- Alternative solution using RECORD:
DO $$
DECLARE
    cust_rec RECORD;
    test_id INTEGER := 1;  -- Change to 99999 to test error handling
BEGIN
    SELECT first_name, last_name 
    INTO STRICT cust_rec
    FROM customer
    WHERE customer_id = test_id;
    
    RAISE NOTICE 'Found customer: % %', cust_rec.first_name, cust_rec.last_name;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'Customer % not found!', test_id;
    WHEN TOO_MANY_ROWS THEN
        RAISE NOTICE 'Multiple customers found with ID % - data integrity issue!', test_id;
END $$;


-- ============================================================
-- Exercise 4 (Advanced): Customer Category
-- Write a block that:
-- - Gets total payment amount for a customer
-- - Categorizes them as BRONZE/SILVER/GOLD/PLATINUM
-- - Prints category and total
-- 
-- Category Rules:
-- PLATINUM: > $150
-- GOLD: > $100
-- SILVER: > $50
-- BRONZE: ≤ $50
-- ============================================================

DO $$
DECLARE
    total_paid NUMERIC(10,2);
    customer_category TEXT;
    test_customer_id INTEGER := 1;  -- Try different customer IDs
BEGIN
    -- Get total payment amount for the customer
    SELECT COALESCE(SUM(amount), 0) 
    INTO total_paid
    FROM payment 
    WHERE customer_id = test_customer_id;
    
    -- Categorize based on total
    IF total_paid > 150 THEN
        customer_category := 'PLATINUM';
    ELSIF total_paid > 100 THEN
        customer_category := 'GOLD';
    ELSIF total_paid > 50 THEN
        customer_category := 'SILVER';
    ELSE
        customer_category := 'BRONZE';
    END IF;
    
    -- Print the results
    RAISE NOTICE 'Customer %: % category (Total paid: $%)', 
                 test_customer_id, customer_category, total_paid;
END $$;

-- Sample Expected Output (actual values depend on customer):
-- NOTICE:  Customer 1: PLATINUM category (Total paid: $118.68)

-- Enhanced solution with customer name:
DO $$
DECLARE
    total_paid NUMERIC(10,2);
    customer_category TEXT;
    customer_name TEXT;
    test_customer_id INTEGER := 1;
BEGIN
    -- Get customer name
    SELECT first_name || ' ' || last_name 
    INTO customer_name
    FROM customer 
    WHERE customer_id = test_customer_id;
    
    -- Get total payment amount
    SELECT COALESCE(SUM(amount), 0) 
    INTO total_paid
    FROM payment 
    WHERE customer_id = test_customer_id;
    
    -- Categorize
    IF total_paid > 150 THEN
        customer_category := 'PLATINUM';
    ELSIF total_paid > 100 THEN
        customer_category := 'GOLD';
    ELSIF total_paid > 50 THEN
        customer_category := 'SILVER';
    ELSE
        customer_category := 'BRONZE';
    END IF;
    
    -- Print detailed results
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Customer: %', customer_name;
    RAISE NOTICE 'Total Paid: $%', total_paid;
    RAISE NOTICE 'Category: %', customer_category;
    RAISE NOTICE '========================================';
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'Customer % not found!', test_customer_id;
END $$;

-- Alternative solution: Process multiple customers
DO $$
DECLARE
    cust_rec RECORD;
    total_paid NUMERIC(10,2);
    customer_category TEXT;
BEGIN
    -- Loop through top 5 customers by payment
    FOR cust_rec IN 
        SELECT c.customer_id, 
               c.first_name || ' ' || c.last_name AS full_name,
               COALESCE(SUM(p.amount), 0) AS total_amount
        FROM customer c
        LEFT JOIN payment p USING (customer_id)
        GROUP BY c.customer_id, c.first_name, c.last_name
        ORDER BY total_amount DESC
        LIMIT 5
    LOOP
        -- Categorize each customer
        IF cust_rec.total_amount > 150 THEN
            customer_category := 'PLATINUM';
        ELSIF cust_rec.total_amount > 100 THEN
            customer_category := 'GOLD';
        ELSIF cust_rec.total_amount > 50 THEN
            customer_category := 'SILVER';
        ELSE
            customer_category := 'BRONZE';
        END IF;
        
        RAISE NOTICE '% (ID %): % - $%', 
                     cust_rec.full_name, 
                     cust_rec.customer_id,
                     customer_category, 
                     cust_rec.total_amount;
    END LOOP;
END $$;


-- ============================================================
-- BONUS EXERCISES (For Advanced Students)
-- ============================================================

-- Bonus 1: Film Rental Statistics
-- Calculate average rental duration by film rating
DO $$
DECLARE
    rating_rec RECORD;
    avg_duration NUMERIC(5,2);
    film_count INTEGER;
BEGIN
    RAISE NOTICE 'Film Rental Statistics by Rating';
    RAISE NOTICE '========================================';
    
    FOR rating_rec IN 
        SELECT DISTINCT rating FROM film ORDER BY rating
    LOOP
        SELECT AVG(length), COUNT(*)
        INTO avg_duration, film_count
        FROM film
        WHERE rating = rating_rec.rating;
        
        RAISE NOTICE 'Rating %: % films, Avg duration: % min', 
                     rating_rec.rating, film_count, ROUND(avg_duration, 2);
    END LOOP;
END $$;


-- Bonus 2: Inventory Check with Alerts
-- Check inventory levels and alert if low stock
DO $$
DECLARE
    film_rec RECORD;
    inventory_count INTEGER;
    alert_threshold INTEGER := 3;
BEGIN
    RAISE NOTICE 'Low Inventory Alert Report';
    RAISE NOTICE '========================================';
    
    FOR film_rec IN 
        SELECT f.film_id, f.title, COUNT(i.inventory_id) AS stock
        FROM film f
        LEFT JOIN inventory i USING (film_id)
        GROUP BY f.film_id, f.title
        HAVING COUNT(i.inventory_id) <= alert_threshold
        ORDER BY stock ASC, f.title
        LIMIT 10
    LOOP
        IF film_rec.stock = 0 THEN
            RAISE NOTICE '⚠️  CRITICAL: "%" - OUT OF STOCK!', film_rec.title;
        ELSIF film_rec.stock <= alert_threshold THEN
            RAISE NOTICE '⚠️  WARNING: "%" - Only % copies in stock', 
                         film_rec.title, film_rec.stock;
        END IF;
    END LOOP;
END $$;


-- ============================================================
-- Common Student Mistakes & How to Fix Them
-- ============================================================

-- MISTAKE 1: Using = instead of :=
-- WRONG:
/*
DO $$
DECLARE
    name TEXT;
BEGIN
    name = 'John';  -- This is WRONG!
END $$;
*/

-- CORRECT:
DO $$
DECLARE
    name TEXT;
BEGIN
    name := 'John';  -- Use := for assignment
END $$;


-- MISTAKE 2: Forgetting INTO clause
-- WRONG:
/*
DO $$
DECLARE
    total INTEGER;
BEGIN
    SELECT COUNT(*) FROM customer;  -- Result goes nowhere!
END $$;
*/

-- CORRECT:
DO $$
DECLARE
    total INTEGER;
BEGIN
    SELECT COUNT(*) INTO total FROM customer;
    RAISE NOTICE 'Total customers: %', total;
END $$;


-- MISTAKE 3: Not handling NULL in comparisons
-- PROBLEMATIC:
DO $$
DECLARE
    total_spent NUMERIC(10,2);
BEGIN
    SELECT SUM(amount) INTO total_spent 
    FROM payment WHERE customer_id = 99999;  -- Non-existent = NULL
    
    IF total_spent > 100 THEN  -- NULL > 100 = NULL (treated as FALSE)
        RAISE NOTICE 'High spender';
    ELSE
        RAISE NOTICE 'Low spender';  -- This executes even though we don't know!
    END IF;
END $$;

-- BETTER:
DO $$
DECLARE
    total_spent NUMERIC(10,2);
BEGIN
    SELECT COALESCE(SUM(amount), 0) INTO total_spent 
    FROM payment WHERE customer_id = 99999;
    
    IF total_spent > 100 THEN
        RAISE NOTICE 'High spender';
    ELSE
        RAISE NOTICE 'Low spender or no data';
    END IF;
END $$;


-- MISTAKE 4: Forgetting STRICT and not checking results
-- UNSAFE:
DO $$
DECLARE
    cust_name TEXT;
BEGIN
    SELECT first_name INTO cust_name 
    FROM customer 
    WHERE email LIKE '%@%';  -- Could match multiple rows!
    
    RAISE NOTICE 'Customer: %', cust_name;  -- Which one did we get?
END $$;

-- SAFE:
DO $$
DECLARE
    cust_name TEXT;
BEGIN
    SELECT first_name INTO STRICT cust_name 
    FROM customer 
    WHERE customer_id = 1;
    
    RAISE NOTICE 'Customer: %', cust_name;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'No customer found';
    WHEN TOO_MANY_ROWS THEN
        RAISE NOTICE 'Multiple customers found - be more specific!';
END $$;

-- ============================================================
-- End of Solutions
-- ============================================================
