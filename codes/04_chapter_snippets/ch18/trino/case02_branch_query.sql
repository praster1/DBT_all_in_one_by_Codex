{{ config(
    database='iceberg',
    schema='sample_db',
    alias='case02_branch_query',
    materialized='table',
    pre_hook=["{{ log_model_start() }}"]
) }}

{% set get_mode_query %}
    select value
    from (
        select 'target_mode' as key, 'C' as value
    )
    where key = 'target_mode'
{% endset %}

{% if execute %}
    {% set results = run_query(get_mode_query) %}
    {% set current_mode = results.columns[0].values()[0] if results.rows | length > 0 else 'default' %}
{% else %}
    {% set current_mode = 'default' %}
{% endif %}

{% if current_mode == 'A' %}
    select 'Mode A Query' as source, 'aa' as id, 'aaa' as name
{% elif current_mode == 'B' %}
    select 'Mode B Query' as source, 'bb' as id, 'bbb' as name
{% else %}
    select 'Default Query' as source, 'cc' as id, 'ccc' as name
{% endif %}
