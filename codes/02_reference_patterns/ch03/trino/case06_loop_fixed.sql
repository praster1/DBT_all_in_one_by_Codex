{{ config(
    database='iceberg',
    schema='sample_db',
    alias='case06_loop',
    materialized='incremental',
    unique_key='country_code'
) }}

{% set get_country_query %}
    select distinct country_code
    from {{ source('my_source', 'raw_sales2') }}
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
    current_timestamp at time zone 'Asia/Seoul' as last_updated
{% if not loop.last %} union all {% endif %}
{% endfor %}
