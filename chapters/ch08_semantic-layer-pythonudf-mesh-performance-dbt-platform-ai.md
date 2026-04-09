CHAPTER 08

Semantic Layer, Python/UDF, Mesh, Performance, dbt platform, AI

고급 기능을 따로따로 배우기보다, 공용 분석 API와 확장 가능한 운영 면으로 묶어서 이해한다.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

이 장에서 다루는 기능들은 각각 고급 주제처럼 보이지만, 사실은 모두 하나의 질문으로 연결된다. “모델 위에 어떤 안정적인 분석 API를 얹을 것인가, 그리고 그것을 여러 팀과 여러 도구와 여러 실행 환경에 어떻게 확장할 것인가.” semantic model, metric, saved query, Python model, UDF, mesh, performance tuning, dbt platform, AI surface는 모두 그 질문의 서로 다른 측면이다.

따라서 이 장은 기능별 백과사전이 아니라 구조적 연결을 먼저 강조한다. semantic은 정의층이고, Python/UDF는 표현층이며, mesh는 경계 관리이고, performance는 운영 비용이고, dbt platform과 AI는 소비 표면이다. 각 절을 그 관점으로 읽으면 고급 기능이 훨씬 덜 조각나 보인다.

Semantic Models · Metrics · Saved Queries

| 구분 | 로컬 | dbt platform | 핵심 메모 |
| --- | --- | --- | --- |
| 장 19 | 정의·MetricFlow(mf) query/validate 가능 | dbt sl, exports, caching, Universal Semantic Layer는 Starter+ 이상에서 체감이 커짐 | local Core/Fusion과 platform에서 명령 접두사와 운영 방식이 달라진다. |

19-1. semantic layer는 “정답이 되는 질문 단위”를 모델 위에 한 겹 더 올린다

일반 모델이 relation을 만든다면, semantic layer는 “어떤 지표를 어떤 차원으로 안전하게 묻는가”를 정의한다. semantic model은 entities, dimensions, measures를 기술하고, metrics는 measures를 사람이 소비하기 쉬운 분석 단위로 올리며, saved query는 자주 쓰는 metric + filter + dimension 조합을 노드처럼 저장한다. 이렇게 해 두면 BI 도구나 AI 질의가 매번 raw SQL을 새로 짜지 않아도 일관된 의미를 재사용할 수 있다.

중요: semantic 관련 문법과 지원 범위는 engine/track에 따라 변화가 있었고 앞으로도 바뀔 수 있다. 이 장은 사고방식과 구조를 익히기 위한 올인원 안내서로 읽고, 실제 배포 전에는 현재 사용 중인 engine 문서를 반드시 다시 확인하자.

19-2. semantic model의 최소 구성

semantic model을 설계할 때는 “이 model의 중심 entity가 무엇인가”, “시간의 기준 차원은 무엇인가”, “합산 가능한 measure는 무엇인가”부터 정한다. Retail의 fct_orders라면 order가 primary entity, order_date가 time dimension, gross_revenue가 sum measure가 될 수 있다. Event의 fct_daily_active_users라면 user 또는 session이 entity, event_date가 time dimension이 된다.

| semantic_models:  - name: orders_semantic    model: ref('fct_orders')    defaults:      agg_time_dimension: order_date    entities:      - name: order        type: primary        expr: order_id      - name: customer        type: foreign        expr: customer_id    dimensions:      - name: order_date        type: time        type_params:          time_granularity: day      - name: customer_segment        type: categorical    measures:      - name: gross_revenue        agg: sum        expr: gross_revenue |
| --- |

19-3. metric과 saved query는 “반복 질문”을 명시적으로 저장한다

metric은 measure를 business-friendly 이름으로 올린 것이다. 예를 들어 Retail의 revenue, Event의 dau, SaaS의 mrr가 여기에 해당한다. saved query는 자주 쓰는 분석 조합을 노드로 저장해 두는 방식이다. 예를 들어 “최근 90일간 segment별 revenue”, “주간 active users by platform”, “월별 plan별 MRR” 같은 쿼리를 저장해 두면 BI와 AI 모두 같은 의미 정의를 재사용하기 쉬워진다.

| metrics:  - name: revenue    label: Revenue    type: simple    type_params:      measure: gross_revenuesaved_queries:  - name: revenue_by_segment_90d    query_params:      metrics: [revenue]      group_by: [Dimension('customer_segment'), TimeDimension('order_date', 'month')]      where: "order_date >= dateadd(day, -90, current_date)" |
| --- |

