# Lab 10: Database Triggers

## 🎯 Learning Objectives
- Understand trigger concepts and use cases
- Master different trigger types (BEFORE, AFTER, INSTEAD OF)
- Implement data validation and business rule enforcement
- Create audit trails and logging systems
- Handle trigger performance and cascading effects

## 📚 Theory Overview

### What are Triggers?
Triggers are special stored procedures that automatically execute (fire) in response to specific database events. They provide a way to:
- **Enforce Business Rules**: Automatically validate data and enforce constraints
- **Audit Changes**: Track who changed what and when
- **Maintain Data Integrity**: Keep related data synchronized
- **Automate Processes**: Perform calculations and updates automatically

### Types of Triggers:
- **Row-Level Triggers**: Execute once for each affected row
- **Statement-Level Triggers**: Execute once for the entire SQL statement
- **BEFORE Triggers**: Execute before the triggering event
- **AFTER Triggers**: Execute after the triggering event
- **INSTEAD OF Triggers**: Replace the triggering event (views only)

### Trigger Events:
- **INSERT**: When new rows are added
- **UPDATE**: When existing rows are modified
- **DELETE**: When rows are removed
- **TRUNCATE**: When table is truncated (statement-level only)

### Trigger Function Structure:
```sql
CREATE OR REPLACE FUNCTION trigger_function_name()
RETURNS TRIGGER AS $$
BEGIN
    -- Trigger logic here
    -- Access OLD and NEW records
    -- Return NEW, OLD, or NULL based on trigger type
    RETURN NEW; -- or OLD or NULL
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_name
    BEFORE/AFTER INSERT/UPDATE/DELETE
    ON table_name
    FOR EACH ROW/STATEMENT
    EXECUTE FUNCTION trigger_function_name();
```

## 🛠️ Exercises

### Exercise 1: Basic Trigger Implementation (25 points)

**1.1** Audit triggers:
Create comprehensive audit functionality:
- Customer audit trail (track all changes to customer table)
- Payment audit trail (track payment modifications)
- Film audit trail (track film catalog changes)
- Rental audit trail (track rental transactions)

```sql
-- Example audit table structure
CREATE TABLE customer_audit (
    audit_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    operation CHAR(1), -- 'I', 'U', 'D'
    old_values JSONB,
    new_values JSONB,
    changed_by TEXT,
    changed_at TIMESTAMP DEFAULT NOW()
);
```

**1.2** Timestamp triggers:
Implement automatic timestamp management:
- Update `last_update` columns on modifications
- Set creation timestamps on new records
- Track modification history
- Handle timezone conversions

**1.3** Data validation triggers:
Create validation triggers for:
- Email format validation for customers
- Rental date consistency (rental_date ≤ return_date)
- Film rating validation (only valid MPAA ratings)
- Payment amount validation (positive amounts only)

### Exercise 2: Business Rule Enforcement (30 points)

**1.1** Inventory management triggers:
Implement automatic inventory tracking:
- Update film availability when rentals are created/returned
- Prevent rentals when inventory is unavailable
- Track inventory turnover statistics
- Automatic reorder notifications when stock is low

**2.2** Customer status management:
Create triggers for customer lifecycle:
- Automatically set customer status based on activity
- Calculate customer loyalty levels
- Update customer statistics on rental activity
- Handle customer reactivation scenarios

**2.3** Financial calculation triggers:
Implement automatic financial calculations:
- Calculate late fees when rentals are overdue
- Apply discounts based on customer loyalty level
- Update revenue totals when payments are made
- Handle payment refunds and adjustments

**2.4** Data consistency triggers:
Maintain referential integrity and consistency:
- Cascade updates to related tables
- Maintain denormalized summary data
- Synchronize related record timestamps
- Handle soft deletes with status updates

### Exercise 3: Advanced Trigger Patterns (25 points)

**3.1** Conditional triggers:
Create triggers with complex conditional logic:
- Triggers that fire only under specific conditions
- Different logic based on user roles or context
- Time-based trigger behavior (business hours only)
- Triggers with configuration-driven behavior

