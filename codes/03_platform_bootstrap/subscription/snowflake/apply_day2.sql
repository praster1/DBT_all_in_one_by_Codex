-- subscription day2 apply for snowflake

TRUNCATE TABLE raw_billing.subscriptions;

INSERT INTO raw_billing.subscriptions (subscription_id, account_id, plan_id, status, started_at, cancelled_at, monthly_amount, updated_at) VALUES
('sub_1', 7001, 'growth', 'active', '2026-01-01', NULL, 199, '2026-04-05 00:00:00'),
('sub_2', 7002, 'growth', 'cancelled', '2026-02-01', '2026-04-05', 199, '2026-04-05 00:00:00'),
('sub_3', 7003, 'enterprise', 'active', '2026-03-20', NULL, 799, '2026-04-05 00:00:00');
