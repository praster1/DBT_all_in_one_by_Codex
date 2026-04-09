CHAPTER 03

source/ref, selectors, layered modeling, grain, materializations

모델 간 계약, DAG 제어, 레이어 설계, fanout 방지, incremental 판단까지 변환의 핵심 설계를 묶어 본다.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

dbt의 핵심은 source()와 ref()로 DAG를 만드는 데서 끝나지 않는다. 그 DAG 위에 어떤 grain의 모델을 놓을지, 어떤 selector로 개발 범위를 줄일지, 어디까지를 staging으로 두고 어디서부터 비즈니스 로직을 묶을지, 어떤 materialization으로 저장할지를 함께 결정해야 비로소 프로젝트가 안정된다.

이 장은 변환 설계를 “모델을 어떻게 쪼개고, 어떤 순서로 실행하고, 어떤 형태로 저장할 것인가”라는 하나의 문제로 묶어 본다. fanout, late-arriving data, full-refresh, selector 습관 같은 실무 감각도 이 장 안에서 같이 다룬다.

grain과 fanout의 위험을 그림으로 보기

source()와 ref()

| 필수 | 처음 읽는 사람은 장 끝의 ‘직접 해보기’를 반드시 해 본다. 이해가 아니라 손의 감각을 남기는 것이 목표다. |
| --- | --- |

| 이 장에서 배우는 것 • source()와 ref()의 차이를 정확히 구분한다. • source 레벨 설명, 테스트, freshness가 왜 실무적으로 중요한지 이해한다. • 직접 테이블명 하드코딩을 피해야 하는 이유를 사례로 설명한다. | 완료 기준 • source는 프로젝트 바깥 입력, ref는 프로젝트 안 산출물이라는 구분이 선다. • loaded_at_field와 freshness block의 역할을 이해한다. • source not found와 ref not found를 어디서부터 봐야 하는지 안다. |
| --- | --- |

5-1. source()는 원천 데이터와의 계약이다

source()는 단순히 테이블명을 감추는 매크로가 아니다. dbt에게 ‘이 모델은 이 원천 입력에 의존한다’고 선언하는 행위다. source를 쓰기 시작하면 원천 테이블에도 설명, 컬럼 테스트, freshness 기준을 붙일 수 있고, docs site에서는 lineage의 시작점으로 드러난다.

| YAML · sources.yml version: 2 sources: - name: raw description: "로컬 CSV를 DuckDB raw 스키마로 적재한 원천 데이터" schema: raw loaded_at_field: ingested_at freshness: warn_after: {count: 3650, period: day} error_after: {count: 7300, period: day} tables: - name: customers description: "고객 원천 테이블" columns: - name: customer_id data_tests: - not_null - unique - name: orders description: "주문 헤더 원천 테이블" columns: - name: order_id data_tests: - not_null - unique - name: customer_id data_tests: - not_null - name: order_items description: "주문 라인 원천 테이블" columns: - name: order_item_id data_tests: - not_null - unique - name: products description: "상품 원천 테이블" columns: - name: product_id data_tests: - not_null - unique |
| --- |

5-2. ref()는 모델 간 계약이다

ref()는 모델 사이의 의존성을 표현한다. 이 순간 dbt는 단순 문자열 치환을 넘어서 DAG를 만들고, 실행 순서를 정하고, docs lineage를 그리고, selector로 영향을 좁힐 수 있게 해 준다. 같은 SQL이더라도 ref()를 쓰느냐 직접 relation 이름을 쓰느냐에 따라 운영성이 크게 달라진다.

| SQL select * from {{ ref('stg_orders') }} |
| --- |

| 상황 | 무엇을 써야 하나 | 이유 |
| --- | --- | --- |
| raw 스키마의 원천 입력 | source() | 프로젝트 바깥 입력이기 때문 |
| 같은 dbt 프로젝트의 다른 모델 | ref() | DAG와 build 순서를 자동으로 관리하기 때문 |
| seed 파일 | 보통 ref() | dbt가 생성한 리소스로 다루기 때문 |

5-3. source freshness를 초보자답게 이해하기