**3.2** Multi-table triggers:
Implement triggers affecting multiple tables:
- Customer rental triggers updating multiple summary tables
- Film modification triggers updating category statistics
- Payment triggers updating customer and store totals
- Complex cascading update scenarios

**3.3** Performance optimization triggers:
Create efficient trigger implementations:
- Batch processing within triggers
- Minimal impact trigger design
- Conditional processing to avoid unnecessary work
- Optimized trigger ordering and dependencies

### Exercise 4: Error Handling and Monitoring (20 points)

**4.1** Trigger error handling:
Implement robust error handling:
- Graceful failure handling in triggers
- Logging trigger errors without stopping transactions
- Recovery mechanisms for trigger failures
- User-friendly error messages

**4.2** Trigger monitoring and debugging:
Create monitoring systems for triggers:
- Log trigger execution times and frequency
- Monitor trigger performance impact
- Debug trigger execution chains
- Track trigger success/failure rates

**4.3** Trigger management:
Implement trigger administration tools:
- Enable/disable triggers dynamically
- Trigger dependency analysis
- Bulk trigger operations
- Trigger documentation and change tracking

## 🔍 Sample Trigger Implementations

### Basic Audit Trigger:
```sql
-- Create audit table
CREATE TABLE customer_audit (
    audit_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    operation CHAR(1),
    old_data JSONB,
    new_data JSONB,
    changed_by TEXT DEFAULT CURRENT_USER,
    changed_at TIMESTAMP DEFAULT NOW()
);

-- Create trigger function
CREATE OR REPLACE FUNCTION customer_audit_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO customer_audit (customer_id, operation, old_data)
        VALUES (OLD.customer_id, 'D', row_to_json(OLD));
        RETURN OLD;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO customer_audit (customer_id, operation, old_data, new_data)
        VALUES (NEW.customer_id, 'U', row_to_json(OLD), row_to_json(NEW));
        RETURN NEW;
    ELSIF TG_OP = 'INSERT' THEN
        INSERT INTO customer_audit (customer_id, operation, new_data)
        VALUES (NEW.customer_id, 'I', row_to_json(NEW));
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
CREATE TRIGGER customer_audit_trigger
    AFTER INSERT OR UPDATE OR DELETE ON customer
    FOR EACH ROW EXECUTE FUNCTION customer_audit_trigger();
```

### Business Rule Trigger:
```sql
-- Prevent rentals to inactive customers
CREATE OR REPLACE FUNCTION check_customer_active()
RETURNS TRIGGER AS $$
DECLARE
    customer_status BOOLEAN;
BEGIN
    -- Check if customer is active
    SELECT active INTO customer_status
    FROM customer
    WHERE customer_id = NEW.customer_id;
    
    IF NOT customer_status THEN
        RAISE EXCEPTION 'Cannot create rental for inactive customer %', NEW.customer_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_customer_active_trigger
    BEFORE INSERT ON rental
    FOR EACH ROW EXECUTE FUNCTION check_customer_active();
```

### Inventory Management Trigger:
```sql
-- Update inventory counts on rental operations
CREATE OR REPLACE FUNCTION manage_inventory()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Rental created - decrease available inventory
        UPDATE inventory_summary 
        SET available_count = available_count - 1,
            rented_count = rented_count + 1
        WHERE film_id = (SELECT film_id FROM inventory WHERE inventory_id = NEW.inventory_id);
        
        -- Check if inventory is still available
        IF (SELECT available_count FROM inventory_summary 
            WHERE film_id = (SELECT film_id FROM inventory WHERE inventory_id = NEW.inventory_id)) < 0 THEN
            RAISE EXCEPTION 'No inventory available for this film';
        END IF;
        
        RETURN NEW;
        
    ELSIF TG_OP = 'UPDATE' AND OLD.return_date IS NULL AND NEW.return_date IS NOT NULL THEN
        -- Rental returned - increase available inventory
        UPDATE inventory_summary 
        SET available_count = available_count + 1,
            rented_count = rented_count - 1
        WHERE film_id = (SELECT film_id FROM inventory WHERE inventory_id = NEW.inventory_id);
        
        RETURN NEW;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER manage_inventory_trigger
    AFTER INSERT OR UPDATE ON rental
    FOR EACH ROW EXECUTE FUNCTION manage_inventory();
```