19-4. exposure와 semantic은 서로 경쟁하지 않는다

exposure는 “어떤 대시보드/앱/분석 파이프라인이 이 모델을 쓰는가”를 보여 주고, semantic layer는 “그 소비자가 어떤 metric/dimension 조합으로 질문할 수 있는가”를 보여 준다. Retail에서는 dashboard exposure가 semantic revenue metric을 소비한다고 문서화할 수 있고, SaaS에서는 finance dashboard exposure가 mrr/churn saved query를 소비한다고 표현할 수 있다. 하나는 downstream lineage, 다른 하나는 reusable meaning layer에 가깝다.

• semantic model의 입력은 보통 신뢰 가능한 public mart 또는 contract model이 된다.

• saved query는 “자주 반복되는 분석 질의 템플릿”을 노드로 남기는 방법이다.

• AI/semantic은 모델링이 좋아질수록 같이 좋아진다. semantic은 지름길이 아니라 좋은 모델링 위의 추가층이다.

19-5. semantic track를 책 안에서 어디까지 가져갈까

이 책의 세 예제는 semantic layer를 “도입 가능한 수준의 starter”까지 끌고 간다. Retail은 revenue/orders, Events는 dau/wau, SaaS는 mrr/active_subscriptions/churn 같은 기본 지표를 semantic model과 metric으로 표현한다. 여기서 더 들어가 cohort, retention, conversions, derived metric까지 넓히는 것은 충분히 가능하지만, 핵심은 semantic model을 만들기 전에 public mart의 grain과 계약이 먼저 안정화되어야 한다는 점이다.

버전 메모: semantic spec은 최근에도 현대화가 진행 중이므로, 이 장의 YAML은 “방향과 역할”을 익히는 기준 예시로 보고 실제 엔진 버전에 맞는 문법을 확인하는 편이 좋다.

Python Models · Functions · UDFs

| 구분 | 로컬 | dbt platform | 핵심 메모 |
| --- | --- | --- | --- |
| 장 20 | Python models는 adapter별 지원 확인, Python UDF는 BigQuery·Snowflake 중심 | platform release track과 adapter 지원 버전을 먼저 확인 | macro는 컴파일 재사용, UDF는 warehouse 재사용이라는 차이를 먼저 잡는다. |

20-1. Python model은 “SQL이 안 되는 곳”이 아니라 “SQL보다 더 명확한 곳”에 쓴다

dbt의 기본 언어는 여전히 SQL이다. 대부분의 mart와 metric 입력 모델은 SQL이 가장 읽기 쉽고 이식성도 높다. Python model은 복잡한 파싱, data science workflow, library 활용, DataFrame 기반 조작처럼 SQL보다 파이썬이 더 읽기 쉬운 경우에만 선택하는 편이 좋다. “할 수 있으니 한다”가 아니라 “이 로직은 Python이 더 명확하다”가 기준이다.

• 최종 공개 mart나 contract model은 가능하면 SQL로 남기는 편이 협업에 유리하다.

• Python model은 보통 table 또는 incremental만 지원한다는 점을 먼저 기억한다.

• Python model이 지원되는 adapter와 실행 방식은 플랫폼마다 다르다.

20-2. UDF는 macro와 다르다: macro는 텍스트 재사용, UDF는 warehouse 함수 재사용

macro는 컴파일 전에 SQL 템플릿을 재사용하는 장치다. 반면 UDF는 warehouse 안에 실제 함수 객체를 만들고, dbt 밖의 SQL이나 BI에서도 다시 부를 수 있다는 점이 다르다. 예를 들어 문자열 정규화, 검증, 공통 business calculation처럼 “모든 도구에서 같은 계산을 공유해야 하는가”가 UDF의 가장 좋은 질문이다.

| functions/is_positive_int.sqlcreate or replace function {{ this }}(value string)returns booleanas (  regexp_like(value, '^[0-9]+$'))functions/schema.ymlfunctions:  - name: is_positive_int    description: '양의 정수 문자열 여부 검사' |
| --- |

20-3. Python UDF와 Python model은 목적이 다르다

