-- ============================================================================
-- POSTGRESQL CURSORS DEMO
-- Complete guide to cursor-based row processing in PostgreSQL
-- Database: Pagila (DVD Rental sample database)
-- ============================================================================

-- ============================================================================
-- WHAT ARE CURSORS?
-- ============================================================================
-- Cursors allow you to process query results ONE ROW AT A TIME
-- Think of it as a pointer that moves through your result set
--
-- WITHOUT CURSOR:  All rows loaded at once (memory intensive)
-- WITH CURSOR:     One row at a time (memory efficient, fine control)
--
-- ⚠️ IMPORTANT: Only use cursors when necessary!
-- If regular SQL can do it (COUNT, SUM, UPDATE), use SQL instead!
-- ============================================================================


-- ============================================================================
-- SECTION 2: CURSOR BASICS - THE 4-STEP PATTERN
-- ============================================================================
-- Manual cursor management: DECLARE → OPEN → FETCH → CLOSE

-- synthaxe  of declarimg a cursor and using it
--  Cursor_name CURSOR FOR SQL_QUERY

DO $$
DECLARE 
    -- Step 1: DECLARE the cursor
    film_cursor CURSOR FOR 
        SELECT film_id, title, rental_rate 
        FROM film 
        WHERE rating = 'G' -- Filter just films with PG rating ,
        LIMIT 5;  -- Always test with LIMIT first!
    
    -- Variable to hold each row
    film_record RECORD;
    row_count INTEGER := 0;
BEGIN
    RAISE NOTICE '=== BASIC CURSOR DEMO ===';
    RAISE NOTICE '';
    
    -- Step 2: OPEN the cursor: Execute the underlying query
    OPEN film_cursor;
    
    -- Step 3: FETCH rows in a LOOP
    LOOP
        -- Get next row
        FETCH film_cursor INTO film_record;
        
        -- Exit when no more rows (CRITICAL!)
        EXIT WHEN NOT FOUND;
        
        -- Process the row
        row_count := row_count + 1;
        RAISE NOTICE 'Row %: Film #% - "%" ($%)', 
            row_count,
            film_record.film_id,
            film_record.title,
            film_record.rental_rate;
    END LOOP;
    
    -- Step 4: CLOSE the cursor : Release resources 
    CLOSE film_cursor;
    
    RAISE NOTICE '';
    RAISE NOTICE 'Processed % films', row_count;
END $$;


-- it s a little long winded, so we have a better way...
-- we have to declare , open, fetch and close the cursor manually
-- also the record variable used to hold each row should be declared

-- The advantage of manual cursor management is fine control over the cursor lifecycle 
-- You can open/close multiple times, fetch specific rows, etc.
-- you can also use scrollable cursors to move back and forth : for example to go back to a previous row



-- ============================================================================
-- SECTION 3: SIMPLIFIED FOR LOOP SYNTAX (RECOMMENDED!)
-- ============================================================================
-- FOR loop handles OPEN/CLOSE automatically - Much cleaner!

-- Version 1: Named cursor with FOR loop
DO $$
DECLARE
    film_cursor CURSOR FOR 
        SELECT film_id, title, rental_rate 
        FROM film 
        WHERE rating = 'G'
        LIMIT 5;
    
    -- film_record RECORD;
    counter INTEGER := 0;
BEGIN
 
    -- FOR loop opens and closes automatically!
    FOR film_record IN film_cursor LOOP
        counter := counter + 1;
        RAISE NOTICE '%: "%" - $%', 
            counter, film_record.title, film_record.rental_rate;
    END LOOP;
    
    RAISE NOTICE 'Total: %', counter;
END $$;



-- Version 2: Direct query in FOR loop (SIMPLEST - Use this 80% of the time!)
-- Appopriate when no complex cursor management needed , the cursor is used only once
-- So we combine DECLARE and CURSOR usage in one step   
DO $$
DECLARE
    film_record RECORD;
    counter INTEGER := 0;
BEGIN
    RAISE NOTICE '=== DIRECT QUERY IN FOR LOOP (SIMPLEST!) ===';
    RAISE NOTICE '';
    
    -- No cursor declaration needed! But RECORD variable is needed!
    FOR film_record IN 
        SELECT film_id, title, rental_rate 
        FROM film 
        WHERE rating = 'G'  
        LIMIT 5
    LOOP
        RAISE NOTICE ' "%" - $%', 
            film_record.title, film_record.rental_rate;
    END LOOP;
    
END $$;


-- ============================================================================
-- SECTION 4: WORKING WITH CURSOR DATA - ACCUMULATORS
-- ============================================================================
-- Common pattern: Count, sum, categorize as you iterate

DO $$
DECLARE
    payment_rec RECORD;
    total_amount DECIMAL(10,2) := 0;
    high_value_count INTEGER := 0;
    low_value_count INTEGER := 0;
    counter INTEGER := 0;
