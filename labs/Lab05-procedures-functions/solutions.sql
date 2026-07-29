-- ============================================================================
-- LAB 04: STORED PROCEDURES AND FUNCTIONS - COMPLETE SOLUTIONS
-- Database: Pagila (DVD Rental Database)
-- ============================================================================

-- ============================================================================
-- PART 1: BASIC SCALAR FUNCTIONS - SOLUTIONS
-- ============================================================================

-- Exercise 1.1: Temperature Converter
CREATE OR REPLACE FUNCTION fahrenheit_to_celsius(temp_f NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    RETURN ROUND((temp_f - 32) * 5.0 / 9.0, 2);
END;
$$ LANGUAGE plpgsql;

-- Test:
SELECT fahrenheit_to_celsius(32);    -- 0.00
SELECT fahrenheit_to_celsius(212);   -- 100.00
SELECT fahrenheit_to_celsius(98.6);  -- 37.00


-- Exercise 1.2: Film Duration Formatter
CREATE OR REPLACE FUNCTION format_film_duration(length_minutes INTEGER)
RETURNS TEXT AS $$
DECLARE
    hours INTEGER;
    minutes INTEGER;
    hour_word TEXT;
BEGIN
    hours := length_minutes / 60;
    minutes := length_minutes % 60;
    
    IF hours = 1 THEN
        hour_word := 'hour';
    ELSE
        hour_word := 'hours';
    END IF;
    
    RETURN hours || ' ' || hour_word || ' ' || minutes || ' minutes';
END;
$$ LANGUAGE plpgsql;

-- Test:
SELECT title, length, format_film_duration(length) AS formatted_duration
FROM film
WHERE length IN (46, 120, 185)
LIMIT 3;


-- Exercise 1.3: Calculate Rental Days
CREATE OR REPLACE FUNCTION calculate_rental_days(
    rental_date_param TIMESTAMP,
    return_date_param TIMESTAMP
)
RETURNS INTEGER AS $$
DECLARE
    actual_return_date TIMESTAMP;
    days_difference INTEGER;
BEGIN
    IF return_date_param IS NULL THEN
        actual_return_date := CURRENT_TIMESTAMP;
    ELSE
        actual_return_date := return_date_param;
    END IF;
    
    days_difference := EXTRACT(DAY FROM (actual_return_date - rental_date_param))::INTEGER;
    
    RETURN days_difference;
END;
$$ LANGUAGE plpgsql;

-- Test:
SELECT rental_id, rental_date, return_date,
       calculate_rental_days(rental_date, return_date) AS rental_days
FROM rental
LIMIT 10;


-- Exercise 1.4: Calculate Late Fee
CREATE OR REPLACE FUNCTION calculate_late_fee(rental_days INTEGER)
RETURNS NUMERIC AS $$
DECLARE
    standard_period INTEGER := 3;
    daily_late_fee NUMERIC := 1.50;
    max_late_fee NUMERIC := 25.00;
    days_overdue INTEGER;
    calculated_fee NUMERIC;
BEGIN
    days_overdue := rental_days - standard_period;
    
    IF days_overdue <= 0 THEN
        RETURN 0;
    END IF;
    
    calculated_fee := days_overdue * daily_late_fee;
    
    IF calculated_fee > max_late_fee THEN
        calculated_fee := max_late_fee;
    END IF;
    
    RETURN ROUND(calculated_fee, 2);
END;
$$ LANGUAGE plpgsql;

-- Test:
SELECT calculate_late_fee(2) AS no_fee,      -- 0.00
       calculate_late_fee(5) AS small_fee,    -- 3.00
       calculate_late_fee(10) AS medium_fee,  -- 10.50
       calculate_late_fee(25) AS max_fee;     -- 25.00


-- ============================================================================
-- PART 2: FUNCTIONS WITH DATABASE QUERIES - SOLUTIONS
-- ============================================================================

-- Exercise 2.1: Get Customer Full Name
CREATE OR REPLACE FUNCTION get_customer_full_name(cust_id INTEGER)
RETURNS TEXT AS $$
DECLARE
    full_name TEXT;
BEGIN
    SELECT first_name || ' ' || last_name
    INTO full_name
    FROM customer
    WHERE customer_id = cust_id;
    
    IF full_name IS NULL THEN
        RETURN 'Customer not found';
    END IF;
    
    RETURN full_name;
END;
$$ LANGUAGE plpgsql;

-- Test:
SELECT get_customer_full_name(1);
SELECT get_customer_full_name(9999);


-- Exercise 2.2: Count Customer Rentals
CREATE OR REPLACE FUNCTION count_customer_rentals(cust_id INTEGER)
RETURNS INTEGER AS $$
DECLARE
    rental_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO rental_count
    FROM rental
    WHERE customer_id = cust_id;
    
    RETURN rental_count;
END;
$$ LANGUAGE plpgsql;

-- Test:
SELECT customer_id,
       get_customer_full_name(customer_id) AS customer_name,
       count_customer_rentals(customer_id) AS total_rentals
FROM customer
WHERE customer_id IN (1, 2, 3);


-- Exercise 2.3: Get Customer Total Spent
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

-- Test:
SELECT customer_id,
       get_customer_full_name(customer_id) AS name,
       count_customer_rentals(customer_id) AS rentals,
       get_customer_total_spent(customer_id) AS total_spent
FROM customer
ORDER BY total_spent DESC
LIMIT 10;


-- Exercise 2.4: Get Film Average Rental Duration
CREATE OR REPLACE FUNCTION get_film_avg_rental_duration(film_id_param INTEGER)
RETURNS NUMERIC AS $$
DECLARE
    avg_duration NUMERIC;
BEGIN
    SELECT AVG(calculate_rental_days(r.rental_date, r.return_date))
    INTO avg_duration
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    WHERE i.film_id = film_id_param;
    
    RETURN COALESCE(ROUND(avg_duration, 2), 0);
END;
$$ LANGUAGE plpgsql;

-- Test:
SELECT f.film_id, f.title,
       get_film_avg_rental_duration(f.film_id) AS avg_rental_days
FROM film f
WHERE f.film_id IN (1, 2, 3, 4, 5);


-- ============================================================================
-- PART 3: TABLE-RETURNING FUNCTIONS - SOLUTIONS
-- ============================================================================

-- Exercise 3.1: Get Top Spending Customers
CREATE OR REPLACE FUNCTION get_top_customers(limit_count INTEGER)
RETURNS TABLE(
    customer_id INTEGER,
    customer_name TEXT,
    total_rentals BIGINT,
    total_spent NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        COUNT(DISTINCT r.rental_id) AS total_rentals,
        COALESCE(SUM(p.amount), 0) AS total_spent
    FROM customer c
    LEFT JOIN rental r ON c.customer_id = r.customer_id
    LEFT JOIN payment p ON r.rental_id = p.rental_id
    GROUP BY c.customer_id, c.first_name, c.last_name
    ORDER BY total_spent DESC
    LIMIT limit_count;
END;
$$ LANGUAGE plpgsql;

-- Test:
SELECT * FROM get_top_customers(10);


-- Exercise 3.2: Get Films by Category and Rating
CREATE OR REPLACE FUNCTION get_films_by_category_rating(
    category_name_param TEXT,
    rating_param TEXT
)
RETURNS TABLE(
    film_id INTEGER,
    title TEXT,
    category_name TEXT,
    rating TEXT,
    rental_rate NUMERIC,
    length INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        f.film_id,
        f.title,
        c.name AS category_name,
        f.rating::TEXT,
        f.rental_rate,
        f.length
    FROM film f
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = category_name_param
      AND f.rating = rating_param::mpaa_rating
    ORDER BY f.title;
END;
$$ LANGUAGE plpgsql;

-- Test:
SELECT * FROM get_films_by_category_rating('Action', 'PG-13');
SELECT * FROM get_films_by_category_rating('Comedy', 'G');


-- Exercise 3.3: Get Customer Rental History
CREATE OR REPLACE FUNCTION get_customer_rental_history(cust_id INTEGER)
RETURNS TABLE(
    rental_id INTEGER,
    rental_date TIMESTAMP,
    film_title TEXT,
    rental_rate NUMERIC,
    return_date TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.rental_id,
        r.rental_date,
        f.title AS film_title,
        f.rental_rate,
        r.return_date
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    WHERE r.customer_id = cust_id
    ORDER BY r.rental_date DESC;
END;
$$ LANGUAGE plpgsql;

-- Test:
SELECT * FROM get_customer_rental_history(1) LIMIT 10;


-- ============================================================================
-- PART 4: VALIDATION FUNCTIONS - SOLUTIONS
-- ============================================================================

-- Exercise 4.1: Validate Email Format
CREATE OR REPLACE FUNCTION is_valid_email(email TEXT)
RETURNS BOOLEAN AS $$
DECLARE
    at_count INTEGER;
    at_position INTEGER;
    domain_part TEXT;
BEGIN
    IF email IS NULL OR email = '' THEN
        RETURN FALSE;
    END IF;
    
    IF email LIKE '% %' THEN
        RETURN FALSE;
    END IF;
    
    at_count := LENGTH(email) - LENGTH(REPLACE(email, '@', ''));
    IF at_count != 1 THEN
        RETURN FALSE;
    END IF;
    
    at_position := POSITION('@' IN email);
    
    IF at_position = 1 THEN
        RETURN FALSE;
    END IF;
    
    domain_part := SUBSTRING(email FROM at_position + 1);
    
    IF LENGTH(domain_part) < 3 OR domain_part NOT LIKE '%.%' THEN
        RETURN FALSE;
    END IF;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Test:
SELECT is_valid_email('user@example.com');      -- TRUE
SELECT is_valid_email('invalid.email');         -- FALSE
SELECT is_valid_email('@example.com');          -- FALSE
SELECT is_valid_email('user@domain');           -- FALSE
SELECT is_valid_email('user @example.com');     -- FALSE
SELECT is_valid_email(NULL);                    -- FALSE


-- Exercise 4.2: Validate Rental Rate
CREATE OR REPLACE FUNCTION is_valid_rental_rate(rate NUMERIC)
RETURNS BOOLEAN AS $$
BEGIN
    IF rate IS NULL OR rate <= 0 OR rate > 50.00 THEN
        RETURN FALSE;
    END IF;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Test:
SELECT is_valid_rental_rate(2.99);   -- TRUE
SELECT is_valid_rental_rate(0);      -- FALSE
SELECT is_valid_rental_rate(-1);     -- FALSE
SELECT is_valid_rental_rate(NULL);   -- FALSE
SELECT is_valid_rental_rate(100);    -- FALSE


-- Exercise 4.3: Check Film Availability
CREATE OR REPLACE FUNCTION is_film_available(film_id_param INTEGER)
RETURNS BOOLEAN AS $$
DECLARE
    available_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO available_count
    FROM inventory i
    LEFT JOIN rental r ON i.inventory_id = r.inventory_id 
        AND r.return_date IS NULL
    WHERE i.film_id = film_id_param
        AND r.rental_id IS NULL;
    
    RETURN available_count > 0;
END;
$$ LANGUAGE plpgsql;

-- Test:
SELECT film_id, title,
       is_film_available(film_id) AS available
FROM film
ORDER BY film_id
LIMIT 20;


-- ============================================================================
-- PART 5: BASIC PROCEDURES - SOLUTIONS
-- ============================================================================

-- Exercise 5.1: Update Customer Email
CREATE OR REPLACE PROCEDURE update_customer_email(
    cust_id INTEGER,
    new_email TEXT
)
AS $$
BEGIN
    IF NOT is_valid_email(new_email) THEN
        RAISE EXCEPTION 'Invalid email format: %', new_email;
    END IF;
    
    UPDATE customer
    SET email = new_email,
        last_update = CURRENT_TIMESTAMP
    WHERE customer_id = cust_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Customer ID % not found', cust_id;
    END IF;
    
    RAISE NOTICE 'Email updated successfully for customer %', cust_id;
END;
$$ LANGUAGE plpgsql;

-- Test:
-- CALL update_customer_email(1, 'newemail@example.com');


-- Exercise 5.2: Update Film Rental Rate
CREATE OR REPLACE PROCEDURE update_film_rental_rate(
    film_id_param INTEGER,
    new_rate NUMERIC
)
AS $$
BEGIN
    IF NOT is_valid_rental_rate(new_rate) THEN
        RAISE EXCEPTION 'Invalid rental rate: %. Must be between 0 and 50.', new_rate;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM film WHERE film_id = film_id_param) THEN
        RAISE EXCEPTION 'Film ID % not found', film_id_param;
    END IF;
    
    UPDATE film
    SET rental_rate = new_rate,
        last_update = CURRENT_TIMESTAMP
    WHERE film_id = film_id_param;
    
    RAISE NOTICE 'Film % rental rate updated to $%', film_id_param, new_rate;
END;
$$ LANGUAGE plpgsql;

-- Test:
-- CALL update_film_rental_rate(1, 3.99);


-- Exercise 5.3: Deactivate Customer
CREATE OR REPLACE PROCEDURE deactivate_customer(
    cust_id INTEGER,
    reason TEXT
)
AS $$
DECLARE
    customer_name TEXT;
    current_status BOOLEAN;
BEGIN
    SELECT first_name || ' ' || last_name, activebool::BOOLEAN
    INTO customer_name, current_status
    FROM customer
    WHERE customer_id = cust_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Customer ID % not found', cust_id;
    END IF;
    
    IF current_status = FALSE THEN
        RAISE NOTICE 'Customer % is already inactive', customer_name;
        RETURN;
    END IF;
    
    UPDATE customer
    SET active = 0,
        activebool = FALSE,
        last_update = CURRENT_TIMESTAMP
    WHERE customer_id = cust_id;
    
    RAISE NOTICE '===================================';
    RAISE NOTICE 'Customer Deactivation Log';
    RAISE NOTICE '===================================';
    RAISE NOTICE 'Customer ID: %', cust_id;
    RAISE NOTICE 'Customer Name: %', customer_name;
    RAISE NOTICE 'Deactivation Date: %', CURRENT_TIMESTAMP;
    RAISE NOTICE 'Reason: %', reason;
    RAISE NOTICE '===================================';
END;
$$ LANGUAGE plpgsql;

-- Test:
-- CALL deactivate_customer(600, 'Customer request for account closure');


-- ============================================================================
-- PART 6: ADVANCED PROCEDURES - SOLUTIONS
-- ============================================================================

-- Exercise 6.1: Calculate and Display Customer Statistics
CREATE OR REPLACE PROCEDURE display_customer_statistics(cust_id INTEGER)
AS $$
DECLARE
    v_name TEXT;
    v_email TEXT;
    v_rental_count INTEGER;
    v_total_spent NUMERIC;
    v_avg_payment NUMERIC;
    v_tier TEXT;
BEGIN
    v_name := get_customer_full_name(cust_id);
    
    IF v_name = 'Customer not found' THEN
        RAISE EXCEPTION 'Customer ID % not found', cust_id;
    END IF;
    
    SELECT email INTO v_email
    FROM customer
    WHERE customer_id = cust_id;
    
    v_rental_count := count_customer_rentals(cust_id);
    v_total_spent := get_customer_total_spent(cust_id);
    
    IF v_rental_count > 0 THEN
        v_avg_payment := v_total_spent / v_rental_count;
    ELSE
        v_avg_payment := 0;
    END IF;
    
    IF v_total_spent >= 150 THEN
        v_tier := 'Premium';
    ELSIF v_total_spent >= 100 THEN
        v_tier := 'Gold';
    ELSIF v_total_spent >= 50 THEN
        v_tier := 'Silver';
    ELSE
        v_tier := 'Bronze';
    END IF;
    
    RAISE NOTICE '============================================';
    RAISE NOTICE 'CUSTOMER STATISTICS REPORT';
    RAISE NOTICE '============================================';
    RAISE NOTICE 'Customer ID:      %', cust_id;
    RAISE NOTICE 'Name:             %', v_name;
    RAISE NOTICE 'Email:            %', v_email;
    RAISE NOTICE '--------------------------------------------';
    RAISE NOTICE 'Total Rentals:    %', v_rental_count;
    RAISE NOTICE 'Total Spent:      $%', v_total_spent;
    RAISE NOTICE 'Average Payment:  $%', ROUND(v_avg_payment, 2);
    RAISE NOTICE 'Customer Tier:    %', v_tier;
    RAISE NOTICE '============================================';
END;
$$ LANGUAGE plpgsql;

-- Test:
-- CALL display_customer_statistics(1);


-- Exercise 6.2: Transfer Inventory Between Stores
CREATE OR REPLACE PROCEDURE transfer_inventory(
    inventory_id_param INTEGER,
    target_store_id INTEGER
)
AS $$
DECLARE
    v_film_id INTEGER;
    v_current_store_id INTEGER;
    v_film_title TEXT;
BEGIN
    SELECT i.film_id, i.store_id, f.title
    INTO v_film_id, v_current_store_id, v_film_title
    FROM inventory i
    JOIN film f ON i.film_id = f.film_id
    WHERE i.inventory_id = inventory_id_param;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Inventory ID % not found', inventory_id_param;
    END IF;
    
    IF EXISTS (
        SELECT 1 FROM rental
        WHERE inventory_id = inventory_id_param
          AND return_date IS NULL
    ) THEN
        RAISE EXCEPTION 'Cannot transfer: inventory is currently rented';
    END IF;
    
    IF v_current_store_id = target_store_id THEN
        RAISE NOTICE 'Inventory % is already at store %', 
                     inventory_id_param, target_store_id;
        RETURN;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM store WHERE store_id = target_store_id) THEN
        RAISE EXCEPTION 'Target store % does not exist', target_store_id;
    END IF;
    
    UPDATE inventory
    SET store_id = target_store_id,
        last_update = CURRENT_TIMESTAMP
    WHERE inventory_id = inventory_id_param;
    
    RAISE NOTICE 'Successfully transferred inventory % (%) from store % to store %',
                 inventory_id_param, v_film_title, 
                 v_current_store_id, target_store_id;
END;
$$ LANGUAGE plpgsql;

-- Test:
-- CALL transfer_inventory(1, 2);


-- ============================================================================
-- BONUS CHALLENGES - SOLUTIONS
-- ============================================================================

-- BONUS 1: Customer Lifetime Value Function
CREATE OR REPLACE FUNCTION calculate_customer_lifetime_value(
    cust_id INTEGER,
    projection_months INTEGER DEFAULT 12
)
RETURNS NUMERIC AS $$
DECLARE
    v_total_spent NUMERIC;
    v_first_rental_date TIMESTAMP;
    v_rental_count INTEGER;
    v_months_active NUMERIC;
    v_monthly_avg NUMERIC;
    v_projected_value NUMERIC;
    v_lifetime_value NUMERIC;
BEGIN
    v_total_spent := get_customer_total_spent(cust_id);
    
    SELECT COUNT(*), MIN(rental_date)
    INTO v_rental_count, v_first_rental_date
    FROM rental
    WHERE customer_id = cust_id;
    
    IF v_rental_count = 0 OR v_first_rental_date IS NULL THEN
        RETURN 0;
    END IF;
    
    v_months_active := EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - v_first_rental_date)) / (30.44 * 86400);
    
    IF v_months_active < 0.1 THEN
        v_months_active := 0.1;
    END IF;
    
    v_monthly_avg := v_total_spent / v_months_active;
    v_projected_value := v_monthly_avg * projection_months;
    v_lifetime_value := v_total_spent + v_projected_value;
    
    RETURN ROUND(v_lifetime_value, 2);
