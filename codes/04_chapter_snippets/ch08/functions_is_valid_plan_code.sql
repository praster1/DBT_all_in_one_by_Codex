create or replace function {{ this }}(value string)
returns boolean
as (
  regexp_like(value, '^[A-Z]{2,8}_[0-9]{2}$')
);
