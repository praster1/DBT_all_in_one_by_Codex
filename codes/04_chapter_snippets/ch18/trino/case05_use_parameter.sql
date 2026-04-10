{{ config(
    database='iceberg',
    schema='sample_db',
    alias='case05_use_parameter',
    materialized='table',
    pre_hook=["{{ log_model_start() }}"]
) }}

{% set f_date = var('from_date', none) %}
{% set t_date = var('to_date', none) %}

select
    'aa' as id,
    {% if f_date and t_date %}
        '{{ f_date }}' as range_start,
        '{{ t_date }}' as range_end,
        'RANGE_BATCH' as load_type
    {% else %}
        cast(current_date as varchar) as range_start,
        cast(current_date as varchar) as range_end,
        'DAILY_BATCH' as load_type
    {% endif %},
    current_timestamp as dw_load_dt
