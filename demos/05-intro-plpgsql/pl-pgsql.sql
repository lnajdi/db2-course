-- ============================================================================
-- PL/pgSQL INTRODUCTION DEMO
-- Complete guide to PostgreSQL procedural language basics
-- Database: Pagila (DVD Rental sample database)
-- ============================================================================

-- ============================================================================
-- STEP 1: BASIC DO BLOCKS & RAISE NOTICE
-- ============================================================================
-- The simplest PL/pgSQL block - just prints messages

DO $$
BEGIN
    RAISE NOTICE 'Simple message';
    RAISE NOTICE 'Message with value: %', 42;
    RAISE NOTICE 'Multiple values: % and %', 'Alice', 100;
END $$;


-- ============================================================================
-- STEP 2: DECLARING & USING VARIABLES
-- ============================================================================
-- Variables must be declared in the DECLARE section

DO $$
DECLARE
    customer_name VARCHAR(100);
    total_orders INTEGER;
    average_amount DECIMAL(10,2);
    today_date DATE := CURRENT_DATE;  -- Can initialize on declaration
BEGIN
    -- Assign values using :=
    customer_name := 'John Doe';
    total_orders := 15;
    average_amount := 250.75;
    
    RAISE NOTICE 'Customer: %, Orders: %, Avg: $%', 
                 customer_name, total_orders, average_amount;
    RAISE NOTICE 'Today is: %', today_date;
END $$;


-- ============================================================================
-- STEP 3: USING %TYPE FOR COLUMN-BASED TYPES
-- ============================================================================
-- %TYPE copies the data type from a table column
-- Ensures type safety and automatic updates if schema changes

DO $$
DECLARE
    customer_fname customer.first_name%TYPE;  -- Copies VARCHAR type
    customer_lname customer.last_name%TYPE;
    customer_email customer.email%TYPE;
    payment_amount payment.amount%TYPE;       -- NUMERIC(5,2) - max 999.99
BEGIN
    customer_fname := 'Alice';
    customer_lname := 'Johnson';
    customer_email := 'alice@example.com';
    payment_amount := 99.99;  
    
    RAISE NOTICE 'Customer: % % (%)', customer_fname, customer_lname, customer_email;
    RAISE NOTICE 'Payment amount: $%', payment_amount;
END $$;


-- ============================================================================
-- STEP 4: SELECT INTO - Loading Query Results
-- ============================================================================
-- Use SELECT INTO to load data from database into variables

-- The query behind this block aggregates rental data for a customer
SELECT c.email, COUNT(r.rental_id), COALESCE(SUM(p.amount), 0)
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
LEFT JOIN payment p ON r.rental_id = p.rental_id
WHERE c.customer_id = 1
GROUP BY c.email;


-- MARY.SMITH@sakilacustomer.org	32	118.68

-- Coalesce returns the first non-NULL value
-- Coalesce is used to handle NULL sums when there are no payments



DO $$
DECLARE
    customer_email customer.email%TYPE;
    rental_count INTEGER;
    total_spent NUMERIC(10,2);
BEGIN
    -- Get aggregated data from Pagila database
    SELECT c.email, COUNT(r.rental_id), COALESCE(SUM(p.amount), 0)
    INTO customer_email, rental_count, total_spent
    FROM customer c
    LEFT JOIN rental r ON c.customer_id = r.customer_id
    LEFT JOIN payment p ON r.rental_id = p.rental_id
    WHERE c.customer_id = 1
    GROUP BY c.email;
    
    RAISE NOTICE 'Customer % has % rentals totaling $%', 
                 customer_email, rental_count, total_spent;
END $$;


-- ============================================================================
-- STEP 5: STRICT vs NON-STRICT SELECT INTO
-- ============================================================================

-- First, check how many customers match our criteria
SELECT customer_id, first_name, last_name, email 
FROM customer
WHERE first_name LIKE 'BILLrrrrr%'; 
-- Returns 3 rows: BILLIE ,BILLY,BILL


