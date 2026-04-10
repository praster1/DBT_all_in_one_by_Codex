{{ config(
    materialized='incremental',
    incremental_strategy='microbatch',
    event_time='session_start',
    begin='2026-01-01',
    batch_size='day',
    lookback=2,
    full_refresh=false,
    partition_by={
      "field": "session_date",
      "data_type": "date",
      "granularity": "day"
    },
    cluster_by=["user_id", "session_id"]
) }}

with page_views as (
    select * from {{ ref('stg_events') }}
),
sessionized as (
    select
        session_id,
        user_id,
        min(event_ts) as session_start,
        date(min(event_ts)) as session_date,
        count(*) as page_view_count
    from page_views
    group by 1, 2
)
select * from sessionized
