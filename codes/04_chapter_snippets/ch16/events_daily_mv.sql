{{ config(
    materialized='materialized_view',
    catchup=true
) }}
{{ materialization_target_table(ref('events_daily_target')) }}

select
    toDate(event_time) as event_date,
    event_type,
    count() as total_events
from {{ source('raw', 'events') }}
group by event_date, event_type
