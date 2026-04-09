select
  customer_id,
  first_name,
  last_name,
  customer_segment,
  signup_date,
  country_code
from {{ ref('stg_customers') }}