freshness는 ‘원천이 얼마나 최근 상태인가’를 보는 장치다. loaded_at_field가 있어야 dbt가 가장 최근 적재 시각을 계산할 수 있고, warn_after·error_after를 정의하면 배치나 모니터링에서 기준을 세울 수 있다.

| YAML · freshness 예시 sources: - name: raw loaded_at_field: ingested_at freshness: warn_after: {count: 6, period: hour} error_after: {count: 24, period: hour} |
| --- |

| BASH dbt source freshness dbt build --select "source_status:fresher+" |
| --- |

| 결과를 어디서 보나 • 콘솔 출력에서 각 source의 freshness 상태를 바로 볼 수 있다. • target/sources.json은 freshness 결과를 남기는 artifact다. • 운영 환경에서는 freshness 통과 후 downstream build를 이어서 실행하는 패턴을 자주 쓴다. |
| --- |

5-4. 레코드 추적: 5003이 source에서 staging으로 넘어갈 때

5003번 주문을 읽는 방식 비교

| 방식 | 예시 | 무엇이 달라지나 |
| --- | --- | --- |
| 하드코딩 | from raw.orders | docs에 원천 계약이 드러나지 않고 rename 대응이 약하다 |
| source() | from {{ source('raw', 'orders') }} | lineage 시작점, freshness, source test와 연결된다 |
| ref() downstream | from {{ ref('stg_orders') }} | 환경별 relation 이름이 달라도 코드가 흔들리지 않는다 |

| 팀 규칙 제안 ‘원천을 직접 읽는 첫 모델은 무조건 source()에서 시작한다’는 한 줄 규칙만 정해도 품질이 크게 올라간다. source 레벨 설명과 테스트를 붙이기 쉬워지고, raw rename 같은 변화에 대응하기도 쉬워진다. |
| --- |

| 안티패턴 source 선언이 이미 있는데도 습관처럼 raw.orders 같은 relation 이름을 직접 적는 것. 눈앞의 한 줄은 짧아져도 프로젝트 전체의 계약은 약해진다. |
| --- |

| 직접 해보기 1. sources.yml에 products 테이블 설명 한 줄과 product_id not_null/unique 테스트를 추가한다. 2. loaded_at_field와 freshness block을 넣고 dbt source freshness를 실행한다. 3. stg_orders.sql에서 source() 대신 raw.orders를 직접 적었다고 가정할 때 어떤 점이 나빠지는지 세 가지 적는다. 정답 확인 기준: source(), ref(), loaded_at_field가 각각 무엇과 연결되는지 말할 수 있으면 성공이다. |
| --- |

| 완료 체크리스트 • □ source와 ref의 차이를 구분할 수 있다. • □ source freshness의 목적을 설명할 수 있다. • □ 하드코딩이 왜 위험한지 실무 관점에서 말할 수 있다. |
| --- |

--select와 DAG 제어

| 필수 | 처음 읽는 사람은 장 끝의 ‘직접 해보기’를 반드시 해 본다. 이해가 아니라 손의 감각을 남기는 것이 목표다. |
| --- | --- |

| 이 장에서 배우는 것 • plus 연산자와 이름·태그·test_type selector의 기본을 익힌다. • dbt ls로 실행 범위를 먼저 확인하는 습관을 만든다. • dbt show를 활용해 한 노드의 결과를 빠르게 훑어보는 방법을 배운다. | 완료 기준 • model, +model, model+, +model+의 차이를 예로 들 수 있다. • 복잡한 선택식을 바로 실행하지 않고 먼저 ls로 확인할 수 있다. • data test와 unit/singular test를 선택적으로 돌릴 수 있다. |
| --- | --- |

6-1. 왜 --select가 중요한가

초보자일수록 매번 전체 프로젝트를 실행하고 싶어진다. 하지만 실무에서는 전체 실행보다 필요한 범위를 정확하게 좁히는 능력이 훨씬 중요하다. 선택 실행을 잘 쓰면 실패 범위를 줄일 수 있고, 내가 건드린 모델의 upstream/downstream 영향을 더 또렷하게 볼 수 있다.

먼저 몸에 익힐 네 가지 패턴