-- ⚠️ WITHOUT STRICT - Silently takes first row!
DO $$
DECLARE
    cust_id customer.customer_id%TYPE;
    cust_first customer.first_name%TYPE;
    cust_last customer.last_name%TYPE;
    cust_email customer.email%TYPE;
BEGIN
    SELECT customer_id, first_name, last_name, email 
    INTO cust_id, cust_first, cust_last, cust_email
    FROM customer
    WHERE first_name LIKE 'BILL%';  -- Multiple customers match!
    
    RAISE NOTICE ' WITHOUT STRICT:';
    RAISE NOTICE 'Found customer: % % % (ID: %)', 
                 cust_first, cust_last, cust_email, cust_id;
    RAISE NOTICE 'Other matching customers were silently ignored!';
END $$;


-- ✅ WITH STRICT - Raises exception if 0 or >1 rows
DO $$
DECLARE
    cust_id customer.customer_id%TYPE;
    cust_first customer.first_name%TYPE;
    cust_last customer.last_name%TYPE;
    cust_email customer.email%TYPE;
BEGIN
    SELECT customer_id, first_name, last_name, email 
    INTO STRICT cust_id, cust_first, cust_last, cust_email
    FROM customer
    WHERE first_name LIKE 'BILL%';  -- Multiple customers - will error!
    
    RAISE NOTICE 'Customer: % % % (ID: %)', 
                 cust_first, cust_last, cust_email, cust_id;
END $$;


--- let's handle the exception properly
DO $$
DECLARE
    cust_id customer.customer_id%TYPE;
    cust_first customer.first_name%TYPE;
    cust_last customer.last_name%TYPE;
    cust_email customer.email%TYPE;
BEGIN
    SELECT customer_id, first_name, last_name, email 
    INTO STRICT cust_id, cust_first, cust_last, cust_email
    FROM customer
    WHERE first_name LIKE 'BILLrrrrr%';  -- Multiple customers - will error!
    
    RAISE NOTICE 'Customer: % % % (ID: %)', 
                 cust_first, cust_last, cust_email, cust_id;
    
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        RAISE NOTICE '✅ EXCEPTION RAISED!';
        RAISE NOTICE 'Multiple customers found with first name starting with BILL';
        RAISE NOTICE 'Query returned more than one row - cannot use SELECT INTO STRICT!';
    WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'No customer found matching criteria';
END $$;


-- ============================================================================
-- STEP 6: FOR LOOPS - Simple Integer Range
-- ============================================================================

DO $$
DECLARE
    i INTEGER;
    result INTEGER;
BEGIN
    RAISE NOTICE 'Calculating squares from 1 to 5:';
    
    FOR i IN 1..5 LOOP
        result := i * i;
        RAISE NOTICE 'Square of % is %', i, result;
    END LOOP;
END $$;


-- ============================================================================
-- STEP 7: RECORD TYPE - Dynamic Row Structure
-- ============================================================================
-- RECORD can hold any row structure (like a flexible container)

DO $$
DECLARE
    customer_rec RECORD;  -- Can hold any row structure
BEGIN
    SELECT * INTO customer_rec 
    FROM customer 
    WHERE customer_id = 1;
    
    -- Access columns using dot notation
    RAISE NOTICE 'Customer ID: %', customer_rec.customer_id;
    RAISE NOTICE 'Name: % %', 
        customer_rec.first_name, 
        customer_rec.last_name;
    RAISE NOTICE 'Email: %', customer_rec.email;
END $$;


-- ============================================================================
-- STEP 8: FOR LOOP with RECORD - Query Iteration
-- ============================================================================
-- Loop through query results - most common pattern in PL/pgSQL

DO $$
DECLARE
    film_rec RECORD;  -- Holds each film row
BEGIN
    RAISE NOTICE 'Premium films (rental rate > $2.99):';
    RAISE NOTICE '----------------------------------------';
    
    FOR film_rec IN 
        SELECT film_id, title, rental_rate, length
        FROM film
        WHERE rental_rate > 2.99
        ORDER BY title
        LIMIT 5
    LOOP
        RAISE NOTICE 'Film #%: "%" - $% (%min)', 
            film_rec.film_id,
            film_rec.title,
            film_rec.rental_rate,
            film_rec.length;
    END LOOP;
