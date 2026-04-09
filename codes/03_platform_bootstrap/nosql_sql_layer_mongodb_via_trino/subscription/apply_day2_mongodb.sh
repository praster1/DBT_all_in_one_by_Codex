#!/usr/bin/env bash
set -euo pipefail

# Example: MongoDB import for subscription day2
MONGO_URI="${MONGO_URI:-mongodb://localhost:27017}"
mongoimport --uri "$MONGO_URI" --db raw_billing --collection subscriptions --drop --file subscriptions_day2.jsonl
