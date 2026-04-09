select
  order_id,
  customer_id,
  cast(order_date as date) as order_date,
  lower(status) as order_status,
  cast(total_amount as double) as total_amount,
  cast(updated_at as timestamp) as updated_at
from {{ source('raw_retail', 'orders') }}
