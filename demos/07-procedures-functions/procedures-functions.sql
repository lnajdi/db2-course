-- ============================================================================
-- POSTGRESQL FUNCTIONS & PROCEDURES DEMO
-- Complete guide to building reusable database logic
-- Database: Pagila (DVD Rental sample database)
-- ============================================================================

-- ============================================================================
-- WHAT ARE FUNCTIONS & PROCEDURES?
-- ============================================================================
-- Reusable blocks of code that live in your database
-- Write once → Use many times with different inputs
--
-- FUNCTIONS:  Return values - "What is...?"
-- PROCEDURES: Perform actions - "Please do..."
--
-- ⚠️ IMPORTANT: Use functions for calculations/queries, procedures for operations!
-- ============================================================================


-- ============================================================================
-- SECTION 1: YOUR FIRST FUNCTION - HELLO WORLD
-- ============================================================================

CREATE OR REPLACE FUNCTION say_hello()
RETURNS TEXT AS $$
BEGIN
    RETURN 'Hello, World!';
END;
$$ LANGUAGE plpgsql;

-- Using it:
SELECT say_hello();
-- Result: "Hello, World!"



-- ============================================================================
-- SECTION 2: FUNCTIONS WITH PARAMETERS (INPUTS)
-- ============================================================================

-- Function with ONE parameter
CREATE OR REPLACE FUNCTION say_hello(person_name TEXT)
RETURNS TEXT AS $$
BEGIN
    RETURN 'Hello, ' || person_name || '!';  -- || concatenates text
END;
$$ LANGUAGE plpgsql;

-- Using it with different inputs:
SELECT say_hello('Alice');  -- Result: "Hello, Alice!"
SELECT say_hello('Bob');    -- Result: "Hello, Bob!"
SELECT say_hello('مريم');   -- Result: "Hello, مريم!" (Unicode works!)

-- Common Error Example:
-- SELECT say_hello(123);  -- ERROR: type mismatch
-- Fix: Convert to text
SELECT say_hello(CAST(123 AS TEXT));  -- Result: "Hello, 123!"


-- ============================================================================
-- SECTION 3: SIMPLE MATH FUNCTIONS
-- ============================================================================

CREATE OR REPLACE FUNCTION add_numbers(num1 INTEGER, num2 INTEGER)
RETURNS INTEGER AS $$
BEGIN
    RETURN num1 + num2;
END;
$$ LANGUAGE plpgsql;

-- Test it:
SELECT add_numbers(5, 3);      -- Result: 8
SELECT add_numbers(100, 250);  -- Result: 350


