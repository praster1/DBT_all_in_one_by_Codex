with orders as (
    select * from {{ ref('stg_orders') }}
),
items as (
    select * from {{ ref('stg_order_items') }}
)
select
    o.order_id,
    o.customer_id,
    sum(o.total_amount) as gross_revenue
from orders o
join items i using (order_id)
group by 1, 2
