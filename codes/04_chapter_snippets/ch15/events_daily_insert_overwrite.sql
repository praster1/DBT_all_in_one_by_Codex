{{ config(
    materialized='incremental',
    incremental_strategy='insert_overwrite',
    partition_by={
      "field": "event_date",
      "data_type": "date",
      "granularity": "day",
      "copy_partitions": true
    },
    require_partition_filter=true,
    cluster_by=["user_id", "session_id"],
    labels={"domain": "events"}
) }}

with source_events as (
    select *
    from {{ ref('stg_events') }}
    {% if is_incremental() %}
      where event_date >= (
          select date_sub(max(event_date), interval 3 day)
          from {{ this }}
      )
    {% endif %}
)
select
    event_date,
    user_id,
    session_id,
    count(*) as event_count
from source_events
group by 1, 2, 3
