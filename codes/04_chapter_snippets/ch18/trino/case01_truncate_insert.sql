{# 
case01 · 전체 재적재형 배치 예시
이 패턴은 canonical incremental이라기보다 truncate-insert형 운영 패턴에 가깝다.
#}

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

select
    sale_id,
    product_name,
    amount,
    current_timestamp at time zone '{{ var("log_timezone", "Asia/Seoul") }}' as last_updated
from {{ source('my_source', 'raw_sales') }}
