#!/usr/bin/env bash
set -euo pipefail

SOURCES_STATE="${1:-./source_artifacts}"

dbt source freshness
dbt build --selector source_refresh --state "$SOURCES_STATE"