| 명령 | 의미 | 언제 쓰는가 |
| --- | --- | --- |
| dbt run -s stg_orders | 현재 모델만 | 수정 직후 가장 빠른 확인 |
| dbt run -s stg_orders+ | 현재 + downstream | 내 변경이 mart까지 어떻게 퍼지는지 확인 |
| dbt run -s +fct_orders | 현재 + upstream | fact가 이상할 때 입력 쪽을 함께 확인 |
| dbt run -s +fct_orders+ | 양방향 포함 | 영향 범위를 크게 보고 싶을 때 |

6-2. 선택 결과는 먼저 dbt ls로 본다

| BASH dbt ls -s +fct_orders+ dbt ls -s tag:daily dbt ls -s test_type:generic dbt ls -s test_type:singular dbt ls -s test_type:unit |
| --- |

복잡한 selector는 생각보다 자주 예상과 다르게 잡힌다. 그래서 바로 build를 누르기보다 ls로 먼저 확인하는 습관이 실수를 크게 줄여 준다. 특히 plus 연산자와 태그, path, fqn이 섞이기 시작하면 이 습관의 가치가 더 커진다.

6-3. 자주 쓰는 selector 조합

| 선택 기준 | 예시 | 메모 |
| --- | --- | --- |
| 이름 | dbt run -s stg_orders | 가장 기본적인 확인 |
| 폴더 | dbt build -s models/marts | 레이어 단위 점검 |
| 태그 | dbt run -s tag:daily | 배치 주기별 그룹핑 |
| 테스트 타입 | dbt test -s test_type:generic | 품질 규칙만 먼저 확인 |
| state | dbt build -s state:modified+ | 운영/CI 장에서 다시 다룸 |

6-4. dbt show는 언제 쓰나

dbt show는 단일 모델·테스트·analysis 또는 inline 쿼리를 컴파일하고 실행해 터미널에 결과를 미리 보여 주는 명령이다. 이미 만들어진 테이블을 그냥 읽는 명령이 아니라, 선택한 정의를 기준으로 컴파일하고 warehouse(또는 DuckDB)에 질의한다는 점이 포인트다.

| BASH dbt show --select fct_orders dbt show --select stg_orders |
| --- |

| 처음엔 여기까지만 익혀도 충분하다 • 이름 선택 • plus 연산자 • dbt ls • test_type 선택 • dbt show |
| --- |

| 안티패턴 ‘어차피 몇 개 안 되는데’라는 이유로 항상 전체 build만 돌리는 것. 프로젝트가 커질수록 가장 비싼 습관이 된다. |
| --- |

| 직접 해보기 1. stg_orders를 바꾼 뒤 dbt ls -s stg_orders+로 어떤 downstream 모델이 선택되는지 적어 본다. 2. dbt test -s test_type:generic 과 dbt test -s test_type:unit을 각각 실행해 무엇이 달라지는지 본다. 3. dbt show --select fct_orders를 실행해 결과 상단 몇 줄을 확인한다. 정답 확인 기준: 전체 build를 누르지 않고도 수정 범위를 점검할 수 있다는 감각이 생기면 성공이다. |
| --- |

| 완료 체크리스트 • □ plus 연산자의 방향을 알고 있다. • □ dbt ls로 범위를 먼저 보는 이유를 설명할 수 있다. • □ test_type selector와 dbt show의 용도를 안다. |
| --- |

계층형 모델링과 grain 클리닉

| 필수 | 처음 읽는 사람은 장 끝의 ‘직접 해보기’를 반드시 해 본다. 이해가 아니라 손의 감각을 남기는 것이 목표다. |
| --- | --- |

| 이 장에서 배우는 것 • 레이어별 책임 경계를 이해한다. • grain, business key, fanout을 예제로 설명할 수 있다. • join 전에 행의 단위를 먼저 적는 습관을 만든다. | 완료 기준 • staging에서 무엇을 하고 무엇을 하지 말아야 하는지 안다. • intermediate가 왜 reusable join의 자리인지 설명할 수 있다. • 중복 집계가 왜 발생하는지와 어떤 검증을 붙일지 말할 수 있다. |
| --- | --- |

7-1. 레이어를 나누는 이유

레이어를 나누는 목적은 파일을 예쁘게 정리하려는 것이 아니다. 변경 비용을 줄이고, 테스트 지점을 선명하게 만들고, 실수했을 때 어디서 잘못됐는지 빨리 찾기 위해서다. 이름 정리와 타입 캐스팅, 재사용 가능한 조인, 최종 집계가 한 파일에 섞이면 문제를 좁히기가 급격히 어려워진다.

