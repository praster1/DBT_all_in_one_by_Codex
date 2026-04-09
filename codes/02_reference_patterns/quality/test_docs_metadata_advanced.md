# Advanced test, docs, and metadata patterns

## Data test configs worth using
- `severity`
- `error_if` / `warn_if`
- `where`
- `store_failures`
- `store_failures_as`
- `fail_calc`
- `limit`

## selectors.yml idea
```yml
selectors:
  - name: ci_core
    definition:
      union:
        - method: state
          value: modified+
          indirect_selection: buildable
        - method: tag
          value: critical
```

## Documentation beyond descriptions
- docs blocks + `doc()`
- `persist_docs`
- `meta`
- `query-comment`

## Good operating loop
1. Add baseline tests.
2. Tune thresholds for noisy checks.
3. Store failure rows where triage matters.
4. Add `meta` and query comments for ownership and cost tracking.
