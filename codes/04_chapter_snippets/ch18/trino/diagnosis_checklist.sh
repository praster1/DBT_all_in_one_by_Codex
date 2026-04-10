#!/usr/bin/env bash
set -euo pipefail

echo "=== CONNECTION REFUSED ==="
echo "1) dbt debug"
echo "2) curl http://localhost:8080/v1/info"
echo "3) sudo ./launcher status"
echo "4) check /opt/trino/data/var/run/launcher.pid permission"
echo

echo "=== dbt_internal_source.id cannot be resolved ==="
echo "1) open target/compiled/... model SQL"
echo "2) verify source-side branch keeps unique_key column"
echo "3) verify both branches project same final schema"
echo

echo "=== dbt_internal_dest.id cannot be resolved ==="
echo "1) DESCRIBE target table"
echo "2) verify target table really has unique_key column"
echo "3) run with --full-refresh if schema drift exists"
