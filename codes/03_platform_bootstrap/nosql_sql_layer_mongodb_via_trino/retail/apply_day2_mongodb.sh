#!/usr/bin/env bash
set -euo pipefail

# Example: MongoDB import for retail day2
MONGO_URI="${MONGO_URI:-mongodb://localhost:27017}"
mongoimport --uri "$MONGO_URI" --db raw_retail --collection orders --drop --file orders_day2.jsonl
