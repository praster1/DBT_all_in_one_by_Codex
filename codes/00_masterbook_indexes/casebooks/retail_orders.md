# Retail Orders Casebook Map

- raw bootstrap: `03_platform_bootstrap/retail/<platform>/setup_day1.sql`
- day2 change: `03_platform_bootstrap/retail/<platform>/apply_day2.sql`
- source: `01_duckdb_runnable_project/dbt_all_in_one_lab/models/retail/retail_sources.yml`
- staging: `.../models/retail/staging/`
- intermediate: `.../models/retail/intermediate/int_order_lines.sql`
- marts: `.../models/retail/marts/`
- singular test: `.../tests/retail_gross_revenue_nonnegative.sql`
- expected result: `01_duckdb_runnable_project/expected/fct_orders.csv`
