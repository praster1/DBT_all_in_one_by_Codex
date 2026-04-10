#!/usr/bin/env bash
set -euo pipefail

# 1) day1 bootstrap
#    duckdb < day1_bootstrap_excerpt.sql

# 2) freshness 먼저 확인
dbt source freshness --select source:raw_events.events

# 3) events 예제 전체 build
dbt build --select events

# 4) 결과 미리보기
dbt show --select fct_sessions
dbt show --select fct_daily_active_users

# 5) day2 적용 후 late-arriving correction 확인
#    duckdb < apply_day2_late_arrival.sql
dbt build --select fct_daily_active_users+ --vars '{"events_dau_lookback_days": 2}'

# 6) source freshness 기반 선택 실행 (advanced)
dbt source freshness --select source:raw_events.events
dbt build --select "source_status:fresher+" --state target
