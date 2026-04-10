insert into raw_events.users values
    (9004, '2026-04-03 09:20:00', 'JP');

insert into raw_events.events values
    ('e1008', 9001, '2026-04-03 09:00:00', '2026-04-03 09:00:20', 'page_view', 'web',     's04'),
    ('e1009', 9004, '2026-04-03 09:30:00', '2026-04-03 09:30:15', 'signup',    'android', 's05'),
    -- late-arriving event: 실제 발생은 4월 1일, 적재는 4월 3일
    ('e1010', 9003, '2026-04-01 23:50:00', '2026-04-03 09:40:00', 'page_view', 'web',     's06');
