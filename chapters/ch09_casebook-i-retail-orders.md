CHAPTER 09

Casebook I · Retail Orders

소매 주문 DW를 source → marts → tests → snapshot → semantic → CI까지 단계적으로 확장한다.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

Retail Orders는 이 책의 가장 기본적인 예제다. 주문, 주문상세, 고객, 상품이라는 익숙한 raw 구조를 가지고 source, staging, intermediate, fact/dimension 설계를 가장 뚜렷하게 보여 줄 수 있기 때문이다. 동시에 grain과 fanout, 주문 상태 변경, KPI 정의, semantic layer의 기초를 함께 실험하기에도 좋다.

이 장에서는 책 앞에서 배운 개념을 처음부터 다시 설명하지 않는다. 대신 day1/day2 raw 변화, source 정의, stg_orders와 int_order_lines, fct_orders, tests, snapshot, contracts, semantic starter, slim CI까지 한 흐름으로 엮어, 하나의 소매 예제가 실제 프로젝트처럼 자라나는 과정을 단계별 사례로 보여 준다.

이 예제를 시작할 때 가장 먼저 확인할 파일

| 구분 | 파일 경로 | 왜 먼저 보는가 |
| --- | --- | --- |
| bootstrap | 03_platform_bootstrap/retail/<platform>/setup_day1.sql | day1 raw 상태를 만드는 출발점 |
| day2 변경 | 03_platform_bootstrap/retail/<platform>/apply_day2.sql | 주문 상태·금액 변경을 주입하는 두 번째 단계 |
| source 정의 | models/retail/retail_sources.yml | raw_retail source와 설명을 확인 |
| 핵심 모델 | models/retail/staging/stg_orders.sql | 주문 레코드가 정리되는 첫 관문 |
| 핵심 mart | models/retail/marts/fct_orders.sql | 주문 단위 metric이 최종적으로 계산되는 곳 |

Retail Orders 예제는 companion ZIP의 `03_platform_bootstrap/retail/` 아래 bootstrap 스크립트와 `01_duckdb_runnable_project/dbt_all_in_one_lab/models/` 아래 모델 파일이 함께 움직인다. day1은 안정된 초기 상태를, day2는 실제 프로젝트에서 흔히 생기는 변경을 흉내 낸다. 따라서 이 장의 핵심은 단순히 모델 결과를 보는 것이 아니라, day1과 day2 사이의 변화가 어떤 dbt 장치들을 필요로 하게 만드는지 추적하는 데 있다.

도메인과 day1/day2 시나리오

Retail Orders는 customers, products, orders, order_items 네 raw 테이블로 시작한다. day1에서는 정상 주문 상태를 만들고, day2에서는 일부 주문의 status와 total_amount, updated_at을 바꿔 snapshot과 freshness, 재실행 판단을 시험할 수 있게 한다. order_id 5003은 이 장 전체에서 추적 기준점 역할을 하며, raw orders에서 시작해 staging, intermediate, marts, snapshot까지 어떤 값이 바뀌는지 비교하기 좋다.

DuckDB 기준 retail day1 bootstrap 일부

| -- retail day1 bootstrap for duckdb CREATE SCHEMA IF NOT EXISTS raw_retail; DROP TABLE IF EXISTS raw_retail.customers; CREATE TABLE raw_retail.customers ( customer_id INTEGER, first_name VARCHAR, last_name VARCHAR, customer_segment VARCHAR, signup_date DATE, country_code VARCHAR ); INSERT INTO raw_retail.customers (customer_id, first_name, last_name, customer_segment, signup_date, country_code) VALUES (101, 'Mina', 'Kim', 'vip', '2025-11-03', 'KR'), (102, 'Jin', 'Park', 'regular', '2026-01-05', 'KR'), (103, 'Alex', 'Cho', 'regular', '2026-01-18', 'US'); DROP TABLE IF EXISTS raw_retail.products; CREATE TABLE raw_retail.products ( product_id INTEGER, product_name VARCHAR, category_name VARCHAR ); |
| --- |

코드 · SQL

