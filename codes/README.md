# dbt_all_in_one_lab_pack

이 companion pack은 `DBT 올인원 교과서`와 함께 쓰도록 만든 학습/참고 묶음입니다.

구성은 세 부분입니다.

1. `01_duckdb_runnable_project/`
   - DuckDB에서 실제로 따라 해 볼 수 있는 runnable path
   - Retail / Events / Subscription 세 트랙을 한 프로젝트 안에서 다룹니다
   - source, staging, marts, tests, snapshot, exposure, selector 기본기를 재현하는 용도입니다

2. `02_reference_patterns/`
   - 버전/엔진/플랜에 따라 문법과 지원 범위가 달라질 수 있는 고급 예시 모음
   - governance, semantic layer, functions/UDF, mesh, microbatch, platform profiles, command/Jinja reference가 들어 있습니다
   - 이 폴더는 개념 참고용으로 보고, 실제 적용 전에는 현재 사용하는 dbt 버전과 엔진 문서를 다시 확인하세요

3. `03_platform_bootstrap/`
   - 세 예제를 각 데이터플랫폼에서 바로 시험해 볼 수 있도록 만든 raw 데이터 초기 셋업 묶음
   - DuckDB / MySQL / PostgreSQL / BigQuery / ClickHouse / Snowflake / Trino(memory)
   - NoSQL + SQL Layer 실습용으로 MongoDB JSONL + `mongoimport` + Trino catalog 예시를 함께 제공합니다

권장 순서
- 먼저 `01_duckdb_runnable_project/README.md`
- 그다음 책의 Chapter 16~23과 함께 `02_reference_patterns/`
- 플랫폼별 raw 데이터 셋업이 필요할 때 `03_platform_bootstrap/README.md`
