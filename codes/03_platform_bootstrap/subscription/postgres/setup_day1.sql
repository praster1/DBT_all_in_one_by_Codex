-- subscription day1 bootstrap for postgres

CREATE SCHEMA IF NOT EXISTS raw_billing;

DROP TABLE IF EXISTS raw_billing.accounts;
CREATE TABLE raw_billing.accounts (
  account_id INTEGER,
  account_name TEXT,
  signup_date DATE,
  segment TEXT
);

INSERT INTO raw_billing.accounts (account_id, account_name, signup_date, segment) VALUES
(7001, 'Northwind Coffee', '2025-12-01', 'mid_market'),
(7002, 'Pixel Mart', '2026-01-15', 'smb'),
(7003, 'Orbit Labs', '2026-02-10', 'enterprise');

DROP TABLE IF EXISTS raw_billing.plans;
CREATE TABLE raw_billing.plans (
  plan_id TEXT,
  plan_name TEXT,
  monthly_amount NUMERIC(18,2)
);

INSERT INTO raw_billing.plans (plan_id, plan_name, monthly_amount) VALUES
('starter', 'Starter', 49),
('growth', 'Growth', 199),
('enterprise', 'Enterprise', 799);

DROP TABLE IF EXISTS raw_billing.invoices;
CREATE TABLE raw_billing.invoices (
  invoice_id TEXT,
  subscription_id TEXT,
  invoice_date DATE,
  amount NUMERIC(18,2)
);

INSERT INTO raw_billing.invoices (invoice_id, subscription_id, invoice_date, amount) VALUES
('inv_1', 'sub_1', '2026-04-01', 49),
('inv_2', 'sub_2', '2026-04-01', 199),
('inv_3', 'sub_3', '2026-04-01', 0);

DROP TABLE IF EXISTS raw_billing.subscriptions;
CREATE TABLE raw_billing.subscriptions (
  subscription_id TEXT,
  account_id INTEGER,
  plan_id TEXT,
  status TEXT,
  started_at DATE,
  cancelled_at DATE,
  monthly_amount NUMERIC(18,2),
  updated_at TIMESTAMP
);

INSERT INTO raw_billing.subscriptions (subscription_id, account_id, plan_id, status, started_at, cancelled_at, monthly_amount, updated_at) VALUES
('sub_1', 7001, 'starter', 'active', '2026-01-01', NULL, 49, '2026-04-01 00:00:00'),
('sub_2', 7002, 'growth', 'active', '2026-02-01', NULL, 199, '2026-04-01 00:00:00'),
('sub_3', 7003, 'enterprise', 'trialing', '2026-03-20', NULL, 799, '2026-04-01 00:00:00');
