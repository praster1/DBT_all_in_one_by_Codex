#!/usr/bin/env bash
set -euo pipefail

# Example: MongoDB import for events day1
# Adjust MONGO_URI if needed.
MONGO_URI="${MONGO_URI:-mongodb://localhost:27017}"

mongoimport --uri "$MONGO_URI" --db raw_events --collection __schema --drop --jsonArray --file /dev/null || true
mongoimport --uri "$MONGO_URI" --db raw_events --collection users --drop --file users.jsonl
mongoimport --uri "$MONGO_URI" --db raw_events --collection events --drop --file events_day1.jsonl
