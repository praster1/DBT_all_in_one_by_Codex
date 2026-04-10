select *
from {{ ref('finance_core', 'fct_orders_v2') }}