BEGIN
    RAISE NOTICE '=== PAYMENT ANALYSIS ===';
    RAISE NOTICE '';
    
    FOR payment_rec IN 
        SELECT payment_id, customer_id, amount, payment_date
        FROM payment
        LIMIT 100  -- Process first 100 payments
    LOOP
        counter := counter + 1;
        total_amount := total_amount + payment_rec.amount;
        
        -- Conditional categorization
        IF payment_rec.amount >= 5.00 THEN
            high_value_count := high_value_count + 1;
        ELSE
            low_value_count := low_value_count + 1;
        END IF;
        
        -- Show progress every 25 rows
        IF counter % 25 = 0 THEN
            RAISE NOTICE 'Progress: % payments processed...', counter;
        END IF;
    END LOOP;
    
    RAISE NOTICE '';
    RAISE NOTICE '=== RESULTS ===';
    RAISE NOTICE 'Total payments: %', counter;
    RAISE NOTICE 'Total amount: $%', total_amount;
    RAISE NOTICE 'High value (>=$5): %', high_value_count;
    RAISE NOTICE 'Low value (<$5): %', low_value_count;
    RAISE NOTICE 'Average: $%', ROUND(total_amount / counter, 2);
END $$;


-- ============================================================================
-- SECTION 5: CONDITIONAL PROCESSING
-- ============================================================================
-- Different actions based on row data

DO $$
DECLARE
    customer_rec RECORD;
    vip_count INTEGER := 0;
    regular_count INTEGER := 0;
    inactive_count INTEGER := 0;
BEGIN
    RAISE NOTICE '=== CUSTOMER CATEGORIZATION ===';
    RAISE NOTICE '';
    
    FOR customer_rec IN 
        SELECT c.customer_id, c.first_name, c.last_name, c.active,
               COUNT(r.rental_id) as rental_count,
               COALESCE(SUM(p.amount), 0) as total_spent
        FROM customer c
        LEFT JOIN rental r ON c.customer_id = r.customer_id
        LEFT JOIN payment p ON r.rental_id = p.rental_id
        GROUP BY c.customer_id, c.first_name, c.last_name, c.active
        ORDER BY total_spent DESC
        LIMIT 20
    LOOP
        -- Different logic per customer based on spending
        IF customer_rec.total_spent > 150 THEN
            vip_count := vip_count + 1;
            RAISE NOTICE '⭐ VIP: % % - $% spent (% rentals)',
                customer_rec.first_name,
                customer_rec.last_name,
                customer_rec.total_spent,
                customer_rec.rental_count;
                
        ELSIF customer_rec.total_spent > 100 THEN
            regular_count := regular_count + 1;
            RAISE NOTICE '✓ Regular: % % - $%',
                customer_rec.first_name,
                customer_rec.last_name,
                customer_rec.total_spent;
                
        ELSE
            inactive_count := inactive_count + 1;
            -- Could trigger "we miss you" email here
        END IF;
    END LOOP;
    
    RAISE NOTICE '';
    RAISE NOTICE 'VIP customers: %', vip_count;
    RAISE NOTICE 'Regular customers: %', regular_count;
    RAISE NOTICE 'Inactive customers: %', inactive_count;
END $$;


-- ============================================================================
-- SECTION 6: PARAMETERIZED CURSORS
-- ============================================================================
-- Reusable cursors with parameters - Like functions for queries!

-- Single Parameter Example
DO $$
DECLARE
    -- Cursor with ONE parameter
        films_by_rating CURSOR(p_rating film.rating%TYPE) FOR 
            SELECT film_id, title, length, rental_rate
            FROM film
            WHERE rating = p_rating
            ORDER BY rental_rate DESC
            LIMIT 5;
        
        film_rec RECORD;
BEGIN
    RAISE NOTICE '=== PARAMETERIZED CURSOR: PG-13 FILMS ===';
    RAISE NOTICE '';
    
    -- Use cursor with parameter value
    FOR film_rec IN films_by_rating('PG-13') LOOP
        RAISE NOTICE '"%": %min - $%', 
            film_rec.title, film_rec.length, film_rec.rental_rate;
    END LOOP;

END $$;


-- Reusing Parameterized Cursor 
DO $$
DECLARE
    customer_by_city_London CURSOR(p_city TEXT) FOR 
        SELECT c.customer_id, c.first_name, c.last_name, c.email
        FROM customer c
        JOIN address a ON c.address_id = a.address_id
        JOIN city ci ON a.city_id = ci.city_id
        WHERE ci.city = p_city
        LIMIT 3;
    
    cust_rec RECORD;
    total_count INTEGER := 0;
