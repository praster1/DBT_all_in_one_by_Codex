-- events day1 bootstrap for bigquery

CREATE SCHEMA IF NOT EXISTS `raw_events`;

CREATE OR REPLACE TABLE `raw_events.users` (
  user_id INT64,
  signup_at TIMESTAMP,
  country_code STRING
);

INSERT INTO `raw_events.users` (user_id, signup_at, country_code) VALUES
(9001, TIMESTAMP '2026-04-01 08:00:00', 'KR'),
(9002, TIMESTAMP '2026-04-01 10:00:00', 'KR'),
(9003, TIMESTAMP '2026-04-02 11:30:00', 'US');

CREATE OR REPLACE TABLE `raw_events.events` (
  event_id STRING,
  user_id INT64,
  event_at TIMESTAMP,
  event_name STRING,
  platform STRING,
  session_id STRING
);

INSERT INTO `raw_events.events` (event_id, user_id, event_at, event_name, platform, session_id) VALUES
('e1', 9001, TIMESTAMP '2026-04-01 09:00:00', 'page_view', 'web', 's1'),
('e2', 9001, TIMESTAMP '2026-04-01 09:04:00', 'add_to_cart', 'web', 's1'),
('e3', 9002, TIMESTAMP '2026-04-01 10:05:00', 'page_view', 'ios', 's2'),
('e4', 9003, TIMESTAMP '2026-04-02 11:35:00', 'page_view', 'web', 's3');
