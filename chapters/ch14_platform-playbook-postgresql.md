CHAPTER 14

Platform Playbook · PostgreSQL

작고 명료한 운영형 DW/마트 실험에 강한 범용 SQL 엔진.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

PostgreSQL은 dbt를 배우기에도, 작은 내부 마트를 운영하기에도 비교적 이해하기 쉬운 플랫폼이다. schema 개념과 권한 모델이 명확하고, 로컬 개발 환경이나 작은 팀 환경에서도 다루기 수월하기 때문이다.

이 장은 Postgres에서 세 예제를 올릴 때의 profile, schema 분리, snapshot과 tests, materialization 선택, OLTP와 공유할 때의 주의점, CI와 migrations의 균형을 정리한다.

가장 먼저 확인할 profile / setup 예시

PostgreSQL profile 예시

| my_postgres: target: dev outputs: dev: type: postgres host: localhost port: 5432 dbname: analytics schema: dbt_dev user: analytics |
| --- |

코드 · YAML

| 예제 | day1 bootstrap 경로 | day2 변경 경로 |
| --- | --- | --- |
| Retail Orders | 03_platform_bootstrap/retail/postgres/setup_day1.sql | 03_platform_bootstrap/retail/postgres/apply_day2.sql |
| Event Stream | 03_platform_bootstrap/events/postgres/setup_day1.sql | 03_platform_bootstrap/events/postgres/apply_day2.sql |
| Subscription & Billing | 03_platform_bootstrap/subscription/postgres/setup_day1.sql | 03_platform_bootstrap/subscription/postgres/apply_day2.sql |

PostgreSQL은 dbt 개념을 작은 운영형 DW/마트에 옮기기 좋은 범용 엔진이다. schema 분리와 권한, snapshot과 tests, contracts를 이해하기 쉽고, DuckDB보다 운영형 감각을 더 빨리 익힐 수 있다.

세 예제를 Postgres에서 진행할 때의 기준

Retail Orders와 Subscription & Billing은 비교적 자연스럽게 올라가며, Event Stream도 데이터량이 크지 않다면 충분히 연습할 수 있다. 다만 OLTP와 같은 인스턴스를 공유할 경우 무거운 full rebuild나 잦은 incremental backfill이 애플리케이션 성능에 영향을 줄 수 있으므로, 운영 시간대와 workload 분리를 함께 고려해야 한다.
