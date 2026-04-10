{{ config(
    materialized='incremental',
    incremental_strategy='microbatch',
    event_time='event_time',
    begin='2026-01-01 00:00:00',
    batch_size='day',
    lookback=2,
    full_refresh=false,
    engine='MergeTree()',
    order_by='(event_date, session_id)',
    partition_by='toYYYYMM(event_date)'
) }}

with events as (
    select
        event_id,
        user_id,
        session_id,
        event_type,
        event_time,
        toDate(event_time) as event_date
    from {{ ref('stg_events') }}
),
sessionized as (
    select
        session_id,
        user_id,
        min(event_time) as session_start,
        max(event_time) as session_end,
        count() as event_count,
        any(event_date) as event_date
    from events
    group by session_id, user_id
)
select *
from sessionized
