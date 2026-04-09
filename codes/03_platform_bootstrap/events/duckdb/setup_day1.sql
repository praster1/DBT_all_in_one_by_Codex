-- events day1 bootstrap for duckdb

CREATE SCHEMA IF NOT EXISTS raw_events;

DROP TABLE IF EXISTS raw_events.users;
CREATE TABLE raw_events.users (
  user_id INTEGER,
  signup_at TIMESTAMP,
  country_code VARCHAR
);

INSERT INTO raw_events.users (user_id, signup_at, country_code) VALUES
(9001, '2026-04-01 08:00:00', 'KR'),
(9002, '2026-04-01 10:00:00', 'KR'),
(9003, '2026-04-02 11:30:00', 'US');

DROP TABLE IF EXISTS raw_events.events;
CREATE TABLE raw_events.events (
  event_id VARCHAR,
  user_id INTEGER,
  event_at TIMESTAMP,
  event_name VARCHAR,
  platform VARCHAR,
  session_id VARCHAR
);

INSERT INTO raw_events.events (event_id, user_id, event_at, event_name, platform, session_id) VALUES
('e1', 9001, '2026-04-01 09:00:00', 'page_view', 'web', 's1'),
('e2', 9001, '2026-04-01 09:04:00', 'add_to_cart', 'web', 's1'),
('e3', 9002, '2026-04-01 10:05:00', 'page_view', 'ios', 's2'),
('e4', 9003, '2026-04-02 11:35:00', 'page_view', 'web', 's3');
