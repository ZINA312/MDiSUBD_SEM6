DROP TABLE orders;
DROP TABLE customers;
DROP TABLE sellers;

DROP TABLE orders_history;
DROP TABLE customers_history;
DROP TABLE sellers_history;

CREATE TABLE customers
(
    customer_id  NUMBER(10)
        CONSTRAINT PK_customers PRIMARY KEY,
    first_name   VARCHAR2(50),
    last_name    VARCHAR2(50),
    email        VARCHAR2(100) UNIQUE,
    phone_number VARCHAR2(50)
);

CREATE TABLE sellers
(
    seller_id   NUMBER(10)
        CONSTRAINT PK_sellers PRIMARY KEY,
    seller_name VARCHAR2(100),
    products_sold VARCHAR2(500),
    age         NUMBER
);

CREATE TABLE orders
(
    order_id    NUMBER(10)
        CONSTRAINT PK_orders PRIMARY KEY,
    order_date  DATE,
    customer_id NUMBER(10),
    seller_id   NUMBER(10),
    total_amount NUMBER(10),
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
    CONSTRAINT fk_seller FOREIGN KEY (seller_id) REFERENCES sellers (seller_id)
);

CREATE TABLE customers_history
(
    action_id    NUMBER,
    customer_id  NUMBER(10),
    first_name   VARCHAR2(50),
    last_name    VARCHAR2(50),
    email        VARCHAR2(100),
    phone_number VARCHAR2(50),
    change_date  DATE,
    change_type  VARCHAR2(10)
);

CREATE TABLE sellers_history
(
    action_id     NUMBER,
    seller_id     NUMBER(10),
    seller_name   VARCHAR2(100),
    products_sold VARCHAR2(500),
    age           NUMBER,
    change_date   DATE,
    change_type   VARCHAR2(10)
);

CREATE TABLE orders_history
(
    action_id    NUMBER,
    order_id     NUMBER(10),
    order_date   DATE,
    customer_id  NUMBER(10),
    seller_id    NUMBER(10),
    total_amount NUMBER(10),
    change_date  DATE,
    change_type  VARCHAR2(10)
);

CREATE TABLE reports_history
(
    id          NUMBER GENERATED ALWAYS AS IDENTITY,
    report_date TIMESTAMP,
    CONSTRAINT PK_reports PRIMARY KEY (id)
);

CREATE SEQUENCE history_seq START WITH 1;