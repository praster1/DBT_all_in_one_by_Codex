#!/usr/bin/env bash
set -euo pipefail

dbt --version
dbt debug
dbt parse
dbt ls -s +fct_orders+
dbt compile -s fct_orders
dbt show --select fct_orders --limit 20
dbt build -s +fct_orders+
dbt docs generate
