#!/usr/bin/env bash
set -euo pipefail

dbt debug --target dev
dbt run --select stg_orders
dbt run --select fct_order_lines_clickhouse
dbt test --select fct_order_lines_clickhouse

dbt run --select stg_events
dbt run --select events_sessions_clickhouse
dbt run --select events_daily_target events_daily_mv

dbt run --select stg_subscriptions
dbt run --select fct_mrr_daily_clickhouse