-- More useful: Calculate sales tax
CREATE OR REPLACE FUNCTION calculate_tax(amount NUMERIC, tax_rate NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    RETURN ROUND(amount * tax_rate, 2);
END;
$$ LANGUAGE plpgsql;

-- Test it:
SELECT calculate_tax(100, 0.08);   -- Result: 8.00
SELECT calculate_tax(250.50, 0.07); -- Result: 17.54


-- ============================================================================
-- SECTION 4: USING FUNCTIONS IN REAL QUERIES
-- ============================================================================

-- Calculate tax on all payments
SELECT 
    payment_id,
    amount,
    calculate_tax(amount, 0.07) AS tax,
    amount + calculate_tax(amount, 0.07) AS total_with_tax
FROM payment
LIMIT 5;


-- Use in aggregate queries
SELECT 
    customer_id,
    SUM(amount) AS subtotal,
    SUM(calculate_tax(amount, 0.07)) AS total_tax,
    SUM(amount + calculate_tax(amount, 0.07)) AS grand_total
FROM payment
GROUP BY customer_id
ORDER BY grand_total DESC
LIMIT 10;


-- ============================================================================
-- SECTION 5: FUNCTIONS WITH CONDITIONAL LOGIC
-- ============================================================================

-- Apply tiered discounts based on price
CREATE OR REPLACE FUNCTION calculate_discounted_price(original_price NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    IF original_price > 1000 THEN
        RETURN ROUND(original_price * 0.90, 2);  -- 10% discount
    ELSIF original_price > 500 THEN
        RETURN ROUND(original_price * 0.95, 2);  -- 5% discount
    ELSE
        RETURN original_price;                    -- No discount
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Test with different values:
SELECT calculate_discounted_price(1500);  -- Result: 1350.00 (10% off)
SELECT calculate_discounted_price(750);   -- Result: 712.50 (5% off)
SELECT calculate_discounted_price(250);   -- Result: 250.00 (no discount)


-- ============================================================================
-- SECTION 6: FUNCTIONS WITH VARIABLES
-- ============================================================================

-- Calculate final price with discount AND tax
CREATE OR REPLACE FUNCTION calculate_final_price(
    original_price NUMERIC, 
    tax_rate NUMERIC
)
RETURNS NUMERIC AS $$
DECLARE
    discounted_price NUMERIC;
    tax_amount NUMERIC;
    final_price NUMERIC;
BEGIN
    -- Step 1: Apply discount
    discounted_price := calculate_discounted_price(original_price);
    
    -- Step 2: Calculate tax on discounted price
    tax_amount := calculate_tax(discounted_price, tax_rate);
    
    -- Step 3: Add tax to get final price
    final_price := discounted_price + tax_amount;
    
    RETURN ROUND(final_price, 2);
END;
$$ LANGUAGE plpgsql;

-- Test it:
SELECT calculate_final_price(1500, 0.08);  -- 1458.00 (discount + tax)
SELECT calculate_final_price(750, 0.08);   -- 769.50 (discount + tax)
SELECT calculate_final_price(250, 0.08);   -- 270.00 (no discount, just tax)


-- ============================================================================
-- SECTION 7: FUNCTIONS THAT QUERY THE DATABASE
-- ============================================================================

-- Get customer's total spending
CREATE OR REPLACE FUNCTION get_customer_total_spent(cust_id INTEGER)
RETURNS NUMERIC AS $$
DECLARE
    total_spent NUMERIC;
BEGIN
    SELECT COALESCE(SUM(amount), 0)
    INTO total_spent
    FROM payment
    WHERE customer_id = cust_id;
    
    RETURN ROUND(total_spent, 2);
END;
$$ LANGUAGE plpgsql;

-- Test it:
SELECT get_customer_total_spent(5);   -- Customer 5's total
SELECT get_customer_total_spent(10);  -- Customer 10's total


-- Use in a query to categorize customers
SELECT 
    customer_id,
    first_name,
    last_name,
    get_customer_total_spent(customer_id) AS total_spent,
    CASE 
        WHEN get_customer_total_spent(customer_id) > 150 THEN 'VIP'
        WHEN get_customer_total_spent(customer_id) > 100 THEN 'Gold'
        WHEN get_customer_total_spent(customer_id) > 50 THEN 'Silver'
        ELSE 'Bronze'
    END AS loyalty_tier
FROM customer
ORDER BY total_spent DESC
LIMIT 10;


-- ============================================================================
-- SECTION 8: ERROR HANDLING IN FUNCTIONS
-- ============================================================================

-- Safe division with error checking
CREATE OR REPLACE FUNCTION safe_divide(num1 NUMERIC, num2 NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    -- Check for NULL inputs
    IF num1 IS NULL OR num2 IS NULL THEN
        RAISE NOTICE 'Input cannot be NULL';
        RETURN NULL;
    END IF;
    
    -- Check for division by zero
    IF num2 = 0 THEN
        RAISE NOTICE 'Cannot divide by zero!';
        RETURN NULL;
    END IF;
    
    RETURN ROUND(num1 / num2, 2);
END;
$$ LANGUAGE plpgsql;

-- Test error handling:
SELECT safe_divide(10, 2);     -- Result: 5.00
SELECT safe_divide(10, 0);     -- Result: NULL (with notice)
SELECT safe_divide(NULL, 5);   -- Result: NULL (with notice)


-- Strict version with EXCEPTION
CREATE OR REPLACE FUNCTION strict_divide(num1 NUMERIC, num2 NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    IF num2 = 0 THEN
        RAISE EXCEPTION 'Division by zero not allowed!';
    END IF;
    RETURN ROUND(num1 / num2, 2);
END;
$$ LANGUAGE plpgsql;

-- This will stop execution:
-- SELECT strict_divide(10, 0);  -- ERROR: Division by zero not allowed!


-- ============================================================================
-- SECTION 9: VALIDATION FUNCTIONS
-- ============================================================================

-- Validate age is reasonable
CREATE OR REPLACE FUNCTION is_valid_age(age INTEGER)
RETURNS BOOLEAN AS $$
BEGIN
    IF age IS NULL OR age < 0 OR age > 150 THEN
        RETURN FALSE;
    END IF;
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Test it:
SELECT is_valid_age(25);    -- TRUE
SELECT is_valid_age(-5);    -- FALSE
SELECT is_valid_age(200);   -- FALSE
SELECT is_valid_age(NULL);  -- FALSE


-- Email validation
CREATE OR REPLACE FUNCTION is_valid_email(email TEXT)
RETURNS BOOLEAN AS $$
DECLARE
    at_count INTEGER;
    at_position INTEGER;
    domain_part TEXT;
BEGIN
    -- Check for NULL or empty
    IF email IS NULL OR email = '' THEN
        RETURN FALSE;
    END IF;
    
    -- Check for spaces
    IF email LIKE '% %' THEN
        RETURN FALSE;
    END IF;
    
    -- Count @ symbols (must be exactly 1)
    at_count := LENGTH(email) - LENGTH(REPLACE(email, '@', ''));
    IF at_count != 1 THEN
        RETURN FALSE;
    END IF;
    
    -- Get position of @
    at_position := POSITION('@' IN email);
    
    -- Check text exists before @
    IF at_position = 1 THEN
        RETURN FALSE;
    END IF;
    
    -- Check text exists after @ and contains .
    domain_part := SUBSTRING(email FROM at_position + 1);
    IF LENGTH(domain_part) < 3 OR domain_part NOT LIKE '%.%' THEN
        RETURN FALSE;
    END IF;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Test email validation:
SELECT is_valid_email('user@example.com');     -- TRUE
SELECT is_valid_email('invalid.email');        -- FALSE (no @)
SELECT is_valid_email('@example.com');         -- FALSE (nothing before @)
SELECT is_valid_email('user@domain');          -- FALSE (no . after @)
SELECT is_valid_email('user @example.com');    -- FALSE (has space)


-- ============================================================================
-- SECTION 10: TABLE-RETURNING FUNCTIONS (Set-Returning Functions)
-- ============================================================================

-- Get all films by rating
-- Note: rating column uses mpaa_rating enum type (G, PG, PG-13, R, NC-17)
CREATE OR REPLACE FUNCTION get_films_by_rating(p_rating TEXT)
RETURNS TABLE(
    film_id INTEGER,
    title TEXT,
    rental_rate NUMERIC,
    length SMALLINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT f.film_id, f.title, f.rental_rate, f.length
    FROM film f
    WHERE f.rating::TEXT = p_rating
    ORDER BY f.title
    LIMIT 10;
END;
$$ LANGUAGE plpgsql;

-- Use it like a table:
SELECT * FROM get_films_by_rating('PG');
SELECT * FROM get_films_by_rating('R');


-- More complex: Customer rental summary
CREATE OR REPLACE FUNCTION get_customer_rental_summary(cust_id INTEGER)
RETURNS TABLE(
    customer_name TEXT,
    total_rentals BIGINT,
    total_spent NUMERIC,
    avg_payment NUMERIC,
    loyalty_tier TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.first_name || ' ' || c.last_name,
        COUNT(r.rental_id),
        COALESCE(SUM(p.amount), 0),
        COALESCE(ROUND(AVG(p.amount), 2), 0),
        CASE 
            WHEN COALESCE(SUM(p.amount), 0) > 150 THEN 'VIP'
            WHEN COALESCE(SUM(p.amount), 0) > 100 THEN 'Gold'
            ELSE 'Silver'
        END
    FROM customer c
    LEFT JOIN rental r ON c.customer_id = r.customer_id
    LEFT JOIN payment p ON r.rental_id = p.rental_id
    WHERE c.customer_id = cust_id
    GROUP BY c.first_name, c.last_name;
END;
$$ LANGUAGE plpgsql;

-- Test it:
SELECT * FROM get_customer_rental_summary(5);
SELECT * FROM get_customer_rental_summary(10);


-- ============================================================================
-- SECTION 11: YOUR FIRST PROCEDURE
-- ============================================================================

-- Simple greeting procedure
CREATE OR REPLACE PROCEDURE greet_user(user_name TEXT)
AS $$
BEGIN
    RAISE NOTICE 'Welcome, %!', user_name;
END;
$$ LANGUAGE plpgsql;

-- Call a procedure (note: CALL not SELECT)
CALL greet_user('Alice');
-- Output: NOTICE: Welcome, Alice!


-- ============================================================================
-- SECTION 12: PROCEDURES THAT UPDATE DATA
-- ============================================================================

-- Update film rental rate
CREATE OR REPLACE PROCEDURE update_film_rental_rate(
    film_id_param INTEGER,
    new_rate NUMERIC
)
AS $$
DECLARE
    old_rate NUMERIC;
    film_title TEXT;
BEGIN
    -- Validate new rate (must be positive and fit NUMERIC(4,2) constraint)
    IF new_rate IS NULL OR new_rate <= 0 THEN
        RAISE EXCEPTION 'Rental rate must be positive';
    END IF;
    
    IF new_rate >= 100 THEN
        RAISE EXCEPTION 'Rental rate must be less than 100.00';
    END IF;
    
    -- Get current info
    SELECT rental_rate, title 
    INTO old_rate, film_title
    FROM film
    WHERE film_id = film_id_param;
    
    -- Check if film exists
    IF old_rate IS NULL THEN
        RAISE EXCEPTION 'Film ID % not found', film_id_param;
    END IF;
    
    -- Update the rate
    UPDATE film
    SET rental_rate = new_rate,
        last_update = CURRENT_TIMESTAMP
    WHERE film_id = film_id_param;
    
    RAISE NOTICE 'Updated "%": $% → $%', film_title, old_rate, new_rate;
END;
$$ LANGUAGE plpgsql;

-- Test it (will rollback to keep demo clean):
BEGIN;
    CALL update_film_rental_rate(1, 3.99);
    -- NOTICE: Updated "ACADEMY DINOSAUR": $0.99 → $3.99
ROLLBACK;


-- ============================================================================
-- SECTION 13: PROCEDURES WITH COMPLEX LOGIC
-- ============================================================================

-- Apply bulk discount to category
CREATE OR REPLACE PROCEDURE apply_category_discount(
    category_name TEXT,
    discount_percent NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    films_updated INTEGER;
    category_id_var INTEGER;
BEGIN
    -- Validate inputs
    IF discount_percent < 0 OR discount_percent > 100 THEN
        RAISE EXCEPTION 'Discount must be between 0 and 100';
    END IF;
    
    -- Get category ID
    SELECT category_id INTO category_id_var
    FROM category
    WHERE name = category_name;
    
    -- Check if category exists
    IF category_id_var IS NULL THEN
        RAISE EXCEPTION 'Category "%" not found', category_name;
    END IF;
    
    RAISE NOTICE 'Applying % percent discount to "%" category...', 
                 discount_percent, category_name;
    
    -- Update films in this category
    WITH updated AS (
        UPDATE film
        SET rental_rate = rental_rate * (1 - discount_percent / 100.0),
            last_update = CURRENT_TIMESTAMP
        WHERE film_id IN (
            SELECT film_id 
            FROM film_category 
            WHERE category_id = category_id_var
        )
        RETURNING film_id
    )
    SELECT COUNT(*) INTO films_updated FROM updated;
    
    RAISE NOTICE 'Updated % films in "%" category', films_updated, category_name;
END;
$$;

-- Test it (will rollback):
BEGIN;
    CALL apply_category_discount('Comedy', 10);
    -- NOTICE: Applying 10% discount to "Comedy" category...
    -- NOTICE: Updated X films in "Comedy" category
ROLLBACK;


-- ============================================================================
-- END OF FUNCTIONS & PROCEDURES DEMO
-- ============================================================================
-- Remember:
-- 1. Functions RETURN values, procedures PERFORM actions
-- 2. Use meaningful names with prefixes (p_ for params, v_ for variables)
-- 3. Always validate inputs (NULL checks, range checks)
-- 4. Add error handling with RAISE NOTICE/WARNING/EXCEPTION
-- 5. Test incrementally - build simple first, then add complexity
-- 6. Use IMMUTABLE/STABLE/VOLATILE appropriately for performance
-- 7. Document your functions with comments!
-- ============================================================================
