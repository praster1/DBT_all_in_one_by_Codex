with subs as (
  select
    subscription_id,
    account_id,
    plan_id,
    subscription_status,
    started_at,
    case
      when cancelled_at_raw is null or cancelled_at_raw = '' then null
      else cast(cancelled_at_raw as date)
    end as cancelled_at,
    monthly_amount
  from {{ ref('stg_subscriptions') }}
),
active as (
  select *
  from subs
  where subscription_status in ('active', 'trialing')
)
select
  plan_id,
  count(*) as active_subscriptions,
  sum(monthly_amount) as mrr
from active
group by 1
