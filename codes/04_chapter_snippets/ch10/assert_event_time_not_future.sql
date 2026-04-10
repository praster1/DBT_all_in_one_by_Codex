select *
from {{ ref('stg_events') }}
where event_at > current_timestamp
