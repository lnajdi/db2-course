-- Connect to Pagila database
-- \c pagila


-- list all tables in the public schema
SELECT tablename , tableowner
FROM pg_tables
WHERE schemaname = 'public';




-- Check current indexes in the database
SELECT tablename, indexdef, indexname
FROM pg_indexes 
WHERE schemaname = 'public'
AND tablename IN ('actor', 'film', 'customer')
ORDER BY tablename, indexname;


-- Check current indexes in the database
SELECT tablename, indexdef, indexname
FROM pg_indexes 
WHERE schemaname = 'public'
AND tablename ='film'
ORDER BY tablename, indexname;


-- Check the structure of the film table 
SELECT column_name,
    data_type,
    is_nullable
FROM
    information_schema.columns
WHERE
    table_name = 'film';


SELECT COUNT(*) FROM film;


DROP INDEX IF EXISTS idx_title;

-- Now let's search for a film by title without an index

-- analyze is used to get actual execution time

EXPLAIN ANALYZE
SELECT * FROM film 
WHERE title = 'ACADEMY DINOSAUR';



-- Seq Scan on film → PostgreSQL read the whole table row-by-row.

-- cost=0.00..67.50 → planner’s estimate: no startup work, total work ≈ 67.5 abstract units (not ms), derived from page + CPU costs.

-- rows=1 width=390 → it expected 1 row to match; each row ~390 bytes (avg of selected columns).

-- (actual time=0.018..0.430 rows=1 loops=1) → it really started returning at 0.018 ms and finished by 0.430 ms; produced 1 row; node ran once.

-- Filter: (title = 'ACADEMY DINOSAUR'::text) → predicate applied during the scan.

-- Rows Removed by Filter: 999 → it inspected ~1000 rows total; 999 didn’t match.

-- Planning Time: 0.104 ms / Execution Time: 0.456 ms → planner time vs full execution time.

-- Why a Seq Scan here?
-- Likely because either (a) there’s no usable index on film.title, or (b) the table is so small (~1000 rows) that reading all rows is cheaper than using an index (index overhead + random I/O).

-- What would change with an index?
-- If you create an index on title and the table is larger, you’d typically see Index Scan (or Index Only Scan) with much lower total cost and fewer pages touched; on a tiny table, the planner may still prefer Seq Scan.



-- Create an index on the title column
CREATE INDEX idx_title ON film(title);

-- Check the indexes again
SELECT tablename, indexdef, indexname
FROM pg_indexes 
WHERE schemaname = 'public'
AND tablename ='film'


-- Now let's search for a film by title with the index
EXPLAIN ANALYZE
SELECT * FROM film 
WHERE title = 'ACADEMY DINOSAUR';


-- Before (Seq Scan): cost 0.00..67.50, execution 0.456 ms, rows removed by filter 999.

-- After (Index Scan): cost 0.28..8.29, execution 0.069 ms, planning time slightly higher.

-- Takeaway: index plan is ~6–7× faster here; on bigger tables the gap usually widens.


-- verbose is used to get more detailed output

EXPLAIN (ANALYZE, verbose)
SELECT * FROM film 
WHERE title = 'ACADEMY DINOSAUR';

-- buffers is used to get information about buffer usage
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM film 
WHERE title = 'ACADEMY DINOSAUR';

-- buffers is used to get information about buffer usage
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT * FROM film 
WHERE title = 'ACADEMY DINOSAUR';

--   Buffers: shared hit=3 means the query found all needed pages already in memory (no disk I/O).
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT * FROM customer 
WHERE first_name = 'MARY' AND last_name = 'SMITH'; 

--  Buffers: shared hit=31 read=5 dirtied=2 means it had to read 5 pages from disk.

-- analyze simple reporting queries two tables on a join film language
EXPLAIN ANALYZE
SELECT
    f.title,
    l.name AS language
FROM film f
JOIN language l ON f.language_id = l.language_id
WHERE l.name = 'English'
ORDER BY f.title;

-- analyze simple reporting queries two tables on a join film language cout by language
EXPLAIN ANALYZE
SELECT
    l.name AS language,
    COUNT(*) AS film_count
FROM film f
JOIN language l ON f.language_id = l.language_id
WHERE l.name IN ('English', 'Italian', 'Japanese')
GROUP BY l.name
ORDER BY film_count DESC;


