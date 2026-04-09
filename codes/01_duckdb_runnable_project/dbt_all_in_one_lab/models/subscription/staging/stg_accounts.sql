select
  account_id,
  account_name,
  cast(signup_date as date) as signup_date,
  lower(segment) as segment
from {{ source('raw_billing', 'accounts') }}