END $$;


-- ============================================================================
-- STEP 9: WHILE LOOP - Conditional Iteration
-- ============================================================================
-- Use WHILE when the number of iterations isn't known in advance

DO $$
DECLARE
    counter INTEGER := 1;
    factorial INTEGER := 1;
    target INTEGER := 5;
BEGIN
    RAISE NOTICE 'Calculating factorial of %:', target;
    
    WHILE counter <= target LOOP
        factorial := factorial * counter;
        RAISE NOTICE '%! = %', counter, factorial;
        counter := counter + 1;
    END LOOP;
    
    RAISE NOTICE 'Final result: %! = %', target, factorial;
END $$;


-- ============================================================================
-- STEP 10: EXCEPTION HANDLING
-- ============================================================================
-- Handle errors gracefully with EXCEPTION blocks

DO $$
DECLARE
    customer_rec RECORD;
    safe_customer_id INTEGER := 1;
    invalid_customer_id INTEGER := 99999;
BEGIN
    -- Try to fetch a non-existent customer
    SELECT * INTO STRICT customer_rec
    FROM customer
    WHERE customer_id = invalid_customer_id;
    
    RAISE NOTICE 'Found customer: %', customer_rec.first_name;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE NOTICE '❌ Customer ID % not found!', invalid_customer_id;
        RAISE NOTICE 'Attempting fallback to customer ID %...', safe_customer_id;
        
        -- Fallback: get a valid customer
        SELECT * INTO customer_rec
        FROM customer
        WHERE customer_id = safe_customer_id;
        
        RAISE NOTICE '✅ Fallback successful: % %', 
            customer_rec.first_name, customer_rec.last_name;
        
    WHEN OTHERS THEN
        RAISE NOTICE 'Unexpected error occurred: %', SQLERRM;
END $$;


-- ============================================================================
-- STEP 11: COMBINING CONCEPTS - Complete Example
-- ============================================================================
-- Real-world example combining multiple concepts

DO $$
DECLARE
    rental_rec RECORD;
    customer_name VARCHAR(200);
    total_revenue NUMERIC(10,2) := 0;
    rental_counter INTEGER := 0;
    avg_rental NUMERIC(10,2);
BEGIN
    RAISE NOTICE '=== CUSTOMER RENTAL ANALYSIS ===';
    RAISE NOTICE '';
    
    -- Get customer name
    SELECT first_name || ' ' || last_name INTO STRICT customer_name
    FROM customer
    WHERE customer_id = 1;
    
    RAISE NOTICE 'Customer: %', customer_name;
    RAISE NOTICE 'Recent rentals:';
    RAISE NOTICE '----------------------------------------';
    
    -- Loop through customer's rentals
    FOR rental_rec IN
        SELECT r.rental_date, f.title, p.amount
        FROM rental r
        JOIN inventory i ON r.inventory_id = i.inventory_id
        JOIN film f ON i.film_id = f.film_id
        LEFT JOIN payment p ON r.rental_id = p.rental_id
        WHERE r.customer_id = 1
        ORDER BY r.rental_date DESC
        LIMIT 10
    LOOP
        rental_counter := rental_counter + 1;
        total_revenue := total_revenue + COALESCE(rental_rec.amount, 0);
        
        RAISE NOTICE '%: "%" - $% (rented: %)', 
            rental_counter,
            rental_rec.title,
            COALESCE(rental_rec.amount, 0),
            rental_rec.rental_date::DATE;
    END LOOP;
    
    -- Calculate average
    IF rental_counter > 0 THEN
        avg_rental := total_revenue / rental_counter;
    ELSE
        avg_rental := 0;
    END IF;
    
    RAISE NOTICE '----------------------------------------';
    RAISE NOTICE 'Total rentals: %', rental_counter;
    RAISE NOTICE 'Total revenue: $%', total_revenue;
    RAISE NOTICE 'Average per rental: $%', ROUND(avg_rental, 2);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'Customer not found';
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
END $$;


-- ============================================================================
-- END OF DEMO
-- ============================================================================