-- DuckDB shell example
create schema if not exists raw_retail;
create or replace table raw_retail.customers as
select * from read_csv_auto('../raw_csv/retail_customers.csv');

create or replace table raw_retail.orders as
select * from read_csv_auto('../raw_csv/retail_orders_day1.csv');

create schema if not exists raw_events;
create or replace table raw_events.events as
select * from read_csv_auto('../raw_csv/events_day1.csv');

create schema if not exists raw_billing;
create or replace table raw_billing.subscriptions as
select * from read_csv_auto('../raw_csv/subscriptions_day1.csv');