| 레이어 | 주된 역할 | 가급적 피할 일 |
| --- | --- | --- |
| staging | rename, cast, 상태값 표준화, 기본 정리 | 복잡한 조인, 최종 KPI 확정 |
| intermediate | 재사용 가능한 조인, 계산 컬럼 분리 | 최종 fact/dim 역할까지 동시에 맡기기 |
| marts | 분석용 최종 구조, fact/dim, KPI | 원천 정리 로직 재반복 |

```mermaid
flowchart TB
    A[orders<br/>grain: order_id] --> J{{JOIN}}
    B[order_items<br/>grain: order_item_id] --> J
    J --> C[행 수 증가(팬아웃 위험)]
    C --> D[order grain 재집계 필요]
```

*그림 7-1. grain을 적지 않고 join부터 시작하면 fanout이 생기기 쉽다*

7-2. grain은 ‘한 행이 무엇을 대표하는가’다

grain은 모델링에서 가장 먼저 적어야 하는 질문이다. stg_orders의 grain은 주문 1행, stg_order_items의 grain은 주문상품 1행, int_order_lines도 주문상품 1행을 유지한다. fct_orders로 올라갈 때 비로소 grain이 다시 주문 1행으로 바뀐다.

| 초보자 메모 join을 쓰기 전에 ‘지금 이 모델의 한 행은 무엇을 대표하는가?’를 문서나 주석에 먼저 적어 보자. 이 한 줄이 fanout을 크게 줄여 준다. |
| --- |

7-3. 레코드 추적: 5003은 intermediate에서 어떻게 풀리나

day1의 5003번 주문 라인

| order_item_id | product_id | 수량 | 단가 | 할인 | line_amount |
| --- | --- | --- | --- | --- | --- |
| 5 | 105 | 1 | 8.5 | 0.0 | 8.5 |
| 6 | 103 | 2 | 4.0 | 0.5 | 7.5 |

intermediate는 이런 라인 정보를 주문 헤더와 상품 정보와 결합하지만, grain은 여전히 주문상품 1행으로 유지된다. 그 덕분에 downstream의 상품 분석, 카테고리 분석, 주문 집계가 모두 같은 중간 모델을 재사용할 수 있다.

| SQL · int_order_lines.sql with orders as ( select * from {{ ref('stg_orders') }} ), items as ( select * from {{ ref('stg_order_items') }} ), products as ( select * from {{ ref('stg_products') }} ) select i.order_item_id, i.order_id, o.customer_id, o.order_date, o.order_status, o.payment_method, o.store_id, o.shipping_fee, i.product_id, p.product_sku, p.product_name, p.category_code, p.category_name, i.quantity, i.unit_price, i.discount_amount, i.line_amount from items i join orders o using (order_id) join products p using (product_id) |
| --- |

7-4. fanout은 왜 생기나

fanout은 보통 서로 다른 grain의 테이블을 조인한 뒤, 원래보다 더 많은 행이 생겼는데 이를 인지하지 못하고 집계해 버릴 때 생긴다. 예를 들어 주문 1행 모델과 주문상품 다행 모델을 합친 뒤 grain을 다시 주문 1행으로 올리지 않으면, gross_revenue가 주문상품 수만큼 늘어나 버릴 수 있다.

| 검증 포인트 | 왜 보나 | 실전 팁 |
| --- | --- | --- |
| row count | 예상보다 행이 늘었는가 | 조인 전후 count(*)를 기록해 둔다 |
| 합계 비교 | 금액이 두 배·세 배가 되지 않았는가 | raw 총합과 intermediate/mart 총합을 비교한다 |
| 고유키 테스트 | order_id가 중복되지 않는가 | marts의 unique test는 마지막 안전망이다 |
| relationships 테스트 | 차원 참조가 끊기지 않았는가 | fanout 자체를 모두 잡지는 못하지만 정합성 오류를 찾는다 |

