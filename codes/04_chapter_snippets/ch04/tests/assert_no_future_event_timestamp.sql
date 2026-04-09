select *
from {{ ref('fct_events_daily') }}
where event_timestamp > current_timestamp
