{{ config(
    materialized='table',
    engine='MergeTree()',
    order_by='(event_date, event_type)'
) }}

select
    toDate(now()) as event_date,
    '' as event_type,
    toUInt64(0) as total_events
where 0
