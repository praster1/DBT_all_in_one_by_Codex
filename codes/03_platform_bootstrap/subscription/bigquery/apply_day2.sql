-- subscription day2 apply for bigquery

DELETE FROM `raw_billing.subscriptions` WHERE TRUE;

INSERT INTO `raw_billing.subscriptions` (subscription_id, account_id, plan_id, status, started_at, cancelled_at, monthly_amount, updated_at) VALUES
('sub_1', 7001, 'growth', 'active', DATE '2026-01-01', NULL, 199, TIMESTAMP '2026-04-05 00:00:00'),
('sub_2', 7002, 'growth', 'cancelled', DATE '2026-02-01', DATE '2026-04-05', 199, TIMESTAMP '2026-04-05 00:00:00'),
('sub_3', 7003, 'enterprise', 'active', DATE '2026-03-20', NULL, 799, TIMESTAMP '2026-04-05 00:00:00');
