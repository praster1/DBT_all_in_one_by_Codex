#!/usr/bin/env bash
set -euo pipefail

dbt run -s case01_truncate_insert   --vars '{"airflow_run_id":"123456","from_dt":"2026-04-02","end_dt":"2026-04-08"}'

dbt run -s case05_use_parameter   --vars '{"from_date":"20260101","to_date":"20260102"}'
