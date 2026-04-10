#!/usr/bin/env bash
set -euo pipefail

dbt parse
dbt sl validate --select state:modified+

dbt sl query \
  --metrics revenue \
  --group-by customer_segment,order_date__month \
  --where "order_date >= '2026-01-01'"
