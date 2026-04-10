{{ config(
    database='iceberg',
    schema='sample_db',
    alias='case06_loop',
    materialized='table',
    pre_hook=["{{ log_model_start() }}"]
) }}

{% set get_country_query %}
    select distinct country_code
    from {{ source('my_source', 'country') }}
    where country_code is not null
    order by 1
{% endset %}

{% if execute %}
    {% set results = run_query(get_country_query) %}
    {% set country_list = results.columns[0].values() %}
{% else %}
    {% set country_list = [] %}
{% endif %}

{% for country in country_list %}
    select
        '{{ country }}' as country_code,
        current_timestamp at time zone '{{ var("log_timezone", "Asia/Seoul") }}' as last_updated
    {% if not loop.last %} union all {% endif %}
{% endfor %}