| 비즈니스 규칙은 별도 결정이 필요하다 교재 예제의 5003번 주문은 day2에 cancelled가 되지만, fct_orders는 여전히 line_amount 합계를 유지한다. 이처럼 ‘취소 주문 매출을 0으로 볼지’는 모델링 규칙의 영역이다. 중요한 것은 규칙을 어디에 두고 어떤 테스트로 보호할지 명시하는 것이다. |
| --- |

| 안티패턴 모델을 열자마자 join부터 짜는 것. 한 행의 단위를 먼저 정의하지 않으면 나중에 왜 값이 두 배가 되었는지 설명하기 어렵다. |
| --- |

| 직접 해보기 1. stg_orders, stg_order_items, int_order_lines, fct_orders 각각의 grain을 한 줄로 적는다. 2. 주문 5003의 gross_revenue가 intermediate와 mart에서 어떻게 계산되는지 손으로 다시 합산해 본다. 3. 취소 주문의 order_amount를 0으로 처리할지 말지 팀 규칙을 한 문장으로 써 본다. 정답 확인 기준: grain을 적고 나서 join을 생각하게 되면 성공이다. |
| --- |

| 완료 체크리스트 • □ 레이어별 책임을 구분할 수 있다. • □ grain과 fanout을 예로 설명할 수 있다. • □ 5003 주문이 intermediate에서 어떻게 풀리는지 안다. |
| --- |

Materializations와 incremental 실전

| 필수 | 처음 읽는 사람은 장 끝의 ‘직접 해보기’를 반드시 해 본다. 이해가 아니라 손의 감각을 남기는 것이 목표다. |
| --- | --- |

| 이 장에서 배우는 것 • 대표 materialization의 특징을 비교한다. • incremental 모델에서 is_incremental(), unique_key, on_schema_change의 역할을 이해한다. • late-arriving data와 full-refresh를 어떻게 생각해야 하는지 익힌다. | 완료 기준 • 왜 초보자에게 staging=view, marts=table이 안전한 출발점인지 설명할 수 있다. • incremental을 성능 최적화 수단으로 이해하고, 설계가 불명확할 때 서두르지 않게 된다. • companion ZIP의 incremental 데모 파일을 읽고 흐름을 해석할 수 있다. |
| --- | --- |

8-1. 결과를 어떤 형태로 남길지 정하는 것이 materialization이다

| 유형 | 특징 | 입문자 기준 사용 감각 |
| --- | --- | --- |
| view | 쿼리 정의만 저장 | staging과 가벼운 intermediate에 적합 |
| table | 실행 결과를 테이블로 저장 | 자주 조회되는 marts의 기본 선택 |
| incremental | 새 데이터 중심으로 갱신 | 전체 재생성이 비쌀 만큼 커졌을 때 검토 |
| ephemeral | 상위 모델에 인라인 | 아주 작은 helper 로직에 한정 |

| 안전한 출발점 입문 단계에서는 incremental보다 정확한 모델 구조와 테스트를 먼저 확보하는 편이 낫다. 성능 문제를 해결하려고 incremental을 붙였는데, 설계가 모호하면 오히려 누락과 중복을 더 오래 숨기게 된다. |
| --- |

8-2. incremental을 붙이기 전에 묻는 네 가지

1. 새로 들어온 행을 구분할 기준 컬럼(updated_at 등)이 있는가?

2. 기존 행이 수정(update)될 수 있는가? 그러면 unique_key는 무엇인가?

3. late-arriving data가 들어오면 어디까지 다시 읽어야 하는가?

4. 문제가 생겼을 때 full-refresh로 복구할 수 있는가?

8-3. companion ZIP의 incremental 데모 읽기

| SQL · optional_examples/fct_orders_incremental_demo.sql {{ config( materialized='incremental', unique_key='order_id', on_schema_change='append_new_columns' ) }} with orders as ( select * from {{ ref('stg_orders') }} {% if is_incremental() %} where updated_at >= ( select coalesce(max(updated_at), cast('1900-01-01' as timestamp)) from {{ this }} ) {% endif %} ), lines as ( select * from {{ ref('int_order_lines') }} where order_id in (select order_id from orders) ) select order_id, customer_id, min(order_date) as order_date, max(order_status) as order_status, round(sum(line_amount), 2) as gross_revenue from lines group by 1, 2 -- 이 파일은 교재용 데모이며 기본 build 흐름에는 포함하지 않는다. |
| --- |

