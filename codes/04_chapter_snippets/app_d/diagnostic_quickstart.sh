#!/usr/bin/env bash
set -euo pipefail

echo "[1/5] version"
dbt --version || true

echo "[2/5] debug"
dbt debug || true

echo "[3/5] parse"
dbt parse || true

MODEL="${1:-fct_orders}"

echo "[4/5] selector preview"
dbt ls -s "+${MODEL}+" || true

echo "[5/5] compile"
dbt compile -s "${MODEL}" || true

echo "Open:"
echo "  - target/compiled/"
echo "  - target/run/"
echo "  - target/run_results.json"
echo "  - logs/dbt.log"
