{% macro grant_reporter_access(role='reporter') %}
  {% set sql %}
    grant usage on schema {{ target.schema }} to role {{ role }};
  {% endset %}
  {% do run_query(sql) %}
{% endmacro %}