END;
$$ LANGUAGE plpgsql;

-- Test:
SELECT customer_id,
       get_customer_full_name(customer_id) AS name,
       get_customer_total_spent(customer_id) AS spent_to_date,
       calculate_customer_lifetime_value(customer_id, 12) AS clv_12_months
FROM customer
ORDER BY clv_12_months DESC
LIMIT 10;


-- BONUS 2: Bulk Price Update Procedure
CREATE OR REPLACE PROCEDURE bulk_update_category_prices(
    category_name_param TEXT,
    price_adjustment_pct NUMERIC
)
AS $$
DECLARE
    v_films_updated INTEGER;
    v_category_id INTEGER;
    v_avg_before NUMERIC;
    v_avg_after NUMERIC;
BEGIN
    -- Validate category exists
    SELECT category_id INTO v_category_id
    FROM category
    WHERE name = category_name_param;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Category % not found', category_name_param;
    END IF;
    
    -- Get average before
    SELECT AVG(f.rental_rate)
    INTO v_avg_before
    FROM film f
    JOIN film_category fc ON f.film_id = fc.film_id
    WHERE fc.category_id = v_category_id;
    
    -- Update prices
    UPDATE film f
    SET rental_rate = ROUND(f.rental_rate * (1 + price_adjustment_pct / 100.0), 2),
        last_update = CURRENT_TIMESTAMP
    FROM film_category fc
    WHERE f.film_id = fc.film_id
      AND fc.category_id = v_category_id
      AND is_valid_rental_rate(ROUND(f.rental_rate * (1 + price_adjustment_pct / 100.0), 2));
    
    GET DIAGNOSTICS v_films_updated = ROW_COUNT;
    
    -- Get average after
    SELECT AVG(f.rental_rate)
    INTO v_avg_after
    FROM film f
    JOIN film_category fc ON f.film_id = fc.film_id
    WHERE fc.category_id = v_category_id;
    
    RAISE NOTICE '============================================';
    RAISE NOTICE 'BULK PRICE UPDATE SUMMARY';
    RAISE NOTICE '============================================';
    RAISE NOTICE 'Category:           %', category_name_param;
    RAISE NOTICE 'Adjustment:         %% ', price_adjustment_pct;
    RAISE NOTICE 'Films Updated:      %', v_films_updated;
    RAISE NOTICE 'Avg Rate Before:    $%', ROUND(v_avg_before, 2);
    RAISE NOTICE 'Avg Rate After:     $%', ROUND(v_avg_after, 2);
    RAISE NOTICE '============================================';
END;
$$ LANGUAGE plpgsql;

-- Test:
-- CALL bulk_update_category_prices('Action', 10);


-- ============================================================================
-- END OF SOLUTIONS
-- ============================================================================