BEGIN
    -- Use for London
    RAISE NOTICE '=== CUSTOMERS IN LONDON ===';
    FOR cust_rec IN customer_by_city('London') LOOP
        RAISE NOTICE '% % - %', cust_rec.first_name, cust_rec.last_name, cust_rec.email;
        total_count := total_count + 1;
    END LOOP;
    
    RAISE NOTICE '';
    
    -- Reuse same cursor for different city
    RAISE NOTICE '=== CUSTOMERS IN WOODRIDGE ===';
    FOR cust_rec IN customer_by_city('Woodridge') LOOP
        RAISE NOTICE '% % - %', cust_rec.first_name, cust_rec.last_name, cust_rec.email;
        total_count := total_count + 1;
    END LOOP;
    
    RAISE NOTICE '';
    RAISE NOTICE 'Total customers processed: %', total_count;
END $$;


-- -- Multiple Parameters Example
-- DO $$
-- DECLARE
--     -- Cursor with TWO parameters
--     filtered_films CURSOR(p_rating TEXT, min_length INTEGER) FOR 
--         SELECT film_id, title, length, rating, rental_rate
--         FROM film
--         WHERE rating = p_rating 
--           AND length >= min_length
--         ORDER BY rental_rate DESC
--         LIMIT 5;
    
--     film_rec RECORD;
-- BEGIN
--     RAISE NOTICE '=== MULTIPLE PARAMETERS: PG-13 Films over 120 min ===';
--     RAISE NOTICE '';
    
--     -- Must OPEN explicitly when using multiple parameters
--     OPEN filtered_films('PG-13', 120);
    
--     LOOP
--         FETCH filtered_films INTO film_rec;
--         EXIT WHEN NOT FOUND;
        
--         RAISE NOTICE '"%": %min (%%) - $%', 
--             film_rec.title, 
--             film_rec.length, 
--             film_rec.rating,
--             film_rec.rental_rate;
--     END LOOP;
    
--     CLOSE filtered_films;
-- END $$;


-- Reusing Parameterized Cursor



-- ============================================================================
-- SECTION 8: NESTED CURSORS
-- ============================================================================
-- Cursor within cursor - Use sparingly (performance impact!)




DO $$
DECLARE
    category_rec RECORD;
    film_rec RECORD;
    category_count INTEGER := 0;
    film_count INTEGER := 0;

    -- declare cursors 
    category_cursor CURSOR FOR 
        SELECT category_id, name 
        FROM category 
        ORDER BY name
        LIMIT 3 ; -- Just 3 categories for demo

    -- Parameterized cursor for films in a given category
    film_cursor CURSOR(p_category_id INT) FOR 
        SELECT f.film_id, f.title, f.rental_rate
        FROM film f
        JOIN film_category fc ON f.film_id = fc.film_id
        WHERE fc.category_id = p_category_id
        ORDER BY f.rental_rate DESC
        LIMIT 3 ; -- Top 3 films per category 
BEGIN
    RAISE NOTICE '=== FILMS BY CATEGORY (Nested Cursors) ===';
    RAISE NOTICE '';
    
    -- Outer cursor: Categories
    FOR category_rec IN  category_cursor    LOOP
        category_count := category_count + 1;
        RAISE NOTICE '=== CATEGORY %: % ===', category_count, category_rec.name;
        
        film_count := 0;
        
        -- Inner cursor: Films in this category will be executed for each category 3 times
        FOR film_rec IN film_cursor(category_rec.category_id)  LOOP
            film_count := film_count + 1;
            RAISE NOTICE '  %: "%" - $%',
                film_count, film_rec.title, film_rec.rental_rate;
        END LOOP;
        
        IF film_count = 0 THEN
            RAISE NOTICE '  (No films in this category)';
        END IF;
        
        RAISE NOTICE '';
    END LOOP;
    
    RAISE NOTICE 'Processed % categories', category_count;
END $$;



-- -- Alternative: Inline nested cursor without separate declaration  

DO $$
DECLARE
    category_rec RECORD;
    film_rec RECORD;
    category_count INTEGER := 0;
    film_count INTEGER := 0;
BEGIN
    RAISE NOTICE '=== FILMS BY CATEGORY (Nested Cursors) ===';
    RAISE NOTICE '';
    
    -- Outer cursor: Categories
    FOR category_rec IN 
        SELECT category_id, name 
        FROM category 
        ORDER BY name
        LIMIT 3  -- Just 3 categories for demo
    LOOP
        category_count := category_count + 1;
        RAISE NOTICE '=== CATEGORY %: % ===', category_count, category_rec.name;
        
        film_count := 0;
        
        -- Inner cursor: Films in this category
        FOR film_rec IN
            SELECT f.film_id, f.title, f.rental_rate
            FROM film f
            JOIN film_category fc ON f.film_id = fc.film_id
            WHERE fc.category_id = category_rec.category_id
            ORDER BY f.rental_rate DESC
            LIMIT 3  -- Top 3 films per category
        LOOP
            film_count := film_count + 1;
            RAISE NOTICE '  %: "%" - $%',
                film_count, film_rec.title, film_rec.rental_rate;
        END LOOP;
        
        IF film_count = 0 THEN
            RAISE NOTICE '  (No films in this category)';
        END IF;
        
        RAISE NOTICE '';
    END LOOP;
    
    RAISE NOTICE 'Processed % categories', category_count;
