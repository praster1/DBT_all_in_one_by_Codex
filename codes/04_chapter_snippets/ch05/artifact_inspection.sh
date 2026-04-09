#!/usr/bin/env bash
set -euo pipefail

# manifest에서 특정 노드 확인
jq '.nodes | keys[]' target/manifest.json | head

# run_results에서 실패 노드와 status 확인
jq '.results[] | {unique_id, status, execution_time}' target/run_results.json

# freshness 실행 후 stale source 상태 확인
jq '.results[] | {unique_id, max_loaded_at, snapshotted_at, status}' target/sources.json

# 로그에서 특정 모델 이름 검색
grep -n "fct_orders" logs/dbt.log | tail -20
