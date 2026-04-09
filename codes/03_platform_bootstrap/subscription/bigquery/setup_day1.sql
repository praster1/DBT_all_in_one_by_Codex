-- subscription day1 bootstrap for bigquery

CREATE SCHEMA IF NOT EXISTS `raw_billing`;

CREATE OR REPLACE TABLE `raw_billing.accounts` (
  account_id INT64,
  account_name STRING,
  signup_date DATE,
  segment STRING
);

INSERT INTO `raw_billing.accounts` (account_id, account_name, signup_date, segment) VALUES
(7001, 'Northwind Coffee', DATE '2025-12-01', 'mid_market'),
(7002, 'Pixel Mart', DATE '2026-01-15', 'smb'),
(7003, 'Orbit Labs', DATE '2026-02-10', 'enterprise');

CREATE OR REPLACE TABLE `raw_billing.plans` (
  plan_id STRING,
  plan_name STRING,
  monthly_amount NUMERIC
);

INSERT INTO `raw_billing.plans` (plan_id, plan_name, monthly_amount) VALUES
('starter', 'Starter', 49),
('growth', 'Growth', 199),
('enterprise', 'Enterprise', 799);

CREATE OR REPLACE TABLE `raw_billing.invoices` (
  invoice_id STRING,
  subscription_id STRING,
  invoice_date DATE,
  amount NUMERIC
);

INSERT INTO `raw_billing.invoices` (invoice_id, subscription_id, invoice_date, amount) VALUES
('inv_1', 'sub_1', DATE '2026-04-01', 49),
('inv_2', 'sub_2', DATE '2026-04-01', 199),
('inv_3', 'sub_3', DATE '2026-04-01', 0);

CREATE OR REPLACE TABLE `raw_billing.subscriptions` (
  subscription_id STRING,
  account_id INT64,
  plan_id STRING,
  status STRING,
  started_at DATE,
  cancelled_at DATE,
  monthly_amount NUMERIC,
  updated_at TIMESTAMP
);

INSERT INTO `raw_billing.subscriptions` (subscription_id, account_id, plan_id, status, started_at, cancelled_at, monthly_amount, updated_at) VALUES
('sub_1', 7001, 'starter', 'active', DATE '2026-01-01', NULL, 49, TIMESTAMP '2026-04-01 00:00:00'),
('sub_2', 7002, 'growth', 'active', DATE '2026-02-01', NULL, 199, TIMESTAMP '2026-04-01 00:00:00'),
('sub_3', 7003, 'enterprise', 'trialing', DATE '2026-03-20', NULL, 799, TIMESTAMP '2026-04-01 00:00:00');
