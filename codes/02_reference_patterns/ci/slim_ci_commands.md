# Slim CI reference

```bash
dbt build --select state:modified+ --state path/to/prod_artifacts
dbt build --select state:modified+ --defer --state path/to/prod_artifacts
dbt clone --select tag:heavy --state path/to/prod_artifacts
dbt retry
dbt build --select source_status:fresher+
```

추천 selector 예시
- `slim_ci`
- `semantic_refresh`
- `nightly_heavy`
- `snapshot_only`
