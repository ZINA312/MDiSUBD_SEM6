-- Триггеры для таблицы customers
CREATE OR REPLACE TRIGGER tr_customers_insert
    AFTER INSERT ON customers
    FOR EACH ROW
BEGIN
    INSERT INTO customers_history (action_id, customer_id, first_name, last_name, email, phone_number, change_date, change_type)
    VALUES (history_seq.nextval, :NEW.customer_id, :NEW.first_name, :NEW.last_name, :NEW.email, :NEW.phone_number, SYSDATE, 'INSERT');
END;
/
CREATE OR REPLACE TRIGGER tr_customers_update
    AFTER UPDATE ON customers
    FOR EACH ROW
DECLARE
    v_id NUMBER;
BEGIN
    v_id := history_seq.nextval;
    
    INSERT INTO customers_history (action_id, customer_id, first_name, last_name, email, phone_number, change_date, change_type)
    VALUES (v_id, :OLD.customer_id, :OLD.first_name, :OLD.last_name, :OLD.email, :OLD.phone_number, SYSDATE, 'DELETE');

    INSERT INTO customers_history (action_id, customer_id, first_name, last_name, email, phone_number, change_date, change_type)
    VALUES (v_id, :OLD.customer_id, :OLD.first_name, :OLD.last_name, :OLD.email, :OLD.phone_number, SYSDATE, 'UPDATE');

    INSERT INTO customers_history (action_id, customer_id, first_name, last_name, email, phone_number, change_date, change_type)
    VALUES (v_id, :NEW.customer_id, :NEW.first_name, :NEW.last_name, :NEW.email, :NEW.phone_number, SYSDATE, 'INSERT');
END;
/
CREATE OR REPLACE TRIGGER tr_customers_delete
    AFTER DELETE ON customers
    FOR EACH ROW
BEGIN
    INSERT INTO customers_history (action_id, customer_id, first_name, last_name, email, phone_number, change_date, change_type)
    VALUES (history_seq.nextval, :OLD.customer_id, :OLD.first_name, :OLD.last_name, :OLD.email, :OLD.phone_number, SYSDATE, 'DELETE');
END;
/
-- Триггеры для таблицы sellers
CREATE OR REPLACE TRIGGER tr_sellers_insert
    AFTER INSERT ON sellers
    FOR EACH ROW
BEGIN
    INSERT INTO sellers_history (action_id, seller_id, seller_name, products_sold, age, change_date, change_type)
    VALUES (history_seq.nextval, :NEW.seller_id, :NEW.seller_name, :NEW.products_sold, :NEW.age, SYSDATE, 'INSERT');
END;
/
CREATE OR REPLACE TRIGGER tr_sellers_update
    AFTER UPDATE ON sellers
    FOR EACH ROW
DECLARE
    v_id NUMBER;
BEGIN
    v_id := history_seq.nextval;
    
    INSERT INTO sellers_history (action_id, seller_id, seller_name, products_sold, age, change_date, change_type)
    VALUES (v_id, :OLD.seller_id, :OLD.seller_name, :OLD.products_sold, :OLD.age, SYSDATE, 'DELETE');

    INSERT INTO sellers_history (action_id, seller_id, seller_name, products_sold, age, change_date, change_type)
    VALUES (v_id, :OLD.seller_id, :OLD.seller_name, :OLD.products_sold, :OLD.age, SYSDATE, 'UPDATE');

    INSERT INTO sellers_history (action_id, seller_id, seller_name, products_sold, age, change_date, change_type)
    VALUES (v_id, :NEW.seller_id, :NEW.seller_name, :NEW.products_sold, :NEW.age, SYSDATE, 'INSERT');
END;
/
CREATE OR REPLACE TRIGGER tr_sellers_delete
    AFTER DELETE ON sellers
    FOR EACH ROW
BEGIN
    INSERT INTO sellers_history (action_id, seller_id, seller_name, products_sold, age, change_date, change_type)
    VALUES (history_seq.nextval, :OLD.seller_id, :OLD.seller_name, :OLD.products_sold, :OLD.age, SYSDATE, 'DELETE');
END;
/
-- Триггеры для таблицы orders
CREATE OR REPLACE TRIGGER tr_orders_insert
    AFTER INSERT ON orders
    FOR EACH ROW
BEGIN
    INSERT INTO orders_history (action_id, order_id, order_date, customer_id, seller_id, total_amount, change_date, change_type)
    VALUES (history_seq.NEXTVAL, :NEW.order_id, :NEW.order_date, :NEW.customer_id, :NEW.seller_id, :NEW.total_amount, SYSDATE, 'INSERT');
END;
/
CREATE OR REPLACE TRIGGER tr_orders_update
    AFTER UPDATE ON orders
    FOR EACH ROW
DECLARE
    v_id NUMBER;
BEGIN
    v_id := history_seq.nextval;
    
    INSERT INTO orders_history (action_id, order_id, order_date, customer_id, seller_id, total_amount, change_date, change_type)
    VALUES (v_id, :OLD.order_id, :OLD.order_date, :OLD.customer_id, :OLD.seller_id, :OLD.total_amount, SYSDATE, 'DELETE');

    INSERT INTO orders_history (action_id, order_id, order_date, customer_id, seller_id, total_amount, change_date, change_type)
    VALUES (v_id, :OLD.order_id, :OLD.order_date, :OLD.customer_id, :OLD.seller_id, :OLD.total_amount, SYSDATE, 'UPDATE');

    INSERT INTO orders_history (action_id, order_id, order_date, customer_id, seller_id, total_amount, change_date, change_type)
    VALUES (v_id, :NEW.order_id, :NEW.order_date, :NEW.customer_id, :NEW.seller_id, :NEW.total_amount, SYSDATE, 'INSERT');
END;
/
CREATE OR REPLACE TRIGGER tr_orders_delete
    AFTER DELETE ON orders
    FOR EACH ROW
BEGIN
    INSERT INTO orders_history (action_id, order_id, order_date, customer_id, seller_id, total_amount, change_date, change_type)
    VALUES (history_seq.NEXTVAL, :OLD.order_id, :OLD.order_date, :OLD.customer_id, :OLD.seller_id, :OLD.total_amount, SYSDATE, 'DELETE');
END;