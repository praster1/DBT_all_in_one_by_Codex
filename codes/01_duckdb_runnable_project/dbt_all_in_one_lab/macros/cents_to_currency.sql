{% macro cents_to_currency(column_name) %}
  round({{ column_name }} / 100.0, 2)
{% endmacro %}
