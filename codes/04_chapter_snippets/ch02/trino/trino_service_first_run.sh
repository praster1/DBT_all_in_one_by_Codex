#!/usr/bin/env bash
set -euo pipefail

echo "[1] dbt adapter / profile 확인"
dbt debug || true

echo "[2] Trino coordinator health 확인"
curl -sf http://localhost:8080/v1/info || {
  echo "Trino coordinator에 연결할 수 없습니다."
  exit 1
}

echo "[3] launcher / PID 권한 확인 (환경에 맞게 경로 조정)"
if [ -f /opt/trino/data/var/run/launcher.pid ]; then
  ls -l /opt/trino/data/var/run/launcher.pid
fi

echo "[4] catalog / schema 확인용 SQL"
cat <<'SQL'
SHOW CATALOGS;
SHOW SCHEMAS FROM iceberg;
SQL