Python model은 relation을 만들어 내는 변환 단계이고, Python UDF는 warehouse 함수 catalog 안에 남아 row-level 또는 expression-level 재사용을 돕는다. Retail 예제에서 주소 표준화 함수를 만들고 여러 모델과 ad hoc query가 함께 쓰게 하려면 UDF가 맞다. 반대로 raw clickstream을 세션 단위로 묶어 새 fact table을 만들고 싶다면 Python model이 더 자연스럽다.

| models/events/fct_sessions.pydef model(dbt, session):    dbt.config(materialized='table')    events = dbt.ref('stg_events')    # DataFrame 로직 예시    return events |
| --- |

20-4. 어떻게 고를까: model vs macro vs UDF

판단 기준

| 선택지 | 재사용 단위 | 언제 적합한가 | 주의점 |
| --- | --- | --- | --- |
| SQL model | relation | 다른 모델/BI가 읽을 중간 결과나 최종 mart를 만들 때 | 가장 기본이며, contract/testing/documentation과 함께 쓰기 좋다 |
| Macro | SQL 템플릿 | 같은 SQL 패턴이 여러 파일에 반복될 때 | 과도하면 compiled SQL 가독성이 떨어진다 |
| SQL/Python UDF | warehouse function | 여러 도구에서 동일 계산을 공유하고 싶을 때 | adapter 지원과 warehouse 권한을 확인해야 한다 |
| Python model | relation | 복잡한 파서, 라이브러리, DataFrame 조작이 더 명확할 때 | 지원 adapter, 실행 비용, 협업 난도를 고려해야 한다 |

고급 팁: 로직을 Python으로 옮기기 전에 먼저 “이 로직을 public API로 공개해야 하는가, 아니면 내부 구현인가”를 물어보자. 공개 API라면 SQL model + contract가 여전히 가장 안전한 경우가 많다.

Mesh · dependencies.yml · cross-project ref

| 구분 | 로컬 | dbt platform | 핵심 메모 |
| --- | --- | --- | --- |
| 장 21 | packages 기반 분리는 어디서나 가능 | project dependencies·cross-project ref는 Enterprise 계열 기능 | mesh는 조직 구조·Catalog·access 정책을 같이 설계할 때 효과가 커진다. |

21-1. 언제 한 프로젝트를 쪼개야 할까

모든 dbt 프로젝트가 mesh가 되어야 하는 것은 아니다. 프로젝트를 나누기 시작하는 가장 일반적인 신호는 ownership이 분명히 갈라지고, 팀마다 release cadence가 달라지고, public API처럼 장기적으로 유지해야 할 모델이 생길 때다. 반대로 단일 팀이 빠르게 움직이며 공통 기준을 유지할 수 있다면, 하나의 monorepo가 더 단순하고 생산적일 수 있다.

• 팀이 둘 이상이고, 서로 다른 배포 주기를 가진다.

• 여러 소비자가 오래된 모델 이름/shape에 의존하기 시작했다.

• access/group/version 규칙이 프로젝트 단위 ownership과 자연스럽게 연결된다.

21-2. packages와 project dependencies는 목적이 다르다

packages는 코드 재사용에 더 가깝고, project dependencies는 cross-project ref와 mesh 배포에 더 가깝다. packages는 모델·매크로 묶음을 “가져와 합치는” 느낌이고, project dependencies는 다른 프로젝트가 공개한 public/protected model을 계약된 방식으로 참조하는 느낌이다. 작은 조직에서는 packages만으로도 충분하지만, producer/consumer 관계가 생기면 project dependencies 쪽이 운영상 더 적합해진다.

| dependencies.ymlprojects:  - name: finance_core    version: ">=1.2.0"-- consumer project SQLselect *from {{ ref('finance_core', 'fct_mrr') }} |
| --- |

21-3. mesh의 안전장치는 결국 governance에서 나온다

cross-project ref만 열어 놓고 access, group, contract, versioning을 붙이지 않으면 사실상 더 큰 monolith를 여러 저장소로 쪼갠 것에 불과할 수 있다. 진짜 mesh는 “공개해도 되는 모델만 public으로 승격하고, private 구현은 숨기며, 깨지는 변경은 version으로 관리하고, owner group을 분명히 하는 구조”에 가깝다. 즉, mesh는 배포 토폴로지이기 전에 governance discipline이다.

• group은 소유 팀과 private ref 범위를 만든다.

