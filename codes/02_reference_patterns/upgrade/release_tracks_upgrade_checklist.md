# Upgrade and release track checklist

## Support states
- Active
- Critical
- Deprecated
- End of Life

## Release track heuristics
- **Latest Fusion**: fastest access to engine changes
- **Latest**: fastest general platform functionality
- **Compatible**: better alignment with recent dbt Core OSS
- **Extended / Fallback**: slower cadence for change-sensitive teams

## Upgrade routine
1. Start in dev.
2. Narrow the smoke test scope with selectors.
3. Resolve deprecations early.
4. Review behavior change flags intentionally.
5. Confirm package + adapter compatibility together.
