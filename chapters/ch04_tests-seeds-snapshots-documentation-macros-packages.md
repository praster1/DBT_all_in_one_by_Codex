CHAPTER 04

Tests, Seeds, Snapshots, Documentation, Macros, Packages

신뢰 가능한 프로젝트를 만드는 품질 계층을 한 챕터로 묶는다.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

좋은 dbt 프로젝트는 SQL만 있는 저장소가 아니라, 품질과 의미가 함께 저장된 프로젝트다. generic·singular·unit test는 데이터와 로직의 가정을 고정하고, seed와 snapshot은 프로젝트 내부의 작은 기준표와 상태 이력을 다루게 해 주며, 문서화와 macro와 package는 반복성과 가독성을 함께 챙기게 만든다.

이 장은 품질 계층을 작은 기능들의 나열로 다루지 않고 “왜 이 모델을 믿어도 되는가”를 설명하는 장치들의 묶음으로 정리한다. 특히 snapshot과 contracts, docs와 metadata, macro와 package의 경계처럼 헷갈리기 쉬운 지점도 함께 정리한다.

generic·singular·unit test

| 필수 | 처음 읽는 사람은 장 끝의 ‘직접 해보기’를 반드시 해 본다. 이해가 아니라 손의 감각을 남기는 것이 목표다. |
| --- | --- |

| 이 장에서 배우는 것 • generic data test, singular data test, unit test의 차이를 이해한다. • 어떤 테스트를 models/.yml에 두고 어떤 테스트를 tests/ 폴더에 두는지 구분한다. • 실패 메시지를 보고 데이터 문제와 로직 문제를 나눠 보는 법을 익힌다. | 완료 기준 • 핵심 키 컬럼에 기본 generic test를 붙일 수 있다. • singular test 한 개를 직접 작성할 수 있다. • unit test로 계산 로직을 작게 검증하는 이유를 설명할 수 있다. |
| --- | --- |

9-1. 테스트는 모델의 일부다

dbt를 쓰는 큰 이유 중 하나는 검증 규칙을 모델 옆에 남길 수 있다는 점이다. 눈으로 결과를 보는 확인은 한번은 할 수 있지만, 매 배치마다 똑같이 하기 어렵다. 테스트는 그 반복 가능한 확인을 프로젝트 안에 남기는 장치다.

