{% snapshot subscriptions_status_snapshot %}
{{
  config(
    target_schema='snapshots',
    unique_key='subscription_id',
    strategy='check',
    check_cols=['subscription_status', 'plan_id', 'monthly_amount'],
    updated_at='updated_at'
  )
}}
select * from {{ ref('stg_subscriptions') }}
{% endsnapshot %}
