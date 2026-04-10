{{ config(
    materialized='table',
    engine='MergeTree()',
    order_by='(snapshot_date, subscription_id)',
    partition_by='toYYYYMM(snapshot_date)'
) }}

select
    snapshot_date,
    subscription_id,
    customer_id,
    plan_id,
    billing_period,
    mrr
from {{ ref('int_subscription_daily_mrr') }}
