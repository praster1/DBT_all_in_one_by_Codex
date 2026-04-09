-- subscription day1 bootstrap for clickhouse

CREATE DATABASE IF NOT EXISTS raw_billing;

DROP TABLE IF EXISTS raw_billing.accounts;
CREATE TABLE raw_billing.accounts (
  account_id Int32,
  account_name String,
  signup_date Date,
  segment String
)
ENGINE = MergeTree
ORDER BY (account_id);

INSERT INTO raw_billing.accounts (account_id, account_name, signup_date, segment) VALUES
(7001, 'Northwind Coffee', toDate('2025-12-01'), 'mid_market'),
(7002, 'Pixel Mart', toDate('2026-01-15'), 'smb'),
(7003, 'Orbit Labs', toDate('2026-02-10'), 'enterprise');

DROP TABLE IF EXISTS raw_billing.plans;
CREATE TABLE raw_billing.plans (
  plan_id String,
  plan_name String,
  monthly_amount Decimal(18,2)
)
ENGINE = MergeTree
ORDER BY (plan_id);

INSERT INTO raw_billing.plans (plan_id, plan_name, monthly_amount) VALUES
('starter', 'Starter', 49),
('growth', 'Growth', 199),
('enterprise', 'Enterprise', 799);

DROP TABLE IF EXISTS raw_billing.invoices;
CREATE TABLE raw_billing.invoices (
  invoice_id String,
  subscription_id String,
  invoice_date Date,
  amount Decimal(18,2)
)
ENGINE = MergeTree
ORDER BY (invoice_id);

INSERT INTO raw_billing.invoices (invoice_id, subscription_id, invoice_date, amount) VALUES
('inv_1', 'sub_1', toDate('2026-04-01'), 49),
('inv_2', 'sub_2', toDate('2026-04-01'), 199),
('inv_3', 'sub_3', toDate('2026-04-01'), 0);

DROP TABLE IF EXISTS raw_billing.subscriptions;
CREATE TABLE raw_billing.subscriptions (
  subscription_id String,
  account_id Int32,
  plan_id String,
  status String,
  started_at Date,
  cancelled_at Date,
  monthly_amount Decimal(18,2),
  updated_at DateTime
)
ENGINE = MergeTree
ORDER BY (subscription_id);

INSERT INTO raw_billing.subscriptions (subscription_id, account_id, plan_id, status, started_at, cancelled_at, monthly_amount, updated_at) VALUES
('sub_1', 7001, 'starter', 'active', toDate('2026-01-01'), NULL, 49, toDateTime('2026-04-01 00:00:00')),
('sub_2', 7002, 'growth', 'active', toDate('2026-02-01'), NULL, 199, toDateTime('2026-04-01 00:00:00')),
('sub_3', 7003, 'enterprise', 'trialing', toDate('2026-03-20'), NULL, 799, toDateTime('2026-04-01 00:00:00'));
