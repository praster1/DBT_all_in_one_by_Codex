CHAPTER 07

Governance, Contracts, Versions, Grants, Quality Metadata

프로젝트를 공용 API처럼 다듬고, 누가 무엇을 믿고 참조해도 되는지 코드로 남기는 단계.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

거버넌스는 관리 부서의 절차가 아니라 모델을 공용 API처럼 다루기 위한 기술적 장치다. tests와 contracts와 constraints의 역할은 다르고, access/group/version/grant/meta는 서로 겹치지 않는다. 이 차이를 잘 이해하면 “이 모델은 믿고 써도 되는가”라는 질문에 프로젝트 코드만으로 답할 수 있다.

이 장은 contracts, versions, grants, advanced metadata를 함께 묶어, 신뢰성과 공유 가능성을 올리는 장치들을 한 흐름으로 정리한다. 이후 세 예제 케이스북에서는 이 장의 규칙이 각 도메인에서 어떤 공용 API 형태로 나타나는지 구체적으로 다시 보여 준다.

Governance · Grants · Contracts · Versions

| 구분 | Core/Fusion | dbt platform | 핵심 메모 |
| --- | --- | --- | --- |
| 장 18 | governance 대부분 가능 | Catalog·metadata service와 함께 읽을 때 체감이 더 좋아짐 | project dependencies를 제외한 거버넌스 기능은 Core와 platform 모두에서 중요한 기본기다. |

18-1. governance는 “누가 무엇을 믿고 참조해도 되는가”를 코드로 남기는 일이다

dbt의 governance 기능은 모델의 모양, 접근 범위, 소유 그룹, 변경 이력을 프로젝트 수준에서 통제하도록 돕는다. beginner 단계에서는 테스트와 문서만으로도 충분해 보이지만, 팀이 늘어나면 “이 모델을 외부 팀이 ref해도 되는가”, “열 구조가 깨지면 build를 막아야 하는가”, “v1과 v2를 어떻게 같이 운영할 것인가” 같은 질문이 반드시 등장한다.

거버넌스 레버를 어떻게 구분할까

| 기능 | 무엇을 보장하는가 |
| --- | --- |
| grants | 누가 relation을 읽거나 수정할 수 있는지 |
| contract | 모델이 반환해야 하는 열 이름·순서·타입·shape |
| constraints | 데이터 플랫폼이 실제 입력값을 검사하도록 위임하는 규칙 |
| access / groups | 누가 이 모델을 ref할 수 있는지, 어떤 소유 경계에 속하는지 |
| versions | 깨지는 변경을 새 버전으로 안전하게 공개하는 방법 |

18-2. tests, contracts, constraints는 서로 대체제가 아니다

tests는 데이터 상태를 사후 점검하고, contract는 build 시점에 모델 shape를 강제하며, constraints는 데이터 플랫폼이 물리적으로 삽입/업데이트 값을 검증하게 한다. 요약하면 tests는 “이상 징후 탐지”, contracts는 “잘못된 shape 차단”, constraints는 “플랫폼 수준 강제”에 가깝다. 따라서 핵심 public model에서는 세 가지를 함께 생각해야 한다.

| models:  - name: fct_orders    config:      contract:        enforced: true      access: public      group: finance    columns:      - name: order_id        data_type: bigint        constraints:          - type: not_null      - name: gross_revenue        data_type: numeric |
| --- |

18-3. access, group, versions는 “안전한 공유”를 위한 삼총사다

group은 소유권과 private ref 범위를 정하는 최소 단위다. access는 public/protected/private로 모델의 참조 가능 범위를 표현한다. versions는 깨지는 변경이 필요할 때 새 버전을 추가하고, latest_version과 deprecation_date를 통해 소비자에게 이행 시간을 주는 방법이다. 특히 여러 팀이 같은 mart를 함께 사용할 때, access와 versions가 없으면 사실상 “숨은 API”를 운영하게 된다.

| models:  - name: fct_mrr    latest_version: 2    versions:      - v: 1        deprecation_date: 2026-12-31      - v: 2    config:      access: public      group: revenue |
| --- |

18-4. grants는 가능하면 hook보다 config로 선언한다

relation 읽기 권한은 grants config로 관리하는 편이 가장 읽기 쉽다. 다만 schema usage와 같은 작업은 아직 hook나 운영 SQL이 필요한 경우가 있으므로, grants와 on-run-end를 조합하는 식의 하이브리드 패턴이 자주 쓰인다. 원칙은 단순하다. relation 권한은 grants로, schema 단위 보조 작업은 최소한의 hook로 둔다.

| models:  my_project:    marts:      +grants:        select: ['reporter', 'bi_reader']on-run-end:  - "{% for schema in schemas %}grant usage on schema {{ schema }} to role reporter;{% endfor %}" |
| --- |

18-5. 세 예제를 public API처럼 다듬는다면

Retail에서는 fct_orders와 dim_customers를 public contract model로 두고, dashboard exposure가 이를 읽도록 연결하는 것이 자연스럽다. Event Stream에서는 raw/staging과 session intermediate는 private, DAU/WAU rollup만 public으로 공개하는 편이 흔하다. Subscription 트랙에서는 fct_mrr와 dim_plan을 versioned public model로 두고, churn 규칙이 바뀔 때 v2를 추가하는 패턴이 가장 교육적이다.