source → staging → intermediate → marts

Retail Orders의 기본 설계는 단순하다. `source('raw_retail', 'orders')`에서 raw 주문을 읽고, `stg_orders`에서 날짜/상태/금액 타입을 표준화하며, `int_order_lines`에서 order_items와 products를 조인해 line grain을 만든 뒤, `fct_orders`에서 다시 order grain으로 집계한다. 이 과정이 중요한 이유는 주문 domain에서 가장 흔한 fanout 위험이 바로 order grain과 line grain의 경계에서 생기기 때문이다.

핵심 intermediate · int_order_lines

| with orders as ( select * from {{ ref('stg_orders') }} ), items as ( select * from {{ ref('stg_order_items') }} ), products as ( select * from {{ ref('stg_products') }} ) select i.order_id, o.customer_id, o.order_date, p.product_id, p.category_name, i.quantity, i.unit_price, i.quantity * i.unit_price as line_amount from items i join orders o using (order_id) join products p using (product_id) |
| --- |

코드 · SQL

핵심 mart · fct_orders

| with lines as ( select * from {{ ref('int_order_lines') }} ) select order_id, customer_id, min(order_date) as order_date, sum(line_amount) as gross_revenue, sum(quantity) as item_count from lines group by 1, 2 |
| --- |

코드 · SQL

품질과 상태 변화

Retail Orders는 generic test, singular test, snapshot을 함께 보여 주기 좋은 예제다. order_id의 not_null/unique와 customer_id relationships는 기본 안전망을 만든다. 여기에 gross revenue가 음수가 아니어야 한다는 singular test를 더하고, orders source의 day2 상태 변경을 snapshot으로 기록하면 “현재 상태만 맞는 프로젝트”에서 “시간 변화까지 설명 가능한 프로젝트”로 한 단계 올라간다.

Retail singular test 예시

| select * from {{ ref('fct_orders') }} where gross_revenue < 0 |
| --- |

코드 · SQL

운영과 거버넌스 확장

이 예제가 advanced 단계로 갈 때 가장 먼저 붙는 것은 contracts와 semantic starter다. 주문 mart를 팀 공용 API로 노출하려면 컬럼 shape와 비즈니스 의미를 먼저 고정해야 하고, 이후에 revenue나 order_count 같은 metric을 semantic model로 올리는 편이 안정적이다. slim CI에서는 `+fct_orders`나 retail selector를 중심으로 필요한 범위만 검증하고, state/defer를 붙이면 변경 범위가 더 명확해진다.

Semantic starter 예시

| semantic_models: - name: orders_semantic model: ref('fct_orders') defaults: agg_time_dimension: order_date entities: - name: order type: primary expr: order_id - name: customer type: foreign expr: customer_id dimensions: - name: order_date type: time type_params: time_granularity: day - name: customer_segment type: categorical measures: - name: gross_revenue agg: sum expr: gross_revenue - name: mrr_semantic model: ref('fct_mrr') entities: - name: plan type: foreign expr: plan_id dimensions: - name: plan_id |
| --- |

코드 · YAML

플랫폼으로 옮길 때 달라지는 점

DuckDB와 PostgreSQL에서는 이 예제를 거의 그대로 옮기기 쉽다. BigQuery에서는 partition/cluster와 스캔 비용을 함께 고려해야 하고, Snowflake에서는 warehouse와 grants가 운영 설계에 더 크게 들어온다. ClickHouse에서는 line-level fact를 두는 구조가 더 강력할 수 있고, Trino/NoSQL 패턴에서는 raw를 읽는 위치와 materialization을 남기는 catalog를 먼저 정해야 한다. 이 차이는 뒤의 플랫폼 플레이북에서 예제 파일 경로와 함께 다시 정리한다.

| Retail Orders 실험 루틴 1) setup_day1.sql 실행 → 2) dbt build -s retail → 3) fct_orders expected 결과 비교 → 4) apply_day2.sql 실행 → 5) dbt snapshot / source freshness / state-based 재실행 → 6) semantic starter와 contract 예시 읽기 |
| --- |