• access는 consumer가 어디까지 ref해도 되는지 명시한다.

• versions는 깨지는 변경을 새 모델이 아니라 안전한 새 버전으로 공개하게 돕는다.

21-4. 세 예제를 mesh로 나눈다면

producer / consumer 예시

| 트랙 | producer project | consumer project | public API 예시 |
| --- | --- | --- | --- |
| Retail | finance_core | bi_dashboard | fct_orders_v2, dim_customers |
| Events | product_analytics | growth_dashboard | fct_daily_active_users, fct_sessions |
| SaaS | revenue_core | fpna, exec_dashboard | fct_mrr_v2, dim_plan |

플랜 메모: cross-project ref와 mesh 관련 기능은 plan/engine 조건이 걸릴 수 있으므로, 실제 조직 도입 시에는 기능 지원 범위를 먼저 확인하는 편이 좋다.

Performance · Cost · Real-time · materialized_view

| 구분 | 공통 | adapter-specific | 핵심 메모 |
| --- | --- | --- | --- |
| 장 22 | view/table/incremental 전략은 어디서나 공통 | materialized_view, dynamic table, microbatch, refresh 정책은 플랫폼 의존 | 각 절의 DuckDB·MySQL·PostgreSQL·BigQuery·ClickHouse·Snowflake 메모를 함께 읽어야 한다. |

22-1. 성능 튜닝의 황금률: views로 시작하고, 느리면 table, 더 느리면 incremental

성능 최적화는 대개 모델 구조가 어느 정도 안정된 뒤에 해야 효과가 좋다. 너무 이른 incremental은 문제를 숨기고, 너무 이른 warehouse-native feature는 운영 복잡도를 불필요하게 올릴 수 있다. 가장 실용적인 규칙은 “먼저 views로 시작하고, 조회가 너무 느리면 table, 빌드가 너무 느리면 incremental, 그리고 정말 자동 refresh가 필요하면 warehouse-native feature를 검토한다”는 순서다.

• staging은 대개 view가 자연스럽다.

• 핵심 marts는 table 또는 incremental이 자연스럽다.

• real-time 요구가 있더라도 먼저 요구 freshness와 비용 한도를 숫자로 적는다.

22-2. incremental 전략을 고를 때는 데이터의 “도착 방식”을 먼저 본다

append-only인지, update가 있는지, late-arriving data가 있는지, time-series인지에 따라 전략이 달라진다. 단순 append-only면 기본 incremental이나 merge 전략이 맞고, 대형 시간 계열이라면 microbatch가 더 안정적일 수 있다. microbatch는 event_time을 기준으로 여러 batch로 쪼개 처리하며, lookback과 concurrent_batches 같은 config로 late data와 병렬 실행을 조절한다.

| {{ config(    materialized='incremental',    incremental_strategy='microbatch',    event_time='event_at',    batch_size='day',    lookback=2,    concurrent_batches=false) }} |
| --- |

22-3. materialized_view와 dynamic table은 warehouse-native refresh를 활용하는 선택지다

dbt의 built-in materialization에는 materialized_view가 포함된다. 이 객체는 table의 조회 성능과 view의 freshness 장점을 결합한 warehouse-native 기능에 가깝다. 다만 모든 플랫폼이 같은 기능과 이름을 제공하지는 않는다. 예를 들어 Snowflake에서는 dynamic table을 materialized-view 계열의 실전 대안으로 보는 편이 자연스럽고, Postgres/BigQuery는 materialized view 자체를 지원한다. 이 선택지는 “dbt가 batch refresh를 직접 스케줄링할 것인가, 아니면 warehouse에게 더 많이 맡길 것인가”라는 운영 철학과도 연결된다.

• materialized_view는 모든 adapter에서 동일하지 않다. 지원 범위와 config를 확인해야 한다.

• warehouse-native refresh는 편하지만, refresh 정책과 비용 제어를 플랫폼 문서까지 함께 읽어야 한다.

• dynamic table/materialized view는 코드 배포와 데이터 갱신의 분리가 가능한 경우가 많다.

22-4. 플랫폼별 튜닝 포인트

platform tuning quick map

