#!/usr/bin/env bash
set -euo pipefail

# Example: MongoDB import for retail day1
# Adjust MONGO_URI if needed.
MONGO_URI="${MONGO_URI:-mongodb://localhost:27017}"

mongoimport --uri "$MONGO_URI" --db raw_retail --collection __schema --drop --jsonArray --file /dev/null || true
mongoimport --uri "$MONGO_URI" --db raw_retail --collection customers --drop --file customers.jsonl
mongoimport --uri "$MONGO_URI" --db raw_retail --collection products --drop --file products.jsonl
mongoimport --uri "$MONGO_URI" --db raw_retail --collection order_items --drop --file order_items.jsonl
mongoimport --uri "$MONGO_URI" --db raw_retail --collection orders --drop --file orders_day1.jsonl
