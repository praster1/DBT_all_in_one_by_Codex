{{ config(schema=target.schema) }}

with filtered_orders as (
    select *
    from {{ ref('stg_orders') }}
    where order_date >= {{ var('start_date', "'2026-01-01'") }}
)

select *
from filtered_orders