| 플랫폼 | 가장 먼저 볼 것 | 고급 단계에서 추가로 볼 것 |
| --- | --- | --- |
| DuckDB | 모델 구조, selector, 로컬 I/O | extensions, settings, external files, local resource usage |
| MySQL | 운영계 부하 분리, full rebuild 회피 | replica, 배치 시간대, adapter 검증 범위 |
| PostgreSQL | table vs incremental vs materialized view | indexes, transaction hooks, vacuum/analyze |
| BigQuery | partitioning, clustering, scan cost | microbatch, BigFrames Python, materialized views |
| ClickHouse | engine, order_by, partition_by | near real-time rollup, TTL, optimize patterns |
| Snowflake | warehouse sizing, incremental vs dynamic table | clone, Python/Snowpark, role/grant strategy |

22-5. near real-time가 필요할 때 세 예제를 어떻게 바꿀까

Retail은 대부분 시간 단위 배치로 충분하지만, 이벤트 트랙은 몇 분 단위 freshness 요구가 생길 수 있다. 이 경우 append-only raw.events를 기준으로 merge 또는 microbatch incremental, 혹은 warehouse-native refresh를 검토한다. SaaS 트랙은 실시간보다 “정확한 시점 이력”이 더 중요한 경우가 많아 snapshot과 incremental refresh의 균형이 핵심이다. 결국 real-time은 기술 선택 이전에 SLA 선택이다.

운영 메모: event_time은 microbatch와 Advanced CI의 비교 정밀도를 높이는 핵심 메타데이터이므로, 이벤트형 모델에는 가능한 한 일찍 정의해 두는 편이 좋다.

Semantic Layer 운영 Runbook

define → validate → query → save → export → cache 흐름을 운영 절차로 정리한다.

M-1. 기본 흐름: define → validate → query → save → export → cache

• Retail 트랙에서는 gross_revenue, order_count, average_order_value 같은 metric부터 시작한다.

• Event 트랙에서는 dau, wau, session_count처럼 time spine과 grain이 중요한 metric을 먼저 만든다.

• Subscription 트랙에서는 mrr, expansion_mrr, churned_accounts처럼 상태 변화와 SCD 감각이 필요한 metric을 만든다.

• semantic model은 marts를 다시 쓰는 레이어가 아니라, “어떤 질문이 허용되는가”를 명시하는 정의층이라고 생각하면 훨씬 덜 헷갈린다.

M-2. 명령어 기준으로 보면

| 목적 | dbt platform/Fusion 연결형 | local Core 또는 local-only | 언제 쓰나 |
| --- | --- | --- | --- |
| metric 목록 보기 | dbt sl list metrics | mf list metrics | 새 metric이 Catalog/IDE에서 보이는지 확인할 때 |
| dimension 보기 | dbt sl list dimensions --metrics <metric> | mf list dimensions --metrics <metric> | 질문 가능한 slice를 빠르게 확인할 때 |
| entity 보기 | dbt sl list entities --metrics <metric> | mf list entities --metrics <metric> | join path를 점검할 때 |
| saved query 목록 | dbt sl list saved-queries --show-exports | mf list saved-queries | export/caching 연결 상태를 볼 때 |
| metric 질의 | dbt sl query --metrics ... --group-by ... | mf query --metrics ... --group-by ... | BI 연결 전, CLI에서 질문을 검증할 때 |
| saved query 질의 | dbt sl query --saved-query <name> | mf query --saved-query <name> | 반복 질문을 안정적으로 재현할 때 |
| semantic 검증 | dbt sl validate | mf validate-configs | PR 또는 deploy 전에 semantic node를 먼저 막을 때 |
| export 실행 | dbt sl export | 해당 없음/환경 의존 | 개발 환경에서 export 정의를 시험할 때 |

M-3. saved query, export, caching을 어디까지 다르게 봐야 할까

saved query는 “반복해서 묻는 질문”을 이름 붙여 저장하는 장치다. export는 그 saved query를 실제 테이블/뷰로 써 주는 장치이고, declarative caching은 같은 입력 조건의 질의를 더 빠르게 반환하기 위한 운영 최적화다. 세 개는 경쟁 관계가 아니라, 정의 → 배포 → 성능 최적화의 순서다.

| 실전 메모• saved query만으로도 BI 팀과의 대화가 훨씬 쉬워진다.• export는 “metric을 물리 테이블처럼 소비하고 싶다”는 요구가 생길 때 붙인다.• cache는 쿼리 패턴이 반복되고 비용·응답속도 압박이 커질 때 붙인다.• CI에서는 dbt sl validate --select state:modified+ 같은 좁은 검증 루틴을 먼저 고민한다. |
| --- |

