{{ config(
    database='iceberg',
    schema='sample_db',
    alias='case03_branch_query',
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='id',
    pre_hook=["{{ log_model_start() }}"]
) }}

{% set check_query %}
    select count(*)
    from (select 'target_mode' as key, 'C' as value where 1=1)
{% endset %}

{% if execute %}
  {% set results = run_query(check_query) %}
  {% set row_count = results.columns[0][0] | int %}
{% else %}
  {% set row_count = 0 %}
{% endif %}

{% if row_count > 0 %}
    select 'aa' as id, 'data_exists' as run_status
{% else %}
    select 'bb' as id, 'data_not_exists' as run_status where 1=0
{% endif %}