END $$;



-- ============================================================================
-- SECTION 10: EARLY EXIT FROM CURSOR LOOP
-- ============================================================================
-- Stop processing when you find what you need

DO $$
DECLARE
    customer_rec RECORD;
    customers_checked INTEGER := 0;
    high_spender_found BOOLEAN := FALSE;
BEGIN
    RAISE NOTICE '=== FIND FIRST HIGH SPENDER ===';
    RAISE NOTICE '';
    
    FOR customer_rec IN 
        SELECT c.customer_id, c.first_name, c.last_name,
               COALESCE(SUM(p.amount), 0) as total_spent
        FROM customer c
        LEFT JOIN payment p ON c.customer_id = p.customer_id
        GROUP BY c.customer_id, c.first_name, c.last_name
        ORDER BY c.customer_id
    LOOP
        customers_checked := customers_checked + 1;
        
        -- Check if this customer spent over $150
        IF customer_rec.total_spent > 150 THEN
            RAISE NOTICE '✓ Found high spender: % % (ID: %)', 
                customer_rec.first_name,
                customer_rec.last_name,
                customer_rec.customer_id;
            RAISE NOTICE '  Total spent: $%', customer_rec.total_spent;
            high_spender_found := TRUE;
            EXIT;  -- Stop searching!
        END IF;
    END LOOP;
    
    RAISE NOTICE '';
    IF high_spender_found THEN
        RAISE NOTICE 'Search completed after checking % customers', customers_checked;
    ELSE
        RAISE NOTICE 'No high spender found after checking % customers', customers_checked;
    END IF;
END $$;


-- ===========================================================================
-- SECTION 9: UPDATABLE CURSORS (FOR UPDATE) , usig for loop   simple exemple
-- ===========================================================================

-- Update rows through cursor using WHERE CURRENT OF

-- This feature allows us to update the rows that the cursor is currently pointing to
-- it is useful when we need to apply different updates based on row data 
-- Rows are locked for update when using FOR UPDATE 


DO $$
DECLARE
    -- FOR UPDATE locks rows for modification
    film_cursor CURSOR FOR 
        SELECT film_id, title, rental_rate
        FROM film
        WHERE rating = 'G' 
        ORDER BY title
        LIMIT 5
        FOR UPDATE;  -- Important: enables WHERE CURRENT OF
    
    film_rec RECORD;
BEGIN

    RAISE NOTICE '=== UPDATING FILMS THROUGH CURSOR (FOR LOOP) ===';
    RAISE NOTICE '';
    
    FOR film_rec IN film_cursor LOOP
        -- Apply 10% discount to films over $2.99
        IF film_rec.rental_rate > 2.99 THEN
            -- WHERE CURRENT OF updates the row the cursor is currently on
            UPDATE film
            SET rental_rate = rental_rate * 0.90
            WHERE CURRENT OF film_cursor; 
            -- this is the important part , it updates the current row the cursor is pointing to
            
            RAISE NOTICE '✓ Discounted: "%" from $% to $%', 
                film_rec.title,
                film_rec.rental_rate,
                film_rec.rental_rate * 0.90;
        ELSE
            RAISE NOTICE '- Skipped: "%" ($% - already low)', 
                film_rec.title,
                film_rec.rental_rate;
        END IF;
    END LOOP;
    
    -- Rollback so we don't actually change the database
    RAISE NOTICE '';
    RAISE NOTICE '⚠️  Changes rolled back (demo purposes)';
    ROLLBACK;
END $$;     




-- ============================================================================
-- SECTION 11: CURSORS VS SELECT INTO
-- ============================================================================

-- ❌ Using SELECT INTO for single row (CORRECT approach)
DO $$
DECLARE
    customer_name TEXT;
    customer_email TEXT;
    total_spent DECIMAL(10,2);
BEGIN
    RAISE NOTICE '=== SELECT INTO: Single Customer ===';
    
    -- Get ONE customer's data
    SELECT c.first_name || ' ' || c.last_name, c.email, COALESCE(SUM(p.amount), 0)
    INTO customer_name, customer_email, total_spent
    FROM customer c
    LEFT JOIN payment p ON c.customer_id = p.customer_id
    WHERE c.customer_id = 5
    GROUP BY c.first_name, c.last_name, c.email;
    
    RAISE NOTICE 'Customer: %', customer_name;
    RAISE NOTICE 'Email: %', customer_email;
    RAISE NOTICE 'Total spent: $%', total_spent;
END $$;


-- ✅ Using CURSOR for multiple rows (CORRECT approach)
DO $$
DECLARE
    customer_rec RECORD;
    customer_count INTEGER := 0;
    total_revenue DECIMAL(10,2) := 0;
