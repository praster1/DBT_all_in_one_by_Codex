{% macro normalize_status(column_name) %}
  case
    when lower({{ column_name }}) in ('placed', 'created', 'new') then 'placed'
    when lower({{ column_name }}) in ('paid', 'captured') then 'paid'
    when lower({{ column_name }}) in ('cancelled', 'canceled') then 'cancelled'
    when lower({{ column_name }}) in ('shipped', 'in_transit') then 'shipped'
    when lower({{ column_name }}) in ('delivered', 'complete') then 'delivered'
    else 'unknown'
  end
{% endmacro %}
