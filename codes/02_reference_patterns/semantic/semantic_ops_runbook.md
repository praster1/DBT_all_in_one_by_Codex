# Semantic Layer operations runbook

## Default flow
1. Define semantic models and metrics in YAML.
2. Validate semantic configs before deploy.
3. Query metrics from CLI/IDE.
4. Promote repeated questions into saved queries.
5. Add exports if consumers need physical tables/views.
6. Add caching only after query patterns repeat and cost matters.

## Command map
### dbt platform or account-linked Fusion
- `dbt sl list metrics`
- `dbt sl list dimensions --metrics <metric_name>`
- `dbt sl list entities --metrics <metric_name>`
- `dbt sl list saved-queries --show-exports`
- `dbt sl query --metrics <metric_name> --group-by <dimension_name>`
- `dbt sl query --saved-query <name>`
- `dbt sl validate`
- `dbt sl export`

### Local/open workflows
- `mf list metrics`
- `mf query --metrics <metric_name> --group-by <dimension_name>`
- `mf validate-configs`

## CI starter
- Narrow build scope first: `dbt build --select state:modified+`
- Then validate semantic nodes: `dbt sl validate --select state:modified+`
- For local/open CI, use `mf validate-configs`