BEGIN
    RAISE NOTICE '';
    RAISE NOTICE '=== CURSOR: Multiple Customers ===';
    RAISE NOTICE '';
    
    FOR customer_rec IN 
        SELECT c.customer_id, 
               c.first_name || ' ' || c.last_name as name,
               c.email,
               COALESCE(SUM(p.amount), 0) as spent
        FROM customer c
        LEFT JOIN payment p ON c.customer_id = p.customer_id
        WHERE c.active = 1
        GROUP BY c.customer_id, c.first_name, c.last_name, c.email
        ORDER BY spent DESC
        LIMIT 5
    LOOP
        customer_count := customer_count + 1;
        total_revenue := total_revenue + customer_rec.spent;
        
        RAISE NOTICE '% - % - $%', 
            customer_rec.name, 
            customer_rec.email,
            customer_rec.spent;
    END LOOP;
    
    RAISE NOTICE '';
    RAISE NOTICE 'Processed % customers, Total revenue: $%', 
        customer_count, total_revenue;
END $$;




-- ============================================================================
-- SECTION 12: SCROLLABLE CURSORS (Advanced Navigation)
-- ============================================================================
-- Move forward, backward, jump to positions

DO $$
DECLARE
    -- SCROLL keyword enables bidirectional movement
    film_cursor SCROLL CURSOR FOR 
        SELECT film_id, title, rental_rate
        FROM film
        ORDER BY title
        LIMIT 10;
    
    film_rec RECORD;
BEGIN
    RAISE NOTICE '=== SCROLLABLE CURSOR DEMO ===';
    RAISE NOTICE '';
    
    OPEN film_cursor;
    
    -- Fetch first row
    RAISE NOTICE 'FIRST row:';
    FETCH FIRST FROM film_cursor INTO film_rec;
    RAISE NOTICE '  "%"', film_rec.title;
    
    RAISE NOTICE '';
    
    -- Fetch last row
    RAISE NOTICE 'LAST row:';
    FETCH LAST FROM film_cursor INTO film_rec;
    RAISE NOTICE '  "%"', film_rec.title;
    
    RAISE NOTICE '';
    
    -- Go back to first
    RAISE NOTICE 'Back to FIRST:';
    FETCH FIRST FROM film_cursor INTO film_rec;
    RAISE NOTICE '  "%"', film_rec.title;
    
    RAISE NOTICE '';
    
    -- Move forward 3 positions from current
    RAISE NOTICE 'RELATIVE +3 (forward 3):';
    FETCH RELATIVE 3 FROM film_cursor INTO film_rec;
    RAISE NOTICE '  "%"', film_rec.title;
    
    RAISE NOTICE '';
    
    -- Move back 1 position
    RAISE NOTICE 'PRIOR (back 1):';
    FETCH PRIOR FROM film_cursor INTO film_rec;
    RAISE NOTICE '  "%"', film_rec.title;
    
    RAISE NOTICE '';
    
    -- Jump to absolute position 5
    RAISE NOTICE 'ABSOLUTE 5 (row #5):';
    FETCH ABSOLUTE 5 FROM film_cursor INTO film_rec;
    RAISE NOTICE '  "%"', film_rec.title;
    
    CLOSE film_cursor;
    
    RAISE NOTICE '';
    RAISE NOTICE '✓ Scrollable cursors allow flexible navigation!';
END $$;





-- ============================================================================
-- SECTION 14: REAL-WORLD EXAMPLE - Customer Loyalty Program
-- ============================================================================
-- Complete business scenario: Assign loyalty tiers and generate rewards

DO $$
DECLARE
    customer_rec RECORD;
    loyalty_tier TEXT;
    reward_points INTEGER;
    email_message TEXT;
    
    -- Counters
    platinum_count INTEGER := 0;
    gold_count INTEGER := 0;
    silver_count INTEGER := 0;
    bronze_count INTEGER := 0;
