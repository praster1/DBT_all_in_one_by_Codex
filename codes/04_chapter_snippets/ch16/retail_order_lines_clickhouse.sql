{{ config(
    materialized='table',
    engine='MergeTree()',
    order_by='(order_date, order_id, line_id)',
    partition_by='toYYYYMM(order_date)'
) }}

with orders as (
    select * from {{ ref('stg_orders') }}
),
items as (
    select * from {{ ref('stg_order_items') }}
),
products as (
    select * from {{ ref('stg_products') }}
)
select
    i.line_id,
    i.order_id,
    o.customer_id,
    cast(o.order_date as date) as order_date,
    p.product_id,
    p.category_name,
    i.quantity,
    i.unit_price,
    i.quantity * i.unit_price as line_amount
from items i
join orders o using (order_id)
join products p using (product_id)
