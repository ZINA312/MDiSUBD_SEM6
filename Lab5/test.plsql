-- Очистка данных
DELETE FROM orders;
DELETE FROM customers;
DELETE FROM sellers;

DELETE FROM customers_history;
DELETE FROM sellers_history;
DELETE FROM orders_history;
DELETE FROM reports_history;

-- Вставка тестовых данных
INSERT INTO customers (customer_id, first_name, last_name, email, phone_number)
VALUES (3, 'ferfr', 'gre', 'john.doe@examplegre.com', '+124334567890');

INSERT INTO customers (customer_id, first_name, last_name, email, phone_number)
VALUES (2, 'Jane', 'Smith', 'jane.smith@example.com', '+1987654321');

-- Обновление данных покупателя
UPDATE customers
SET phone_number = '+11122233344'
WHERE customer_id = 2;

-- Вставка продавцов
INSERT INTO sellers (seller_id, seller_name, products_sold, age)
VALUES (1, 'TechStore', 'Electronics, Gadgets', 5);

INSERT INTO sellers (seller_id, seller_name, products_sold, age)
VALUES (2, 'FashionHub', 'Clothing, Accessories', 3);

-- Вставка заказов
INSERT INTO orders (order_id, order_date, customer_id, seller_id, total_amount)
VALUES (1, TO_DATE('2023-01-15', 'YYYY-MM-DD'), 1, 1, 599.99);

INSERT INTO orders (order_id, order_date, customer_id, seller_id, total_amount)
VALUES (2, TO_DATE('2023-02-20', 'YYYY-MM-DD'), 2, 2, 299.95);

-- Удаление заказа
DELETE FROM orders
WHERE order_id = 2;

-- Проверка данных
SELECT * FROM customers;
SELECT * FROM customers_history;

SELECT * FROM sellers;
SELECT * FROM sellers_history;

SELECT * FROM orders;
SELECT * FROM orders_history;

SELECT * FROM reports_history;

-- Вызовы процедур
CALL rollback_by_date(to_timestamp('2025-03-14 19:35:00', 'YYYY-MM-DD HH24:MI:SS'));
CALL rollback_by_date(to_timestamp('2025-03-13 12:30:00', 'YYYY-MM-DD HH24:MI:SS'));
CALL FUNC_PACKAGE.ROLL_BACK(50000); 
CALL FUNC_PACKAGE.ROLL_BACK(to_timestamp('2025-03-13 15:00:00', 'YYYY-MM-DD HH24:MI:SS'));
CALL FUNC_PACKAGE.REPORT();
CALL FUNC_PACKAGE.REPORT(
    to_timestamp('2025-03-13', 'YYYY-MM-DD HH24:MI:SS'),
    to_timestamp('2025-03-14 19:39:59', 'YYYY-MM-DD HH24:MI:SS')
);