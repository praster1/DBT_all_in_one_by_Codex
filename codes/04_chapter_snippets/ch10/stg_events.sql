with src as (

    select *
    from {{ source('raw_events', 'events') }}

),

typed as (

    select
        cast(event_id as varchar) as event_id,
        cast(user_id as integer) as user_id,
        cast(event_at as timestamp) as event_at,
        cast(event_ingested_at as timestamp) as event_ingested_at,
        cast(event_at as date) as event_date,
        lower(trim(event_name)) as event_name,
        lower(trim(platform)) as platform,
        coalesce(session_id, 'missing_session_' || cast(user_id as varchar)) as session_id
    from src

)

select *
from typed
