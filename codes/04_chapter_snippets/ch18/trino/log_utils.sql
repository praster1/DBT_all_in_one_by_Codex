{% macro trino_log_relation() %}
  {{ return(var('trino_log_relation', 'iceberg.sample_db.dbt_log')) }}
{% endmacro %}

{% macro trino_run_key() %}
  {{ return(var('airflow_run_id', invocation_id)) }}
{% endmacro %}

{% macro trino_log_timezone() %}
  {{ return(var('log_timezone', 'Asia/Seoul')) }}
{% endmacro %}

{% macro log_model_start() %}
    {% set run_key = trino_run_key() %}
    {% set p_info = "from_dt=" ~ var('from_dt', 'N/A') ~ ", end_dt=" ~ var('end_dt', 'N/A') %}

    merge into {{ trino_log_relation() }} as target
    using (
        select '{{ run_key }}' as run_key,
               '{{ this.name }}' as model_nm
    ) as source
    on target.invocation_id = source.run_key
   and target.model_name = source.model_nm
    when matched then
      update set
          status        = 'RUNNING',
          start_dt      = current_timestamp at time zone '{{ trino_log_timezone() }}',
          run_info      = '{{ p_info }}',
          end_dt        = null,
          error_message = null
    when not matched then
      insert (
          invocation_id,
          model_name,
          status,
          start_dt,
          run_info
      )
      values (
          '{{ run_key }}',
          '{{ this.name }}',
          'RUNNING',
          current_timestamp at time zone '{{ trino_log_timezone() }}',
          '{{ p_info }}'
      );
{% endmacro %}

{% macro log_run_end(results) %}
    {% if execute %}
        {% set run_key = trino_run_key() %}

        {% for res in results %}
            {% set model_nm = res.node.alias if res.node.alias else res.node.name %}
            {% set status = res.status | upper %}
            {% set msg = (res.message | string | replace("'", "''"))[:500] if res.message else '' %}

            {% set merge_query %}
                merge into {{ trino_log_relation() }} as target
                using (
                    select '{{ run_key }}' as run_key,
                           '{{ model_nm }}' as model_nm_source
                ) as source
                on target.invocation_id = source.run_key
               and target.model_name = source.model_nm_source
                when matched then
                  update set
                      status        = '{{ status }}',
                      error_message = '{{ msg }}',
                      end_dt        = current_timestamp at time zone '{{ trino_log_timezone() }}',
                      duration      = format(
                          '%02d:%02d:%02d.%06d',
                          extract(hour from (current_timestamp at time zone '{{ trino_log_timezone() }}' - target.start_dt)),
                          extract(minute from (current_timestamp at time zone '{{ trino_log_timezone() }}' - target.start_dt)),
                          cast(extract(second from (current_timestamp at time zone '{{ trino_log_timezone() }}' - target.start_dt)) as int),
                          cast((
                              extract(second from (current_timestamp at time zone '{{ trino_log_timezone() }}' - target.start_dt))
                              - cast(extract(second from (current_timestamp at time zone '{{ trino_log_timezone() }}' - target.start_dt)) as int)
                          ) * 1000000 as int)
                      );
            {% endset %}

            {% do run_query(merge_query) %}
        {% endfor %}
    {% endif %}
{% endmacro %}
