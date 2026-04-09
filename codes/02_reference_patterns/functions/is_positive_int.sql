create or replace function {{ this }}(value string)
returns boolean
as (
  regexp_like(value, '^[0-9]+$')
)
