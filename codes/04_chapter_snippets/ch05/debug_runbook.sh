#!/usr/bin/env bash
set -euo pipefail

# 최소 범위로 문제를 좁히는 기본 runbook
dbt debug
dbt parse

# 예: 주문 fact 모델이 이상할 때
dbt ls -s fct_orders+
dbt compile -s fct_orders
dbt show -s fct_orders --limit 20
dbt build -s fct_orders+

# 긴 실행에서 마지막 실패 이후만 다시 시도
# dbt retry
