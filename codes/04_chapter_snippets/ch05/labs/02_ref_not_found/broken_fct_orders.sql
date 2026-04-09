with lines as (
    select *
    from {{ ref('int_order_lines_v1') }}
)
select
    order_id,
    customer_id,
    min(order_date) as order_date,
    sum(line_amount) as gross_revenue
from lines
group by 1, 2
