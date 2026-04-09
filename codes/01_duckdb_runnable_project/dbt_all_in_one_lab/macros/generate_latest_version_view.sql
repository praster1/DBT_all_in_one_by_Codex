{% macro generate_latest_version_view(model_name, latest_alias) %}
  -- reference macro used in the book when discussing version cutovers
  create or replace view {{ latest_alias }} as
  select * from {{ ref(model_name) }}
{% endmacro %}
