#!/usr/bin/env bash
set -euo pipefail

PROJECT_ID="${PROJECT_ID:-my-gcp-project}"
RAW_DATASET="${RAW_DATASET:-raw_dev}"
ANALYTICS_DATASET="${ANALYTICS_DATASET:-analytics_dev}"
LOCATION="${LOCATION:-asia-northeast3}"

echo "== BigQuery preflight =="
gcloud auth activate-service-account --key-file "${GOOGLE_APPLICATION_CREDENTIALS}"
gcloud config set project "${PROJECT_ID}"

bq --location="${LOCATION}" mk --dataset --if_not_exists "${PROJECT_ID}:${RAW_DATASET}"
bq --location="${LOCATION}" mk --dataset --if_not_exists "${PROJECT_ID}:${ANALYTICS_DATASET}"

dbt debug
dbt ls -s stg_orders
dbt run -s stg_orders
dbt test -s stg_orders