이 예제는 updated_at을 기준으로 새로 바뀐 주문만 다시 읽고, 해당 order_id에 해당하는 라인만 재집계한다. 여기서 중요한 것은 materialized='incremental' 자체보다도 is_incremental() 안에서 어떤 범위를 읽는지, 그리고 unique_key로 무엇을 약속하는지다.

8-4. late-arriving data와 backfill window

현실에서는 데이터가 순서대로 깔끔하게 들어오지 않는다. 하루 늦게 도착한 주문, 수정된 과거 행, 배치 실패 후 재적재가 생긴다. 그래서 updated_at >= max(updated_at)처럼 딱 잘라 읽는 방식은 종종 너무 낙관적이다. 안전하게는 최근 N일 또는 N시간을 다시 읽는 backfill window를 두는 편이 낫다.

| SQL · backfill window 아이디어 {% if is_incremental() %} where updated_at >= ( select coalesce(max(updated_at) - interval '2 day', cast('1900-01-01' as timestamp)) from {{ this }} ) {% endif %} |
| --- |

8-5. full-refresh와 on_schema_change

| 항목 | 언제 떠올리나 | 메모 |
| --- | --- | --- |
| full-refresh | 로직을 크게 바꿨거나 과거 누락을 한 번에 다시 계산할 때 | incremental의 안전장치이자 복구 수단 |
| unique_key | upsert/merge 기준이 필요할 때 | 주문처럼 비즈니스 키가 분명한 모델에 중요 |
| on_schema_change | 컬럼이 새로 생기거나 구조가 바뀔 때 | append_new_columns 같은 전략을 팀 합의와 함께 사용 |

| 초보자 안티패턴 모델이 느려 보인다는 이유만으로 곧바로 incremental로 바꾸는 것. 어떤 행이 새 행인지, 수정 행인지, 과거 재계산 범위가 무엇인지 정의하지 않은 incremental은 ‘조용히 틀리는 모델’이 되기 쉽다. |
| --- |

| 안티패턴 incremental을 도입한 뒤에는 안전망이 필요 없다고 생각하는 것. 오히려 test와 full-refresh 전략이 더 중요해진다. |
| --- |

| 직접 해보기 1. optional_examples의 incremental 데모 파일을 열고, is_incremental() 블록이 어떤 order_id를 다시 읽는지 주석으로 설명한다. 2. 5003 주문처럼 day2에 상태가 바뀌는 사례를 떠올리며 updated_at만으로 충분한지 생각해 본다. 3. ‘우리 팀은 언제 full-refresh를 허용할까?’를 한 문장 규칙으로 적는다. 정답 확인 기준: incremental을 ‘빠르게 만드는 옵션’이 아니라 ‘다시 읽을 범위를 설계하는 패턴’으로 이해하면 성공이다. |
| --- |

| 완료 체크리스트 • □ 대표 materialization의 특징을 비교할 수 있다. • □ is_incremental, unique_key, full-refresh의 의미를 설명할 수 있다. • □ late-arriving data가 왜 문제인지 안다. |
| --- |

| 이 장을 읽고 예제 케이스북에서 다시 보게 되는 것 Retail Orders에서는 주문 한 건이 source에서 mart까지 어떻게 바뀌는지, Event Stream에서는 append-only raw가 incremental과 session으로 어떻게 조직되는지, Subscription & Billing에서는 상태 변화가 snapshot과 contracts, semantic metric으로 어떻게 연결되는지를 다시 본다. |
| --- |

fanout을 그림으로 다시 보기

materialization을 “저장 형태”가 아니라 “운영 결정”으로 보기

view, table, incremental, ephemeral은 문법이 아니라 운영 선택이다. 어떤 플랫폼에서는 view가 거의 공짜처럼 느껴질 수 있고, 어떤 플랫폼에서는 full scan 비용이 문제를 만들 수 있다. 또 어떤 예제에서는 incremental이 자연스럽지만, grain이 아직 흔들리는 초반 설계에서는 오히려 incremental을 미루는 편이 낫다. 이런 판단은 뒤의 Event Stream과 BigQuery/ClickHouse 플레이북에서 특히 선명하게 드러난다.