• 공개 범위가 넓을수록 contract와 versioning의 가치는 커진다.

• group은 단순 소유자 표기가 아니라 private ref의 경계를 만든다.

• constraints 지원 범위는 데이터 플랫폼마다 다르므로, 지원되지 않는 경우에도 tests와 contract는 유지한다.

실무 메모: 모든 모델에 governance를 들이밀 필요는 없다. 외부 참조를 받는 public mart와 semantic 입력 모델부터 좁고 강하게 적용하는 편이 가장 효과적이다.

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

기능 가용성 배지와 지원 매트릭스

plan tier와 adapter support가 얽히는 기능을 한 번에 구분한다.

L-1. 이 책에서 쓰는 배지를 먼저 정리

올인원 책이 되면서 “기능을 아는 것”만큼 “그 기능이 어디서 되는가”를 구분하는 일이 중요해졌다. 같은 YAML을 본다고 해도 local Core에서 바로 실행되는 경우와, dbt platform 계정·특정 plan·특정 adapter가 있어야 체감되는 경우가 분명히 다르다.

| 배지 | 뜻 | 대표 예시 |
| --- | --- | --- |
| Core | 로컬 dbt Core CLI에서 이해·실행 가능한 축 | models, tests, docs, selectors, packages |
| Fusion | Fusion CLI 또는 Fusion-powered editor에서 직접 체감되는 축 | VS Code extension, supported features matrix |
| dbt platform | Studio IDE, jobs, Catalog, dbt CLI와 연결될 때 가치가 커지는 축 | environments, CI jobs, Catalog, state-aware orchestration |
| Starter+ | Starter, Enterprise, Enterprise+에서 주로 쓰는 기능 | Semantic Layer exports, Catalog, Copilot |
| Enterprise+ | Enterprise 또는 Enterprise+에서 주로 쓰는 기능 | project dependencies, advanced CI, Canvas 일부 기능 |
| Adapter-specific | warehouse 구현 차이를 반드시 확인해야 하는 기능 | Python UDF, materialized_view, dynamic table, ClickHouse physical design |

L-2. 자주 헷갈리는 기능을 한눈에 비교

| 기능 | 로컬 Core | 로컬 Fusion | dbt platform | 플랜/제약 |
| --- | --- | --- | --- | --- |
| VS Code extension | 직접 사용 불가 | 예 | 보통 platform 계정/토큰과 함께 사용 | Fusion 전용, preview 성격 |
| dbt Docs 정적 사이트 | 예 | 예 | 예 | Catalog와 목적이 다름 |
| Catalog | 아니오 | 아니오 | 예 | Starter+ |
| Semantic YAML 정의 | 예 | 예 | 예 | 정의 자체는 코드에 남길 수 있음 |
| MetricFlow local query | mf 명령 | mf 또는 dbt sl(연결 시) | dbt sl | Universal SL·exports·cache는 Starter+ 체감 |
| Project dependencies | 아니오 | 아니오 | 예 | Enterprise 또는 Enterprise+ |
| Python UDF | v1.11+/지원 adapter | 지원 adapter/track 확인 | release track·adapter 확인 | BigQuery/Snowflake 중심 |
| Canvas | 아니오 | 아니오 | 예 | Enterprise 계열 |
| Copilot | 아니오 | 아니오 | 예 | Starter+ |
| Local MCP | 예 | 예 | 예(로컬 연결형) | uvx dbt-mcp |
| Remote MCP | 아니오 | 아니오 | 예 | Starter+ beta 성격 |

L-3. 본문 16~22장을 읽을 때의 체크포인트

| 장 | 먼저 확인할 배지 | 이유 |
| --- | --- | --- |
| 16 | Core · Fusion · dbt platform | state/defer는 로컬에서도 중요하지만, state-aware orchestration과 job metadata는 platform에서 더 강해진다. |
| 17 | Core · dbt platform | vars/env/hooks/packages는 공통이지만 CLI 인증 방식과 platform CLI 사용 흐름이 달라진다. |
| 18 | Core · dbt platform · Enterprise+ | governance는 공통, project dependencies는 Enterprise tier 기능이다. |
| 19 | Core · Fusion · Starter+ | semantic 정의와 local MetricFlow는 가능하지만 Universal Semantic Layer, exports, cache는 platform 계정 가치가 크다. |
| 20 | Adapter-specific | Python model/UDF는 지원 adapter, 버전, release track을 먼저 확인해야 한다. |
| 21 | Enterprise+ | mesh를 진짜 cross-project ref까지 확장하려면 project dependencies와 metadata service를 함께 봐야 한다. |
| 22 | Adapter-specific | materialized_view, dynamic table, refresh 전략이 플랫폼마다 다르다. |

governance를 사례로 옮기면 무엇이 달라지나

contracts와 versions는 이론만 보면 추상적이지만, Retail Orders에서 공용 주문 metric을 제공하고, Subscription & Billing에서 MRR 정의를 versioned API처럼 노출한다고 생각하면 훨씬 실감난다. access, group, grant, meta는 문서화와 권한, 소비 범위를 맞물리게 만드는 정보이고, tests와 contracts는 서로 대체제가 아니라 다른 층위의 안전장치다. 이 장을 읽고 나면 케이스북에서 “어떤 모델을 공용 API로 승격할지”를 보는 눈이 생긴다.
