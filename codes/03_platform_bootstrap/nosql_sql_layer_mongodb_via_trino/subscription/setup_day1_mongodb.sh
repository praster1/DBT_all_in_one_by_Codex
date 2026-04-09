#!/usr/bin/env bash
set -euo pipefail

# Example: MongoDB import for subscription day1
# Adjust MONGO_URI if needed.
MONGO_URI="${MONGO_URI:-mongodb://localhost:27017}"

mongoimport --uri "$MONGO_URI" --db raw_billing --collection __schema --drop --jsonArray --file /dev/null || true
mongoimport --uri "$MONGO_URI" --db raw_billing --collection accounts --drop --file accounts.jsonl
mongoimport --uri "$MONGO_URI" --db raw_billing --collection plans --drop --file plans.jsonl
mongoimport --uri "$MONGO_URI" --db raw_billing --collection invoices --drop --file invoices.jsonl
mongoimport --uri "$MONGO_URI" --db raw_billing --collection subscriptions --drop --file subscriptions_day1.jsonl
