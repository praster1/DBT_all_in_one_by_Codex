with events as (

    select *
    from {{ ref('stg_events') }}

)

select
    session_id,
    min(event_at) as session_started_at,
    max(event_at) as session_ended_at,
    min(user_id) as user_id,
    min(platform) as platform,
    count(*) as event_count
from events
group by 1
