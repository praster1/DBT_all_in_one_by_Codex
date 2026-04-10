#!/usr/bin/env bash
set -euo pipefail

echo "[1] dbt profile syntax and connection"
dbt debug || true

echo "[2] Trino coordinator info"
curl -fsS http://localhost:8080/v1/info || true

echo "[3] launcher status"
sudo ./launcher status || true

echo "[4] launcher restart if needed"
# sudo ./launcher run

echo "[5] verify catalogs"
# run in trino CLI:
# SHOW CATALOGS;
