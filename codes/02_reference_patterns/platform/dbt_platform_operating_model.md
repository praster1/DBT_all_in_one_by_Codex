# dbt platform operating model

## Environments decide three things
- dbt version / release track / engine
- warehouse connection information
- code version (branch / commit)

## Practical split
- **Development**: each developer iterates safely without affecting production consumers.
- **Deployment / Production**: durable metadata, scheduled jobs, trusted outputs.
- **Deployment / Staging**: CI-like verification with production-like credentials but isolated objects.

## Interfaces
| Interface | Best for |
|---|---|
| Studio IDE | Browser-based build/test/run and close Catalog feedback loops |
| dbt CLI | Local terminal execution with platform authentication |
| Catalog | Discoverability, lineage, richer metadata |
| dbt Docs | Static docs hosting |
| Canvas | Visual model authoring |

## Job design rule
Think in terms of **frequency**, **scope**, and **consumer impact**.
- CI: small and fast
- Deploy: stable and trusted
- Metadata / exports: consumer-oriented
