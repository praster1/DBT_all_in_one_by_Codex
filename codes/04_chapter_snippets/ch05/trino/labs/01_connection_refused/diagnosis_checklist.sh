#!/usr/bin/env bash
set -euo pipefail

echo "1. profile / adapter"
dbt debug || true

echo "2. coordinator"
curl -sf http://localhost:8080/v1/info || echo "Connection refused: coordinator/launcher 확인"

echo "3. launcher PID permission"
ls -l /opt/trino/data/var/run/launcher.pid 2>/dev/null || true

echo "4. next"
echo "SQL 문제가 아니라 서비스 상태를 먼저 본다."
