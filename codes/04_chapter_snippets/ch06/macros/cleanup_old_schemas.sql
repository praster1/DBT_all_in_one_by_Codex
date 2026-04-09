{% macro cleanup_old_schemas(prefix='dbt_') %}
  {% set query %}
    select schema_name
    from information_schema.schemata
    where schema_name like '{{ prefix }}%'
  {% endset %}

  {% if execute %}
    {% set results = run_query(query) %}
    {% for row in results.rows %}
      {% set schema_name = row[0] %}
      {% set drop_sql %}
        drop schema if exists {{ schema_name }} cascade
      {% endset %}
      {% do run_query(drop_sql) %}
    {% endfor %}
  {% endif %}
{% endmacro %}
