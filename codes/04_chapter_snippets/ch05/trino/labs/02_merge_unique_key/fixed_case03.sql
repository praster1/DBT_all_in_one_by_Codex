{{ config(
    database='iceberg',
    schema='sample_db',
    alias='case03_branch_query',
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='id'
) }}

select
    'aa' as id,
    'data_exists' as run_status