-- analyze and create -- Create indexes for common reporting queries: statistics by film category by rental year/month to showcase
-- function-based indexes for example upper() usage

--before let’s analyze the query performance without indexes

EXPLAIN ANALYZE
SELECT
    c.name AS category,
    EXTRACT(YEAR FROM r.rental_date) AS rental_year,
    EXTRACT(MONTH FROM r.rental_date) AS rental_month,
    COUNT(*) AS rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE upper(c.name) IN ('ACTION', 'COMEDY', 'DRAMA')
GROUP BY
    c.name,
    EXTRACT(YEAR FROM r.rental_date),
    EXTRACT(MONTH FROM r.rental_date)
ORDER BY category, rental_year, rental_month;

-- Planning Time: 0.889 ms
-- Execution Time: 16.007 ms


-- The `Sort` step, which was required to perform the `GROUP BY`, took **11.8 ms** of that time.
-- This is the most time-consuming part of the query.



-- The original query is slow for two main reasons. First, 
-- the database has to sort a huge amount of data at the end to group the results, which is the most time-consuming step. Second, it has to scan the whole category table and apply the upper() function to every name to find 'ACTION', 'COMEDY', and 'DRAMA'.

-- To fix this, create these two indexes. The first one will have the biggest impact.

-- CREATE INDEX idx_rental_rental_date ON rental (rental_date);
-- CREATE INDEX idx_category_name_upper ON category (upper(name));

-- The first index on rental_date gives the database the data pre-sorted by date. 
-- This completely eliminates the slow sorting step, which is the biggest performance gain.

-- The second index on upper(name) is a special function-based index.
--  It directly matches the WHERE upper(c.name) condition, 
--  making that filter instant instead of a full table scan.

-- We do not need new indexes for the joins because the database schema
--  is already well-designed. The columns used in the joins, 
--  like inventory_id and film_id, are foreign keys and are already indexed. 
--  The database is already joining them efficiently. 
--  The real bottlenecks were the final sort and the WHERE clause filter, 
--  which our new indexes solve.


-- 1) Functional index to support WHERE upper(c.name) IN (...)
DROP INDEX IF EXISTS idx_category_name;
CREATE INDEX idx_category_name ON category (upper(name));

-- check the indexes again
SELECT tablename, indexdef, indexname
FROM pg_indexes
WHERE schemaname = 'public'
AND tablename =  'category';


-- 2) Composite index to help the rental -> inventory join and date grouping
DROP INDEX IF EXISTS idx_rental_rental_date;
CREATE INDEX idx_rental_rental_date ON rental (rental_date);


-- check the indexes again
SELECT tablename, indexdef, indexname
FROM pg_indexes
WHERE schemaname = 'public'
AND tablename =   'rental';


-- lets execute the query again with the index
EXPLAIN ANALYZE
SELECT
    c.name AS category,
    EXTRACT(YEAR FROM r.rental_date) AS rental_year,
    EXTRACT(MONTH FROM r.rental_date) AS rental_month,
    COUNT(*) AS rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE upper(c.name) IN ('ACTION', 'COMEDY', 'DRAMA')
GROUP BY
    c.name,
    EXTRACT(YEAR FROM r.rental_date),
    EXTRACT(MONTH FROM r.rental_date)
ORDER BY category, rental_year, rental_month;




-- Planning Time: 0.889 ms
-- Execution Time: 16.007 ms

-- Planning Time: 1.115 ms
-- Execution Time: 12.656 ms


-- although the execution time is not drastically different on the small 16k row table,
-- the query plan has changed to use the indexes we created.
-- This new plan is fundamentally more efficient and will scale dramatically better as data grows.

--- If the rental table had 5 million rows instead of thousands,
--- the performance difference would be pronounced.

-- BEFORE indexes, with 5 million rows, expect performance:
-- The query would require a full table scan and a massive, slow disk-based sort.
-- Execution Time: ROUGHLY 30 - 180 SECONDS or more.

-- AFTER indexes, with 5 million rows, expect performance:
-- The query would use an efficient index scan, completely avoiding the sort.
-- Execution Time: ROUGHLY 50 - 200 MILLISECONDS.






















