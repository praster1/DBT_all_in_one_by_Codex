{{
  config(
    materialized='incremental',
    unique_key='order_id'
  )
}}

with src as (
    select *
    from {{ ref('stg_orders') }}
    {% if is_incremental() %}
      where updated_at >= (
        select coalesce(max(updated_at), '1900-01-01') from {{ this }}
      )
    {% endif %}
)
select
    order_id,
    customer_id,
    order_status,
    updated_at
from src
