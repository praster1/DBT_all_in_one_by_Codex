select
  plan_id,
  lower(plan_name) as plan_name,
  cast(monthly_amount as double) as monthly_amount
from {{ source('raw_billing', 'plans') }}
