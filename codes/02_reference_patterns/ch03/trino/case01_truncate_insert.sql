{{ config(
    database='iceberg',
    schema='sample_db',
    alias='final_sales',
    materialized='incremental',
    incremental_strategy='append',
    pre_hook=[
      "{{ log_model_start() }}",
      "delete from {{ this }} where 1=1"
    ]
) }}

-- 주의: 이 패턴은 incremental 정석이라기보다 전체 재적재형 운영 패턴이다.
select
    sale_id,
    product_name,
    amount,
    current_timestamp at time zone 'Asia/Seoul' as last_updated
from {{ source('my_source', 'raw_sales') }}
