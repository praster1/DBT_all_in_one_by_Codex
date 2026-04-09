CHAPTER A

Companion Pack, Example Data, Bootstrap, Answer Keys

companion ZIP을 교재처럼 따라갈 때 필요한 runbook, dataset 설명, bootstrap 경로, 빠른 정답 기준을 한 곳에 묶는다.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

이 부록은 ZIP을 단순 파일 묶음이 아니라 실습 교재로 쓰기 위한 안내서다. 세 예제 데이터가 무엇을 보여 주는지, day1/day2를 어떻게 올리는지, 어디서 expected result를 비교하는지, 어떤 디렉터리부터 열어야 하는지를 한 번에 찾을 수 있게 했다.

예제 데이터와 DBMS별 초기 셋업

이 appendix의 목적은 세 가지 예제를 DuckDB 한 곳에만 묶어 두지 않고, 여러 데이터플랫폼에서 같은 raw 상태를 다시 만들어 볼 수 있게 하는 것이다. companion pack의 `03_platform_bootstrap/` 폴더에는 예제별·플랫폼별로 `setup_day1.sql`과 `apply_day2.sql`이 들어 있다.

day1 스크립트는 raw schema와 테이블을 만들고 초기 상태를 적재한다. day2 스크립트는 snapshot과 incremental 실습에 필요한 변경 상태를 다시 주입한다. 따라서 책의 lab을 따라갈 때는 day1 → dbt build → day2 → snapshot 또는 incremental 재실행 순서를 기본 패턴으로 생각하면 된다.

S-1. 세 가지 예제 데이터는 무엇을 보여 주는가

| 트랙 | raw schema | 핵심 raw 테이블 | day1 → day2 변화 | 행 수 | 주로 검증하는 기능 |
| --- | --- | --- | --- | --- | --- |
| Retail Orders | raw_retail | customers / products / order_items / orders | orders 상태가 바뀌며 snapshot과 fact 재계산을 유도 | stable 12 / orders 4→4 | source, staging, mart, snapshot, exposure |
| Event Stream | raw_events | users / events | events가 4행에서 6행으로 늘어나며 append-only와 microbatch를 연습 | users 3 / events 4→6 | incremental, session, DAU/WAU, cost |
| Subscription & Billing | raw_billing | accounts / plans / invoices / subscriptions | subscription 상태와 금액이 바뀌며 MRR·churn·versioning을 연습 | stable 9 / subscriptions 3→3 | snapshot, contracts, versions, semantic |

S-2. companion pack에서 어디를 보면 되는가

| dbt_all_in_one_lab_pack/ ├─ 01_duckdb_runnable_project/ ├─ 02_reference_patterns/ │  ├─ platform_profiles/ │  │  ├─ duckdb.yml │  │  ├─ mysql.yml │  │  ├─ postgres.yml │  │  ├─ bigquery.yml │  │  ├─ clickhouse.yml │  │  ├─ snowflake.yml │  │  └─ trino.yml └─ 03_platform_bootstrap/ ├─ retail/<platform>/setup_day1.sql ├─ retail/<platform>/apply_day2.sql ├─ events/<platform>/setup_day1.sql ├─ events/<platform>/apply_day2.sql ├─ subscription/<platform>/setup_day1.sql ├─ subscription/<platform>/apply_day2.sql ├─ nosql_sql_layer_mongodb_via_trino/ └─ trino_catalog_examples/ |
| --- |

TEXT

핵심 규칙은 단순하다. SQL 계열 플랫폼은 모두 같은 raw schema 이름을 사용하고, NoSQL 원천은 JSONL과 SQL layer 구성 파일을 함께 제공한다.

S-3. 플랫폼별 quickest path

| 플랫폼 | 가장 빠른 시험 경로 | 대표 스크립트 경로 | 주의점 |
| --- | --- | --- | --- |
| DuckDB | dbt Core + local file DB | 03_platform_bootstrap/retail/duckdb/setup_day1.sql | 로컬에서 가장 단순하다. companion project와 가장 잘 맞는다. |
| MySQL | 로컬 또는 dev 인스턴스에 raw DB 생성 | 03_platform_bootstrap/events/mysql/setup_day1.sql | 분석 변환과 OLTP를 분리하는 감각이 중요하다. |
| PostgreSQL | dev DB에 raw schema 생성 | 03_platform_bootstrap/subscription/postgres/setup_day1.sql | schema 권한과 search_path를 먼저 확인한다. |
| BigQuery | dataset 생성 후 script editor로 실행 | 03_platform_bootstrap/retail/bigquery/setup_day1.sql | dataset 이름과 지역, 비용 통제를 함께 본다. |
| ClickHouse | MergeTree raw 테이블 생성 | 03_platform_bootstrap/events/clickhouse/setup_day1.sql | ORDER BY와 day2 재적재 순서를 함께 확인한다. |
| Snowflake | worksheet에서 schema/table 생성 | 03_platform_bootstrap/subscription/snowflake/setup_day1.sql | warehouse·role·schema 권한이 먼저다. |
| Trino | memory catalog로 빠른 local trial | 03_platform_bootstrap/retail/trino/setup_day1.sql | 연습용으로는 memory가 편하지만 재시작 시 데이터가 사라진다. |
| NoSQL + SQL Layer | MongoDB에 JSONL 적재 후 Trino catalog 연결 | 03_platform_bootstrap/nosql_sql_layer_mongodb_via_trino/ | dbt는 NoSQL이 아니라 SQL layer에 연결한다. |

