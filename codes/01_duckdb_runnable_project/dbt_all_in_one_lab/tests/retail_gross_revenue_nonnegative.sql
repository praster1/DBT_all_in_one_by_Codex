select *
from {{ ref('fct_orders') }}
where gross_revenue < 0
