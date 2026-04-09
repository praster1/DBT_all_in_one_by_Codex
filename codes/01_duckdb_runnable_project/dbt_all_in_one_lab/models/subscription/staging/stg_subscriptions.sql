select
  subscription_id,
  account_id,
  plan_id,
  lower(status) as subscription_status,
  cast(started_at as date) as started_at,
  nullif(cancelled_at, '') as cancelled_at_raw,
  cast(monthly_amount as double) as monthly_amount,
  cast(updated_at as timestamp) as updated_at
from {{ source('raw_billing', 'subscriptions') }}
