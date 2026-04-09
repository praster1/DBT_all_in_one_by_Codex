#!/usr/bin/env bash
set -euo pipefail

STATE_PATH="${1:-./state_artifacts}"

dbt parse
dbt ls --selector slim_ci --state "$STATE_PATH"
dbt build --selector slim_ci --state "$STATE_PATH" --defer
