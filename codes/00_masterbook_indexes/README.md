# DBT All-in-One Masterbook Companion Index

이 디렉터리는 교재의 새 구조에 맞춰 companion ZIP 안의 주요 경로를 다시 찾기 쉽게 정리한 인덱스다.

## 크게 보면
- `01_duckdb_runnable_project/` : DuckDB 기준으로 세 예제를 바로 실행할 수 있는 runnable project
- `02_reference_patterns/` : semantic, governance, CI, quality, platform profiles, commands, Jinja 같은 참조 패턴
- `03_platform_bootstrap/` : 각 예제를 DBMS별 day1/day2 상태로 세팅하는 SQL/bootstrap 스크립트
- `03_platform_bootstrap/nosql_sql_layer_mongodb_via_trino/` : MongoDB + Trino SQL Layer 패턴 예시

## 교재 구조와 맞춰 보면
- **Casebook I · Retail Orders**: 
  - `01_duckdb_runnable_project/dbt_all_in_one_lab/models/retail/`
  - `03_platform_bootstrap/retail/`
- **Casebook II · Event Stream**:
  - `01_duckdb_runnable_project/dbt_all_in_one_lab/models/events/`
  - `03_platform_bootstrap/events/`
- **Casebook III · Subscription & Billing**:
  - `01_duckdb_runnable_project/dbt_all_in_one_lab/models/subscription/`
  - `03_platform_bootstrap/subscription/`

- **Platform Playbooks**:
  - DuckDB / MySQL / PostgreSQL / BigQuery / ClickHouse / Snowflake / Trino:
    - `02_reference_patterns/platform_profiles/`
    - `03_platform_bootstrap/<example>/<platform>/`
  - Trino + NoSQL + SQL Layer:
    - `03_platform_bootstrap/nosql_sql_layer_mongodb_via_trino/`
    - `02_reference_patterns/platform_profiles/nosql_sql_layer_via_trino.md`

## 먼저 열어 볼 파일 추천
1. `01_duckdb_runnable_project/README.md`
2. `03_platform_bootstrap/README.md`
3. `02_reference_patterns/commands/dbt_command_reference.md`
4. `02_reference_patterns/jinja/jinja_reference.md`
