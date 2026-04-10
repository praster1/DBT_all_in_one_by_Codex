#!/usr/bin/env bash
set -euo pipefail

dbt parse
dbt sl list metrics
dbt sl validate
dbt sl query --metrics gross_revenue --group-by order__order_date
