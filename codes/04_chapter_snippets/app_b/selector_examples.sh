#!/usr/bin/env bash
set -euo pipefail

dbt ls -s stg_orders
dbt ls -s stg_orders+
dbt ls -s +fct_orders
dbt ls -s +fct_orders+
dbt ls -s path:models/retail
dbt ls -s tag:daily
dbt ls -s state:modified+
dbt build -s marts --exclude tag:slow
