{{
  config(
    materialized='incremental',
    incremental_strategy='microbatch',
    event_time='event_at',
    batch_size='day',
    lookback=2,
    concurrent_batches=false
  )
}}

select
  user_id,
  session_id,
  event_at,
  event_type
from {{ ref('stg_events') }}
