{{ config(
    database='iceberg',
    schema='sample_db',
    alias='case04_raise_except',
    materialized='table',
    pre_hook=["{{ log_model_start() }}"]
) }}

{% set check_query %}
    select count(*)
    from (
        select 'target_mode' as key, 'C' as value
        where 1 = 0
    )
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
    {% if execute %}
        select cast(fail('이것은 임의로 발생시킨 에러 메시지입니다!') as varchar) as id,
               'ERROR' as run_status
    {% else %}
        select 'fake' as id, 'ERROR' as run_status
    {% endif %}
{% endif %}
