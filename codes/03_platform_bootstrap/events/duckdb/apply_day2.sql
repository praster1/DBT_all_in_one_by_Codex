-- events day2 apply for duckdb

TRUNCATE TABLE raw_events.events;

INSERT INTO raw_events.events (event_id, user_id, event_at, event_name, platform, session_id) VALUES
('e1', 9001, '2026-04-01 09:00:00', 'page_view', 'web', 's1'),
('e2', 9001, '2026-04-01 09:04:00', 'add_to_cart', 'web', 's1'),
('e3', 9002, '2026-04-01 10:05:00', 'page_view', 'ios', 's2'),
('e4', 9003, '2026-04-02 11:35:00', 'page_view', 'web', 's3'),
('e5', 9001, '2026-04-03 07:10:00', 'purchase', 'web', 's4'),
('e6', 9002, '2026-04-03 11:20:00', 'page_view', 'ios', 's5');
