#!/usr/bin/env bash
set -euo pipefail

echo "Preview modified nodes from state"
dbt ls --select state:modified+ --state path/to/prod-artifacts

echo "CI build with defer"
dbt build --select state:modified+   --state path/to/prod-artifacts   --defer

echo "Clone reference relations when supported"
dbt clone --select state:modified+   --state path/to/prod-artifacts   --defer || true
