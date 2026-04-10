{{ config(
    database='iceberg',
    schema='sample_db',
    alias='case03_branch_query',
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='id'
) }}

-- 잘못된 예: 최종 SELECT에 id가 없다.
select
    'data_exists' as run_status
