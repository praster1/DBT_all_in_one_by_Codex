select
  product_id,
  product_name,
  lower(category_name) as category_name
from {{ source('raw_retail', 'products') }}
