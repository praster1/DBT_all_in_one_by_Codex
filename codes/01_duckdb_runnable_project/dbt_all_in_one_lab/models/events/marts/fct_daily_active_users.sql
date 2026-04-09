{{ config(materialized='incremental', unique_key='event_date') }}

with events as (
  select * from {{ ref('stg_events') }}
  {% if is_incremental() %}
  where event_date >= (
    select coalesce(max(event_date), cast('1900-01-01' as date))
    from {{ this }}
  )
  {% endif %}
)
select
  event_date,
  count(distinct user_id) as dau
from events
group by 1
