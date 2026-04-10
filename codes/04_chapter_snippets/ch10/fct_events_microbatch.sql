{{ config(
    materialized='incremental',
    incremental_strategy='microbatch',
    event_time='event_at',
    batch_size='day',
    lookback=2,
    concurrent_batches=false
) }}

select
    event_id,
    user_id,
    event_at,
    event_ingested_at,
    event_name,
    platform,
    session_id
from {{ ref('stg_events') }}