### Complex Business Logic Trigger:
```sql
-- Calculate customer loyalty and late fees
CREATE OR REPLACE FUNCTION update_customer_metrics()
RETURNS TRIGGER AS $$
DECLARE
    rental_count INTEGER;
    total_spent NUMERIC;
    overdue_days INTEGER;
    late_fee NUMERIC := 0;
BEGIN
    -- Calculate current customer metrics
    SELECT COUNT(*), COALESCE(SUM(amount), 0)
    INTO rental_count, total_spent
    FROM rental r
    LEFT JOIN payment p ON r.rental_id = p.rental_id
    WHERE r.customer_id = NEW.customer_id;
    
    -- Calculate late fee if applicable
    IF NEW.return_date IS NOT NULL AND NEW.return_date > (NEW.rental_date + INTERVAL '7 days') THEN
        overdue_days := NEW.return_date::date - (NEW.rental_date + INTERVAL '7 days')::date;
        late_fee := overdue_days * 1.00; -- $1 per day late
        
        -- Insert late fee payment
        INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
        VALUES (NEW.customer_id, 1, NEW.rental_id, late_fee, NOW());
    END IF;
    
    -- Update customer loyalty level
    UPDATE customer 
    SET loyalty_level = CASE 
        WHEN rental_count >= 50 THEN 'GOLD'
        WHEN rental_count >= 25 THEN 'SILVER'
        WHEN rental_count >= 10 THEN 'BRONZE'
        ELSE 'BASIC'
    END,
    total_rentals = rental_count,
    lifetime_value = total_spent + late_fee,
    last_update = NOW()
    WHERE customer_id = NEW.customer_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_customer_metrics_trigger
    AFTER INSERT OR UPDATE ON rental
    FOR EACH ROW EXECUTE FUNCTION update_customer_metrics();
```

## 📝 Deliverables

Complete the `solutions.sql` file with:
1. All trigger implementations with comprehensive documentation
2. Test cases demonstrating trigger functionality
3. Performance analysis of trigger impact
4. Error handling and recovery procedures
5. Trigger management and monitoring solutions

## 💡 Best Practices

- **Keep Triggers Simple**: Complex logic should be in separate functions
- **Minimize Trigger Logic**: Avoid expensive operations in triggers
- **Handle Errors Gracefully**: Don't let trigger errors break transactions
- **Document Dependencies**: Track which triggers affect which tables
- **Test Thoroughly**: Consider all edge cases and error scenarios
- **Monitor Performance**: Track trigger execution time and frequency
- **Use Appropriate Timing**: Choose BEFORE vs AFTER triggers carefully

## ⚠️ Common Pitfalls

- **Recursive Triggers**: Triggers that trigger themselves
- **Cascading Effects**: Chains of triggers affecting performance
- **Error Propagation**: Trigger errors rolling back transactions
- **Performance Impact**: Too many or complex triggers slowing operations
- **Maintenance Overhead**: Triggers making debugging difficult

## 🚀 Advanced Challenges (Optional)

1. **Event-Driven Architecture**: Implement publish/subscribe with triggers
2. **Conflict Resolution**: Handle concurrent modifications with triggers
3. **Data Synchronization**: Cross-database synchronization triggers
4. **Performance Benchmarking**: Measure trigger overhead in high-volume scenarios

---

**Time Estimate**: 4-5 hours
**Difficulty**: ⭐⭐⭐⭐☆ (Advanced)
**Prerequisites**: Lab 08 (Introduction to PL/pgSQL)
