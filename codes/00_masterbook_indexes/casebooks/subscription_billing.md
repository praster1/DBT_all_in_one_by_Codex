# Subscription & Billing Casebook Map

- raw bootstrap: `03_platform_bootstrap/subscription/<platform>/setup_day1.sql`
- day2 change: `03_platform_bootstrap/subscription/<platform>/apply_day2.sql`
- source: `01_duckdb_runnable_project/dbt_all_in_one_lab/models/subscription/subscription_sources.yml`
- staging: `.../models/subscription/staging/`
- marts: `.../models/subscription/marts/`
- snapshot: `.../snapshots/subscriptions_status_snapshot.sql`
- governance starter: `02_reference_patterns/governance/contracts_versions.yml`
- expected result: `01_duckdb_runnable_project/expected/fct_mrr.csv`
