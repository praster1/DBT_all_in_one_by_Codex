#!/usr/bin/env bash
set -euo pipefail

HOST="${1:-localhost}"
PORT="${2:-8080}"

echo "== profile quick check =="
grep -n "type:\|host:\|port:\|database:\|schema:" ~/.dbt/profiles.yml || true

echo "== trino info endpoint =="
curl -fsS "http://${HOST}:${PORT}/v1/info" || {
  echo "Trino coordinator is not reachable at ${HOST}:${PORT}"
  exit 1
}

echo "== dbt debug =="
dbt debug
