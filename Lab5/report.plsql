CREATE OR REPLACE PROCEDURE rollback_by_date(date_time IN TIMESTAMP) AS
BEGIN
    disable_all_constraints('ORDERS');
    disable_all_constraints('CUSTOMERS');
    disable_all_constraints('SELLERS');

    DELETE FROM orders;
    DELETE FROM customers;
    DELETE FROM sellers;

    FOR i IN (SELECT * FROM customers_history WHERE CHANGE_DATE <= date_time ORDER BY ACTION_ID) LOOP
        IF i.CHANGE_TYPE = 'INSERT' THEN
            INSERT INTO customers VALUES (i.customer_id, i.first_name, i.last_name, i.email, i.phone_number);
        ELSIF i.CHANGE_TYPE = 'DELETE' THEN
            DELETE FROM customers WHERE customer_id = i.customer_id;
        END IF;
    END LOOP;

    FOR i IN (SELECT * FROM sellers_history WHERE CHANGE_DATE <= date_time ORDER BY ACTION_ID) LOOP
        IF i.CHANGE_TYPE = 'INSERT' THEN
            INSERT INTO sellers VALUES (i.seller_id, i.seller_name, i.products_sold, i.age);
        ELSIF i.CHANGE_TYPE = 'DELETE' THEN
            DELETE FROM sellers WHERE seller_id = i.seller_id;
        END IF;
    END LOOP;

    FOR i IN (SELECT * FROM orders_history WHERE CHANGE_DATE <= date_time ORDER BY ACTION_ID) LOOP
        IF i.CHANGE_TYPE = 'INSERT' THEN
            INSERT INTO orders VALUES (i.order_id, i.order_date, i.customer_id, i.seller_id, i.total_amount);
        ELSIF i.CHANGE_TYPE = 'DELETE' THEN
            DELETE FROM orders WHERE order_id = i.order_id;
        END IF;
    END LOOP;

    DELETE FROM customers_history WHERE CHANGE_DATE > date_time;
    DELETE FROM sellers_history WHERE CHANGE_DATE > date_time;
    DELETE FROM orders_history WHERE CHANGE_DATE > date_time;

    enable_all_constraints('CUSTOMERS');
    enable_all_constraints('SELLERS');
    enable_all_constraints('ORDERS');
END;
/
CREATE OR REPLACE PROCEDURE disable_all_constraints(p_table_name IN VARCHAR2) IS
BEGIN
    FOR c IN (SELECT constraint_name 
              FROM user_constraints 
              WHERE table_name = p_table_name)
    LOOP
        EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table_name || ' DISABLE CONSTRAINT ' || c.constraint_name;
    END LOOP;
    EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table_name || ' DISABLE ALL TRIGGERS';
END;
/
CREATE OR REPLACE PROCEDURE enable_all_constraints(p_table_name IN VARCHAR2) IS
BEGIN
    FOR c IN (SELECT constraint_name 
              FROM user_constraints 
              WHERE table_name = p_table_name)
    LOOP
        EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table_name || ' ENABLE CONSTRAINT ' || c.constraint_name;
    END LOOP;
    EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table_name || ' ENABLE ALL TRIGGERS';
END;
/
CREATE OR REPLACE PROCEDURE create_report(t_begin IN TIMESTAMP, t_end IN TIMESTAMP)
AS
    v_result VARCHAR2(4000);
    i_count  NUMBER;
    u_count  NUMBER;
    d_count  NUMBER;
    my_file  UTL_FILE.FILE_TYPE;
BEGIN
    v_result := '<!DOCTYPE html>
    <html>
    <head>
        <title>Sales Database Report</title>
    </head>
    <body>';

    -- Customers Section
    SELECT COUNT(*) INTO u_count FROM customers_history 
    WHERE change_date BETWEEN t_begin AND t_end AND change_type = 'UPDATE';
    
    SELECT COUNT(*) INTO i_count FROM customers_history 
    WHERE change_date BETWEEN t_begin AND t_end AND change_type = 'INSERT';
    
    SELECT COUNT(*) INTO d_count FROM customers_history 
    WHERE change_date BETWEEN t_begin AND t_end AND change_type = 'DELETE';
    
    v_result := v_result || '<h1>Customers</h1>
        <h2>New customers: ' || (i_count - u_count) || '</h2>
        <h2>Updated profiles: ' || u_count || '</h2>
        <h2>Deleted accounts: ' || (d_count - u_count) || '</h2>';

    -- Sellers Section
    SELECT COUNT(*) INTO u_count FROM sellers_history 
    WHERE change_date BETWEEN t_begin AND t_end AND change_type = 'UPDATE';
    
    SELECT COUNT(*) INTO i_count FROM sellers_history 
    WHERE change_date BETWEEN t_begin AND t_end AND change_type = 'INSERT';
    
    SELECT COUNT(*) INTO d_count FROM sellers_history 
    WHERE change_date BETWEEN t_begin AND t_end AND change_type = 'DELETE';
    
    v_result := v_result || '<h1>Sellers</h1>
        <h2>New sellers: ' || (i_count - u_count) || '</h2>
        <h2>Updated sellers: ' || u_count || '</h2>
        <h2>Removed sellers: ' || (d_count - u_count) || '</h2>';

    -- Orders Section
    SELECT COUNT(*) INTO u_count FROM orders_history 
    WHERE change_date BETWEEN t_begin AND t_end AND change_type = 'UPDATE';
    
    SELECT COUNT(*) INTO i_count FROM orders_history 
    WHERE change_date BETWEEN t_begin AND t_end AND change_type = 'INSERT';
    
    SELECT COUNT(*) INTO d_count FROM orders_history 
    WHERE change_date BETWEEN t_begin AND t_end AND change_type = 'DELETE';
    
    v_result := v_result || '<h1>Orders</h1>
        <h2>New orders: ' || (i_count - u_count) || '</h2>
        <h2>Modified orders: ' || u_count || '</h2>
        <h2>Cancelled orders: ' || (d_count - u_count) || '</h2>
    </body></html>';

    DBMS_OUTPUT.PUT_LINE('Текущее имя: ' || v_result);
END;
/