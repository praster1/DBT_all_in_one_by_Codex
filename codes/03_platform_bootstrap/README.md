# Platform bootstrap pack

This folder contains raw-data bootstrap assets for all three companion examples:

- retail
- events
- subscription

Each SQL platform folder contains:
- `setup_day1.sql` — create the raw schema/tables and load the initial day1 state
- `apply_day2.sql` — replace the mutable raw table with the day2 state used for snapshot/incremental labs

Supported SQL targets in this pack:
- duckdb
- mysql
- postgres
- bigquery
- clickhouse
- snowflake
- trino (using the `memory` catalog for a fast local trial)

NoSQL + SQL layer path:
- `nosql_sql_layer_mongodb_via_trino/` contains JSONL files plus `mongoimport` helpers
- `trino_catalog_examples/` contains example Trino catalog properties for `memory`, `mongodb`, and `elasticsearch`

The SQL scripts are intentionally small and explicit. They favor readability over bulk-load performance so that the same example can be inspected, edited, and debugged while following the book.
