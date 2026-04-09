# Event Stream Casebook Map

- raw bootstrap: `03_platform_bootstrap/events/<platform>/setup_day1.sql`
- day2 change: `03_platform_bootstrap/events/<platform>/apply_day2.sql`
- source: `01_duckdb_runnable_project/dbt_all_in_one_lab/models/events/events_sources.yml`
- staging: `.../models/events/staging/`
- marts: `.../models/events/marts/`
- microbatch reference: `02_reference_patterns/performance/microbatch_events.sql`
- expected result: `01_duckdb_runnable_project/expected/fct_daily_active_users.csv`