| 축 | 무엇을 검증하나 | 대표 예시 | 보통 두는 곳 |
| --- | --- | --- | --- |
| generic data test | 실제 데이터의 성질 | not_null, unique, relationships, accepted_values | models/*.yml |
| singular data test | 실패 행을 직접 SQL로 정의 | 음수 금액, 조인 불일치 행 찾기 | tests/*.sql |
| unit test | 작은 입력 → 기대 출력 | 할인 계산, 취소 주문 처리 | models/*.yml |

9-2. generic test는 가장 먼저 붙이는 안전망

| YAML · marts.yml 일부 version: 2 models: - name: fct_orders columns: - name: order_id data_tests: - not_null - unique - name: customer_id data_tests: - relationships: to: ref('dim_customers') field: customer_id |
| --- |

order_id, customer_id, order_date처럼 모델의 정체성을 이루는 컬럼에는 generic test를 먼저 붙이자. 초보자에게는 이것만으로도 많은 문제를 조기에 발견할 수 있다.

9-3. singular test는 자유 SQL로 실패 행을 찾는다

| SQL · tests/assert_no_negative_order_amount.sql select * from {{ ref('fct_orders') }} where order_amount < 0 |
| --- |

singular test의 요점은 ‘실패 행을 반환하는 SQL’을 직접 쓴다는 데 있다. 복잡한 규칙이 generic test로는 표현되지 않을 때 특히 유용하다. tests/ 디렉터리가 바로 이 자유도를 위한 공간이다.

9-4. unit test는 계산 로직을 작은 입력으로 고정한다

| YAML · unit test 예시 unit_tests: - name: fct_orders_sums_line_amount model: fct_orders given: - input: ref('int_order_lines') rows: - {order_id: 1, customer_id: 10, order_date: '2026-01-01', line_amount: 100, quantity: 1} - {order_id: 1, customer_id: 10, order_date: '2026-01-01', line_amount: 40, quantity: 2} expect: rows: - {order_id: 1, customer_id: 10, order_date: '2026-01-01', gross_revenue: 140, item_count: 3} |
| --- |

| 5003 주문을 UNIT TEST 과제로 바꾸기 day2의 5003 주문을 cancelled로 바꿨을 때 order_amount를 0으로 볼지 16.0으로 볼지는 business rule이다. 이 규칙은 사람 머릿속이 아니라 unit test로 남겨 두어야 다음 수정에서 흔들리지 않는다. |
| --- |

9-5. 테스트 선택과 실패 해석

| BASH dbt test --select test_type:generic dbt test --select test_type:singular dbt test --select test_type:unit dbt build --select fct_orders+ |
| --- |

| 실패 유형 | 먼저 생각할 질문 | 다음 행동 |
| --- | --- | --- |
| generic test 실패 | 실제 데이터가 규칙을 어겼나, 조인 로직이 잘못됐나 | 관련 모델과 upstream source를 본다 |
| singular test 실패 | 내가 정의한 금지 행이 실제로 생겼나 | 실패 행을 직접 읽고 business rule을 확인한다 |
| unit test 실패 | 기대값이 잘못됐나, SQL 계산이 잘못됐나 | 입력 행과 기대 출력부터 다시 본다 |

| 안티패턴 SQL 결과를 눈으로 한 번 보고 ‘맞는 것 같다’고 끝내는 것. 그 순간에는 맞아 보여도 다음 배치에서 똑같이 확인할 수 없다. |
| --- |

| 직접 해보기 1. fct_orders의 order_id와 customer_id 컬럼에 generic test를 붙인다. 2. tests/ 아래에 ‘order_amount < 0 금지’ singular test를 만든다. 3. 5003의 취소 주문 처리 규칙을 한 문장으로 정한 뒤, 그 규칙을 unit test로 어떻게 남길지 초안을 써 본다. 정답 확인 기준: 세 가지 테스트의 목적과 위치를 헷갈리지 않으면 성공이다. |
| --- |

| 완료 체크리스트 • □ generic, singular, unit test의 차이를 안다. • □ tests/ 폴더의 의미를 이해한다. • □ 실패 메시지를 보고 다음에 어디를 볼지 정할 수 있다. |
| --- |

Seeds와 Snapshots

| 필수 | 처음 읽는 사람은 장 끝의 ‘직접 해보기’를 반드시 해 본다. 이해가 아니라 손의 감각을 남기는 것이 목표다. |
| --- | --- |

| 이 장에서 배우는 것 • seed의 적합한 용도와 한계를 이해한다. • snapshot을 current-state 테이블의 이력 보존 장치로 해석한다. • YAML 기반 snapshot 구성이 현재 기본 안내라는 점을 익힌다. | 완료 기준 • seed, source, snapshot의 차이를 한 표로 설명할 수 있다. • day1/day2 데이터로 5003 주문 상태 이력을 추적할 수 있다. • snapshot 결과에서 ‘중복처럼 보이는 행’이 왜 생기는지 이해한다. |
| --- | --- |

10-1. seed는 작고 안정적인 참조 데이터다

seed는 원천 시스템의 대체물이 아니다. 국가 코드, 세그먼트 매핑, 작은 기준표처럼 ‘프로젝트 안에서 버전 관리하는 편이 오히려 명확한’ 데이터를 relation로 올리는 장치다. 크고 자주 바뀌는 원천 데이터를 seed로 들고 오기 시작하면 금세 관리가 어려워진다.

| CSV · seeds/country_codes.csv country_code,country_name KR,South Korea US,United States JP,Japan |
| --- |

10-2. snapshot은 상태 변화의 버전을 남긴다

snapshot은 current-state 테이블에서 과거 상태를 되돌아보고 싶을 때 쓰는 장치다. 주문 상태가 paid → shipped → completed 또는 cancelled로 바뀌는데 원천이 마지막 상태만 남긴다면, 나중에 특정 날짜에 어떤 상태였는지 알기 어렵다. snapshot은 이 변화를 row version 형태로 보존한다.

| YAML · snapshots/orders_snapshot.yml snapshots: - name: orders_snapshot relation: ref('stg_orders') config: schema: snapshots unique_key: order_id strategy: check check_cols: - order_status - total_amount updated_at: updated_at |
| --- |

| 현재 권장 방식 신규 snapshot은 YAML 기반 구성을 먼저 생각하자. 과거에는 SQL 파일 안 config 블록을 많이 썼지만, 최신 안내는 YAML 구성을 기본으로 둔다. 교재는 비교를 위해 두 방식을 모두 설명하되, 실습은 YAML 기준으로 진행한다. |
| --- |

10-3. 레코드 추적: 5003의 day1 ↔ day2 변화

raw.orders 기준 5003의 상태 변화

| 시점 | status | shipping_fee | total_amount | updated_at |
| --- | --- | --- | --- | --- |
| day1 | paid | 2.5 | 18.5 | 2026-03-04 10:50:00 |
| day2 | cancelled | 0.0 | 0.0 | 2026-03-10 08:10:00 |

이 사례에서 snapshot은 5003번 주문에 대해 최소 두 개의 버전을 남긴다. 초보자에게는 이것이 ‘중복 행’처럼 보이기 쉽지만, 실제로는 서로 다른 유효 구간을 가진 이력 행이다.

snapshot을 해석하는 최소 감각

| 질문 | 생각할 포인트 |
| --- | --- |
| 왜 같은 order_id가 여러 번 나오지? | 이력 저장 구조이기 때문. current row와 historical row를 구분해야 한다 |
| downstream은 뭘 읽어야 하지? | 현재 상태만 필요하면 current row만, 과거 분석이면 특정 시점 기준으로 본다 |
| source에 CDC가 이미 있으면? | snapshot이 꼭 필수는 아니다. 원천 이력 테이블을 그대로 모델링해도 된다 |

10-4. source / seed / snapshot을 한눈에 구분하기

| 리소스 | 주된 용도 | 대표 예시 |
| --- | --- | --- |
| source | 프로젝트 바깥 원천 입력 선언 | raw.orders, raw.customers |
| seed | 작고 안정적인 참조 데이터 | country_codes.csv, segment_mapping.csv |
| snapshot | 상태 변화 이력 보존 | orders_snapshot |

| BASH · snapshot 데모 python scripts/load_raw_to_duckdb.py --database ./dbt_book_lab.duckdb --day day1 dbt snapshot python scripts/load_raw_to_duckdb.py --database ./dbt_book_lab.duckdb --day day2 dbt snapshot |
| --- |

| 안티패턴 원천 이력 전체를 seed로 관리하거나, snapshot을 ‘모든 이력 문제의 만능 해법’으로 생각하는 것. |
| --- |

| 직접 해보기 1. day1 데이터를 적재하고 dbt snapshot을 실행한다. 2. day2로 raw를 바꾼 뒤 다시 dbt snapshot을 실행한다. 3. 5003 주문이 왜 두 버전으로 남는지 스스로 설명해 본다. 정답 확인 기준: seed와 snapshot의 차이를 명확히 구분하고, 같은 key의 여러 행이 왜 생기는지 이해하면 성공이다. |
| --- |

| 완료 체크리스트 • □ seed와 snapshot의 역할을 구분할 수 있다. • □ YAML snapshot 구성이 왜 기본인지 이해한다. • □ 5003의 상태 변화를 이력 관점에서 설명할 수 있다. |
| --- |

문서화·Jinja·Macros·Packages

| 필수 | 처음 읽는 사람은 장 끝의 ‘직접 해보기’를 반드시 해 본다. 이해가 아니라 손의 감각을 남기는 것이 목표다. |
| --- | --- |

| 이 장에서 배우는 것 • dbt docs generate/serve의 역할을 이해한다. • Jinja의 기본 문법과 macro의 최소 용도를 익힌다. • package가 독립된 dbt 프로젝트라는 점과 dbt deps의 역할을 안다. | 완료 기준 • 모델 설명, 컬럼 설명, 테스트가 왜 함께 있어야 하는지 설명할 수 있다. • macro는 반복이 명확할 때만 도입해야 한다는 감각이 생긴다. • packages.yml과 dbt deps가 어떤 흐름인지 이해한다. |
| --- | --- |

11-1. 문서화는 나중 일이 아니다

좋은 dbt 모델은 SQL, 설명, 테스트가 따로 놀지 않는다. SQL은 계산을 말하고, 설명은 왜 존재하는지를 말하고, 테스트는 어떤 가정을 깨뜨리면 안 되는지를 말한다. 이 셋이 함께 있어야 팀원이 모델을 믿고 다시 쓸 수 있다.

| YAML · 설명 예시 version: 2 models: - name: fct_orders description: "주문 단위 매출과 수량을 담는 사실 테이블" columns: - name: order_id description: "주문의 비즈니스 키" - name: gross_revenue description: "주문 라인 금액 합계 |
| --- |

| BASH dbt build dbt docs generate dbt docs serve |
| --- |

11-2. Jinja는 SQL을 조금 더 유연하게 쓰게 해 준다

| 표기 | 용도 | 예시 |
| --- | --- | --- |
| {{ ... }} | 값 출력, 함수 결과 삽입 | {{ ref('stg_orders') }} |
| {% ... %} | 조건문, 반복문, 제어 흐름 | {% if is_incremental() %} |
| {# ... #} | 주석 | {# this is a comment #} |

11-3. macro는 언제 쓰고 언제 미루나

같은 SQL 조각이 여러 모델에서 반복되고, 함께 바뀌어야 한다면 macro 후보가 된다. 하지만 초보자가 너무 이르게 macro로 추상화하면 오히려 compiled SQL을 읽기 어려워지고, 팀원이 코드를 따라가기 힘들어진다. 먼저 명확한 모델을 만들고, 반복이 세 번 이상 보일 때 도입해도 늦지 않다.

| SQL · macros/normalize_blank.sql {% macro normalize_blank(column_name) %} case when trim({{ column_name }}) = '' then null else {{ column_name }} end {% endmacro %} |
| --- |

11-4. package는 다른 dbt 프로젝트를 가져오는 것이다

package는 단순 라이브러리가 아니라, models·macros·tests 등을 가진 독립된 dbt 프로젝트다. 그래서 package를 추가하면 그 리소스가 내 프로젝트의 일부처럼 동작한다. 유용하지만, 초보자에게는 ‘왜 이 코드가 갑자기 생겼지?’라는 혼란을 줄 수도 있으므로 남용하지 않는 편이 좋다.

| YAML · packages.example.yml packages: - package: dbt-labs/dbt_utils version: [">=1.1.0", "<2.0.0"] |
| --- |

| BASH dbt deps |
| --- |

| 패키지 팁 • 처음에는 package 없이도 충분히 배울 수 있다. • 패키지를 쓸 때는 버전 범위를 명시하고, 왜 들여왔는지 README에 적어 두자. • 나중에 Fusion으로 옮길 가능성이 있다면 호환 여부와 require-dbt-version을 확인하는 습관이 좋다. |
| --- |

| 안티패턴 같은 로직이 두 번 반복됐다는 이유만으로 곧바로 거대한 macro를 만드는 것. 가독성과 온보딩 비용이 더 커질 수 있다. |
| --- |

| 직접 해보기 1. fct_orders에 description 두 줄을 보강한다. 2. 반복되는 컬럼 정리 로직이 있다면 macro 후보인지 아닌지 이유를 적는다. 3. packages.example.yml을 읽고 dbt deps가 어떤 역할인지 한 문장으로 요약한다. 정답 확인 기준: 설명·테스트·SQL이 함께 있어야 모델 의도가 완성된다는 점을 이해하면 성공이다. |
| --- |

| 완료 체크리스트 • □ docs generate 흐름을 안다. • □ Jinja 기본 표기를 구분할 수 있다. • □ packages와 dbt deps의 역할을 이해한다. |
| --- |

고급 테스트·문서화·메타데이터

quality gate와 metadata를 조금 더 운영 친화적으로 읽는다.

O-1. 테스트는 실패 여부만이 아니라 “어떻게 실패를 남길지”까지 설계한다

| 설정 | 무엇을 바꾸나 | 언제 유용한가 |
| --- | --- | --- |
| severity | warn / error | 배포를 막을지, 경고로만 남길지 구분할 때 |
| error_if / warn_if | 실패 임계치 | 실패 건수가 1건이면 error, 특정 비율 이상이면 warn처럼 다르게 둘 때 |
| where | 테스트 범위 제한 | 최근 n일 데이터만 점검하거나 활성 행만 볼 때 |
| store_failures | 실패 행 저장 여부 | 문제 행을 triage 테이블로 남기고 싶을 때 |
| store_failures_as | view / table / ephemeral | 실패 결과를 어떤 relation으로 남길지 정할 때 |
| fail_calc / limit | 실패 계산식·샘플 제한 | 대용량 테스트 결과를 현실적으로 다룰 때 |

O-2. selectors.yml과 indirect_selection은 팀 규칙을 코드화한다

selectors:

- name: ci_core

definition:

union:

- method: state

value: modified+

indirect_selection: buildable

- method: tag

value: critical

indirect_selection을 eager, cautious, buildable 중 무엇으로 두느냐에 따라 “연결된 테스트를 얼마나 공격적으로 함께 고를지”가 달라진다. 개인 개발에서는 eager가 편하지만, CI에서는 buildable이나 cautious가 더 예측 가능한 경우가 많다.

O-3. 문서화는 description만이 아니다

| 기능 | 핵심 역할 | 메모 |
| --- | --- | --- |
| docs block + doc() | 긴 설명과 공통 설명 조각 재사용 | 모델/컬럼 설명을 더 DRY하게 관리할 수 있다. |
| persist_docs | warehouse comments로 설명 남기기 | 지원 여부와 mixed-case 주의사항을 adapter별로 확인한다. |
| meta | manifest에 팀 메타데이터 남기기 | owner, pii, domain, sla 같은 태그를 코드로 남길 때 좋다. |
| query-comment | 실행 쿼리에 메타데이터 태그 남기기 | 특히 BigQuery에서는 job labels와 함께 비용 추적에 유용하다. |

| 품질 운영 루틴1) 핵심 model에 기본 data test를 붙인다.2) 실패가 자주 나는 test에는 warn/error 임계치를 설계한다.3) store_failures로 triage 테이블을 남긴다.4) meta와 query-comment로 owner·도메인·비용 추적 정보를 함께 남긴다. |
| --- |

| 품질 계층의 핵심 질문 이 모델의 의도를 SQL 바깥에서도 설명할 수 있는가? tests는 깨지면 안 되는 가정을, snapshots는 시간에 따른 상태 변화를, docs와 metadata는 의미와 소비 경로를, macros와 packages는 반복성과 공유 범위를 설명한다. |
| --- |

세 예제에서 품질 계층이 달라지는 방식

Retail Orders에서는 핵심 키와 gross revenue 검증이 중요하고, Event Stream에서는 uniqueness보다 volume, late-arriving behavior, session logic 같은 흐름 검증이 중요하다. Subscription & Billing에서는 snapshot과 contract, semantic metric이 함께 붙을 때 품질 계층이 가장 입체적으로 보인다. 따라서 tests와 docs를 “모든 모델에 똑같이 붙이는 장식”이 아니라, 예제가 요구하는 신뢰 질문에 맞춘 조합으로 이해하는 편이 훨씬 실무적이다.

PART II · 신뢰성·운영·확장

신뢰성, 운영, 확장

이 파트에서는 “돌아가는 모델”을 넘어 “고장나도 좁혀서 고칠 수 있고, 팀으로 운영할 수 있는 프로젝트”를 만드는 방법을 다룬다.