BEGIN
    RAISE NOTICE '=== CUSTOMER LOYALTY TIER ASSIGNMENT ===';
    RAISE NOTICE '';
    RAISE NOTICE 'Analyzing customer spending and rental activity...';
    RAISE NOTICE '================================================';
    RAISE NOTICE '';
    
    FOR customer_rec IN 
        SELECT c.customer_id, 
               c.first_name, 
               c.last_name, 
               c.email,
               c.active,
               COUNT(DISTINCT r.rental_id) as rental_count,
               COALESCE(SUM(p.amount), 0) as total_spent
        FROM customer c
        LEFT JOIN rental r ON c.customer_id = r.customer_id
        LEFT JOIN payment p ON r.rental_id = p.rental_id
        GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.active
        HAVING COALESCE(SUM(p.amount), 0) > 0  -- Only paying customers
        ORDER BY total_spent DESC
        LIMIT 30  -- Top 30 customers
    LOOP
        -- Determine tier based on spending
        IF customer_rec.total_spent >= 150 THEN
            loyalty_tier := 'PLATINUM';
            reward_points := 500;
            email_message := 'VIP benefits + Free rental';
            platinum_count := platinum_count + 1;
            
        ELSIF customer_rec.total_spent >= 120 THEN
            loyalty_tier := 'GOLD';
            reward_points := 300;
            email_message := 'Priority support + Discount';
            gold_count := gold_count + 1;
            
        ELSIF customer_rec.total_spent >= 80 THEN
            loyalty_tier := 'SILVER';
            reward_points := 150;
            email_message := '10% off next rental';
            silver_count := silver_count + 1;
            
        ELSE
            loyalty_tier := 'BRONZE';
            reward_points := 50;
            email_message := 'Thank you for your loyalty';
            bronze_count := bronze_count + 1;
        END IF;
        
        -- Display customer tier assignment
        RAISE NOTICE '% ⭐ % %', 
            loyalty_tier,
            customer_rec.first_name,
            customer_rec.last_name;
        RAISE NOTICE '   Email: %', customer_rec.email;
        RAISE NOTICE '   Spent: $% | Rentals: % | Points: %', 
            customer_rec.total_spent,
            customer_rec.rental_count,
            reward_points;
        RAISE NOTICE '   Message: %', email_message;
        RAISE NOTICE '';
        
        -- In real system, would:
        -- 1. UPDATE customer table with tier
        -- 2. INSERT into rewards table
        -- 3. Call email service function
        -- 4. Log the assignment
    END LOOP;
    
    RAISE NOTICE '================================================';
    RAISE NOTICE '=== SUMMARY ===';
    RAISE NOTICE 'PLATINUM (>$150): % customers', platinum_count;
    RAISE NOTICE 'GOLD ($120-150): % customers', gold_count;
    RAISE NOTICE 'SILVER ($80-120): % customers', silver_count;
    RAISE NOTICE 'BRONZE (<$80): % customers', bronze_count;
    RAISE NOTICE 'Total processed: %', platinum_count + gold_count + silver_count + bronze_count;
END $$;


-- ============================================================================
-- SECTION 15: REAL-WORLD EXAMPLE - Overdue Rental Processing
-- ============================================================================
-- Multi-step conditional processing based on how overdue

DO $$
DECLARE
    rental_rec RECORD;
    days_overdue INTEGER;
    late_fee DECIMAL(5,2);
    action_taken TEXT;
    
    -- Action counters
    reminder_count INTEGER := 0;
    warning_count INTEGER := 0;
    suspend_count INTEGER := 0;
    total_fees DECIMAL(10,2) := 0;
BEGIN
    RAISE NOTICE '=== OVERDUE RENTAL PROCESSING ===';
    RAISE NOTICE '';
    RAISE NOTICE 'Processing rentals without return date...';
    RAISE NOTICE '==========================================';
    RAISE NOTICE '';
    
    FOR rental_rec IN 
        SELECT r.rental_id,
               r.rental_date,
               r.return_date,
               c.customer_id,
               c.first_name,
               c.last_name,
               c.email,
               f.title as film_title,
               f.rental_rate,
               CURRENT_DATE - r.rental_date::DATE as days_out
        FROM rental r
        JOIN customer c ON r.customer_id = c.customer_id
        JOIN inventory i ON r.inventory_id = i.inventory_id
        JOIN film f ON i.film_id = f.film_id
        WHERE r.return_date IS NULL
          AND r.rental_date < CURRENT_DATE - INTERVAL '3 days'
        ORDER BY r.rental_date
        LIMIT 20
    LOOP
        days_overdue := rental_rec.days_out - 3;  -- Assuming 3-day rental period
        
        -- Calculate escalating late fees
        IF days_overdue <= 2 THEN
            late_fee := 1.00;
            action_taken := 'Send friendly reminder email';
            reminder_count := reminder_count + 1;
            
        ELSIF days_overdue <= 7 THEN
            late_fee := 2.00 + (days_overdue - 2) * 0.50;
            action_taken := 'Send warning + charge late fee';
            warning_count := warning_count + 1;
            
        ELSE
            late_fee := 5.00 + (days_overdue - 7) * 1.00;
            action_taken := 'Suspend account + charge maximum fee';
            suspend_count := suspend_count + 1;
        END IF;
        
        total_fees := total_fees + late_fee;
        
        RAISE NOTICE 'Rental #%: "%" (%% days overdue)', 
            rental_rec.rental_id,
            rental_rec.film_title,
            days_overdue;
        RAISE NOTICE '  Customer: % % (%)', 
            rental_rec.first_name,
            rental_rec.last_name,
            rental_rec.email;
        RAISE NOTICE '  Rented: % | Late fee: $%', 
            rental_rec.rental_date::DATE,
            late_fee;
        RAISE NOTICE '  Action: %', action_taken;
        RAISE NOTICE '';
        
        -- In real system, would:
        -- 1. INSERT into late_fees table
        -- 2. Call email notification function
        -- 3. UPDATE customer status if suspended
        -- 4. Log the action taken
    END LOOP;
    
    RAISE NOTICE '==========================================';
    RAISE NOTICE '=== PROCESSING SUMMARY ===';
    RAISE NOTICE 'Friendly reminders sent: %', reminder_count;
    RAISE NOTICE 'Warnings issued: %', warning_count;
    RAISE NOTICE 'Accounts suspended: %', suspend_count;
    RAISE NOTICE 'Total late fees: $%', total_fees;
