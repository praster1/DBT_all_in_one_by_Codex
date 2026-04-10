#!/usr/bin/env bash
set -euo pipefail

dbt parse
dbt sl validate
dbt sl query \
  --metrics revenue \
  --group-by order__order_date \
  --where "order__order_date >= dateadd(day, -30, current_date)"
