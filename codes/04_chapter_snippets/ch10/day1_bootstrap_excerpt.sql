create schema if not exists raw_events;

create or replace table raw_events.users (
    user_id integer,
    signup_at timestamp,
    country_code varchar
);

insert into raw_events.users values
    (9001, '2026-04-01 08:00:00', 'KR'),
    (9002, '2026-04-01 10:00:00', 'KR'),
    (9003, '2026-04-02 11:30:00', 'US');

create or replace table raw_events.events (
    event_id varchar,
    user_id integer,
    event_at timestamp,
    event_ingested_at timestamp,
    event_name varchar,
    platform varchar,
    session_id varchar
);

insert into raw_events.events values
    ('e1001', 9001, '2026-04-01 08:05:00', '2026-04-01 08:05:10', 'page_view', 'web',     's01'),
    ('e1002', 9001, '2026-04-01 08:07:00', '2026-04-01 08:07:20', 'add_to_cart', 'web',   's01'),
    ('e1003', 9001, '2026-04-01 08:10:00', '2026-04-01 08:10:10', 'checkout', 'web',      's01'),
    ('e1004', 9002, '2026-04-01 10:10:00', '2026-04-01 10:10:40', 'page_view', 'ios',     's02'),
    ('e1005', 9002, '2026-04-01 10:12:00', '2026-04-01 10:12:05', 'purchase', 'ios',      's02'),
    ('e1006', 9003, '2026-04-02 11:40:00', '2026-04-02 11:40:10', 'page_view', 'web',     's03'),
    ('e1007', 9003, '2026-04-02 11:45:00', '2026-04-02 11:45:15', 'page_view', 'web',     's03');
