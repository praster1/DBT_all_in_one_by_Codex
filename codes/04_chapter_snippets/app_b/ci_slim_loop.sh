#!/usr/bin/env bash
set -euo pipefail

ARTIFACTS_DIR="${1:-path/to/prod_artifacts}"

dbt deps
dbt parse --warn-error
dbt ls -s state:modified+
dbt build -s state:modified+ --defer --state "${ARTIFACTS_DIR}"