END $$;


-- ============================================================================
-- SECTION 16: COMMON MISTAKES & HOW TO AVOID THEM
-- ============================================================================

-- ❌ MISTAKE 1: Infinite loop (forgot EXIT WHEN NOT FOUND)
/*
DO $$
DECLARE
    film_cursor CURSOR FOR SELECT * FROM film LIMIT 5;
    film_rec RECORD;
BEGIN
    OPEN film_cursor;
    LOOP
        FETCH film_cursor INTO film_rec;
        -- MISSING: EXIT WHEN NOT FOUND;
        -- This will loop forever after last row!
        RAISE NOTICE '%', film_rec.title;
    END LOOP;
    CLOSE film_cursor;
END $$;
*/

-- ✅ CORRECT: Always include EXIT condition
DO $$
DECLARE
    film_cursor CURSOR FOR SELECT film_id, title FROM film LIMIT 5;
    film_rec RECORD;
BEGIN
    RAISE NOTICE '=== CORRECT: Exit condition included ===';
    OPEN film_cursor;
    LOOP
        FETCH film_cursor INTO film_rec;
        EXIT WHEN NOT FOUND;  -- CRITICAL!
        RAISE NOTICE '%', film_rec.title;
    END LOOP;
    CLOSE film_cursor;
END $$;


-- ❌ MISTAKE 2: Using cursor when SQL would work
-- DON'T do this:
/*
DO $$
DECLARE
    total DECIMAL := 0;
    payment_rec RECORD;
BEGIN
    FOR payment_rec IN SELECT amount FROM payment LOOP
        total := total + payment_rec.amount;  -- Slow!
    END LOOP;
    RAISE NOTICE 'Total: $%', total;
END $$;
*/

-- ✅ DO this instead:
DO $$
DECLARE
    total DECIMAL;
BEGIN
    SELECT SUM(amount) INTO total FROM payment;
    RAISE NOTICE 'Total: $%', total;
END $$;


-- ❌ MISTAKE 3: No error handling in production
-- Risky - one bad row crashes everything:
/*
DO $$
BEGIN
    FOR rec IN SELECT * FROM customer LOOP
        -- Complex processing that might fail
        -- If it fails, entire batch stops!
    END LOOP;
END $$;
*/

-- ✅ CORRECT: Wrap in exception handler
DO $$
DECLARE
    rec RECORD;
    success INTEGER := 0;
    errors INTEGER := 0;
BEGIN
    RAISE NOTICE '=== WITH ERROR HANDLING ===';
    FOR rec IN SELECT customer_id, email FROM customer LIMIT 10 LOOP
        BEGIN
            -- Processing that might fail
            IF rec.email IS NULL THEN
                RAISE EXCEPTION 'Missing email';
            END IF;
            success := success + 1;
        EXCEPTION
            WHEN OTHERS THEN
                errors := errors + 1;
                -- Continue with next row!
        END;
    END LOOP;
    RAISE NOTICE 'Success: %, Errors: %', success, errors;
END $$;


-- ============================================================================
-- SECTION 17: PERFORMANCE TIPS
-- ============================================================================

-- TIP 1: Always test with LIMIT first!
DO $$
DECLARE
    film_rec RECORD;
    counter INTEGER := 0;
BEGIN
    RAISE NOTICE '=== Testing with LIMIT ===';
    
    -- Start with LIMIT 10, then increase gradually
    FOR film_rec IN 
        SELECT * FROM film 
        LIMIT 10  -- NOT 1000 on first run!
    LOOP
        counter := counter + 1;
        -- Your processing here
    END LOOP;
    
    RAISE NOTICE 'Processed % rows', counter;
    RAISE NOTICE 'If this works, increase LIMIT gradually';
END $$;


-- TIP 2: Show progress for long operations
DO $$
DECLARE
    payment_rec RECORD;
    counter INTEGER := 0;
BEGIN
    RAISE NOTICE '=== Processing with progress updates ===';
    
    FOR payment_rec IN SELECT * FROM payment LIMIT 500 LOOP
        counter := counter + 1;
        
        -- Show progress every 100 rows
        IF counter % 100 = 0 THEN
            RAISE NOTICE 'Progress: %/500 rows processed...', counter;
        END IF;
        
        -- Your processing here
    END LOOP;
    
    RAISE NOTICE 'Complete! Processed % rows', counter;
END $$;


-- TIP 3: Use appropriate cursor type
-- Simple FOR loop (fastest for forward-only):
DO $$
BEGIN
    FOR rec IN SELECT * FROM film LIMIT 5 LOOP
        -- Process
        NULL;
    END LOOP;
