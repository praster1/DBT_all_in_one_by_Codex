select
  user_id,
  cast(signup_at as timestamp) as signup_at,
  upper(country_code) as country_code
from {{ source('raw_events', 'users') }}
