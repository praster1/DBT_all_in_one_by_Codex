{{ config(
    materialized='materialized_view',
    on_configuration_change='apply',
    partition_by={
      "field": "metric_date",
      "data_type": "date",
      "granularity": "day"
    },
    cluster_by=["account_id", "subscription_id"],
    labels={"domain": "finance", "contains_pii": "no"}
) }}

select
    metric_date,
    account_id,
    subscription_id,
    mrr
from {{ ref('fct_mrr') }}
where metric_date >= date_sub(current_date(), interval 90 day)
