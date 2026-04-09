-- subscription day1 bootstrap for trino

CREATE SCHEMA IF NOT EXISTS memory.raw_billing;

DROP TABLE IF EXISTS memory.raw_billing.accounts;
CREATE TABLE memory.raw_billing.accounts (
  account_id INTEGER,
  account_name VARCHAR,
  signup_date DATE,
  segment VARCHAR
);

INSERT INTO memory.raw_billing.accounts (account_id, account_name, signup_date, segment) VALUES
(7001, 'Northwind Coffee', '2025-12-01', 'mid_market'),
(7002, 'Pixel Mart', '2026-01-15', 'smb'),
(7003, 'Orbit Labs', '2026-02-10', 'enterprise');

DROP TABLE IF EXISTS memory.raw_billing.plans;
CREATE TABLE memory.raw_billing.plans (
  plan_id VARCHAR,
  plan_name VARCHAR,
  monthly_amount DECIMAL(18,2)
);

INSERT INTO memory.raw_billing.plans (plan_id, plan_name, monthly_amount) VALUES
('starter', 'Starter', 49),
('growth', 'Growth', 199),
('enterprise', 'Enterprise', 799);

DROP TABLE IF EXISTS memory.raw_billing.invoices;
CREATE TABLE memory.raw_billing.invoices (
  invoice_id VARCHAR,
  subscription_id VARCHAR,
  invoice_date DATE,
  amount DECIMAL(18,2)
);

INSERT INTO memory.raw_billing.invoices (invoice_id, subscription_id, invoice_date, amount) VALUES
('inv_1', 'sub_1', '2026-04-01', 49),
('inv_2', 'sub_2', '2026-04-01', 199),
('inv_3', 'sub_3', '2026-04-01', 0);

DROP TABLE IF EXISTS memory.raw_billing.subscriptions;
CREATE TABLE memory.raw_billing.subscriptions (
  subscription_id VARCHAR,
  account_id INTEGER,
  plan_id VARCHAR,
  status VARCHAR,
  started_at DATE,
  cancelled_at DATE,
  monthly_amount DECIMAL(18,2),
  updated_at TIMESTAMP
);

INSERT INTO memory.raw_billing.subscriptions (subscription_id, account_id, plan_id, status, started_at, cancelled_at, monthly_amount, updated_at) VALUES
('sub_1', 7001, 'starter', 'active', '2026-01-01', NULL, 49, '2026-04-01 00:00:00'),
('sub_2', 7002, 'growth', 'active', '2026-02-01', NULL, 199, '2026-04-01 00:00:00'),
('sub_3', 7003, 'enterprise', 'trialing', '2026-03-20', NULL, 799, '2026-04-01 00:00:00');
