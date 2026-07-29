CREATE TRIGGER audit_customer_email
    AFTER UPDATE OF email ON customer  -- Only fires when email changes
    FOR EACH ROW
    EXECUTE FUNCTION log_email_change();



-- old email mary-jho@example.com

UPDATE customer SET email = 'lotfi@example.com' WHERE customer_id = 1;

SELECT * FROM customer_audit_log  WHERE customer_id = 1;

select  * from customer WHERE customer_id = 1;
