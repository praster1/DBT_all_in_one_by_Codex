-- retail day2 apply for clickhouse

TRUNCATE TABLE raw_retail.orders;

INSERT INTO raw_retail.orders (order_id, customer_id, order_date, status, total_amount, updated_at) VALUES
(5001, 101, toDate('2026-04-01'), 'DELIVERED', 42.0, toDateTime('2026-04-04 09:15:00')),
(5002, 102, toDate('2026-04-01'), 'SHIPPED', 15.0, toDateTime('2026-04-01 12:30:00')),
(5003, 103, toDate('2026-04-02'), 'SHIPPED', 29.0, toDateTime('2026-04-04 08:45:00')),
(5004, 101, toDate('2026-04-03'), 'DELIVERED', 12.0, toDateTime('2026-04-03 16:10:00'));
