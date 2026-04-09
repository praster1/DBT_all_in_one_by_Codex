# Feature availability matrix

Use this matrix as a quick companion to the book's availability badges.

## Read this first
- **Core**: Works in local dbt Core CLI workflows.
- **Fusion**: Best experienced in Fusion CLI or Fusion-powered editors.
- **dbt platform**: Gains extra value when used with Studio IDE, Jobs, Catalog, or dbt CLI connected to a platform account.
- **Starter+ / Enterprise+**: Plan-gated experiences. Always re-check official docs before rollout.
- **Adapter-specific**: Confirm current adapter support before implementation.

## Quick matrix
| Capability | Core local | Fusion local | dbt platform | Note |
|---|---|---|---|---|
| Static dbt Docs | Yes | Yes | Yes | Static site output. |
| Catalog | No | No | Yes | Dynamic documentation experience. |
| Semantic YAML definitions | Yes | Yes | Yes | Definitions live in code. |
| MetricFlow local query (`mf`) | Yes | Yes | N/A | Local/open workflows. |
| `dbt sl` remote Semantic Layer commands | Limited / account-linked | Yes (account-linked) | Yes | Universal Semantic Layer workflows. |
| Project dependencies | No | No | Yes | Enterprise-tier capability. |
| Python UDF | Adapter-specific | Adapter-specific | Adapter-specific | BigQuery / Snowflake first. |
| Canvas | No | No | Yes | Enterprise-tier experience. |
| Copilot | No | No | Yes | Starter+ experience. |
| Local MCP | Yes | Yes | Yes | Runs locally with `uvx dbt-mcp`. |
| Remote MCP | No | No | Yes | Plan / beta / account dependent. |
