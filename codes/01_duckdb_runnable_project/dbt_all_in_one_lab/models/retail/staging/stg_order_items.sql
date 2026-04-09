select
  order_item_id,
  order_id,
  product_id,
  cast(quantity as integer) as quantity,
  cast(unit_price as double) as unit_price
from {{ source('raw_retail', 'order_items') }}