S-4. day1 → day2 실행 루틴

| # 1) raw day1 상태 만들기 psql -f 03_platform_bootstrap/retail/postgres/setup_day1.sql # 2) dbt로 첫 build dbt build --select retail+ # 3) raw day2 상태 주입 psql -f 03_platform_bootstrap/retail/postgres/apply_day2.sql # 4) snapshot / incremental 재실행 dbt snapshot --select subscriptions_status_snapshot dbt build --select fct_orders+ |
| --- |

BASH

플랫폼이 바뀌어도 학습 리듬은 같다. day1에서 정상 상태를 만들고, day2에서 변경 상태를 주입한 뒤, snapshot이나 incremental 모델이 어떤 차이를 내는지 확인하는 것이 핵심이다.

S-5. NoSQL + SQL Layer를 어떻게 읽어야 하나

문서형/검색형 NoSQL을 바로 dbt에 붙이려 하기보다, SQL layer를 앞세우고 dbt는 그 SQL 계층에 연결하는 패턴이 더 이해하기 쉽다. companion pack에서는 MongoDB JSONL + Trino catalog 예시를 제공하고, 같은 아이디어를 Elasticsearch/OpenSearch에도 확장할 수 있게 catalog properties 예시를 함께 둔다.

| # MongoDB raw 문서를 적재 bash 03_platform_bootstrap/nosql_sql_layer_mongodb_via_trino/retail/setup_day1_mongodb.sh # Trino catalog file 예시 connector.name=mongodb mongodb.connection-url=mongodb://localhost:27017/ # dbt-trino profile 예시 type: trino database: mongodb schema: raw_retail |
| --- |

BASH

따라하기 워크북 모드

| 이 appendix를 이렇게 쓰세요 • 처음 따라칠 때는 README보다 이 부록의 단계 표를 먼저 펼쳐 둔다. 명령, 기대 결과, 막히면 먼저 볼 곳이 한 번에 모여 있다. • 주문 5003을 기준점으로 삼아 raw → staging → intermediate → mart → snapshot 값이 연결되는지 확인한다. • 값이 다르면 workbook/5003_trace_summary.csv 와 reference_outputs/ 를 바로 대조한다. 이 부록의 표는 companion ZIP의 workbook/ 폴더 내용과 1:1로 맞춰 두었다. |
| --- |

F-1. day1/day2 8단계 runbook

| 단계 | 실행 명령 | 여기서 확인할 것 | 5003 기대 결과 | 막히면 먼저 볼 곳 |
| --- | --- | --- | --- | --- |
| 0 | venv 생성 + dbt 설치profile 복사 | CLI와 adapter 준비 | 아직 데이터 없음 | .venv / profiles.example.yml |
| 1 | python scripts/load_raw_to_duckdb.py--database ./dbt_book_lab.duckdb --day day1 | raw 스키마 4개 테이블 생성 | status=paidshipping_fee=2.5total_amount=18.5 | scripts/load_raw_to_duckdb.pyDuckDB 파일 경로 |
| 2 | dbt debug | profile·adapter 인식 | 연결 통과 | ~/.dbt/profiles.ymlprofile 이름 |
| 3 | dbt seed | seed_data relation 생성 | country_codes / segment_mapping 생성 | dbt_project.ymlseed-paths |
| 4 | dbt build -s staging | rename / cast / 표준화 | order_status=paidorder_date=2026-03-04 | models/sources.ymlstg_orders.sql |
| 5 | dbt build -s intermediate | line grain 유지 | 5003이 2행8.5 + 7.5 = 16.0 | join keyint_order_lines.sql |
| 6 | dbt build -s marts | 주문 grain 1행으로 재집계 | gross_revenue=16.0order_amount=18.5item_count=3 | fanout 여부fct_orders.sql |
| 7 | dbt source freshnessdbt docs generatedbt show --select fct_orders | sources.json과 lineage 확인 | raw→stg→int→fct 노선이 보임 | sources.yml freshnesstarget/sources.json |
| 8 | python scripts/load_raw_to_duckdb.py--database ./dbt_book_lab.duckdb --day day2dbt snapshot | late change + snapshot 이력 | cancelled 버전 추가총 2행 기대 | snapshots/orders_snapshot.ymlupdated_at/check_cols |

