{% macro log_table_relation() -%}
    {{ var('log_database', 'iceberg') }}.{{ var('log_schema', 'sample_db') }}.{{ var('log_table', 'dbt_log') }}
{%- endmacro %}

{% macro log_model_start() %}
    {% set run_key = var('airflow_run_id', invocation_id) %}
    {% set tz = var('log_timezone', 'Asia/Seoul') %}
    {% set p_info = "f_date=" ~ var('from_dt', 'N/A') ~ ", t_date=" ~ var('end_dt', 'N/A') %}

    merge into {{ log_table_relation() }} as target
    using (
        select '{{ run_key }}' as run_key, '{{ this.name }}' as model_nm
    ) as source
    on target.invocation_id = source.run_key
       and target.model_name = source.model_nm
    when matched then update
        set status = 'RUNNING',
            start_dt = current_timestamp at time zone '{{ tz }}',
            run_info = '{{ p_info }}',
            end_dt = null,
            error_message = null
    when not matched then insert (
        invocation_id, model_name, status, start_dt, run_info
    ) values (
        '{{ run_key }}', '{{ this.name }}', 'RUNNING',
        current_timestamp at time zone '{{ tz }}', '{{ p_info }}'
    );
{% endmacro %}

{% macro log_run_end() %}
    {% if execute %}
        {% set run_key = var('airflow_run_id', invocation_id) %}
        {% set tz = var('log_timezone', 'Asia/Seoul') %}
        {% for res in results %}
            {% set model_nm = res.node.alias if res.node.alias else res.node.name %}
            {% set status = res.status | upper %}
            {% set msg = (res.message | string | replace("'", "''"))[:500] if res.message else '' %}

            {% set merge_query %}
                merge into {{ log_table_relation() }} as target
                using (
                    select '{{ run_key }}' as run_key, '{{ model_nm }}' as model_nm_source
                ) as source
                on target.invocation_id = source.run_key
                   and target.model_name = source.model_nm_source
                when matched then update
                    set status = '{{ status }}',
                        error_message = '{{ msg }}',
                        end_dt = current_timestamp at time zone '{{ tz }}'
            {% endset %}
            {% do run_query(merge_query) %}
        {% endfor %}
    {% endif %}
{% endmacro %}