M-4. 세 트랙에 바로 붙이는 semantic starter

# retail_metrics.yml

metrics:

- name: gross_revenue

label: Gross revenue

type: simple

type_params:

measure:

name: gross_revenue

saved_queries:

- name: daily_revenue_by_status

query_params:

metrics: [gross_revenue]

group_by: [order__order_date, order__order_status]

같은 패턴을 Event 트랙에서는 dau / session_count, Subscription 트랙에서는 mrr / churn_rate로 바꾸면 된다. 이 책의 세 트랙은 semantic layer를 “새로운 세계”로 다루지 않고, 기존 marts를 조금 더 잘 소비하게 만드는 층으로 다룬다.

AI · Copilot · MCP 빠른 안내

빠르게 변하는 AI 표면은 “무엇을 대신하나”보다 “무엇과 연결되나”를 중심으로 읽는다.

Q-1. 어떤 AI 기능을 어디에 쓰면 좋은가

| 기능 | 잘하는 일 | 주의점 |
| --- | --- | --- |
| Copilot | 문서, 테스트, metric, semantic model, SQL 초안 생성 | 생성 결과를 바로 merge하지 말고 프로젝트 규칙으로 다시 리뷰한다. |
| Local MCP | 로컬 코드·모델·문서 컨텍스트를 에이전트에 제공 | 로컬 환경 권한과 tool access를 최소화한다. |
| Remote MCP | Semantic Layer, Discovery, SQL 등 원격 서비스형 MCP 사용 | plan/preview 상태와 데이터 접근 범위를 먼저 점검한다. |
| Studio agent / Canvas AI | 브라우저 기반 초안 생성과 리팩터링 보조 | 생성 편의성과 최종 품질 검증은 별개다. |

| 실무 권장 순서• 먼저 source/ref/test/docs 규칙을 사람 기준으로 고정한다.• 그 다음 Copilot이나 MCP를 붙여 속도를 높인다.• AI가 만든 산출물도 결국 contracts, tests, CI, owners 같은 인간 규칙 아래에 있어야 한다. |
| --- |

확장 개발자 트랙

R-1. custom generic test는 가장 좋은 첫 확장 포인트

generic test는 팀 규칙을 재사용 가능한 품질 규칙으로 바꾸는 가장 쉬운 출발점이다.

R-2. materialization은 고급 기능이지만, 내부 구조를 읽어 보면 dbt 실행 모델이 보인다

custom materialization 자체를 자주 만들지는 않더라도, built-in materialization이 macro 조합이라는 점을 이해하면 dbt 실행 모델을 더 깊게 읽을 수 있다.

R-3. package author 관점에서 보면

| 관점 | 먼저 챙길 것 |
| --- | --- |
| 테스트 | 지원 dbt version·adapter 조합을 먼저 명시한다. |
| 문서 | README, examples, require-dbt-version을 함께 둔다. |
| 배포 | override 우선순위와 dispatch 구조를 이해한다. |
| 유지보수 | deprecation·behavior changes를 먼저 읽는다. |

| 이 장이 다루는 고급 기능을 한 줄로 묶으면 semantic은 정의층, Python/UDF는 표현층, mesh는 경계 관리, performance는 비용 관리, dbt platform은 실행면, AI/MCP는 소비 표면이다. 각각 따로 배우기보다 이 연결을 먼저 이해해야 기능이 덜 조각나 보인다. |
| --- |

케이스북과 플랫폼 플레이북에서 무엇을 다시 보게 되나

Retail Orders 케이스북에서는 semantic starter와 contracts를, Event Stream 케이스북에서는 incremental과 cost-aware selector와 saved query를, Subscription & Billing 케이스북에서는 snapshot·versions·metric layer를 더 입체적으로 보게 된다. 플랫폼 플레이북에서는 같은 고급 기능이 plan tier와 adapter support, warehouse-native feature에 따라 어떤 차이를 보이는지도 함께 정리한다.

PART III · 예제 케이스북

연속 예제 케이스북

앞서 배운 내용을 예제별로 끝까지 다시 묶는다. 여기서는 기능을 소개하지 않고, 이미 배운 기능이 도메인 안에서 어떤 순서로 자리 잡는지를 보여 준다.
