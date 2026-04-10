{% snapshot subscription_status_snapshot %}
{{
  config(
    unique_key='subscription_id',
    strategy='check',
    check_cols=['status', 'plan_id', 'billing_period']
  )
}}
select
  subscription_id,
  customer_id,
  plan_id,
  billing_period,
  status,
  updated_at
from {{ ref('stg_subscriptions') }}
{% endsnapshot %}
