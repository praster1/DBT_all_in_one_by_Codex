select
  event_id,
  user_id,
  cast(event_at as timestamp) as event_at,
  cast(date_trunc('day', cast(event_at as timestamp)) as date) as event_date,
  lower(event_name) as event_name,
  lower(platform) as platform,
  session_id
from {{ source('raw_events', 'events') }}
