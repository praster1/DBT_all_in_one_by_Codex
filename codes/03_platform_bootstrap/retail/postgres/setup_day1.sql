-- retail day1 bootstrap for postgres

CREATE SCHEMA IF NOT EXISTS raw_retail;

DROP TABLE IF EXISTS raw_retail.customers;
CREATE TABLE raw_retail.customers (
  customer_id INTEGER,
  first_name TEXT,
  last_name TEXT,
  customer_segment TEXT,
  signup_date DATE,
  country_code TEXT
);

INSERT INTO raw_retail.customers (customer_id, first_name, last_name, customer_segment, signup_date, country_code) VALUES
(101, 'Mina', 'Kim', 'vip', '2025-11-03', 'KR'),
(102, 'Jin', 'Park', 'regular', '2026-01-05', 'KR'),
(103, 'Alex', 'Cho', 'regular', '2026-01-18', 'US');

DROP TABLE IF EXISTS raw_retail.products;
CREATE TABLE raw_retail.products (
  product_id INTEGER,
  product_name TEXT,
  category_name TEXT
);

INSERT INTO raw_retail.products (product_id, product_name, category_name) VALUES
(1001, 'Espresso Beans', 'coffee'),
(1002, 'Cold Brew Bottle', 'beverage'),
(1003, 'Ceramic Mug', 'goods');

DROP TABLE IF EXISTS raw_retail.order_items;
CREATE TABLE raw_retail.order_items (
  order_item_id INTEGER,
  order_id INTEGER,
  product_id INTEGER,
  quantity INTEGER,
  unit_price NUMERIC(18,2)
);

INSERT INTO raw_retail.order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES
(1, 5001, 1001, 1, 18.0),
(2, 5001, 1003, 2, 12.0),
(3, 5002, 1002, 3, 5.0),
(4, 5003, 1001, 1, 18.0),
(5, 5003, 1002, 2, 5.5),
(6, 5004, 1003, 1, 12.0);

DROP TABLE IF EXISTS raw_retail.orders;
CREATE TABLE raw_retail.orders (
  order_id INTEGER,
  customer_id INTEGER,
  order_date DATE,
  status TEXT,
  total_amount NUMERIC(18,2),
  updated_at TIMESTAMP
);

INSERT INTO raw_retail.orders (order_id, customer_id, order_date, status, total_amount, updated_at) VALUES
(5001, 101, '2026-04-01', 'PLACED', 42.0, '2026-04-01 09:15:00'),
(5002, 102, '2026-04-01', 'SHIPPED', 15.0, '2026-04-01 12:30:00'),
(5003, 103, '2026-04-02', 'PLACED', 29.0, '2026-04-02 08:45:00'),
(5004, 101, '2026-04-03', 'DELIVERED', 12.0, '2026-04-03 16:10:00');
