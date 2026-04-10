{{ config(
    database='iceberg',
    schema='sample_db',
    alias='case02_branch_query',
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='id',
    pre_hook=["{{ log_model_start() }}"]
) }}

{% set get_mode_query %}
    select value
    from (select 'target_mode' as key, 'C' as value)
    where key = 'target_mode'
{% endset %}

{% if execute %}
  {% set results = run_query(get_mode_query) %}
  {% set current_mode = results.columns[0].values()[0] if results.rows | length > 0 else 'default' %}
{% else %}
  {% set current_mode = '' %}
{% endif %}

{% if current_mode == 'A' %}
    select 'aa' as id, 'Mode A Query' as source, 'aaa' as name
{% elif current_mode == 'B' %}
    select 'bb' as id, 'Mode B Query' as source, 'bbb' as name
{% else %}
    select 'cc' as id, 'Default Query' as source, 'ccc' as name
{% endif %}