F-2. 5003 expected result 정답표

| 층/시점 | 핵심 값 | 왜 이렇게 되나 | 빠른 비교 파일 |
| --- | --- | --- | --- |
| raw day1 | status=paidshipping_fee=2.5total_amount=18.5 | 원천 입력값 그대로 | raw_data/day1/orders.csv |
| stg_orders day1 | order_status=paidline_total=16.0total_amount=18.5 | rename + cast + 표준화 | reference_outputs/stg_orders_day1.csv |
| int_order_lines day1 | 2행line_amount=8.5 / 7.5 | line grain을 유지한 reusable join | reference_outputs/int_order_lines_day1.csv |
| fct_orders day1 | gross_revenue=16.0order_amount=18.5item_count=3 | 주문 grain 1행으로 다시 집계 | reference_outputs/fct_orders_day1.csv |
| raw/stg day2 | status=cancelledshipping_fee=0.0total_amount=0.0 | late change 반영 | raw_data/day2/orders.csvreference_outputs/stg_orders_day2.csv |
| fct_orders day2 | gross_revenue=16.0order_amount=16.0 | business rule 예시: 취소 주문 총액 재정의 | reference_outputs/fct_orders_day2.csv |
| snapshot after day2 | paid 버전 1행 + cancelled 버전 1행 | 이력 구조이므로 같은 key의 여러 행이 의도적으로 생김 | workbook/orders_snapshot_expected_5003.csv |

| 정답이 하나가 아닌 부분 • 5003의 order_amount를 day2에 0.0으로 둘지 16.0으로 다시 계산할지는 business rule의 영역이다. • 중요한 것은 어떤 규칙을 선택했는지와, 그 규칙을 test와 docs로 남겼는지다. |
| --- |

F-3. 실패 증상 → 먼저 볼 곳 매트릭스

| 증상 | 가장 먼저 볼 곳 | 흔한 원인 | 빠른 복구 |
| --- | --- | --- | --- |
| Profile not found | ~/.dbt/profiles.ymlprofiles.example.yml | profile 이름 불일치 | project의 profile 값과 profiles.yml 최상위 키를 맞춘다 |
| source not found | models/sources.ymldbt parse | source/table 이름 오타 | source() 인자와 YAML 이름을 동일하게 맞춘다 |
| ref not found | dbt ls -s ...대상 모델 파일 | 모델 rename / disabled / 오타 | ref 대상 모델 이름과 selector 범위를 다시 본다 |
| relationships 실패 | dimension build 결과upstream raw 키 | missing key 또는 join 문제 | upstream build 후 missing customer_id를 찾는다 |
| gross_revenue가 두 배 | int_order_lines vs fct_orders row count | grain 누락 / fanout | intermediate에서 line grain 고정 후 mart에서 집계한다 |
| snapshot 행 수가 늘지 않음 | snapshots/orders_snapshot.yml | updated_at 또는 check_cols 설정 누락 | snapshot config를 다시 보고 day2 데이터를 재적재한다 |

| BASHdbt debugdbt parsedbt ls -s fct_orders+dbt compile -s fct_ordersdbt build -s fct_orders+ |
| --- |

장별 미션 빠른 정답 가이드

| 장 | 미션 핵심 | 정답 확인 기준 |
| --- | --- | --- |
| 01 | giant SQL 분리 | 최소 source/staging/mart로 역할이 나뉘었는가 |
| 02 | 설치 실패 재현 | debug 단계에서 원인을 정확히 말했는가 |
| 04 | 5003 추적 | raw와 stg에서 어떤 컬럼이 바뀌는지 적었는가 |
| 05 | freshness 추가 | loaded_at_field와 warn/error 기준이 들어갔는가 |
| 07 | grain 정의 | 모든 핵심 모델에 행의 단위를 적었는가 |
| 08 | incremental 해석 | 새 행, 수정 행, full-refresh 기준을 적었는가 |
| 09 | test 3분법 | generic/singular/unit을 각각 하나 이상 떠올렸는가 |
| 10 | snapshot 이력 해석 | 동일 key의 여러 행을 이력 구조로 설명했는가 |
| 12 | failure lab | debug/parse/compile 중 어디서 걸렸는지 말했는가 |
| 15 | 자기 프로젝트 적용 | grain·키·status rule을 다시 정의했는가 |
| F | 워크북 runbook | 단계별 기대 결과와 실패 지점을 바로 찾을 수 있는가 |

| 힌트 정답은 하나가 아니라, 판단 기준이 명확한지가 핵심이다. 특히 5003의 취소 주문 규칙처럼 business rule이 열려 있는 부분은 ‘왜 그 규칙을 택했는가’가 더 중요하다. |
| --- |
