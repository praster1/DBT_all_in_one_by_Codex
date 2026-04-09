{{ config(
    materialized='incremental',
    incremental_strategy='microbatch',
    event_time='event_at',
    batch_size='day',
    lookback=2,
    concurrent_batches=false
) }}

select *
from {{ ref('stg_events') }}
