# NoSQL + SQL Layer via Trino

dbt connects to the SQL layer, not directly to the NoSQL engine.

Recommended local trial path:
1. Load JSON documents into MongoDB.
2. Expose the database to Trino with the MongoDB connector.
3. Use `dbt-trino` with `database: mongodb` and the source schema matching the MongoDB database name.

You can use the `03_platform_bootstrap/nosql_sql_layer_mongodb_via_trino/` directory for JSONL seeds and `mongoimport` commands.