END $$;

-- Named cursor (when you need parameters/reuse):
DO $$
DECLARE
    my_cursor CURSOR(min_rate DECIMAL) FOR 
        SELECT * FROM film WHERE rental_rate >= min_rate;
BEGIN
    FOR rec IN my_cursor(2.99) LOOP
        -- Process
        NULL;
    END LOOP;
END $$;

-- Scrollable cursor (only when you need backward navigation):
DO $$
DECLARE
    my_cursor SCROLL CURSOR FOR SELECT * FROM film LIMIT 5;
    rec RECORD;
BEGIN
    OPEN my_cursor;
    FETCH LAST FROM my_cursor INTO rec;  -- Need SCROLL for this
    CLOSE my_cursor;
END $$;


-- ============================================================================
-- SECTION 18: DEBUGGING CURSORS
-- ============================================================================

DO $$
DECLARE
    customer_rec RECORD;
    counter INTEGER := 0;
    checkpoint INTEGER := 0;
BEGIN
    RAISE NOTICE '=== DEBUGGING EXAMPLE ===';
    RAISE NOTICE 'Starting cursor processing...';
    RAISE NOTICE '';
    
    FOR customer_rec IN 
        SELECT customer_id, first_name, last_name
        FROM customer
        LIMIT 10
    LOOP
        counter := counter + 1;
        
        -- Debug: Show what we're processing
        RAISE NOTICE 'DEBUG: Processing customer %: % %', 
            customer_rec.customer_id,
            customer_rec.first_name,
            customer_rec.last_name;
        
        -- Checkpoints for debugging
        IF counter = 5 THEN
            checkpoint := 1;
            RAISE NOTICE 'DEBUG: Reached checkpoint 1 (halfway)';
        END IF;
        
        -- Your actual processing would go here
        -- ...
        
    END LOOP;
    
    RAISE NOTICE '';
    RAISE NOTICE 'DEBUG: Loop completed';
    RAISE NOTICE 'DEBUG: Total rows processed: %', counter;
    RAISE NOTICE 'DEBUG: Checkpoints reached: %', checkpoint;
END $$;


-- ============================================================================
-- SECTION 19: QUICK REFERENCE - COPY THESE TEMPLATES!
-- ============================================================================

-- TEMPLATE 1: Simple FOR loop (use this 80% of the time)
/*
DO $$
DECLARE
    rec RECORD;
    counter INTEGER := 0;
BEGIN
    FOR rec IN SELECT * FROM your_table WHERE condition LIMIT 10 LOOP
        counter := counter + 1;
        -- Your processing here
        RAISE NOTICE '%: %', counter, rec.column_name;
    END LOOP;
    
    RAISE NOTICE 'Processed % rows', counter;
END $$;
*/


-- TEMPLATE 2: With error handling (production code)
/*
DO $$
DECLARE
    rec RECORD;
    success_count INTEGER := 0;
    error_count INTEGER := 0;
BEGIN
    FOR rec IN SELECT * FROM your_table LOOP
        BEGIN
            -- Your processing that might fail
            success_count := success_count + 1;
        EXCEPTION
            WHEN OTHERS THEN
                error_count := error_count + 1;
                RAISE NOTICE 'Error processing row: %', SQLERRM;
        END;
    END LOOP;
    
    RAISE NOTICE 'Success: %, Errors: %', success_count, error_count;
END $$;
*/


-- TEMPLATE 3: Parameterized cursor
/*
DO $$
DECLARE
    my_cursor CURSOR(param1 TYPE, param2 TYPE) FOR 
        SELECT * FROM your_table WHERE col1 = param1 AND col2 = param2;
    rec RECORD;
BEGIN
    FOR rec IN my_cursor(value1, value2) LOOP
        -- Your processing here
    END LOOP;
END $$;
*/


-- TEMPLATE 4: With progress tracking
/*
DO $$
DECLARE
    rec RECORD;
    counter INTEGER := 0;
BEGIN
    FOR rec IN SELECT * FROM your_table LOOP
        counter := counter + 1;
        
        -- Show progress every 100 rows
        IF counter % 100 = 0 THEN
            RAISE NOTICE 'Progress: % rows...', counter;
        END IF;
        
        -- Your processing here
    END LOOP;
    
    RAISE NOTICE 'Complete! % rows processed', counter;
END $$;
*/


-- ============================================================================
-- END OF CURSORS DEMO
-- ============================================================================
-- Remember:
-- 1. Use cursors ONLY when necessary (complex per-row logic)
-- 2. Prefer simple FOR loops over manual OPEN/FETCH/CLOSE
-- 3. Always include error handling in production code
-- 4. Test with LIMIT first, then scale up
-- 5. Show progress for long-running operations
-- 6. When in doubt, try SQL first - it's usually faster!
-- ============================================================================
