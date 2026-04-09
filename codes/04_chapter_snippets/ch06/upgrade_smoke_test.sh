#!/usr/bin/env bash
set -euo pipefail

dbt deps
dbt parse
dbt build --select tag:smoke+
dbt docs generate
