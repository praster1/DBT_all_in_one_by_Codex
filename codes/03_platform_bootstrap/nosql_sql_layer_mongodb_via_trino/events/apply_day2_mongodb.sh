#!/usr/bin/env bash
set -euo pipefail

# Example: MongoDB import for events day2
MONGO_URI="${MONGO_URI:-mongodb://localhost:27017}"
mongoimport --uri "$MONGO_URI" --db raw_events --collection events --drop --file events_day2.jsonl
