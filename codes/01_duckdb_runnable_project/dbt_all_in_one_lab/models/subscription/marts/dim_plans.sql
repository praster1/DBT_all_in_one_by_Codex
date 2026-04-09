select
  plan_id,
  plan_name,
  monthly_amount
from {{ ref('stg_plans') }}
