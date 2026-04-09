select
  customer_id,
  first_name,
  last_name,
  lower(customer_segment) as customer_segment,
  cast(signup_date as date) as signup_date,
  upper(country_code) as country_code
from {{ source('raw_retail', 'customers') }}
