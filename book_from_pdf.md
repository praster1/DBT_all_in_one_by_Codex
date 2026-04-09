이 책을 읽는 방법

이 교재는 초보자용 입문서처럼 앞에서 하나씩 기능을 소개하지만, 뒤로 갈수록 실무 운영과 고급 기능, 예제 케이스북, 플랫폼 플레이북으로 서서히 확장되도록 설계했다. 그래서 앞쪽 장은 일반 원리를 충분히 설명하고, 뒤쪽 장은 그 원리가 특정 도메인과 특정 플랫폼에서 어떤 순서와 제약으로 나타나는지를 사례 중심으로 보여 준다.

중요한 점은 반복되는 요약 표로 예제와 플랫폼을 매번 훑지 않는다는 것이다. 대신 본문은 큰 개념 장으로 묶고, 뒤에서 Retail Orders / Event Stream / Subscription & Billing 세 가지 케이스북과 DuckDB / MySQL / PostgreSQL / BigQuery / ClickHouse / Snowflake / Trino + NoSQL + SQL Layer 플레이북을 각각 별도 챕터로 두어, 앞에서 배운 내용을 실제 문맥 안에서 다시 전개한다.

| 책 전체의 흐름 Part I는 개념과 기본기, Part II는 신뢰성·운영·확장, Part III는 예제 케이스북, Part IV는 플랫폼 플레이북, 마지막 Appendices는 실행과 참조를 위한 백업 장치로 구성된다. 따라서 책을 처음 읽을 때는 앞쪽 장을 순서대로 보고, 실제 프로젝트에 옮길 때는 뒤쪽 casebook과 platform playbook을 병행해서 보는 방식이 가장 효과적이다. |
| --- |

세 가지 연속 예제의 성장 지도

권장 읽기 경로

| 독자 유형 | 먼저 읽을 부분 | 그 다음 볼 부분 |
| --- | --- | --- |
| dbt를 처음 배우는 사람 | Chapter 01 → 05 | Casebook 09~11, DuckDB/BigQuery 플레이북 |
| 실무 프로젝트를 맡은 사람 | Chapter 01 → 08 | 해당 도메인 Casebook + 해당 플랫폼 Playbook |
| 리드·플랫폼 오너 | Chapter 05 → 08을 먼저 훑고 01~04로 복귀 | Governance/Semantic + Platform chapters |

차례

| 구분 | 번호 | 제목 |
| --- | --- | --- |
| PART I · 핵심 개념과 기본기 | 01 | DBT의 전체 그림과 세 가지 연속 예제 |
| PART I · 핵심 개념과 기본기 | 02 | 개발 환경, 프로젝트 구조, DBT 명령어와 Jinja, 첫 실행 |
| PART I · 핵심 개념과 기본기 | 03 | source/ref, selectors, layered modeling, grain, materializations |
| PART I · 핵심 개념과 기본기 | 04 | Tests, Seeds, Snapshots, Documentation, Macros, Packages |
| PART II · 신뢰성·운영·확장 | 05 | 디버깅, artifacts, runbook, anti-patterns |
| PART II · 신뢰성·운영·확장 | 06 | 운영, CI/CD, state/defer/clone, vars/env/hooks, 업그레이드 |
| PART II · 신뢰성·운영·확장 | 07 | Governance, Contracts, Versions, Grants, Quality Metadata |
| PART II · 신뢰성·운영·확장 | 08 | Semantic Layer, Python/UDF, Mesh, Performance, dbt platform, AI |
| PART III · 예제 케이스북 | 09 | Casebook I · Retail Orders |
| PART III · 예제 케이스북 | 10 | Casebook II · Event Stream |
| PART III · 예제 케이스북 | 11 | Casebook III · Subscription & Billing |
| PART IV · 플랫폼 플레이북 | 12 | Platform Playbook · DuckDB |
| PART IV · 플랫폼 플레이북 | 13 | Platform Playbook · MySQL |
| PART IV · 플랫폼 플레이북 | 14 | Platform Playbook · PostgreSQL |
| PART IV · 플랫폼 플레이북 | 15 | Platform Playbook · BigQuery |
| PART IV · 플랫폼 플레이북 | 16 | Platform Playbook · ClickHouse |
| PART IV · 플랫폼 플레이북 | 17 | Platform Playbook · Snowflake |
| PART IV · 플랫폼 플레이북 | 18 | Platform Playbook · Trino와 NoSQL + SQL Layer |
| APP | A | Companion Pack, Example Data, Bootstrap, Answer Keys |
| APP | B | DBT 명령어 레퍼런스 |
| APP | C | Jinja, Macro, Extensibility Reference |
| APP | D | Troubleshooting, Decision Guides, Glossary, Official Sources, Support Matrix |

PART I · 핵심 개념과 기본기

핵심 개념과 기본기

dbt를 데이터 스택의 어디에 놓아야 하는지, 이 책이 끝까지 끌고 가는 세 가지 예제가 무엇인지, 그리고 각 플랫폼이 어떤 성격의 실행 환경인지 먼저 잡는다.

CHAPTER 01

DBT의 전체 그림과 세 가지 연속 예제

도구 소개가 아니라 구조와 책임, 예제 트랙, 플랫폼 범주부터 이해한다.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

이 책의 첫 목표는 명령어를 외우기 전에 dbt를 어디에 놓아야 하는지부터 분명하게 만드는 것이다. dbt는 적재된 데이터를 분석 가능한 구조로 바꾸는 변환 계층이면서, 그 변환을 모델·테스트·문서·계약으로 다루게 만드는 프로젝트 계층이다. 따라서 dbt를 잘 배운다는 것은 SQL만 잘 쓰는 것이 아니라, 분석 로직을 반복 가능하고 설명 가능한 형태로 운영하는 법을 배우는 일에 가깝다.

또 하나의 축은 예제다. 이 책은 Retail Orders, Event Stream, Subscription & Billing 세 개의 연속 예제를 앞장에서 소개하고 뒤의 예제 케이스북과 플랫폼 플레이북에서 다시 완주한다. 앞쪽 장에서는 기능의 일반 원리를 충분히 설명하고, 뒤쪽 장에서는 그 원리가 세 예제와 여덟 가지 플랫폼에서 실제로 어떻게 작동하는지 사례로 연결한다.

dbt 기본 순환을 그림으로 먼저 보기

왜 dbt를 쓰는가

| 필수 | 처음 읽는 사람은 장 끝의 ‘직접 해보기’를 반드시 해 본다. 이해가 아니라 손의 감각을 남기는 것이 목표다. |
| --- | --- |

| 이 장에서 배우는 것 • dbt가 데이터 스택에서 맡는 역할과 맡지 않는 역할을 구분한다. • source(), ref(), test, docs가 왜 함께 움직여야 하는지 이해한다. • ‘큰 쿼리 하나’보다 ‘작은 모델 여러 개’가 유리한 이유를 설명한다. | 완료 기준 • dbt를 단순 SQL 실행기가 아니라 프로젝트 관리 도구로 설명할 수 있다. • 기존 SQL 파일 운영과 dbt 프로젝트 운영의 차이를 비교할 수 있다. • 원천 → staging → intermediate → marts → tests/docs 흐름을 그릴 수 있다. |
| --- | --- |

1-1. dbt는 어디에 있는가

dbt는 이미 저장소나 웨어하우스에 적재된 데이터를 분석 가능한 형태로 바꾸는 ‘변환 계층’에 있다. 수집 자체를 담당하는 ETL/EL, 대시보드 도구, 전체 오케스트레이터를 모두 대체하지는 않지만, 그 사이를 연결하는 분석용 SQL을 프로젝트처럼 관리하게 만든다.

dbt가 잘하는 일과 그렇지 않은 일

| 구분 | 대표 기능 | 왜 중요한가 |
| --- | --- | --- |
| dbt가 잘하는 일 | 모델 정의, ref()/source() 의존성, 테스트, 문서화, lineage | 분석용 SQL이 개인 파일이 아니라 팀 자산이 된다 |
| dbt가 직접 하지 않는 일 | 원천 수집, BI 시각화, 복잡한 외부 시스템 제어 | 다른 도구와 역할을 분리해야 전체 파이프라인이 단순해진다 |
| 초보자가 먼저 익힐 것 | 모델 분리, 선택 실행, 테스트, docs | 실무에서 가장 빠르게 효과가 난다 |

1-2. 왜 dbt가 필요한가

기존 분석 환경에서는 잘 만든 SQL 하나가 팀의 표준처럼 복사되기 쉽다. 처음에는 빠르지만 시간이 지나면 로직이 조용히 갈라지고, 변경 영향 범위를 자신 있게 말할 사람이 없어지고, 지표 정의가 사람마다 조금씩 달라진다. dbt는 이 문제를 줄이기 위해 모델 사이의 관계와 품질 가정을 프로젝트 안으로 끌어온다.

기존 SQL 파일 운영과 dbt 프로젝트 운영의 차이

| 관점 | 기존 SQL 파일 운영 | dbt 프로젝트 운영 |
| --- | --- | --- |
| 실행 순서 | 사람이 기억하거나 문서에 적어 둔다 | ref()와 source()가 DAG를 만들고 순서를 정한다 |
| 재사용 | 복사·붙여넣기가 많다 | 모델을 작은 단위로 나눠 재사용한다 |
| 품질 검증 | 눈으로 결과를 확인하기 쉽다 | tests가 반복 실행 가능한 규칙이 된다 |
| 문서화 | 위키나 메신저에 흩어지기 쉽다 | docs와 YAML이 모델과 함께 간다 |
| 변경 영향 | 누가 어디서 쓰는지 추적이 어렵다 | lineage와 selector로 범위를 좁힌다 |

그림 1-1. 초보자가 먼저 익혀야 하는 dbt 기본 순환

1-3. 초보자에게 더 중요한 사고방식

• 직접 스키마와 테이블명을 적는 습관을 줄이고, 가능하면 source()와 ref()를 쓴다.

• 한 모델에 너무 많은 역할을 넣지 않는다. 정리, 조인, 집계를 한 파일에 모두 섞으면 디버깅이 급격히 어려워진다.

• 전체 build보다 선택 실행으로 빠르게 검증한다. 작은 성공과 작은 실패를 많이 만들어 보는 편이 훨씬 빠르다.

• 문제가 생기면 SQL을 새로 쓰기 전에 compiled SQL과 DAG 범위를 먼저 본다.

| 핵심 문장 dbt는 분석용 SQL을 ‘코드처럼’ 다루게 만드는 도구다. 잘 쓰는 핵심은 화려한 문법보다 구조를 나누고 작은 단위로 검증하는 습관에 있다. |
| --- |

| 안티패턴 하나의 거대한 SQL 안에 rename, join, 집계, KPI 계산, 예외 처리까지 모두 넣고 ‘잘 돌아가니 됐다’고 생각하는 것. 처음에는 빨라도 수정 비용이 빠르게 폭증한다. |
| --- |

| 직접 해보기 1. 지금까지 하던 분석 쿼리 하나를 떠올리고, 그 쿼리를 source → staging → mart 세 단계로 나눠 본다. 2. 각 단계에서 어떤 테스트를 붙일 수 있는지 한 줄씩 적는다. 3. 마지막으로 ‘이걸 giant SQL로 유지했을 때 어떤 문제가 생길까’를 적어 본다. 정답 확인 기준: 정답은 하나가 아니지만, 최소한 원천 정리와 최종 KPI를 별도의 모델로 분리했는지 확인한다. |
| --- |

| 완료 체크리스트 • □ dbt가 어디에 있는 도구인지 설명할 수 있다. • □ source·ref·tests·docs가 왜 함께 가야 하는지 말할 수 있다. • □ 작은 모델 여러 개가 giant SQL보다 유리한 이유를 예로 들 수 있다. |
| --- |

| 세 가지 연속 예제를 어떻게 읽을까 앞쪽 장은 기능을 일반 원리로 설명하고, 뒤쪽의 케이스북은 그 원리가 실제 도메인에서 어떤 순서로 자리를 잡는지 보여 준다. Retail Orders는 레이어 설계와 grain을, Event Stream은 incremental과 비용을, Subscription & Billing은 snapshot·contracts·metric의 가치를 가장 선명하게 보여 주는 트랙이다. |
| --- |

세 예제가 책 전체에서 자라는 방식

세 예제의 역할을 한 번에 잡기

Retail Orders는 가장 기본적인 source → staging → intermediate → marts 구조를 몸에 익히기 위한 트랙이다. 고객·주문·주문상세·상품이라는 익숙한 엔터티 덕분에 source/ref, grain, fanout, tests, snapshot의 흐름을 설명하기 좋다. Event Stream은 append-only 이벤트가 중심이어서 incremental, late-arriving data, session, DAU, cache, cost-aware selector 이야기를 꺼내기 좋다. Subscription & Billing은 상태 변화와 정의의 일관성이 핵심이어서 contracts, versions, semantic metric, governed sharing 이야기를 가장 깊게 가져가기 좋다.

| 예제 | 초기 질문 | 후반 확장 질문 |
| --- | --- | --- |
| Retail Orders | 주문 한 건은 어떻게 mart까지 바뀌나? | 주문 metric을 팀 공용 API처럼 어떻게 공개하나? |
| Event Stream | append-only 이벤트에서 session과 DAU를 어떻게 만들까? | 증가하는 데이터량과 비용을 어떻게 통제하나? |
| Subscription & Billing | 구독 상태 변화와 MRR을 어떻게 안정적으로 정의할까? | contracts·versions·semantic으로 어떻게 공유하나? |

CHAPTER 02

개발 환경, 프로젝트 구조, DBT 명령어와 Jinja, 첫 실행

환경 구성부터 파일 구조, 워크플로 명령, 템플릿 문법, 첫 번째 build 순환까지 한 챕터에서 잡는다.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

초보자가 가장 자주 막히는 곳은 모델링보다 환경과 워크플로다. adapter가 안 잡히고, profile 이름이 어긋나고, 어떤 명령을 먼저 써야 하는지 모르면 가장 단순한 실습도 쉽게 흔들린다. 이 장은 로컬 DuckDB를 기준으로 출발하지만, 같은 raw 데이터를 MySQL, PostgreSQL, BigQuery, ClickHouse, Snowflake, Trino, 그리고 NoSQL + SQL Layer 패턴에서 어떻게 재현하는지까지 함께 연결한다.

또한 이 장은 프로젝트 구조, DBT 명령어, Jinja 기초를 한꺼번에 다룬다. 이유는 단순하다. 실제로 dbt를 쓰는 순간 이 셋은 따로 움직이지 않기 때문이다. 프로젝트 구조를 모르면 명령어 선택이 흔들리고, Jinja를 모르면 컴파일 결과를 읽기 어렵고, 명령어 흐름을 모르면 디버깅 순서를 고정하기 어렵다.

실습 환경 구축

로컬 환경부터 profile, adapter, Core/Fusion 구분까지.

| 구분 | 로컬 | dbt platform | 핵심 메모 |
| --- | --- | --- | --- |
| 장 02 | Core CLI 또는 Fusion CLI | Core engine·Fusion engine 모두 가능 | 공식 VS Code extension은 Fusion 전용이므로 이 장은 Core CLI를 기준으로 시작한다. |

| 필수 | 처음 읽는 사람은 장 끝의 ‘직접 해보기’를 반드시 해 본다. 이해가 아니라 손의 감각을 남기는 것이 목표다. |
| --- | --- |

| 이 장에서 배우는 것 • 가상환경, dbt Core, adapter 설치 흐름을 익힌다. • Core CLI와 Fusion + VS Code extension의 현재 공식 흐름 차이를 구분한다. • profiles.yml과 dbt debug로 연결 상태를 가장 먼저 검증하는 습관을 만든다. | 완료 기준 • dbt debug가 통과하는 기본 환경을 직접 만들 수 있다. • 이 책이 왜 Core + DuckDB를 기본값으로 잡는지 설명할 수 있다. • 설치 실패를 SQL 문제와 분리해서 다룰 수 있다. |
| --- | --- |

2-1. 왜 이 책은 dbt Core + DuckDB로 시작하는가

초보자가 처음 지치는 이유는 대개 개념이 아니라 환경 복잡도다. 계정 발급, 권한, 과금, 네트워크, 드라이버 문제를 한꺼번에 만나면 dbt 자체를 배우기도 전에 힘이 빠진다. 그래서 이 책은 로컬에서 즉시 재현 가능한 dbt Core + DuckDB를 기본 실습 환경으로 삼는다.

입문 환경 선택표

| 선택지 | 언제 잘 맞는가 | 주의할 점 |
| --- | --- | --- |
| dbt Core + DuckDB | 교재 따라 하기, 빠른 재현, 오프라인 실습 | 로컬 단일 사용자 실습에 가장 적합하다 |
| dbt Core + 회사 플랫폼 | 이미 BigQuery/Snowflake 등 계정이 준비된 팀 | 권한·과금·스키마 분리까지 함께 신경 써야 한다 |
| Fusion + VS Code extension | 공식 확장 기능을 적극 활용하고 싶은 경우 | 현재 확장은 Fusion 전용이며 Core와는 호환되지 않는다 |

| 결론부터 이 교재는 최신 공식 흐름을 존중하되, 학습 재현성과 이식성을 위해 Core CLI를 기준으로 설명한다. 팀에서 Fusion을 쓰더라도 source·ref·테스트·문서화·레이어 설계의 핵심 개념은 거의 그대로 가져갈 수 있다. |
| --- |

2-2. 설치 전 준비

dbt를 설치할 때는 프로젝트마다 가상환경을 분리하는 편이 좋다. adapter는 플랫폼마다 따로 설치되므로, 가상환경이 없으면 패키지 충돌이 나거나 어떤 adapter가 현재 셸에서 활성화되어 있는지 헷갈리기 쉽다.

| BASH python3 -m venv .venv source .venv/bin/activate python -m pip install --upgrade pip wheel setuptools python -m pip install "dbt-core==1.11.*" "dbt-duckdb==1.11.*" |
| --- |

| 버전 고정 교재와 companion ZIP은 재현성을 위해 1.11 계열 예시를 사용한다. 실제 도입 시에는 공식 설치 문서와 adapter 호환표를 다시 확인한 뒤 팀의 표준 버전을 정하자. |
| --- |

2-3. 첫 프로젝트와 profile

| BASH dbt init dbt_book_lab_complete cd dbt_book_lab_complete dbt --version dbt debug |
| --- |

| YAML · profiles.example.yml dbt_book_lab_complete: target: dev outputs: dev: type: duckdb path: ./dbt_book_lab.duckdb threads: 4 |
| --- |

profiles.yml은 보통 ~/.dbt/ 아래에 두며, 민감한 값은 환경변수로 분리한다. 현재 DuckDB 예제에는 비밀 정보가 없지만, 이 습관은 BigQuery keyfile, Snowflake 비밀번호, Postgres 접속 정보로 옮겨 가는 순간 바로 중요해진다.

2-4. Core / Fusion / VS Code extension을 어떻게 구분할까

초보자 관점의 선택 기준

| 질문 | Core CLI | Fusion + VS Code extension |
| --- | --- | --- |
| 명령어와 디렉터리 구조를 또렷하게 배우고 싶다 | 적합 | 보조 도구가 많아 더 편하지만 내부 동작이 가려질 수 있다 |
| 교재의 모든 화면과 가장 비슷한 흐름을 원한다 | 적합 | 일부 경험이 달라질 수 있다 |
| 공식 편집기 기능을 바로 활용하고 싶다 | 제한적 | 적합 |
| 팀 표준이 이미 회사 플랫폼에 묶여 있다 | 플랫폼 adapter별로 명시적으로 다룬다 | 팀 정책에 따라 매우 편할 수 있다 |

2-5. 설치 단계의 흔한 실패

| 증상 | 가능한 원인 | 가장 먼저 할 일 |
| --- | --- | --- |
| Profile not found | dbt_project.yml의 profile과 profiles.yml 최상위 키 불일치 | 두 이름을 문자 하나까지 동일하게 맞춘다 |
| Could not find adapter type duckdb | 가상환경 미활성화 또는 adapter 미설치 | pip install과 source .venv/bin/activate를 재확인한다 |
| dbt 명령을 못 찾음 | PATH에 현재 venv가 반영되지 않음 | 현재 셸을 다시 열고 가상환경을 활성화한다 |
| DuckDB 파일 권한 오류 | 쓰기 권한 없는 경로 사용 | 프로젝트 루트 아래 단순 경로로 바꾼다 |

| 안티패턴 문제가 생겼는데 바로 dbt run부터 시도하는 것. 설치·연결·SQL 오류가 한 번에 섞여 버려 초보자에게 가장 비싼 실패가 된다. |
| --- |

| 직접 해보기 1. 가상환경을 만들고 dbt --version으로 core와 adapter가 함께 잡히는지 확인한다. 2. profiles.example.yml을 참고해 ~/.dbt/profiles.yml을 작성한 뒤 dbt debug를 실행한다. 3. 일부러 profile 이름을 다르게 적어 보고 어떤 에러가 나는지 확인한 뒤 다시 고친다. 정답 확인 기준: dbt debug가 최종적으로 통과하고, 실패했을 때 설치 문제인지 연결 문제인지 분리해서 설명할 수 있으면 성공이다. |
| --- |

| 완료 체크리스트 • □ 가상환경과 adapter 설치 흐름을 설명할 수 있다. • □ Core와 Fusion/extension의 차이를 대략 구분할 수 있다. • □ profiles.yml과 dbt debug의 역할을 알고 있다. |
| --- |

프로젝트 구조 해부

파일과 디렉터리를 “운영 규칙”, “연결 정보”, “모델”, “메타데이터” 네 축으로 읽는다.

| 필수 | 처음 읽는 사람은 장 끝의 ‘직접 해보기’를 반드시 해 본다. 이해가 아니라 손의 감각을 남기는 것이 목표다. |
| --- | --- |

| 이 장에서 배우는 것 • dbt 프로젝트를 이루는 핵심 파일 지도를 익힌다. • 설정 우선순위(config())와 YAML, dbt_project.yml의 역할을 구분한다. • 민감한 값을 Git에 남기지 않는 최소 원칙을 익힌다. | 완료 기준 • 어떤 파일을 어디서 수정해야 할지 망설이는 시간이 줄어든다. • config 위치가 많아도 ‘어디에 두는 게 자연스러운지’ 판단할 수 있다. • 테스트·snapshot·packages가 프로젝트 구조 안에서 어디에 들어가는지 설명할 수 있다. |
| --- | --- |

3-1. 초보자 기준으로 먼저 봐야 할 네 축

처음에는 디렉터리가 많아 보여도, 초보자 기준으로는 네 가지만 먼저 보면 된다. 모델 SQL이 들어 있는 models/, 설명과 테스트를 적는 YAML, 프로젝트 규칙을 담는 dbt_project.yml, 연결 정보를 담는 profiles.yml이다. 나머지 폴더는 이 네 축의 확장으로 이해하면 된다.

| TEXT · companion 프로젝트 구조 dbt_book_lab_complete/ ├─ raw_data/ │  ├─ day1/ │  └─ day2/ ├─ scripts/ │  └─ load_raw_to_duckdb.py ├─ models/ │  ├─ staging/ │  │  ├─ stg_customers.sql │  │  ├─ stg_orders.sql │  │  ├─ stg_order_items.sql │  │  ├─ stg_products.sql │  │  └─ staging.yml │  ├─ intermediate/ │  │  ├─ int_order_lines.sql │  │  └─ intermediate.yml │  ├─ marts/ │  │  ├─ fct_orders.sql │  │  ├─ dim_customers.sql │  │  ├─ dim_products.sql │  │  ├─ fct_daily_sales.sql │  │  └─ marts.yml │  ├─ sources.yml │  └─ exposures.yml ├─ snapshots/ │  └─ orders_snapshot.yml ├─ tests/ │  ├─ assert_fct_orders_revenue_reconciles.sql │  ├─ assert_no_negative_order_amount.sql │  └─ generic/ ├─ macros/ ├─ labs/ │  ├─ 01_source_not_found/ │  ├─ 02_ref_not_found/ │  ├─ 03_fanout_bug/ │  ├─ 04_singular_test_fail/ │  ├─ 05_incremental_backfill/ │  └─ 06_cancelled_order_rule/ ├─ optional_examples/ ├─ reference_outputs/ ├─ dbt_project.yml ├─ profiles.example.yml ├─ selectors.yml └─ README.md |
| --- |

3-2. dbt_project.yml은 ‘운영 규칙’이다

dbt_project.yml은 이 디렉터리가 dbt 프로젝트라는 선언이자, 폴더별 기본 materialization, schema, tags, docs 설정을 관리하는 중심 파일이다. 여러 모델에 반복해서 들어갈 규칙은 가능하면 이 파일에 두고, 예외적인 한 모델만 SQL 안의 config()로 덮어쓰는 편이 관리가 쉽다.

| YAML · 핵심 뼈대 name: 'dbt_book_lab_complete' version: '1.0.0' config-version: 2 profile: 'dbt_book_lab_complete' models: dbt_book_lab_complete: staging: +materialized: view +schema: staging marts: +materialized: table +schema: marts |
| --- |

3-3. profiles.yml은 연결 정보다

반대로 profiles.yml은 어떤 플랫폼에 어떤 자격 증명으로 연결할지 정의한다. 프로젝트 규칙과 접속 정보는 성격이 다르므로, 초보자일수록 둘을 분리해서 생각하는 습관이 중요하다. dbt_project.yml은 프로젝트 안에 함께 커밋하되, profiles.yml은 보통 사용자 홈 디렉터리 아래에 둔다.

| 구분을 잊지 말자 • dbt_project.yml = 모델을 어떻게 만들지 • profiles.yml = 어디에 연결할지 • models/*.yml = 각 모델과 컬럼이 무엇을 의미하는지 |
| --- |

3-4. config 우선순위를 감으로 잡기

| 위치 | 적합한 용도 | 예시 |
| --- | --- | --- |
| SQL 안의 config() | 특정 모델 하나만 예외 처리 | 한 모델만 incremental로 바꾸기 |
| 해당 모델의 YAML config | 설명과 함께 둘 설정 | contract, constraints, tests |
| dbt_project.yml | 폴더 공통 기본값 | staging은 view, marts는 table |

초보자는 우선순위를 시험 문제처럼 외울 필요는 없다. 대신 ‘공통 규칙은 프로젝트 파일에, 개별 예외는 모델 가까이에’라는 감각만 먼저 잡아도 유지보수 품질이 크게 좋아진다.

3-5. packages, selectors, target 디렉터리는 어디에 쓰나

| 파일/폴더 | 무엇이 들어가는가 | 언제 떠올리면 되는가 |
| --- | --- | --- |
| packages.yml | 외부 dbt package 의존성 | 반복되는 매크로나 테스트를 가져오고 싶을 때 |
| selectors.yml | 복잡한 선택 규칙 이름 붙이기 | 매번 긴 --select 식을 쓰기 싫을 때 |
| target/ | compiled SQL과 artifacts | 디버깅과 docs, state selection을 볼 때 |
| logs/ | dbt.log | 실패 원인을 텍스트로 추적할 때 |

| 안티패턴 연결 정보와 프로젝트 규칙을 같은 파일처럼 생각하거나, 비밀번호를 프로젝트 코드에 직접 넣는 것. |
| --- |

| 직접 해보기 1. project_tree를 보며 models, tests, snapshots, optional_examples 중 무엇이 ‘실행 대상’이고 무엇이 ‘설명/지원 파일’인지 나눠 적는다. 2. dbt_project.yml을 열고 staging과 marts의 기본 materialization을 찾는다. 3. 다음 질문에 답해 본다. ‘한 모델만 incremental로 바꾸려면 어디를 수정하는 게 가장 자연스러운가?’ 정답 확인 기준: config() / YAML / dbt_project.yml이 각각 어떤 수준의 설정을 담당하는지 말할 수 있으면 성공이다. |
| --- |

| 완료 체크리스트 • □ 핵심 파일 네 축을 설명할 수 있다. • □ 공통 규칙과 개별 예외를 어디에 둘지 판단할 수 있다. • □ target과 logs 폴더를 디버깅 관점에서 이해한다. |
| --- |

첫 End-to-End 실행

dbt seed / run / build / docs generate의 최소 순환을 먼저 몸에 익힌다.

| 필수 | 처음 읽는 사람은 장 끝의 ‘직접 해보기’를 반드시 해 본다. 이해가 아니라 손의 감각을 남기는 것이 목표다. |
| --- | --- |

| 이 장에서 배우는 것 • seed, source, run, test, docs generate가 각각 무엇을 하는지 구분한다. • 전체 build보다 좁은 범위 실행이 왜 유리한지 경험한다. • 레코드 한 건을 따라가며 모델이 어떻게 바뀌는지 본다. | 완료 기준 • companion 프로젝트의 기본 흐름을 스스로 다시 실행할 수 있다. • stg_orders 하나만 선택 실행하고 결과를 확인할 수 있다. • order_id 5003이 raw에서 staging으로 어떻게 정리되는지 설명할 수 있다. |
| --- | --- |

4-1. 가장 짧은 완주 루틴

초보자는 기능을 따로따로 배우기보다, 짧더라도 한 번 완주하는 편이 훨씬 빠르다. 아래 순환은 앞으로 계속 반복될 기본 루틴이다.

1. 원천 CSV 또는 raw 테이블을 준비한다.

2. source를 선언하고 staging 모델을 만든다.

3. dbt run 또는 dbt build로 relation을 생성한다.

4. dbt test로 데이터 가정이 깨지지 않았는지 본다.

5. dbt docs generate로 lineage와 설명을 한 번에 확인한다.

4-2. companion 프로젝트 기본 실행

| BASH python scripts/load_raw_to_duckdb.py --database ./dbt_book_lab.duckdb --day day1 dbt debug dbt seed dbt run -s stg_orders dbt test -s stg_orders dbt docs generate |
| --- |

| 작게 움직이기 처음부터 dbt build를 누르지 않아도 된다. 오히려 stg_orders처럼 범위를 좁혀 실행해 보면 source(), ref(), 테스트가 어떤 순서로 움직이는지 더 선명하게 보인다. |
| --- |

4-3. seed와 source를 헷갈리지 않기

| 리소스 | 주된 용도 | 교재 예시 |
| --- | --- | --- |
| seed | 작고 안정적인 참조 데이터를 프로젝트 내부에서 관리 | country_codes.csv, segment_mapping.csv |
| source | 프로젝트 바깥에서 적재된 원천 입력 선언 | raw.orders, raw.customers |
| model | source나 다른 model을 읽어 변환 | stg_orders, int_order_lines, fct_orders |

4-4. 레코드 추적: order_id = 5003

이 책은 같은 주문 하나를 여러 장에서 반복해 본다. 아래 표는 day1 기준 raw.orders의 5003번 주문이 staging에 오면서 어떤 컬럼으로 정리되는지를 보여 준다.

order_id 5003의 첫 번째 변화

| 층 | 핵심 컬럼 | 값 |
| --- | --- | --- |
| raw.orders | status / shipping_fee / total_amount | paid / 2.5 / 18.5 |
| stg_orders | order_status / order_date / total_amount | paid / 2026-03-04 / 18.5 |
| 의미 | 이름 정리 + 타입 캐스팅 | 원천의 문자열·날짜·상태값을 downstream 친화적으로 표준화 |

| SQL · stg_orders.sql with source_data as ( select * from {{ source('raw', 'orders') }} ), renamed as ( select order_id, customer_id, cast(order_ts as timestamp) as order_ts, cast(order_ts as date) as order_date, lower(status) as order_status, lower(payment_method) as payment_method, store_id, cast(shipping_fee as double) as shipping_fee, cast(total_amount as double) as total_amount, cast(updated_at as timestamp) as updated_at, cast(ingested_at as timestamp) as ingested_at from source_data ) select * from renamed |
| --- |

4-5. 첫 완주 후 무엇을 확인할까

• relation 이름이 예상한 schema에 만들어졌는가

• source → staging lineage가 docs에서 이어지는가

• 테스트 실패가 ‘데이터 품질’ 문제인지 ‘모델 로직’ 문제인지 구분할 수 있는가

• 선택 실행만으로도 필요한 검증을 상당 부분 끝낼 수 있다는 감각이 생겼는가

| 안티패턴 staging 단계에서 바로 최종 KPI까지 만들거나, source 선언 없이 raw 테이블명을 SQL에 직접 적는 것. |
| --- |

| 직접 해보기 1. stg_orders를 한 번 실행한 뒤, dbt ls -s stg_orders+로 downstream 범위를 확인한다. 2. raw.orders의 status 값 하나를 바꾼 뒤 stg_orders만 다시 실행해 어떤 컬럼이 변하는지 기록한다. 3. 문서 사이트에서 raw → stg_orders 노선을 캡처하거나 메모한다. 정답 확인 기준: seed, source, model이 각각 무슨 역할인지 헷갈리지 않고 말할 수 있으면 성공이다. |
| --- |

| 완료 체크리스트 • □ 짧은 완주 루틴을 직접 실행할 수 있다. • □ stg_orders 하나만 선택 실행해 볼 수 있다. • □ 5003 주문이 raw와 staging에서 어떻게 보이는지 설명할 수 있다. |
| --- |

프로젝트를 실제로 움직이는 워크플로 명령

dbt 명령어는 단순한 CLI 목록이 아니라 프로젝트를 관찰하고, 컴파일하고, 실행하고, 검증하고, 운영하는 workflow 언어다. 실제로 많이 쓰는 순서는 debug → parse → ls → compile → run/build → test → docs generate에 가깝고, 운영 단계에서는 state, defer, clone, retry, snapshot, semantic 명령이 그 뒤를 잇는다. Appendix B에는 전체 레퍼런스를 따로 실어 두었고, 이 절에서는 실제 학습 흐름에서 꼭 먼저 손에 익힐 조합만 뽑아 본다.

| 장면 | 먼저 쓸 명령 | 왜 이 명령부터 보는가 |
| --- | --- | --- |
| 환경 검증 | dbt debug | 연결과 profile 문제가 SQL 문제와 섞이지 않게 하기 위해 |
| 구조 확인 | dbt parse / dbt ls | 코드 구조와 selector 범위를 실행 전에 확인하기 위해 |
| SQL 확인 | dbt compile -s... | ref/source/Jinja가 최종 SQL로 어떻게 풀리는지 보기 위해 |
| 개발 실행 | dbt run -s... / dbt build -s... | 필요한 범위만 좁게 실행하기 위해 |
| 품질 검증 | dbt test / dbt snapshot | 품질 가정과 상태 이력을 확인하기 위해 |

Jinja는 어디까지 배우면 시작할 수 있는가

입문 단계에서는 세 가지만 알아도 충분하다. `{{... }}`는 값을 출력하거나 함수를 넣는 곳, `{%... %}`는 조건문·반복문 같은 제어 흐름, `{#... #}`는 주석이다. 여기에 `ref()`, `source()`, `config()`, `var()`, `env_var()`, 그리고 짧은 macro 한두 개만 익혀도 대부분의 실습을 따라갈 수 있다. Appendix C에는 delimiter, helper, macro 인수, whitespace control, run_query까지 길게 정리해 두었다.

예시 · Jinja가 섞인 가장 기본적인 dbt 모델

| select order_id, customer_id, cast(order_date as date) as order_date, lower(status) as order_status, cast(total_amount as double) as total_amount, cast(updated_at as timestamp) as updated_at from {{ source('raw_retail', 'orders') }} |
| --- |

코드 · SQL

세 예제를 올릴 때 가장 먼저 보는 경로

세 예제를 직접 시험해 보려면 `03_platform_bootstrap/<example>/<platform>/setup_day1.sql` 또는 MongoDB/Trino 스크립트부터 본다. 그 다음 `01_duckdb_runnable_project/dbt_all_in_one_lab/models/...` 아래의 staging과 marts를 열고, 같은 이름의 `.yml` 파일에서 source와 tests를 확인하면 된다. 이 순서를 익히면 어떤 DBMS에서든 “raw → dbt 모델 → 기대 결과”의 기본 경로를 같은 눈으로 볼 수 있다.

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

그림 7-1. grain을 적지 않고 join부터 시작하면 fanout이 생기기 쉽다

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

CHAPTER 05

디버깅, artifacts, runbook, anti-patterns

문제를 좁히는 순서, 실패 실험, 정답표와 워크북, 반복되는 실수까지 한 번에 묶는다.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

실무에서 가장 큰 차이를 만드는 것은 “정답을 미리 아는 능력”보다 “문제를 빨리 좁히는 순서”를 갖는 능력이다. dbt는 debug, parse, ls, compile, build라는 관찰 명령을 따로 제공하고, target과 logs와 artifacts를 분리해서 남기기 때문에, 이 구조를 이해하면 같은 실패도 훨씬 빠르게 다룰 수 있다.

이 장은 실패 재현 랩, 5003 expected result, day1/day2 runbook, 안티패턴 아틀라스를 함께 넣어 단순한 설명서가 아니라 실제 훈련 자료처럼 읽히도록 구성한다. 여기서 익힌 관찰 순서는 뒤의 예제 케이스북과 플랫폼 플레이북에서도 그대로 반복된다.

디버깅과 실패 재현 랩

| 필수+ | 처음 읽는 사람은 장 끝의 ‘직접 해보기’를 반드시 해 본다. 이해가 아니라 손의 감각을 남기는 것이 목표다. |
| --- | --- |

| 이 장에서 배우는 것 • 문제 유형을 설치/연결/구조/SQL/데이터 품질로 나눠 본다. • target/compiled, target/run, logs/dbt.log, manifest.json, run_results.json의 역할을 이해한다. • 실패 재현 랩을 통해 ‘망가뜨리고 고치는’ 경험을 한다. | 완료 기준 • 문제가 생겼을 때 전체 build를 반복하는 대신 범위를 줄이는 루틴을 쓸 수 있다. • 어떤 파일을 먼저 열어야 하는지 감이 생긴다. • source not found, ref not found, test failure, fanout bug를 재현하고 해결할 수 있다. |
| --- | --- |

그림 12-1. 문제를 좁히는 순서를 먼저 고정하면 불필요한 재실행이 크게 줄어든다

12-1. 디버깅은 명령 순서가 핵심이다

초보자가 가장 많이 시간을 잃는 순간은 설치 문제, YAML 문제, SQL 문제를 한 번에 잡으려 할 때다. 그래서 디버깅은 정답을 맞히는 기술보다 순서를 지키는 습관에 가깝다. debug는 연결, parse는 구조, ls는 선택 범위, compile은 SQL, run/build는 실제 실행이라는 계단을 만든다.

12-2. target과 logs, artifacts를 구분해 보기

| 위치 | 무엇이 있나 | 언제 보나 |
| --- | --- | --- |
| target/compiled | Jinja가 풀린 compiled SQL | 매크로·ref·조건문이 실제로 어떻게 해석됐는지 볼 때 |
| target/run | 실행에 사용된 SQL | materialization이나 adapter 동작이 궁금할 때 |
| logs/dbt.log | 오류 메시지, 쿼리 로그 | 콘솔보다 더 자세한 실패 맥락이 필요할 때 |
| manifest.json | 전체 프로젝트 메타데이터 | state selection, docs, lineage, config 확인 |
| run_results.json | 실행된 노드의 status와 timing | 느린 모델, 실패 노드, 실행 이력 파악 |
| sources.json | source freshness 결과 | freshness 실행 후 상태를 기록 |

failure lab 1 source not found

| 재현 방법 1. labs/01_source_not_found/broken_stg_orders.sql을 현재 stg_orders.sql 대신 복사한다. 2. dbt parse를 실행한다. 3. source 이름이 왜 끊겼는지 sources.yml과 SQL을 함께 본다. |
| --- |

| 체크 순서 1) models/sources.yml 의 source name / table name 2) 해당 모델 SQL 의 source() 인자 3) dbt parse 결과 4) target/manifest.json 에 source 노드가 잡혔는지 |
| --- |

failure lab 2 ref not found

모델 이름을 바꾸었는데 ref('예전이름')를 그대로 두면 ref not found가 난다. 이때는 실제 파일명, 모델 name, disabled 여부, selector 범위를 함께 봐야 한다.

failure lab 3 relationships / singular test 실패

테스트 실패는 곧바로 SQL 전체를 갈아엎으라는 신호가 아니다. 실패한 테스트가 어떤 가정을 말하는지 먼저 읽고, 관련 모델과 upstream 데이터를 좁혀 들어가야 한다. singular test는 실패 행을 직접 보여 주기 때문에 원인을 파악하기 더 쉽다.

failure lab 4 fanout bug

labs/03_fanout_bug에는 일부러 grain을 틀린 상태의 mart 예제가 들어 있다. row count와 gross_revenue 합계를 비교해 보고, intermediate로 조인을 끌어올린 이유를 다시 확인해 보자.

failure lab 5 incremental backfill 문제

labs/05_incremental_backfill은 updated_at 기준만으로는 과거 수정이 누락될 수 있음을 보여 준다. 이 랩은 ‘incremental은 더 복잡한 설계’라는 사실을 몸으로 익히게 해 준다.

| 막혔을 때 스스로에게 던질 질문 • 이건 연결 문제인가, 구조 문제인가, SQL 문제인가? • 현재 선택 범위가 너무 넓지 않은가? • compiled SQL을 실제로 확인했는가? • 실패 테스트가 말하는 가정을 정확히 이해했는가? • direct relation 이름을 써서 lineage를 깨뜨린 것은 아닌가? |
| --- |

| 안티패턴 에러가 나자마자 SQL을 새로 쓰기 시작하는 것. 먼저 debug/parse/ls/compile로 범위를 줄이는 편이 훨씬 빠르다. |
| --- |

| 직접 해보기 1. companion ZIP의 labs/01_source_not_found를 재현하고 dbt parse로 해결한다. 2. 다음으로 labs/03_fanout_bug를 재현한 뒤 row count와 gross_revenue 합계를 비교한다. 3. 마지막으로 run_results.json이 어떤 정보를 담는지 한 번 열어 본다. 정답 확인 기준: 오류가 났을 때 바로 전체 build를 반복하지 않고, 어떤 계단에서 멈췄는지 설명할 수 있으면 성공이다. |
| --- |

| 완료 체크리스트 • □ 디버깅 사다리의 순서를 기억한다. • □ target, logs, artifacts의 차이를 안다. • □ failure lab 하나 이상을 스스로 재현하고 고쳤다. |
| --- |

문제 해결 체크리스트

실패가 났을 때 제일 먼저 좁히는 순서를 다시 확인한다.

1. 가상환경이 활성화되어 있는가

2. dbt --version에서 adapter가 함께 보이는가

3. dbt debug가 통과하는가

4. profile 이름과 profiles.yml 최상위 키가 같은가

5. 실패 범위를 -s model_name까지 좁혔는가

6. dbt ls -s...로 선택 결과를 확인했는가

7. dbt parse로 구조 오류를 먼저 확인했는가

8. dbt compile -s...로 compiled SQL을 보았는가

9. target/run과 target/compiled를 구분해서 보고 있는가

10. logs/dbt.log를 열어 보았는가

11. 직접 relation 이름 하드코딩으로 lineage를 깨뜨리지 않았는가

12. 테스트 실패를 데이터 품질 문제와 로직 문제로 분리해서 보고 있는가

| 중요한 원칙 전체 실행을 반복하기 전에, 문제 범위를 줄이고 compiled SQL과 관련 artifacts를 보는 것이 가장 큰 시간 절약이다. |
| --- |

따라하기 워크북 모드

companion pack을 실제 실습서처럼 사용할 때의 step-by-step runbook.

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

초보자 안티패턴 아틀라스

시간이 갈수록 비용이 커지는 대표 패턴을 먼저 본다.

| 빠르게 읽는 법 • 지금 겪는 증상과 닮은 행이 보이면 해당 장으로 바로 돌아간다. • 안티패턴은 지식 부족의 증거가 아니라, 아직 규칙이 코드와 테스트로 고정되지 않았다는 신호다. |
| --- |

G-1. 자주 반복되는 안티패턴 8개

| 안티패턴 | 보이는 증상 | 왜 위험한가 | 돌아갈 장 |
| --- | --- | --- | --- |
| giant SQL 만능론 | rename, join, 집계, KPI가 한 파일에 다 섞여 있다 | 변경 지점과 테스트 위치가 흐려진다 | 01, 07 |
| raw relation 하드코딩 | from raw.orders가 여기저기 보인다 | lineage와 source 계약이 약해진다 | 05 |
| grain 없이 바로 join | row 수가 늘고 금액이 두 배가 된다 | fanout이 생겨도 원인을 설명하기 어렵다 | 07, 12 |
| 항상 전체 build | 작은 수정에도 시간이 오래 걸린다 | 실패 범위를 좁히지 못한다 | 06, 12 |
| premature incremental | 빨라졌지만 결과가 조용히 틀린다 | 새 행/수정 행/backfill 규칙이 비어 있다 | 08 |
| macro 과잉 추상화 | SQL보다 템플릿을 더 오래 읽게 된다 | 온보딩과 디버깅이 어려워진다 | 11 |
| 눈대중 검증만 하기 | 이번엔 맞아 보여도 다음 배치에서 다시 확인할 수 없다 | 가정이 테스트로 남지 않는다 | 09 |
| dev / prod 같은 schema 쓰기 | 실습 중 공용 자산이 덮어써진다 | 개발과 배포 규칙이 뒤섞인다 | 13 |

G-2. 좋은 흐름을 기억하는 다섯 문장

| 좋은 흐름 요약 • 원천을 읽는 첫 모델은 source()에서 시작한다. • join 전에 각 모델의 grain을 문장으로 적는다. • giant SQL이 보이면 intermediate로 역할을 나눈다. • 전체 build보다 ls / run / test로 범위를 좁힌다. • 규칙은 사람의 기억이 아니라 docs와 tests에 남긴다. |
| --- |

G-3. 스스로 진단해 보기

| 질문 | 예 / 아니오 | 메모 |
| --- | --- | --- |
| 최근에 raw relation 이름을 직접 적은 적이 있는가? | □ 예   □ 아니오 |  |
| join 전에 grain을 쓰지 않고 바로 SQL을 짜는 편인가? | □ 예   □ 아니오 |  |
| 작은 수정에도 습관처럼 전체 build를 돌리는가? | □ 예   □ 아니오 |  |
| 테스트 없이 눈으로만 확인하고 넘어간 모델이 있는가? | □ 예   □ 아니오 |  |
| incremental인데 full-refresh 기준을 팀 규칙으로 정하지 않았는가? | □ 예   □ 아니오 |  |
| dev와 prod의 schema 분리 원칙을 문장으로 설명하기 어려운가? | □ 예   □ 아니오 |  |

| 복습 미션 • 위 표에서 “예”가 나온 항목 둘을 골라, 그것을 줄이는 팀 규칙을 한 문장씩 적어 본다. • 각 항목이 다시 나타났을 때 어디로 돌아갈지 장 번호를 같이 적는다. |
| --- |

다음 단계에서 해볼 것

| 이제부터는 “학습용 프로젝트”를 “현업 온보딩 교재”로 바꿉니다 • APPENDIX H에서는 실제 요청 문장을 dbt 변경 작업으로 번역하는 실무 시나리오 5개를 다룬다. • APPENDIX I에서는 언제 view / table / incremental / snapshot / macro / intermediate를 쓰는지 결정표로 정리한다. • APPENDIX J에서는 01~15장을 질문으로 다시 묶어 1분 퀴즈와 자기 점검으로 복습한다. 책을 한 번 읽은 뒤에는 H → I → J 순서로 다시 훑으면 현업 적용 감각이 훨씬 빨라진다. |
| --- |

5003과 실패 재현 랩을 같이 쓰는 법

companion ZIP의 5003 expected result 표는 단순한 정답지가 아니다. source에서 읽은 값이 staging에서 어떻게 정리되고, intermediate에서 어떤 line grain으로 풀리며, mart와 snapshot에서 어떤 결과로 이어지는지를 단계별로 보여 준다. 실패 재현 랩과 함께 보면 “무엇이 기대값이었는지”와 “어디서부터 어긋났는지”를 동시에 확인할 수 있어 디버깅 훈련 자료로 매우 좋다.

5003 trace 시각화

안티패턴 아틀라스를 읽는 자세

안티패턴은 “틀린 예시 모음”이 아니라 비용이 커지는 방향을 미리 보는 지도다. giant SQL, 하드코딩, grain 미정 join, premature incremental, macro 남용 같은 실수는 처음에는 빠르게 보이지만 시간이 갈수록 디버깅과 협업 비용을 키운다. 그래서 안티패턴은 초반에 한 번 보고 끝내기보다, 예제 케이스북을 따라가며 같은 실수를 어디에서 피하고 있는지 비교해 보는 편이 더 효과적이다.

CHAPTER 06

운영, CI/CD, state/defer/clone, vars/env/hooks, 업그레이드

개인 실습을 팀 운영으로 끌고 갈 때 필요한 실행 전략을 한 흐름으로 묶는다.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

dbt 프로젝트가 팀 단위로 커지기 시작하면 “좋은 모델”만으로는 충분하지 않다. dev/prod 분리, PR 검증, slim CI, state selector, defer, clone, env_var, hooks, run-operation, release track 같은 운영 요소가 함께 들어와야 프로젝트가 계속 살아남는다.

이 장은 로컬 검증 루틴에서 시작해 state-aware 실행, CI job 설계, vars와 target을 이용한 환경 분기, 업그레이드 체크리스트까지 이어지는 운영 흐름을 한 챕터로 묶는다. dbt platform의 environments/jobs 관점도 여기에서 함께 읽어 둔다.

운영·배포·협업

| 선택 | 처음 읽는 사람은 장 끝의 ‘직접 해보기’를 반드시 해 본다. 이해가 아니라 손의 감각을 남기는 것이 목표다. |
| --- | --- |

| 이 장에서 배우는 것 • dev/prod 분리와 개인 스키마의 필요성을 이해한다. • PR 검증과 배포 실행의 목적이 다르다는 점을 배운다. • state:modified+, --defer, dbt clone, dbt retry를 초보자 시각으로 정리한다. | 완료 기준 • 로컬 개발 → PR → CI → 배포 흐름을 설명할 수 있다. • slim CI가 왜 빠른지와 defer의 핵심을 이해한다. • 실무 도입 초기에 어떤 운영 규칙을 먼저 정해야 하는지 말할 수 있다. |
| --- | --- |

그림 13-1. 로컬 검증은 좁게, PR은 빠르게, 배포는 안정적으로

13-1. 개인 실습과 팀 운영의 가장 큰 차이

혼자 배울 때는 모델이 돌아가기만 해도 충분히 기쁘다. 하지만 팀 프로젝트에서는 반복 가능성, 리뷰 가능성, 배포 안정성이 더 중요해진다. 따라서 일정 수준을 넘기면 좋은 SQL만으로는 부족하고, 브랜치 전략, PR 리뷰, 환경 분리, 문서 유지가 함께 들어온다.

13-2. dev / prod를 머릿속에서 먼저 분리하자

| 환경 | 목적 | 권장 습관 |
| --- | --- | --- |
| dev | 개인 실험과 빠른 수정 | 개인 schema를 쓰고 선택 실행 위주로 개발 |
| prod | 공용 분석 자산 제공 | 더 엄격한 테스트와 권한 정책 적용 |

13-3. slim CI를 너무 어렵게 생각하지 않기

slim CI의 핵심은 ‘바뀐 영역만 빠르게 검증한다’는 데 있다. state:modified+는 현재 프로젝트와 기준 manifest를 비교해 새로 추가되거나 변경된 리소스를 찾고, --defer는 현재 환경에 없는 upstream 모델을 기준 환경의 relation로 참조하게 해 준다.

| BASH dbt parse dbt build --select state:modified+ --defer --state ./state_artifacts |
| --- |

프로젝트가 작을 때는 이 패턴이 과하게 느껴질 수 있다. 그 경우에는 핵심 mart나 변경 도메인만 고르는 단순한 CI로 시작해도 된다. 중요한 것은 ‘PR 단계의 목적은 빠른 피드백’이라는 점이다.

13-4. dbt clone과 dbt retry는 언제 떠올리나

| 명령 | 언제 유용한가 | 초보자 한 줄 해석 |
| --- | --- | --- |
| dbt clone | 큰 테이블을 CI/dev 환경으로 빠르게 가져오고 싶을 때 | 실제 재생성 대신 clone materialization을 활용한다 |
| dbt retry | 직전 실행의 실패 노드만 다시 돌리고 싶을 때 | 대형 배치에서 복구 시간을 줄여 준다 |

13-5. 운영 초기에 먼저 정할 규칙

• 원천을 읽는 첫 모델은 source()를 쓴다.

• 핵심 키 컬럼에는 generic test를 기본으로 붙인다.

• staging에서는 집계하지 않고 marts에서 최종 KPI를 만든다.

• PR 설명에 변경된 모델과 영향 범위를 적는다.

• 민감 정보는 env_var()로 분리한다.

• docs와 설명은 모델 추가와 동시에 갱신한다.

| 작게 시작하는 것이 낫다 운영 장이라고 해서 처음부터 완벽한 거버넌스를 요구할 필요는 없다. 개인 schema 분리, PR 리뷰, 핵심 테스트, 문서화, slim CI의 뼈대만 잡아도 초기 시행착오가 크게 줄어든다. |
| --- |

| 안티패턴 개발과 배포를 같은 schema에서 처리하고, 에러가 나면 warehouse 크기나 스레드 수부터 키우는 것. |
| --- |

| 직접 해보기 1. 우리 팀에 dev와 prod를 어떻게 나눌지 스키마 이름 예시와 함께 적어 본다. 2. ‘PR 단계에서 최소 무엇을 돌릴까?’를 한 줄 명령으로 적어 본다. 3. state:modified+와 --defer가 각각 어떤 문제를 푸는지 한 문장씩 써 본다. 정답 확인 기준: 운영의 핵심이 기능 개수보다 규칙과 목적의 분리라는 점을 이해하면 성공이다. |
| --- |

| 완료 체크리스트 • □ dev/prod 분리를 설명할 수 있다. • □ PR CI와 배포 실행의 목적이 다르다는 것을 안다. • □ state, defer, clone, retry를 어디서 쓸지 감이 생겼다. |
| --- |

Artifacts · State · Slim CI

| 구분 | 로컬 | dbt platform | 핵심 메모 |
| --- | --- | --- | --- |
| 장 16 | state selection, defer, clone, retry 가능 | state-aware orchestration, CI jobs, job metadata와 연결됨 | 같은 개념이 로컬과 플랫폼에서 모두 쓰이지만 자동화 강도는 플랫폼 쪽이 더 높다. |

16-1. artifacts를 읽으면 dbt가 “무슨 생각을 했는지” 보인다

dbt는 실행할 때마다 프로젝트 상태를 artifacts로 남긴다. 입문 단계에서는 target/compiled만 보아도 도움이 되지만, 팀 운영 단계로 넘어가면 manifest.json, run_results.json, sources.json, catalog.json을 함께 보는 편이 훨씬 강력하다. 이 파일들은 단순 부산물이 아니라, state comparison, docs, source freshness, CI 재시도와 같은 기능의 기반이 된다.

운영 단계에서 자주 보는 artifact

| artifact | 주로 어디에 쓰는가 |
| --- | --- |
| manifest.json | 프로젝트 그래프, node metadata, state comparison, docs의 중심 메타데이터 |
| run_results.json | 어떤 node가 성공/실패/스킵되었는지, 소요 시간이 얼마나 걸렸는지 확인 |
| sources.json | source freshness 결과와 source_status selector의 입력 |
| catalog.json | dbt docs에서 relation/column 메타데이터 탐색에 사용 |

16-2. state selector는 “무엇이 바뀌었는가”를 코드 기준으로 좁힌다

state selection은 현재 프로젝트를 이전 manifest와 비교해 새로 생기거나 수정된 리소스를 찾는 기능이다. 로컬 개발에서는 “내가 지금 바꾼 것만 빠르게 검증”하는 데 쓰고, CI에서는 modified 영역과 그 downstream만 빌드하는 slim CI의 핵심이 된다. 다만 vars나 env_var 값의 변경처럼 정적 비교로 완전히 잡히지 않는 경우가 있으므로, state만 맹신하지 말고 도메인 상식과 selector를 함께 써야 한다.

| dbt ls --select state:modified+dbt build --select state:modified+dbt build --select source_status:fresher+# prod artifact를 비교 기준으로 사용할 때# dbt build --select state:modified+ --state path/to/prod_artifacts |
| --- |

16-3. defer, clone, retry는 큰 프로젝트의 체감 속도를 바꾼다

defer는 현재 환경에 없는 upstream relation을 비교 기준 환경의 relation로 대신 참조하게 하여, 일부 모델만 샌드박스에서 검증하도록 돕는다. clone은 선택한 노드를 state 기준 환경에서 대상 schema로 복제해, 무거운 incremental/table 모델을 굳이 재계산하지 않고도 테스트 환경을 빠르게 마련하게 해 준다. retry는 마지막 명령이 node 일부를 실행한 뒤 중간에서 실패했을 때, 실패 지점부터 다시 이어서 실행하도록 도와 준다.

| dbt build --select state:modified+ --defer --state path/to/prod_artifactsdbt clone --select tag:heavy --state path/to/prod_artifactsdbt retry |
| --- |

16-4. selectors.yml로 팀의 공용 실행 패턴을 코드화한다

selector 문법을 매번 CLI에 길게 적는 대신 selectors.yml에 “slim_ci”, “nightly_heavy”, “semantic_refresh” 같은 이름으로 저장하면 팀 공통 실행 패턴을 코드처럼 관리할 수 있다. 이렇게 해 두면 리뷰와 운영 지식이 사람이 아니라 저장소 안에 남는다. beginner 단계에서는 --select를 손으로 익히고, intermediate 이후부터는 공용 selector로 승격하는 식이 가장 자연스럽다.

| selectors:  - name: slim_ci    definition: "state:modified+"  - name: nightly_heavy    definition: "tag:heavy,tag:nightly"  - name: semantic_refresh    definition: "path:models/semantic+" |
| --- |

실무 체크포인트: state는 “코드 차이”, defer는 “upstream 대체 참조”, clone은 “비용을 아끼는 빠른 실체 복제”, retry는 “중간 실패 뒤 이어 달리기”라고 기억하면 헷갈림이 크게 줄어든다.

Vars · Env · Hooks · Operations · Packages

| 구분 | 로컬 | dbt platform | 핵심 메모 |
| --- | --- | --- | --- |
| 장 17 | var, env_var, run-operation, packages 가능 | dbt CLI와 Studio IDE에서도 같은 개념을 사용 | packages는 어디서나 쓰지만 project dependencies는 다음 장의 별도 제약을 따른다. |

17-1. var, env_var, target: “환경별로 다르다”를 프로젝트 안에 선언하는 세 가지 축

var()는 프로젝트 기본값과 실행 시점 오버라이드를 연결하고, env_var()는 비밀값과 환경별 설정을 외부에서 주입하며, target은 현재 연결된 환경의 database/schema/warehouse 정보를 읽게 해 준다. beginner 단계에서는 profile과 schema 이름 정도만 다루지만, intermediate 이후에는 샘플 기간, feature flag, semantic refresh 여부 같은 것도 var로 제어하는 편이 유용하다.

| {{ config(schema=target.schema) }}where order_date >= {{ var('start_date', '2026-01-01') }}password: "{{ env_var('DBT_ENV_SECRET_SNOWFLAKE_PASSWORD') }}" |
| --- |

17-2. hook는 강력하지만, 먼저 built-in config로 해결할 수 없는지 확인한다

pre-hook, post-hook, on-run-start, on-run-end는 표준 materialization과 config만으로 표현하기 어려운 작업을 붙일 때 유용하다. 다만 grants, persist_docs, contracts처럼 이미 dbt가 공식 설정을 제공하는 영역은 hook보다 built-in config를 우선하는 편이 유지보수에 좋다. hook는 “dbt 바깥의 작업을 억지로 우겨 넣는 마법”이 아니라, 꼭 필요한 warehouse-specific 작업을 최소 범위로 수행하는 도구라고 보는 편이 안전하다.

| models:  my_project:    marts:      +post-hook:        - "analyze table {{ this }} compute statistics"on-run-end:  - "{% for schema in schemas %}grant usage on schema {{ schema }} to role reporter;{% endfor %}" |
| --- |

17-3. run-operation은 “모델이 아닌 작업”을 위한 도어다

run-operation은 매크로를 직접 호출해 maintenance SQL이나 관리 작업을 실행할 때 쓴다. 예를 들어 오래된 schema 정리, warehouse 통계 수집, audit 테이블 기록, 버전 전환용 view 재생성 같은 작업이 여기에 해당한다. 모델과 테스트의 책임을 흐리지 않고도 운영 작업을 코드로 남길 수 있다는 점이 장점이다.

| dbt run-operation grant_reporter_access --args '{role: reporter}'dbt run-operation cleanup_old_schemas --args '{prefix: dbt_}' |
| --- |

17-4. packages.yml과 dependencies.yml을 구분해 생각한다

packages는 재사용 가능한 독립 dbt 프로젝트를 가져와 모델·매크로·tests를 내 프로젝트의 일부처럼 쓰게 해 준다. 반면 project dependencies는 mesh나 cross-project ref처럼 다른 프로젝트를 “소비”하는 관계를 표현하는 데 더 적합하다. 작은 팀에서는 packages만으로도 충분하지만, 프로젝트가 커져 ownership 경계가 생기기 시작하면 dependencies.yml을 고려할 시점이 온다.

| packages:  - package: dbt-labs/dbt_utils    version: [">=1.2.0", "<2.0.0"]# dependencies.yml 예시projects:  - name: finance_core    version: ">=1.0.0" |
| --- |

17-5. 패키지·매크로·UDF·모델의 경계를 어떻게 잡을까

같은 SQL 조각이 세 번 반복되면 macro 후보, 여러 도구에서 반복 사용할 계산이면 UDF 후보, 결과 relation 자체를 재사용해야 하면 모델 후보, 여러 프로젝트가 함께 써야 하면 package 후보라고 보면 출발점으로 충분하다. “공유할 것”을 무엇으로 공유할지 분류하는 감각이 생기면 프로젝트가 덜 꼬인다.

• 패키지는 문제 영역 단위로 재사용한다. 작은 개인 취향 매크로 모음은 package보다 root project가 낫다.

• env_var는 secret과 환경별 차이를 관리하는 도구지, 비즈니스 규칙을 숨기는 도구가 아니다.

• hook는 built-in config보다 우선순위가 낮다. grants·persist_docs·contracts를 hook로 대체하지 않는다.

버전/트랙 메모: package와 semantic 관련 기능은 dbt 버전·engine에 따라 문법과 지원 범위가 달라질 수 있으므로, companion pack의 예시는 개념과 뼈대를 익히는 용도로 보고 실제 도입 전에는 현재 사용 중인 track 문서를 다시 확인하는 편이 안전하다.

dbt platform 작업환경 가이드

dbt platform의 environment / job / interface를 도구 설명이 아니라 운영면으로 읽는다.

N-1. environment는 세 가지를 정한다

| environment가 정하는 것 | 설명 | 초보자 메모 |
| --- | --- | --- |
| dbt 실행 버전/엔진 | 어떤 dbt version 또는 release track, 어떤 engine으로 실행할지 | 로컬과 플랫폼 결과가 다르면 여기부터 본다. |
| warehouse 연결 정보 | database/schema/role/credentials 등 실행 대상 | dev/prod 분리의 핵심이다. |
| 실행할 코드 버전 | 어느 branch/commit의 프로젝트를 실행할지 | CI와 배포에서 중요하다. |

dbt platform에서는 Development 환경과 Deployment 환경을 구분해서 생각하는 것이 중요하다. Deployment 환경 안에서도 production / staging / general 성격이 갈릴 수 있으므로, “잡(job)이 어떤 환경을 바라보는가”를 먼저 이해해야 한다.

N-2. 어떤 인터페이스를 언제 쓸까

| 도구 | 가장 잘하는 일 | 주의점 |
| --- | --- | --- |
| Studio IDE | 브라우저에서 바로 build/test/run, Catalog와의 왕복, platform-native 개발 | 로컬 편집기와의 습관 차이를 인정해야 한다. |
| dbt CLI | 로컬 터미널에서 dbt 명령과 MetricFlow 명령을 동일한 리듬으로 실행 | dbt_cloud.yml 또는 profiles.yml 등 인증 흐름을 먼저 맞춘다. |
| VS Code extension | Fusion 기반 LSP, 인라인 오류, 리팩터링, hover 정보 | Fusion 전용이며 Core CLI 단독과는 다르다. |
| Catalog | 동적 문서/lineage/협업 메타데이터 탐색 | dbt Docs 정적 사이트와 목적이 다르다. |
| dbt Docs | 정적 사이트 생성·호스팅이 쉬운 문서 출력 | 최신 메타데이터 경험은 Catalog 쪽이 더 풍부하다. |
| Canvas | 시각적 모델 작성과 빠른 초안 제작 | Enterprise 계열 기능이며 모든 팀에 필수는 아니다. |

N-3. job 설계는 “얼마나 자주, 얼마나 넓게, 누가 소비하나”로 정한다

• CI job: PR 변경분과 downstream만 좁게 build/test한다.

• Deploy job: production metadata를 남기며 안정적으로 전체 또는 상태 기준 범위를 실행한다.

• Documentation/metadata job: Catalog를 더 풍부하게 쓰려면 job에서 문서 metadata를 남기는 습관이 필요하다.

• Semantic export/cache job: saved query exports와 caching을 운영하려면 주기와 freshness를 함께 본다.

| 선택 기준• local-only: 비용 제어와 자유도가 가장 크지만, 문서/CI/공유 메타데이터는 직접 구축해야 한다.• hybrid: 로컬 개발 + platform 배포/문서/CI를 섞는 가장 현실적인 형태다.• platform-first: Studio/Catalog/Jobs/Canvas를 한 흐름으로 쓰는 팀에 잘 맞는다. |
| --- |

업그레이드·릴리스 트랙·행동 변화 체크리스트

버전 변화와 behavior change를 운영 절차로 다룬다.

P-1. 먼저 support 상태를 읽는 법

| 상태 | 뜻 | 운영 메모 |
| --- | --- | --- |
| Active | 일반 버그 수정과 보안 패치가 이어지는 지원 구간 | 가능하면 이 구간을 기준으로 학습/운영한다. |
| Critical | 보안·설치 이슈 중심의 제한적 지원 구간 | 당장 못 올리더라도 업그레이드 계획을 세워야 한다. |
| Deprecated | 문서는 남아 있어도 유지보수 기대치가 크게 떨어지는 구간 | 새 기능을 기대하지 말고 마이그레이션을 준비한다. |
| End of Life | 패치가 더 이상 나오지 않는 구간 | 실운영 장기 유지 대상으로는 피해야 한다. |

P-2. dbt platform release track을 고르는 기준

| release track | 성격 | 누가 먼저 고려하나 |
| --- | --- | --- |
| Latest Fusion | 새 엔진의 최신 build를 가장 먼저 받는 축 | Fusion 실험과 최신 기능 추적이 중요한 팀 |
| Latest | dbt platform의 최신 기능을 가장 빠르게 받는 축 | 새 기능을 빨리 쓰고 싶은 팀 |
| Compatible | 최근 dbt Core 공개 버전과의 호환성을 더 중시하는 월간 cadence | Core와 platform을 함께 쓰는 hybrid 팀 |
| Extended | Compatible보다 한 단계 더 완만한 cadence | 변화 흡수가 느린 엔터프라이즈 팀 |
| Fallback | 가장 느린 cadence 계열 | 변경 리스크를 최소화해야 하는 팀 |

P-3. behavior changes와 deprecations는 같은 것이 아니다

behavior change flags는 새 기본 동작으로 넘어가기 전의 이행 창구에 가깝고, deprecations는 앞으로 제거될 문법/행동을 경고하는 신호에 가깝다. 둘 다 “나중에 보자”로 미루기 쉬운데, 실제로는 버전 업그레이드 품질의 절반이 여기서 갈린다.

# dbt_project.yml

flags:

require_generic_test_arguments_property: true

state_modified_compare_more_unrendered_values: true

• 업그레이드는 dev 환경에서 먼저 시도하고, selectors로 범위를 좁혀 smoke test를 돈다.

• deprecation 경고는 릴리스 직전이 아니라 분기 초반에 정리해야 팀 전체 비용이 낮다.

• packages와 adapter의 require-dbt-version 조건도 함께 확인한다.

운영 장을 읽을 때의 관점

운영 파트는 기능을 더 붙이는 장이 아니라, 이미 만든 프로젝트를 어떻게 느리게 망가지지 않게 만들 것인가를 다루는 장이다. state/defer/clone은 속도를, vars/env/hooks는 환경 분기를, release track과 upgrade checklist는 변화 관리를, dbt platform 작업환경은 팀의 실행면을 설명한다. 뒤의 플랫폼 플레이북에서는 같은 운영 원칙이 각 플랫폼에서 어떤 형태로 구현되는지도 함께 다시 본다.

| 운영 질문 | 먼저 확인할 장치 |
| --- | --- |
| PR에서 필요한 것만 빠르게 검증하고 싶다 | state:modified+, defer, clone, selectors.yml |
| 환경별 schema/target을 깔끔하게 분리하고 싶다 | target, var, env_var, profiles / platform environments |
| 업그레이드 때 어디가 깨질지 두렵다 | release track, deprecations, behavior changes checklist |
| 동일한 실행 패턴을 팀 공용 규칙으로 만들고 싶다 | selectors.yml, job templates, run-operation helpers |

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

CHAPTER 10

Casebook II · Event Stream

append-only 이벤트 데이터를 incremental, session, DAU, cache, cost 관점으로 확장한다.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

Event Stream은 Retail Orders와 달리 append-only 성격이 강하고, 시간 축과 세션화가 핵심이 되는 예제다. 이 예제를 통해 incremental이 왜 필요한지, late-arriving data가 어떤 문제를 만드는지, saved query나 cache가 언제 가치가 생기는지 훨씬 선명하게 볼 수 있다.

이 장은 users/events raw bootstrap에서 출발해 stg_events, fct_sessions, fct_daily_active_users, incremental 전략, microbatch 패턴, semantic metric, cost-aware selector, state-based 운영까지 이어지는 흐름을 한 예제로 연결한다.

이 예제를 시작할 때 가장 먼저 확인할 파일

| 구분 | 파일 경로 | 왜 먼저 보는가 |
| --- | --- | --- |
| bootstrap | 03_platform_bootstrap/events/<platform>/setup_day1.sql | events/users day1 raw를 생성 |
| day2 변경 | 03_platform_bootstrap/events/<platform>/apply_day2.sql | 이벤트 추가와 late-arriving change 주입 |
| source 정의 | models/events/events_sources.yml | raw_events source 범위를 확인 |
| 핵심 모델 | models/events/staging/stg_events.sql | 이벤트 시간/이름/플랫폼 정규화 |
| 핵심 mart | models/events/marts/fct_sessions.sql | session grain을 정의하는 곳 |

Event Stream 예제는 companion ZIP의 `03_platform_bootstrap/events/` 아래 bootstrap 스크립트와 `01_duckdb_runnable_project/dbt_all_in_one_lab/models/` 아래 모델 파일이 함께 움직인다. day1은 안정된 초기 상태를, day2는 실제 프로젝트에서 흔히 생기는 변경을 흉내 낸다. 따라서 이 장의 핵심은 단순히 모델 결과를 보는 것이 아니라, day1과 day2 사이의 변화가 어떤 dbt 장치들을 필요로 하게 만드는지 추적하는 데 있다.

이벤트 예제가 필요한 이유

Event Stream은 소매 주문 예제와 달리 append-only raw를 다룬다. 새로운 이벤트가 계속 들어오고, 어떤 경우에는 늦게 도착하며, session이나 DAU처럼 시간 축 집계가 중요하다. 따라서 이 예제는 incremental을 왜 쓰는지, backfill window가 왜 필요한지, selector와 cost-aware execution이 어떻게 도움이 되는지를 가장 잘 보여 준다.

Trino 기준 events day1 bootstrap 일부

| -- events day1 bootstrap for trino CREATE SCHEMA IF NOT EXISTS memory.raw_events; DROP TABLE IF EXISTS memory.raw_events.users; CREATE TABLE memory.raw_events.users ( user_id INTEGER, signup_at TIMESTAMP, country_code VARCHAR ); INSERT INTO memory.raw_events.users (user_id, signup_at, country_code) VALUES (9001, '2026-04-01 08:00:00', 'KR'), (9002, '2026-04-01 10:00:00', 'KR'), (9003, '2026-04-02 11:30:00', 'US'); DROP TABLE IF EXISTS memory.raw_events.events; CREATE TABLE memory.raw_events.events ( event_id VARCHAR, user_id INTEGER, event_at TIMESTAMP, event_name VARCHAR, platform VARCHAR, session_id VARCHAR |
| --- |

코드 · SQL

session grain과 daily active users

`stg_events`는 event timestamp와 event_date, platform, session_id를 표준화한다. 그 다음 `fct_sessions`는 session grain으로 묶고, `fct_daily_active_users`는 event_date grain으로 다시 집계한다. 이 레이어 분리가 중요한 이유는 session과 DAU가 서로 다른 grain의 질문이기 때문이다. 같은 raw를 두 번 다른 grain으로 보는 구조를 만들면, intermediate와 marts의 역할 차이가 자연스럽게 드러난다.

핵심 mart · fct_sessions

| with events as ( select * from {{ ref('stg_events') }} ) select session_id, min(event_at) as session_started_at, max(event_at) as session_ended_at, min(user_id) as user_id, count(*) as event_count from events group by 1 |
| --- |

코드 · SQL

핵심 mart · fct_daily_active_users

| {{ config(materialized='incremental', unique_key='event_date') }} with events as ( select * from {{ ref('stg_events') }} {% if is_incremental() %} where event_date >= ( select coalesce(max(event_date), cast('1900-01-01' as date)) from {{ this }} ) {% endif %} ) select event_date, count(distinct user_id) as dau from events group by 1 |
| --- |

코드 · SQL

incremental과 비용 통제

Event Stream에서 incremental은 빠른 최적화가 아니라 기본 구조의 일부가 되기 쉽다. 이벤트가 매일 늘어나고 전체 재계산 비용이 커지기 때문이다. 하지만 incremental은 grain, unique key, late-arriving window가 명확할 때만 도움이 된다. 이 예제에서는 day2 이벤트를 추가한 뒤 backfill 범위를 좁게 잡아 보고, state selector와 함께 필요한 모델만 다시 빌드하는 연습을 해 볼 수 있다. BigQuery와 ClickHouse 플레이북에서 이 부분이 특히 중요하게 다시 등장한다.

microbatch 패턴 예시

| {{ config( materialized='incremental', incremental_strategy='microbatch', event_time='event_at', batch_size='day', lookback=2, concurrent_batches=false ) }} select * from {{ ref('stg_events') }} |
| --- |

코드 · SQL

semantic, cache, saved query

이벤트 도메인은 semantic layer의 가치가 빠르게 보이는 곳이기도 하다. DAU, sessions, retention 비슷한 질문이 반복되기 때문이다. semantic model과 metric을 정의해 두면 반복 질문이 모델 위에 한 겹 더 올라가고, saved query와 cache는 자주 쓰는 질문을 더 안정적으로 재사용하게 해 준다. 이 예제는 advanced 장에서 다룬 semantic runbook을 실제로 붙여 보기 좋은 출발점이다.

| Event Stream 실험 루틴 1) setup_day1.sql 실행 → 2) dbt build -s events → 3) expected DAU 비교 → 4) apply_day2.sql 실행 → 5) incremental / backfill window 조정 → 6) saved query와 semantic metric 정의 검토 |
| --- |

CHAPTER 11

Casebook III · Subscription & Billing

상태 변화와 계약을 다루는 구독 도메인으로 snapshot, versions, contracts, metric layer를 입체적으로 본다.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

Subscription & Billing 예제는 상태 변화와 공용 정의가 중요한 도메인을 보여 준다. 구독의 상태는 시간에 따라 바뀌고, 취소와 trialing과 active의 의미는 metric에 직접 영향을 주며, MRR 같은 지표는 정의가 조금만 흔들려도 실무에 큰 혼선을 만든다.

이 장은 subscriptions day1/day2, invoices, plans, accounts raw에서 시작해 stg_subscriptions, fct_mrr, status snapshot, contracts, versions, semantic metric, governed sharing까지 이어지는 흐름을 보여 준다. 세 예제 중 거버넌스와 semantic layer의 가치를 가장 강하게 느끼기 좋은 장이다.

이 예제를 시작할 때 가장 먼저 확인할 파일

| 구분 | 파일 경로 | 왜 먼저 보는가 |
| --- | --- | --- |
| bootstrap | 03_platform_bootstrap/subscription/<platform>/setup_day1.sql | accounts/plans/subscriptions/invoices raw를 생성 |
| day2 변경 | 03_platform_bootstrap/subscription/<platform>/apply_day2.sql | 상태 변경과 취소를 day2로 주입 |
| source 정의 | models/subscription/subscription_sources.yml | raw_subscription source 범위 확인 |
| 핵심 모델 | models/subscription/staging/stg_subscriptions.sql | 상태 변화와 월금액을 표준화 |
| 핵심 mart | models/subscription/marts/fct_mrr.sql | MRR을 계산하는 기준점 |

Subscription & Billing 예제는 companion ZIP의 `03_platform_bootstrap/subscription/` 아래 bootstrap 스크립트와 `01_duckdb_runnable_project/dbt_all_in_one_lab/models/` 아래 모델 파일이 함께 움직인다. day1은 안정된 초기 상태를, day2는 실제 프로젝트에서 흔히 생기는 변경을 흉내 낸다. 따라서 이 장의 핵심은 단순히 모델 결과를 보는 것이 아니라, day1과 day2 사이의 변화가 어떤 dbt 장치들을 필요로 하게 만드는지 추적하는 데 있다.

구독 도메인이 특별한 이유

구독 도메인은 상태 변화와 계약의 일관성이 핵심이다. active, trialing, canceled 같은 상태는 단순한 문자열이 아니라 metric 계산 규칙과 직결되고, MRR 정의는 팀마다 조금만 달라도 큰 혼선을 만든다. 따라서 이 예제는 snapshot, contracts, versions, semantic metric의 필요성을 가장 설득력 있게 보여 준다.

핵심 staging · stg_subscriptions

| select subscription_id, account_id, plan_id, lower(status) as subscription_status, cast(started_at as date) as started_at, nullif(cancelled_at, '') as cancelled_at_raw, cast(monthly_amount as double) as monthly_amount, cast(updated_at as timestamp) as updated_at from {{ source('raw_billing', 'subscriptions') }} |
| --- |

코드 · SQL

핵심 mart · fct_mrr

| with subs as ( select subscription_id, account_id, plan_id, subscription_status, started_at, case when cancelled_at_raw is null or cancelled_at_raw = '' then null else cast(cancelled_at_raw as date) end as cancelled_at, monthly_amount from {{ ref('stg_subscriptions') }} ), active as ( select * from subs where subscription_status in ('active', 'trialing') ) select plan_id, count(*) as active_subscriptions, sum(monthly_amount) as mrr from active |
| --- |

코드 · SQL

snapshot과 versioned API

Subscription 예제는 day1/day2 사이에서 구독 상태가 바뀌도록 설계되어 있어 snapshot의 가치를 바로 체감하기 좋다. subscriptions_status_snapshot은 상태 변화 이력을 row version 형태로 남기고, downstream에서는 현재 유효 상태를 보는 모델과 과거 상태 변화를 보는 모델을 구분해 설계할 수 있다. 또한 MRR 모델은 contracts와 versions를 붙여 “이 버전의 MRR 정의를 믿고 써도 되는가”를 코드로 설명하기 좋다.

subscription snapshot 예시

| {% snapshot subscriptions_status_snapshot %} {{ config( target_schema='snapshots', unique_key='subscription_id', strategy='check', check_cols=['subscription_status', 'plan_id', 'monthly_amount'], updated_at='updated_at' ) }} select * from {{ ref('stg_subscriptions') }} {% endsnapshot %} |
| --- |

코드 · SQL

semantic과 governed sharing

구독 도메인에서는 semantic layer가 단순 편의 기능이 아니라 정의 충돌을 줄이는 장치가 되기 쉽다. active_subscriptions, mrr, churn-like metrics를 semantic model과 metric으로 명시하면, BI와 reverse ETL, AI surface가 같은 정의를 바라보게 만들기 좋다. 이때 versions와 group/access/grants를 함께 붙이면 한 프로젝트 안에서도 “어떤 팀이 어떤 정의를 공용 API처럼 소비하는가”를 더 명확히 관리할 수 있다.

contracts / versions 예시

| version: 2 groups: - name: finance owner: name: finance-data email: finance-data@example.com models: - name: fct_orders config: access: public group: finance contract: enforced: true grants: select: ['reporter', 'bi_reader'] columns: - name: order_id data_type: bigint constraints: - type: not_null - name: gross_revenue data_type: numeric - name: fct_mrr latest_version: 2 versions: |
| --- |

코드 · YAML

| Subscription & Billing 실험 루틴 1) setup_day1.sql 실행 → 2) dbt build -s subscription → 3) fct_mrr expected 결과 비교 → 4) apply_day2.sql 실행 → 5) dbt snapshot으로 상태 이력 생성 → 6) contracts, versions, semantic metric을 붙여 governed API처럼 다듬기 |
| --- |

PART IV · 플랫폼 플레이북

플랫폼 플레이북

플랫폼 장은 단순한 profile 모음이 아니다. 앞에서 배운 모든 원리가 각 실행 환경에서 어떤 형태로 바뀌는지, 세 예제를 실제로 어떻게 올리고 운영하는지 보여 주는 장이다.

CHAPTER 12

Platform Playbook · DuckDB

가장 빠른 학습 환경이자 companion runnable project의 기준점.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

DuckDB는 이 책의 기본 출발점이다. 로컬에서 빠르게 반복 실행할 수 있고, 비용과 권한 문제를 거의 신경 쓰지 않으면서도 source, model, test, snapshot, docs, semantic starter까지 대부분의 기본기를 연습할 수 있기 때문이다.

이 장은 DuckDB profile, raw bootstrap, companion runnable project, 세 예제 실행 순서, local debugging과 expected result 확인 방식, DuckDB를 실전 운영으로 오해하지 않기 위한 경계선을 함께 정리한다.

가장 먼저 확인할 profile / setup 예시

DuckDB profile 예시

| dbt_all_in_one_lab: target: dev outputs: dev: type: duckdb path: ./lab.duckdb threads: 4 |
| --- |

코드 · YAML

| 예제 | day1 bootstrap 경로 | day2 변경 경로 |
| --- | --- | --- |
| Retail Orders | 03_platform_bootstrap/retail/duckdb/setup_day1.sql | 03_platform_bootstrap/retail/duckdb/apply_day2.sql |
| Event Stream | 03_platform_bootstrap/events/duckdb/setup_day1.sql | 03_platform_bootstrap/events/duckdb/apply_day2.sql |
| Subscription & Billing | 03_platform_bootstrap/subscription/duckdb/setup_day1.sql | 03_platform_bootstrap/subscription/duckdb/apply_day2.sql |

DuckDB chapter의 핵심은 “가장 빨리 재현할 수 있는 환경”이라는 점이다. local file 기반 path 하나만 맞추면 companion project 전체를 거의 그대로 돌릴 수 있고, expected CSV와 비교하기도 쉽다. 다만 이 단순함이 곧 대규모 다중 사용자 운영까지 의미하는 것은 아니다.

세 예제를 DuckDB에서 읽는 방식

Retail Orders에서는 5003 trace와 snapshot을 가장 손쉽게 볼 수 있고, Event Stream에서는 day1/day2를 바꿔 incremental 실험을 반복하기 좋으며, Subscription & Billing에서는 snapshot과 MRR contract 예시를 낮은 비용으로 시험해 볼 수 있다. 따라서 DuckDB는 본문 전체의 기준 환경이면서, 다른 플랫폼에 옮기기 전 개념을 굳히는 샌드박스 역할을 한다.

CHAPTER 13

Platform Playbook · MySQL

레거시 제약이 있는 환경에서 dbt를 조심스럽게 시작하는 방법.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

MySQL은 dbt의 이상적인 분석 플랫폼이라고 보기는 어렵지만, 현실적으로 여전히 만나는 환경이다. 레거시 애플리케이션 데이터와 가까운 곳에서 검증이나 작은 마트를 시작해야 할 때, 혹은 별도 DW가 아직 없는 조직에서 가장 먼저 부딪히는 선택지가 될 수 있다.

이 장은 MySQL adapter의 현실적 한계와 함께, 세 예제를 어떤 범위에서 실험해 볼 수 있는지, full rebuild와 무거운 변환을 어떻게 조심해야 하는지, 운영계와 분석계의 경계를 어디에 그어야 하는지를 정리한다.

가장 먼저 확인할 profile / setup 예시

MySQL profile 예시

| my_mysql: target: dev outputs: dev: type: mysql server: localhost port: 3306 schema: analytics username: analytics password: "{{ env_var('DBT_ENV_SECRET_MYSQL_PASSWORD') }}" |
| --- |

코드 · YAML

| 예제 | day1 bootstrap 경로 | day2 변경 경로 |
| --- | --- | --- |
| Retail Orders | 03_platform_bootstrap/retail/mysql/setup_day1.sql | 03_platform_bootstrap/retail/mysql/apply_day2.sql |
| Event Stream | 03_platform_bootstrap/events/mysql/setup_day1.sql | 03_platform_bootstrap/events/mysql/apply_day2.sql |
| Subscription & Billing | 03_platform_bootstrap/subscription/mysql/setup_day1.sql | 03_platform_bootstrap/subscription/mysql/apply_day2.sql |

MySQL에서는 “가능한가”보다 “어디까지를 여기서 해야 하는가”를 먼저 판단해야 한다. 작은 검증이나 제약된 환경의 마트는 가능하지만, 무거운 재생성이나 대용량 incremental을 운영계와 같은 인스턴스에 올리는 것은 신중해야 한다.

세 예제를 MySQL에서 진행할 때의 기준

Retail Orders는 비교적 무난하지만, Event Stream처럼 이벤트가 빠르게 누적되는 경우는 비용과 잠금, 운영 영향이 빨리 문제로 드러날 수 있다. Subscription & Billing은 상태 추적과 작은 마트 검증 용도로는 괜찮지만, governed API와 heavy CI를 모두 MySQL 위에서 처리하려고 하면 제약이 커진다. 따라서 MySQL 플레이북의 핵심은 “처음 도입하되, 언제 별도 DW로 이동할지”의 기준을 세우는 것이다.

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

CHAPTER 15

Platform Playbook · BigQuery

서버리스 DW에서 cost-aware하게 dbt를 운영하는 법.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

BigQuery에서는 쿼리 비용과 파티셔닝 전략이 설계의 일부다. 따라서 같은 dbt 개념이라도 BigQuery에서는 “가능한가”보다 “얼마를 스캔하는가”를 먼저 생각해야 할 때가 많다.

이 장은 service account 기반 profile, raw bootstrap, 세 예제의 dataset 구조, partition/cluster 감각, incremental과 state-aware CI, saved query와 semantic layer가 BigQuery에서 어떤 장점과 비용을 갖는지 정리한다.

가장 먼저 확인할 profile / setup 예시

BigQuery profile 예시

| my_bigquery: target: dev outputs: dev: type: bigquery method: service-account project: my-project dataset: analytics keyfile: /path/to/keyfile.json location: US |
| --- |

코드 · YAML

| 예제 | day1 bootstrap 경로 | day2 변경 경로 |
| --- | --- | --- |
| Retail Orders | 03_platform_bootstrap/retail/bigquery/setup_day1.sql | 03_platform_bootstrap/retail/bigquery/apply_day2.sql |
| Event Stream | 03_platform_bootstrap/events/bigquery/setup_day1.sql | 03_platform_bootstrap/events/bigquery/apply_day2.sql |
| Subscription & Billing | 03_platform_bootstrap/subscription/bigquery/setup_day1.sql | 03_platform_bootstrap/subscription/bigquery/apply_day2.sql |

BigQuery에서는 dbt 설계가 곧 스캔 비용과 연결된다. dataset naming, partitioning, clustering, selector 범위, incremental window, state-aware CI까지 모두 “얼마를 다시 읽는가”라는 질문과 연결해서 봐야 한다.

세 예제를 BigQuery에서 진행할 때의 기준

Retail Orders는 비교적 단순하지만 사실/차원 모델에도 partition 기준을 미리 생각하는 편이 좋다. Event Stream은 가장 BigQuery다운 예제로, 이벤트 날짜 파티션과 incremental window, saved query/cache의 가치가 빨리 드러난다. Subscription & Billing은 semantic metric과 governed API를 BigQuery 위에서 운영하는 감각을 익히기 좋지만, full scan이 잦아지지 않도록 carefully designed marts가 중요하다.

CHAPTER 16

Platform Playbook · ClickHouse

컬럼 지향 분석 엔진에서 물리 설계와 dbt 모델링을 함께 보는 법.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

ClickHouse에서는 단순한 SQL 번역만으로는 충분하지 않다. engine, order_by, partition_by 같은 물리 설계가 모델 성능과 비용에 직접 영향을 주기 때문이다. 따라서 ClickHouse 챕터는 materialization을 storage design과 함께 읽는 연습에 가깝다.

이 장은 세 예제 중에서도 특히 Event Stream과 ClickHouse의 궁합이 왜 좋은지, Retail Orders와 Subscription에서도 어떤 이점을 볼 수 있는지, 그리고 dbt 쪽에서 어떤 설정과 기대치를 가져야 하는지 정리한다.

가장 먼저 확인할 profile / setup 예시

ClickHouse profile 예시

| my_clickhouse: target: dev outputs: dev: type: clickhouse host: localhost port: 8123 schema: default user: default password: "" |
| --- |

코드 · YAML

| 예제 | day1 bootstrap 경로 | day2 변경 경로 |
| --- | --- | --- |
| Retail Orders | 03_platform_bootstrap/retail/clickhouse/setup_day1.sql | 03_platform_bootstrap/retail/clickhouse/apply_day2.sql |
| Event Stream | 03_platform_bootstrap/events/clickhouse/setup_day1.sql | 03_platform_bootstrap/events/clickhouse/apply_day2.sql |
| Subscription & Billing | 03_platform_bootstrap/subscription/clickhouse/setup_day1.sql | 03_platform_bootstrap/subscription/clickhouse/apply_day2.sql |

ClickHouse는 물리 설계가 모델링의 일부다. engine, order_by, partition_by가 materialization 선택과 분리되지 않으므로, 단순히 dbt 코드를 “옮긴다”는 마음보다 어떤 쿼리 패턴을 빠르게 만들고 싶은지를 먼저 정해야 한다.

세 예제를 ClickHouse에서 진행할 때의 기준

Event Stream은 ClickHouse와 가장 자연스럽게 맞물린다. append-only 이벤트, 세션화, 고속 집계, 파티션 설계의 장점이 뚜렷하기 때문이다. Retail Orders도 line-level fact를 중심으로 보면 충분히 유용하고, Subscription & Billing 역시 상태 시계열 분석에 강점을 가질 수 있다. 단, snapshot과 warehouse-native governance 기능은 다른 플랫폼만큼 자연스럽지 않을 수 있으므로 목적을 명확히 하고 설계를 단순하게 가져가는 편이 좋다.

CHAPTER 17

Platform Playbook · Snowflake

엔터프라이즈 DW에서 권한, warehouse, refresh 전략을 함께 관리하는 법.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

Snowflake는 역할, warehouse, database, schema, task/dynamic table 같은 운영 요소가 비교적 명료하게 분리된 엔터프라이즈 DW다. 따라서 dbt를 통한 변환 운영뿐 아니라 dev/prod 격리, grants, contracts, semantic layer, governed sharing 같은 주제를 함께 읽기 좋다.

이 장은 Snowflake profile과 권한 구조, 세 예제 raw bootstrap, warehouse 크기와 비용, dynamic table/materialized_view 감각, contracts와 versions의 적용, Semantic Layer 및 platform 운영 관점을 함께 정리한다.

가장 먼저 확인할 profile / setup 예시

Snowflake profile 예시

| my_snowflake: target: dev outputs: dev: type: snowflake account: acme.ap-northeast-2 user: analytics_user password: "{{ env_var('DBT_ENV_SECRET_SNOWFLAKE_PASSWORD') }}" role: transformer database: ANALYTICS |
| --- |

코드 · YAML

| 예제 | day1 bootstrap 경로 | day2 변경 경로 |
| --- | --- | --- |
| Retail Orders | 03_platform_bootstrap/retail/snowflake/setup_day1.sql | 03_platform_bootstrap/retail/snowflake/apply_day2.sql |
| Event Stream | 03_platform_bootstrap/events/snowflake/setup_day1.sql | 03_platform_bootstrap/events/snowflake/apply_day2.sql |
| Subscription & Billing | 03_platform_bootstrap/subscription/snowflake/setup_day1.sql | 03_platform_bootstrap/subscription/snowflake/apply_day2.sql |

Snowflake chapter의 포인트는 warehouse와 권한, 그리고 governed API를 함께 보는 데 있다. 같은 dbt 모델이라도 어떤 warehouse에서 실행하는지, 어떤 role과 grant로 노출하는지에 따라 운영 감각이 크게 달라진다.

세 예제를 Snowflake에서 진행할 때의 기준

Retail Orders는 dev/prod 격리와 grants, contracts를 실험하기 좋고, Event Stream은 dynamic table이나 refresh 전략을 고민하기 좋은 예제다. Subscription & Billing은 versions, semantic layer, governed sharing을 가장 입체적으로 묶어 볼 수 있다. 따라서 Snowflake 플레이북은 기능 자체보다 “운영 면과 거버넌스를 어떻게 설계할 것인가”를 먼저 읽는 편이 좋다.

CHAPTER 18

Platform Playbook · Trino와 NoSQL + SQL Layer

저장소를 하나 더 고르는 대신 SQL 레이어를 어떻게 다룰지부터 생각해야 하는 환경.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

Trino는 단일 저장소라기보다 여러 catalog 위에서 SQL을 실행하고 조합하는 query engine에 가깝다. 따라서 dbt 관점에서도 “어디에 읽고 어디에 쓸 것인가”가 첫 번째 질문이 된다. write 가능한 catalog를 정하고, materialization이 만들어질 위치를 명확히 해야 하고, connector가 보장하는 타입과 성능 특성을 함께 봐야 한다.

NoSQL + SQL Layer 패턴은 Trino 같은 SQL 레이어를 통해 문서 지향 저장소를 분석 대상으로 읽는 방식이다. 이 장에서는 MongoDB + Trino 패턴을 예로 들되, 핵심은 특정 도구를 외우는 것이 아니라 raw JSON 문서와 SQL 변환층 사이의 경계를 명확히 잡는 데 있다.

가장 먼저 확인할 profile / setup 예시

Trino profile 예시

| trino_lab: target: dev outputs: dev: type: trino method: none user: trino host: localhost port: 8080 database: memory |
| --- |

코드 · YAML

| 예제 | day1 bootstrap 경로 | day2 변경 경로 |
| --- | --- | --- |
| Retail Orders | 03_platform_bootstrap/retail/trino/setup_day1.sql | 03_platform_bootstrap/retail/trino/apply_day2.sql |
| Event Stream | 03_platform_bootstrap/events/trino/setup_day1.sql | 03_platform_bootstrap/events/trino/apply_day2.sql |
| Subscription & Billing | 03_platform_bootstrap/subscription/trino/setup_day1.sql | 03_platform_bootstrap/subscription/trino/apply_day2.sql |

Trino에서는 catalog가 곧 저장소 경계다. 따라서 source를 어느 catalog에서 읽는지, materialization을 어느 catalog/schema에 남길지, connector가 쓰기를 지원하는지, 타입과 권한이 어떻게 다르게 보이는지를 먼저 잡아야 한다.

NoSQL + SQL Layer 패턴을 읽는 법

NoSQL + SQL Layer 패턴은 raw JSON 문서를 직접 dbt로 가공한다기보다, Trino 같은 SQL 레이어를 통해 문서 컬렉션을 source처럼 읽고, 결과 marts는 write 가능한 SQL catalog에 남기는 구조로 이해하면 좋다. companion ZIP에는 MongoDB JSONL과 `mongoimport` 스크립트, 그리고 Trino 쪽 bootstrap 예시가 함께 들어 있다. 핵심은 스키마가 느슨한 raw를 그대로 믿지 말고, staging에서 타입과 필수 필드를 더 강하게 정리하는 데 있다.

MongoDB + Trino day1 예시

| #!/usr/bin/env bash set -euo pipefail # Example: MongoDB import for retail day1 # Adjust MONGO_URI if needed. MONGO_URI="${MONGO_URI:-mongodb://localhost:27017}" mongoimport --uri "$MONGO_URI" --db raw_retail --collection __schema --drop --jsonArray --file /dev/null \|\| true mongoimport --uri "$MONGO_URI" --db raw_retail --collection customers --drop --file customers.jsonl mongoimport --uri "$MONGO_URI" --db raw_retail --collection products --drop --file products.jsonl mongoimport --uri "$MONGO_URI" --db raw_retail --collection order_items --drop --file order_items.jsonl mongoimport --uri "$MONGO_URI" --db raw_retail --collection orders --drop --file orders_day1.jsonl |
| --- |

코드 · BASH

세 예제를 Trino/NoSQL 패턴에서 진행할 때의 기준

Retail Orders는 문서 컬렉션을 관계형처럼 정규화하는 연습에 좋고, Event Stream은 이벤트 문서를 session/DAU로 읽는 흐름을 보기 좋다. Subscription & Billing은 문서 저장소에서 상태 추적을 할 때 스키마 일관성이 얼마나 중요한지 보여 준다. 다만 Trino/NoSQL 조합은 “가장 쉬운 운영형 선택”이 아니라, 저장소 다양성과 SQL 접근성을 맞바꾸는 구조라는 점을 기억해야 한다.

APPENDICES

실행·참조·복습을 위한 부록

부록은 본문을 대체하지 않지만, 실습과 운영에서 자주 되돌아오는 참조 지점을 한데 모아 책 전체를 다시 쓰기 쉽게 만든다.

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

CHAPTER B

DBT 명령어 레퍼런스

프로젝트 관찰, 실행, 디버깅, 운영 보조, semantic 명령을 workflow 관점으로 다시 정리한다.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

본문에서 여러 번 등장한 명령어를 한 번에 다시 찾을 수 있도록, 명령을 역할별로 정리한 부록이다. read와 write, local과 CI, model build와 semantic query를 구분해 기억하면 훨씬 덜 헷갈린다.

명령어 치트시트

| 명령 | 무엇을 하나 | 입문자 메모 |
| --- | --- | --- |
| dbt debug | 연결·설치·프로젝트 상태 점검 | 문제 발생 시 가장 먼저 |
| dbt parse | 연결 없이 프로젝트 구조 검증 | YAML/graph 확인 |
| dbt ls -s ... | 선택 결과 나열 | 복잡한 selector를 실행 전에 확인 |
| dbt compile -s ... | compiled SQL 생성 | Jinja·ref·macro가 어떻게 풀리는지 확인 |
| dbt show --select ... | 단일 노드 결과 미리 보기 | 가볍게 데이터를 훑어볼 때 |
| dbt seed | CSV seed 적재 | 작은 참조 데이터용 |
| dbt run -s ... | 선택한 모델 생성 | 개발 중 가장 자주 사용 |
| dbt test | generic/singular/unit test 실행 | 품질 검증 |
| dbt build -s ... | build 가능한 리소스와 테스트 일괄 실행 | 배포 전 검증용 |
| dbt source freshness | source freshness 계산 | sources.json 생성 |
| dbt snapshot | snapshot 리소스 실행 | 상태 이력 보존 |
| dbt deps | packages.yml 의존성 다운로드 | 패키지 설치 |
| dbt clone | 기준 state의 노드 clone | 대형 테이블 CI에 유용 |
| dbt retry | 직전 실행의 실패 노드 재시도 | 배치 복구 시간 단축 |
| dbt docs generate | 문서 artifact 생성 | manifest/catalog 갱신 |

| 추천 루틴 debug → parse → ls → compile → run/test/build 순서를 기본 디버깅 루틴으로 익혀 두면 대부분의 초반 문제를 빠르게 좁힐 수 있다. |
| --- |

DBT 명령어 레퍼런스

이 appendix는 치트시트보다 길고, 장별 예시보다 압축되어 있다. 실습 중에 “지금 어떤 명령을 써야 하지?”가 헷갈릴 때 빠르게 찾아보는 reference chapter로 쓰면 좋다.

T-1. 명령어를 workflow 기준으로 묶기

| 명령 | 역할 | 자주 같이 쓰는 옵션 | 메모 |
| --- | --- | --- | --- |
| dbt init | 새 프로젝트 초기화 | — | 학습 시작점 |
| dbt debug | 설치·연결·project 설정 확인 | --config-dir | 문제 발생 시 제일 먼저 |
| dbt deps | packages 설치 | — | packages.yml 변경 후 |
| dbt parse | 연결 없이 graph와 YAML 구조 확인 | --warn-error | 빠른 구조 검증 |
| dbt ls | 선택 범위를 미리 나열 | -s, --resource-type | 실행 전 범위 확인 |
| dbt compile | compiled SQL 생성 | -s | Jinja와 macro 확인 |
| dbt run / test / build | 모델 생성과 검증 | -s, --exclude, --defer | 개발·CI의 중심 |
| dbt source freshness | source freshness 체크 | -s | source SLA 점검 |
| dbt show | 선택 리소스 preview | -s, --limit | 작은 결과 확인에 편함 |
| dbt clone / retry | 상태 복제와 실패 복구 | -s, --state | slim CI와 재시도 |
| dbt run-operation | macro 실행 | --args | 관리 작업·관리용 SQL 호출 |

T-2. 가장 많이 쓰는 명령 조합

| # 설치/연결 dbt --version dbt debug # 범위 확인 후 실행 dbt ls -s +fct_orders+ dbt build -s +fct_orders+ # source freshness dbt source freshness -s source:raw_retail.orders # 실패 이후 재시도 dbt retry # slim CI 기본형 dbt build -s state:modified+ --defer --state path/to/prod_artifacts |
| --- |

BASH

명령을 외우는 것보다 순서를 외우는 것이 중요하다: debug → parse → ls → compile → run/build → docs.

T-3. read 계열과 write 계열을 구분하는 습관

parse, ls, compile, docs generate, show처럼 현재 상태를 읽거나 산출물을 만드는 명령은 범위를 좁히고 확인할 때 유리하다. run, seed, build, snapshot, clone, run-operation처럼 relation이나 데이터를 바꾸는 명령은 dev/prod 대상과 schema를 먼저 확인하고 실행해야 한다.

| 구분 | 대표 명령 | 언제 유용한가 |
| --- | --- | --- |
| read 중심 | debug / parse / ls / compile / show / docs | 코드를 고치기 전, 범위를 확인할 때 |
| write 중심 | seed / run / build / snapshot / clone / run-operation | 관계를 생성·변경하거나 raw 상태를 복원할 때 |

T-4. 자주 잊는 옵션과 selector

| 표현 | 뜻 | 빠른 기억법 |
| --- | --- | --- |
| -s model_name | 그 모델만 | 가장 좁은 범위 |
| -s model_name+ | 현재 + downstream | 소비처 확인 |
| -s +model_name | 현재 + upstream | 원인 추적 |
| -s +model_name+ | 양방향 | 전체 영향 확인 |
| -s tag:daily | 태그 기준 | 배치 주기 선택 |
| -s path:models/retail | 경로 기준 | 트랙 단위 검증 |
| -s state:modified+ | 변경분 + 영향 범위 | slim CI 핵심 |
| --defer --state <path> | upstream를 이전 상태로 defer | CI에서 prod 참조 |

T-5. 장면별 추천 명령

• 설치 직후: `dbt --version` → `dbt debug`

• YAML이나 source 이름을 고친 직후: `dbt parse` → `dbt ls -s...`

• Jinja/macro를 건드린 직후: `dbt compile -s...`

• 모델 하나를 고친 직후: `dbt build -s model+`

• source SLA를 확인할 때: `dbt source freshness`

• PR에서 변경분만 확인할 때: `dbt build -s state:modified+ --defer --state...`

• 실패 후 같은 범위를 다시 돌릴 때: `dbt retry`

T-6. Semantic Layer와 운영 보조 명령을 어떻게 볼까

Semantic Layer를 쓰는 팀이라면 metric/saved query 검증용 CLI를 별도 운영 루틴으로 둔다. 반대로 semantic 기능을 아직 쓰지 않는 팀이라면 core build/test/docs 루틴만 먼저 굳히는 편이 안전하다.

| # semantic 예시 흐름 dbt parse dbt sl list metrics dbt sl validate dbt sl query --metrics gross_revenue --group-by order__order_date |
| --- |

BASH

CHAPTER C

Jinja, Macro, Extensibility Reference

템플릿 문법, helper, macro 패턴, custom test와 package author 관점을 하나로 묶는다.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

Jinja는 문법만 외우면 되는 영역이 아니라, 가독성을 해치지 않으면서 반복성을 얻는 기술이다. 이 부록은 delimiter, helper, macro 기본형부터 custom generic test, materialization, package author 관점까지를 한 자리에서 다시 보게 해 준다.

Jinja 문법 레퍼런스

Jinja는 SQL을 대체하지 않는다. 좋은 dbt 코드는 SQL이 중심이고, Jinja는 반복 제거·환경 분기·재사용을 돕는 보조 장치다. 그래서 이 appendix는 “얼마나 화려하게 쓸 수 있는가”보다 “어디까지 쓰면 읽기 쉬운가”에 초점을 둔다.

U-1. 세 가지 delimiter

| 형태 | 의미 | 예시 |
| --- | --- | --- |
| {{ ... }} | 표현식. 값을 출력한다 | {{ ref('fct_orders') }} |
| {% ... %} | 문장. 제어 흐름과 선언에 쓴다 | {% if target.name == "prod" %} |
| {# ... #} | Jinja 주석 | {# compile 시 제거됨 #} |

U-2. 가장 자주 쓰는 문법 조각

| {% set payment_methods = ["card", "bank_transfer", "gift_card"] %} select order_id, {% for method in payment_methods %} sum(case when payment_method = '{{ method }}' then amount end) as {{ method }}_amount, {% endfor %} sum(amount) as total_amount from {{ ref('stg_payments') }} group by 1 |
| --- |

JINJA + SQL

• `set`은 리스트나 문자열을 미리 선언할 때 쓴다.

• `for`는 반복 컬럼 생성이나 pivot 패턴에서 자주 등장한다.

• `if`는 target, var, flags에 따라 분기할 때 유용하다.

U-3. dbt 프로젝트에서 많이 쓰는 helper

| helper | 언제 쓰나 | 짧은 예시 |
| --- | --- | --- |
| ref() | 프로젝트 내부 모델 참조 | {{ ref('stg_orders') }} |
| source() | 프로젝트 외부 raw 입력 참조 | {{ source('raw_retail', 'orders') }} |
| var() | 프로젝트 변수 읽기 | {{ var('lookback_days', 3) }} |
| env_var() | 환경변수 읽기 | {{ env_var('DBT_ENV_SECRET_PASSWORD') }} |
| target | 현재 target 정보 분기 | {% if target.name == 'prod' %} |
| this | 현재 relation 자신을 가리킬 때 | {{ this }} |
| run_query() | 컴파일/실행 시 쿼리 결과를 읽을 때 | {% set rs = run_query('select 1') %} |
| log() | Jinja 디버깅 로그 | {{ log('debug here', info=True) }} |

U-4. macro 기본형과 인수 전달

| {% macro cents_to_currency(column_name, scale=2) %} round({{ column_name }} / 100.0, {{ scale }}) {% endmacro %} select {{ cents_to_currency('gross_revenue_cents') }} as gross_revenue from {{ ref('fct_orders_raw') }} |
| --- |

JINJA

문자열 인수는 quote를 붙이고, 컬럼명 자체를 넘길 때도 문자열처럼 전달한다는 점을 자주 잊는다. 반대로 이미 Jinja 변수인 값을 다시 `{{ }}` 안에서 감싸는 중첩 curly는 피한다.

U-5. whitespace control과 가독성

| {%- for col in ["a", "b", "c"] -%} {{ col }}{%- if not loop.last -%}, {%- endif -%} {%- endfor -%} |
| --- |

JINJA

• `{%-`와 `-%}`는 앞뒤 공백을 줄인다.

• 공백을 너무 aggressively 줄이면 compiled SQL이 읽기 어려워질 수 있다.

• DRY보다 읽기 쉬운 SQL이 우선이다.

U-6. 필터와 짧은 함수형 패턴

| 패턴 | 의미 | 예시 |
| --- | --- | --- |
| \| lower | 소문자화 | {{ target.name \| lower }} |
| \| upper | 대문자화 | {{ var('country') \| upper }} |
| \| default(...) | 기본값 지정 | {{ var('threads') \| default(4) }} |
| \| join(...) | 리스트 결합 | {{ payment_methods \| join(', ') }} |
| loop.last | 반복 마지막 원소 확인 | {% if not loop.last %}, {% endif %} |
| is none / is not none | null 분기 | {% if my_value is not none %} |

U-7. run_query와 agate는 언제 필요한가

run_query는 warehouse의 결과를 받아 다음 SQL을 생성해야 할 때만 꺼내는 것이 좋다. 예를 들어 동적 pivot 컬럼 목록을 만들거나 정보 스키마를 읽어 union 순서를 맞출 때 유용하다. 반대로 단순 모델 작성 단계에서는 ref/source/select만으로도 충분한 경우가 많다.

| {% set rs = run_query("select distinct payment_method from " ~ ref("stg_payments")) %} {% if execute %} {% set methods = rs.columns[0].values() %} {% else %} {% set methods = [] %} {% endif %} |
| --- |

JINJA

U-8. 자주 발생하는 실수

• 하나의 모델 전체를 macro 호출 하나로 감싸서 원본 SQL이 보이지 않게 만드는 것

• 환경 분기가 너무 많아 compiled SQL을 봐야만 이해할 수 있게 만드는 것

• `source()`와 `ref()` 대신 문자열 테이블명을 직접 조합하는 것

• `run_query()`를 남용해 compile 시 warehouse round-trip을 과도하게 만드는 것

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

CHAPTER D

Troubleshooting, Decision Guides, Glossary, Official Sources, Support Matrix

실패를 좁히는 체크리스트부터 공식 자료, 용어집, 의사결정 표, 지원 매트릭스까지 책의 백맵 역할을 하는 부록.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

실무에서 자주 꺼내 보는 정보는 대체로 두 종류다. 막혔을 때 어디부터 볼지 알려 주는 정보와, 지금 하려는 선택이 맞는지 판별하는 기준이다. 마지막 부록은 그 두 종류를 하나로 모아 책 전체를 다시 참조할 수 있게 구성했다.

문제 해결 체크리스트

1. 가상환경이 활성화되어 있는가

2. dbt --version에서 adapter가 함께 보이는가

3. dbt debug가 통과하는가

4. profile 이름과 profiles.yml 최상위 키가 같은가

5. 실패 범위를 -s model_name까지 좁혔는가

6. dbt ls -s...로 선택 결과를 확인했는가

7. dbt parse로 구조 오류를 먼저 확인했는가

8. dbt compile -s...로 compiled SQL을 보았는가

9. target/run과 target/compiled를 구분해서 보고 있는가

10. logs/dbt.log를 열어 보았는가

11. 직접 relation 이름 하드코딩으로 lineage를 깨뜨리지 않았는가

12. 테스트 실패를 데이터 품질 문제와 로직 문제로 분리해서 보고 있는가

| 중요한 원칙 전체 실행을 반복하기 전에, 문제 범위를 줄이고 compiled SQL과 관련 artifacts를 보는 것이 가장 큰 시간 절약이다. |
| --- |

용어집

| 용어 | 짧은 설명 |
| --- | --- |
| adapter | dbt가 각 데이터플랫폼과 통신하기 위해 쓰는 플러그인 |
| artifact | dbt 실행 후 남는 JSON 산출물. manifest.json, run_results.json, sources.json 등이 있다 |
| contract | 모델이 반환해야 하는 컬럼 형태와 타입에 대한 약속 |
| defer | 현재 환경에 없는 upstream 리소스를 기준 환경의 relation로 참조하는 기능 |
| exposure | 대시보드·앱 등 downstream 사용처를 DAG에 연결하는 정의 |
| freshness | 원천 또는 모델이 얼마나 최근 상태인지 측정하는 기준 |
| grain | 모델 한 행이 무엇을 대표하는지에 대한 약속 |
| materialization | 모델 결과를 어떤 형태(view/table/incremental 등)로 남길지 정하는 설정 |
| node | 모델·테스트·seed·snapshot 등 DAG를 구성하는 리소스 하나 |
| relation | 데이터플랫폼에 실제로 존재하는 table/view 등의 객체 |
| selector | 실행할 노드를 고르는 문법(--select, tags, state 등) |

공식 자료와 추가 학습 순서

| 공식 문서 제목(검색 키워드) | 왜 중요한가 |
| --- | --- |
| Install dbt / Install and configure the dbt VS Code extension | Core·Fusion·extension의 현재 공식 설치 흐름 확인 |
| Add sources to your DAG / Source freshness | source 계약과 freshness 운영 기준 |
| Add data tests to your DAG / About data tests property | generic·singular test와 data_tests 구조 |
| Unit tests | 작은 입력/기대 출력 방식의 로직 검증 |
| Add snapshots to your DAG / Snapshot configurations | YAML 기반 snapshot과 이력 해석 |
| About dbt artifacts / Manifest JSON / Run results JSON | docs, state, freshness, 실행 결과 이해 |
| About state in dbt / Defer / About dbt clone command | slim CI와 환경 defer 흐름 |
| Packages / About dbt deps command | 패키지 설치와 버전 관리 |
| Model contracts / Add Exposures to your DAG | 팀 운영 확장과 downstream 연결 |
| About dbt show command / dbt command reference | 개발 루틴과 명령 참조 |

| 추천 학습 순서 기본기 → 모델링 → 테스트 → 디버깅 → 운영 → 플랫폼별 최적화 순서로 가면 가장 덜 흔들린다. 처음부터 platform-specific 고급 최적화를 파고들기보다 공통 개념을 먼저 몸에 익히자. |
| --- |

현업 시나리오 실전 지도

| 이 appendix를 이렇게 쓰세요 • 요청 문장을 그대로 믿기보다, 먼저 “어느 grain에서 어떤 business rule을 바꾸라는 말인가?”로 다시 번역한다. • 수정 후보는 가능하면 mart → intermediate → staging 순으로 가깝게 찾는다. 원천 정리 문제면 staging, 재사용 조인이면 intermediate, KPI 규칙이면 marts 쪽일 확률이 높다. • 수정 전후에는 모델 SQL만 보지 말고 test, docs, PR 설명까지 같이 바꿔야 팀 규칙으로 남는다. 아래 시나리오들은 companion ZIP의 field_guide/ 폴더와 1:1로 맞춰 두었다. |
| --- |

H-1. 요청을 dbt 작업으로 바꾸는 4단계

| 단계 | 질문 | 예시 | 산출물 |
| --- | --- | --- | --- |
| 1 | 요청문이 바꾸려는 규칙은 무엇인가? | “취소 주문은 총액에서 빼 주세요” | rule memo 한 줄 |
| 2 | 그 규칙은 어느 grain에서 정의되어야 하나? | order grain / line grain / customer grain | 수정할 레이어 후보 |
| 3 | 가장 가까운 모델은 어디인가? | stg_orders / int_order_lines / fct_orders | 편집 대상 SQL/YML |
| 4 | 무엇으로 검증하고 남길 것인가? | unit test, data test, docs, PR 설명 | review-ready 변경 묶음 |

가장 중요한 질문은 “이 규칙이 어디서 살아야 가장 재사용 가능하고, 가장 덜 놀라운가?”다.

시나리오 카드 1 - “취소 주문을 매출에서 제외해 주세요”

| 항목 | 실무 해석 |
| --- | --- |
| 요청 | “매출 계산에서 취소 주문을 제외해 주세요.” |
| 보통 수정 위치 | staging에서는 status 정리만 하고, 최종 집계 규칙은 fct_orders 같은 mart에 둔다. |
| 먼저 실행할 명령 | dbt build -s fct_orders+dbt test -s fct_orders+dbt show --select fct_orders |
| 같이 바꿔야 할 것 | 취소 주문 예외를 검증하는 unit test, gross_revenue / order_amount 설명, PR 메모 |
| 리뷰어에게 남길 한 줄 | “주문 grain 집계 규칙만 바꾸고 staging의 status 표준화는 유지했다.” |

| 헷갈리기 쉬운 지점 • status 값 자체를 고치는 일과 status를 이용해 KPI를 다르게 계산하는 일은 같은 변경이 아니다. • 취소 규칙이 여러 mart에서 재사용된다면 intermediate에 공통 flag를 올리고, 집계 자체는 marts에서 한다. |
| --- |

시나리오 카드 2 - “오늘 매출이 두 배로 나왔어요”

이 경우는 “어디 SQL이 틀렸지?”보다 먼저 “grain이 바뀌었나? join fanout이 생겼나?”를 의심하는 편이 훨씬 빠르다.

그림 H-1. order grain 모델이 line grain 조인을 그대로 합치면 금액이 두 배처럼 보일 수 있다.

| 먼저 볼 것 | 왜 보나 | 빠른 확인 |
| --- | --- | --- |
| int_order_lines row 수 | line grain이 얼마나 늘어났는지 본다 | count(*) / count(distinct order_id) |
| fct_orders 집계 방식 | order grain으로 다시 묶였는지 확인한다 | group by order_id, customer_id |
| line_amount vs total_amount | 같은 금액을 두 번 더하고 있지 않은지 본다 | gross_revenue 와 order_amount 비교 |
| relationships / singular test | 키 누락인지, 집계 규칙 문제인지 구분한다 | 테스트 실패 메시지와 쿼리 함께 확인 |

| 복구 루틴 • dbt ls -s +fct_orders+ 로 범위를 먼저 좁힌다. • dbt compile -s fct_orders 로 최종 SQL을 보고, join 직후 row 수와 group by 위치를 확인한다. • 필요하면 intermediate에서 line grain을 유지하고 mart에서 order grain으로 다시 집계한다. |
| --- |

시나리오 카드 3 - “새 원천 테이블 reviews 를 추가해 주세요”

| 항목 | 실무 해석 |
| --- | --- |
| 요청 | “product_reviews raw 테이블이 추가됐어요. 별점 평균과 리뷰 수를 보고 싶어요.” |
| 먼저 바꿀 파일 | models/sources.yml → models/staging/stg_reviews.sql → intermediate 또는 marts |
| 안전한 첫 단계 | 리뷰 원천을 source로 선언하고 staging에서 타입 / null / 상태값만 정리한다. |
| 그다음 질문 | 리뷰는 주문과 1:1인가, 상품과 1:N인가, 일자별 분석이 필요한가? |
| 권장 검증 | not_null(review_id), relationships(product_id), accepted_values(review_status) |
| 권장 실행 | dbt parse → dbt build -s stg_reviews+ → dbt docs generate |

시나리오 카드 4 - “오늘은 필요한 범위만 다시 돌리고 싶어요”

| 상황 | 먼저 할 일 | 왜 이 순서인가 |
| --- | --- | --- |
| 소스 적재가 늦어 일부 모델만 다시 돌리고 싶다 | dbt source freshness | freshness 기준을 먼저 갱신해야 fresher source를 고를 수 있다 |
| fresher source downstream만 다시 빌드하고 싶다 | dbt build --select source_status:fresher+ | 필요한 범위만 다시 돌려 비용과 시간을 줄인다 |
| source freshness 결과를 확인하고 싶다 | target/sources.json 확인 | 어느 source가 fresher / stale 인지 artifact로 남는다 |
| PR CI에서만 upstream relation이 없어 실패한다 | state:modified+ 와 --defer 적용 여부 확인 | 개발 환경에 없는 upstream을 applied state로 참조하게 해 준다 |
| zero-copy clone이 가능한 플랫폼에서 반복 비용이 크다 | dbt clone 검토 | 개발용 relation 준비 시간을 줄이는 선택지다 |

| 팀 규칙 템플릿 초안 • 원천을 읽는 첫 모델은 반드시 source()에서 시작한다. • join 전에 각 모델의 grain을 문장으로 남긴다. • fct 계열 모델에는 최소 not_null / unique / relationships 중 필요한 테스트를 붙인다. • incremental 도입 전에는 unique_key, late-arriving data, full-refresh 기준을 리뷰에서 확인한다. • PR 설명에는 변경된 business rule, 영향 받는 모델, 확인한 selector 범위를 적는다. companion ZIP의 templates/team_dbt_rules_template.md에 같은 문장을 바로 수정 가능한 형태로 넣어 두었다. |
| --- |

의사결정 가이드

| 답을 외우기보다 질문 순서를 익히세요 • 이 모델은 아직 자주 바뀌는가, 아니면 이미 안정화됐는가? • 한 행이 대표하는 grain은 무엇인가? • 나중에 다시 설명해야 할 규칙인가, 지금 한 번만 필요한 로직인가? • 전체를 돌려도 되는가, 아니면 selector를 줄여야 비용과 시간이 맞는가? |
| --- |

I-1. materialization 선택표

| 상황 | 추천 | 이유 | 지금 보류해야 할 경우 |
| --- | --- | --- | --- |
| 모델이 아직 자주 바뀌고 빠르게 눈으로 확인해야 한다 | view | 수정-재실행 루프가 빠르다 | 조회 비용/지연이 이미 문제라면 table 검토 |
| downstream 조회가 많고 결과를 안정적으로 재사용해야 한다 | table | 읽기 속도와 예측 가능성이 높다 | 전체 재생성 비용이 너무 크면 incremental 고민 |
| append 중심 대용량이고 unique_key 와 재처리 기준이 명확하다 | incremental | 전체 재생성 비용을 줄인다 | late-arriving data 규칙이 비어 있으면 아직 금지 |
| 아주 작은 helper 로직을 한 번만 인라인해도 충분하다 | ephemeral | 파일은 나누되 별도 relation은 만들지 않는다 | 재사용/디버깅 포인트가 필요하면 view/table |

| 한 문장 규칙 • 정확한 모델 구조와 테스트가 먼저고, incremental은 그다음 최적화다. |
| --- |

I-2. snapshot을 언제 쓰나

| 질문 | snapshot | 대안 |
| --- | --- | --- |
| 현재 상태만 있는 테이블에서 과거 상태 이력이 필요하다 | 예 | snapshot으로 row version 보존 |
| 원천이 이미 CDC / history table을 제공한다 | 아니오 | 그 이력 source를 그대로 모델링 |
| 작은 코드 매핑이나 상태 사전이다 | 아니오 | seed 사용 |
| 변경 빈도가 낮지만 상태 변화 시점을 나중에 분석해야 한다 | 예 | check / timestamp 전략 검토 |

I-3. intermediate를 언제 만든다

| 징후 | intermediate로 올릴까? | 설명 |
| --- | --- | --- |
| 같은 join 이 mart 두세 곳에 반복된다 | 예 | 재사용 가능한 join/logic을 한 번으로 모은다 |
| line grain 계산이 있고 그 결과를 여러 최종 모델이 소비한다 | 예 | mart마다 중복 집계와 fanout 설명을 줄인다 |
| 해당 로직이 한 mart 안에서만 한 번 쓰이고 다시 설명할 필요가 없다 | 아니오 | 오히려 파일 수만 늘릴 수 있다 |
| staging이 giant SQL처럼 길어지고 rename·join·집계가 섞인다 | 예 | 책임 경계를 다시 나누는 신호다 |

I-4. macro를 언제 묶나

| 질문 | macro로 묶기 | 그냥 SQL로 둔다 |
| --- | --- | --- |
| 같은 SQL 조각이 세 번 이상 반복되고 함께 바뀌어야 하는가? | 예 | 반복 제거와 변경 일관성 |
| 모델 로직보다 템플릿 문법이 더 많이 보이기 시작하는가? | 아니오 | 가독성이 먼저 |
| 팀원이 compiled SQL 없이 읽기 어려운가? | 아니오 | 추상화가 과한 신호 |
| 환경 변수 주입이나 가벼운 포맷 변환 정도인가? | 예 | macro가 잘 맞는다 |

I-5. 테스트 범위를 어디까지 붙일까

| 모델 종류 | 최소 권장 | unit test를 특히 붙일 때 | docs에 적을 것 |
| --- | --- | --- | --- |
| staging | 핵심 키 not_null, accepted_values | 상태 표준화 규칙이 복잡할 때 | 원천 컬럼 → 표준 컬럼 대응 |
| dimension | unique, not_null, relationships | SCD/상태 해석 로직이 있을 때 | business key, 제외 규칙 |
| fact | unique key, relationships, singular revenue checks | 합계/할인/취소 규칙이 섬세할 때 | grain, KPI 정의, 제외 기준 |
| intermediate | 필요 최소 테스트 + downstream fact unit test 보강 | fanout / 분기 로직이 있을 때 | 왜 이 join이 reusable인지 |

I-6. 비용·속도까지 고려한 명령 선택

| 지금 목적 | 먼저 쓸 명령 | 전체 build로 바로 가지 않는 이유 |
| --- | --- | --- |
| 설치/연결 확인 | dbt debug | 연결 문제와 SQL 문제를 섞지 않기 위해 |
| selector 범위 미리 확인 | dbt ls -s ... | 잘못된 범위를 오래 돌리지 않기 위해 |
| 모델 SQL만 보고 싶다 | dbt compile -s model | Jinja/ref 결과를 먼저 확인하기 위해 |
| 한 모델과 downstream 테스트까지 보고 싶다 | dbt build -s model+ | 필요한 영향 범위만 검증하기 위해 |
| 소스 변화분만 다시 돌리고 싶다 | dbt source freshness → dbt build --select source_status:fresher+ | 비용과 시간을 함께 줄이기 위해 |

장별 1분 복습 퀴즈와 자기 점검

| 이 부록의 목표 • 정답을 길게 적는 것이 목표가 아니다. 장마다 핵심 키워드가 바로 떠오르면 충분하다. • 모르는 문항은 해당 장으로 즉시 돌아가고, 다시 읽은 뒤 한 줄로 설명해 보는 것이 가장 빠른 복습이다. |
| --- |

J-1. 01~05장 1분 퀴즈

| 장 | 질문 | 정답 키워드 |
| --- | --- | --- |
| 01 | dbt는 어디에 있는 도구인가? | 변환 계층 / 프로젝트 관리 / lineage |
| 02 | 왜 이 책은 Core + DuckDB로 시작하나? | 재현성 / 설치 단순화 / 비용 없음 |
| 03 | dbt_project.yml 과 profiles.yml 의 차이는? | 운영 규칙 vs 연결 정보 |
| 04 | 첫 완주 루틴의 다섯 단계는? | source → run/build → test → docs |
| 05 | source() 와 ref() 의 차이는? | 외부 입력 vs 내부 산출물 |

J-2. 06~10장 1분 퀴즈

| 장 | 질문 | 정답 키워드 |
| --- | --- | --- |
| 06 | model+ 와 +model 의 차이는? | downstream 포함 vs upstream 포함 |
| 07 | join 전에 꼭 적어야 하는 한 문장은? | 각 모델의 grain |
| 08 | incremental 전에 먼저 정해야 하는 세 가지는? | unique_key / 재처리 기준 / full-refresh 전략 |
| 09 | generic · singular · unit test 는 각각 무엇을 보나? | 품질 / 자유 검증 / 로직 |
| 10 | snapshot은 언제 유용한가? | 현재 상태만 있는 테이블의 과거 변화 추적 |

J-3. 11~15장 1분 퀴즈

| 장 | 질문 | 정답 키워드 |
| --- | --- | --- |
| 11 | macro를 너무 빨리 쓰면 왜 어려워지나? | 가독성·디버깅 저하 |
| 12 | 막혔을 때 기본 루틴은? | debug → parse → ls → compile → run/build |
| 13 | dev / prod 분리가 필요한 이유는? | 안전한 개발·배포 / 권한·검증 분리 |
| 14 | 플랫폼을 옮겨도 거의 그대로 남는 공통 개념은? | source/ref/test/docs/lineage |
| 15 | 예제 프로젝트를 자기 조직에 옮길 때 제일 먼저 정할 것은? | grain 과 business key |

J-4. 최종 자기 점검

| 나는 지금 이것을 할 수 있는가? | 예 / 아직 | 다시 볼 장 |
| --- | --- | --- |
| source freshness 결과를 보고 downstream만 다시 돌릴 수 있다 | □ 예   □ 아직 | 05, 13 |
| fanout이 의심될 때 line grain과 order grain을 구분해서 설명할 수 있다 | □ 예   □ 아직 | 07, 12 |
| incremental 도입 전 체크리스트를 말할 수 있다 | □ 예   □ 아직 | 08 |
| generic / singular / unit test를 언제 붙일지 고를 수 있다 | □ 예   □ 아직 | 09 |
| snapshot이 필요한 경우와 seed로 충분한 경우를 구분할 수 있다 | □ 예   □ 아직 | 10, I |
| state:modified, --defer, dbt clone이 왜 나오는지 큰 그림을 설명할 수 있다 | □ 예   □ 아직 | 13, H |
| 새 raw 테이블이 들어오면 source → staging → mart까지 어디를 바꿔야 하는지 안다 | □ 예   □ 아직 | 15, H |

| 마지막 캡스톤 미션 • 예제 프로젝트에 source freshness 기준을 하나 추가하고, fresher source만 다시 도는 명령을 직접 적어 본다. • fct_orders 에 singular test 하나와 unit test 하나를 더 붙이고, 왜 두 테스트가 다른지 설명해 본다. • 팀 규칙 템플릿에서 우리 팀에 꼭 필요한 규칙 3개를 골라 PR 설명 예시와 함께 적어 본다. 이 세 가지를 손으로 해보면, 책의 개념이 거의 전부 “내 프로젝트에 옮길 수 있는 단위”로 바뀐다. |
| --- |

올인원 기능 지도와 버전·엔진 체크포인트

기능별 체크 포인트

| 기능 영역 | 실무에서 무엇을 확인할까 | 버전/엔진/플랜 메모 |
| --- | --- | --- |
| Source freshness | loaded_at_field, warn_after/error_after, source_status selector | source freshness는 sources.json과 downstream build 전략에 직접 연결된다 |
| Incremental / microbatch | unique_key, incremental_strategy, event_time, lookback | microbatch와 event_time은 최신 버전/track에서 특히 중요하다 |
| Snapshot | YAML-based snapshot config, hard delete 정책 | 신규 snapshot은 YAML 구성이 권장된다 |
| State / defer / clone | prod artifact 보관, slim CI selector, clone 대상 태그 | 대규모 프로젝트일수록 가치가 커진다 |
| Contracts / constraints | public model부터 enforced contract 적용 | constraint 지원 범위는 플랫폼마다 다르다 |
| Access / groups / versions | 누가 ref할 수 있는가, owner는 누구인가, v1/v2 이행 전략 | mesh나 다팀 협업에서 급격히 중요해진다 |
| Semantic layer | semantic model, metrics, saved queries, exposures 연결 | spec과 소비 도구 연동 범위는 엔진/버전에 민감할 수 있다 |
| Python models / functions | 지원 adapter, materialization, execution framework | Python models와 Python UDF는 adapter 지원 범위를 반드시 확인한다 |
| Packages / dependencies | dbt Hub package인지, cross-project dependency인지 구분 | packages.yml과 dependencies.yml은 목적이 다르다 |
| Platform tuning | BigQuery 비용, ClickHouse engine, Snowflake warehouse, Postgres MV | 같은 개념도 최적화 포인트는 플랫폼마다 달라진다 |

이 표는 “기능 전체 지도” 역할을 한다. 처음에는 왼쪽 열만 보아도 좋고, 실제 도입 단계에서는 가운데 열을 체크리스트처럼 활용하면 된다. 오른쪽 열은 최신 버전과 엔진 차이에 민감한 기능을 표시한 것이므로, 실제 배포 전에 공식 문서를 다시 확인하는 기준점으로 삼자.

기능 가용성 배지와 지원 매트릭스

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

Semantic Layer 운영 Runbook

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

dbt platform 작업환경 가이드

N-1. environment는 세 가지를 정한다

| environment가 정하는 것 | 설명 | 초보자 메모 |
| --- | --- | --- |
| dbt 실행 버전/엔진 | 어떤 dbt version 또는 release track, 어떤 engine으로 실행할지 | 로컬과 플랫폼 결과가 다르면 여기부터 본다. |
| warehouse 연결 정보 | database/schema/role/credentials 등 실행 대상 | dev/prod 분리의 핵심이다. |
| 실행할 코드 버전 | 어느 branch/commit의 프로젝트를 실행할지 | CI와 배포에서 중요하다. |

dbt platform에서는 Development 환경과 Deployment 환경을 구분해서 생각하는 것이 중요하다. Deployment 환경 안에서도 production / staging / general 성격이 갈릴 수 있으므로, “잡(job)이 어떤 환경을 바라보는가”를 먼저 이해해야 한다.

N-2. 어떤 인터페이스를 언제 쓸까

| 도구 | 가장 잘하는 일 | 주의점 |
| --- | --- | --- |
| Studio IDE | 브라우저에서 바로 build/test/run, Catalog와의 왕복, platform-native 개발 | 로컬 편집기와의 습관 차이를 인정해야 한다. |
| dbt CLI | 로컬 터미널에서 dbt 명령과 MetricFlow 명령을 동일한 리듬으로 실행 | dbt_cloud.yml 또는 profiles.yml 등 인증 흐름을 먼저 맞춘다. |
| VS Code extension | Fusion 기반 LSP, 인라인 오류, 리팩터링, hover 정보 | Fusion 전용이며 Core CLI 단독과는 다르다. |
| Catalog | 동적 문서/lineage/협업 메타데이터 탐색 | dbt Docs 정적 사이트와 목적이 다르다. |
| dbt Docs | 정적 사이트 생성·호스팅이 쉬운 문서 출력 | 최신 메타데이터 경험은 Catalog 쪽이 더 풍부하다. |
| Canvas | 시각적 모델 작성과 빠른 초안 제작 | Enterprise 계열 기능이며 모든 팀에 필수는 아니다. |

N-3. job 설계는 “얼마나 자주, 얼마나 넓게, 누가 소비하나”로 정한다

• CI job: PR 변경분과 downstream만 좁게 build/test한다.

• Deploy job: production metadata를 남기며 안정적으로 전체 또는 상태 기준 범위를 실행한다.

• Documentation/metadata job: Catalog를 더 풍부하게 쓰려면 job에서 문서 metadata를 남기는 습관이 필요하다.

• Semantic export/cache job: saved query exports와 caching을 운영하려면 주기와 freshness를 함께 본다.

| 선택 기준• local-only: 비용 제어와 자유도가 가장 크지만, 문서/CI/공유 메타데이터는 직접 구축해야 한다.• hybrid: 로컬 개발 + platform 배포/문서/CI를 섞는 가장 현실적인 형태다.• platform-first: Studio/Catalog/Jobs/Canvas를 한 흐름으로 쓰는 팀에 잘 맞는다. |
| --- |

고급 테스트·문서화·메타데이터

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

업그레이드·릴리스 트랙·행동 변화 체크리스트

P-1. 먼저 support 상태를 읽는 법

| 상태 | 뜻 | 운영 메모 |
| --- | --- | --- |
| Active | 일반 버그 수정과 보안 패치가 이어지는 지원 구간 | 가능하면 이 구간을 기준으로 학습/운영한다. |
| Critical | 보안·설치 이슈 중심의 제한적 지원 구간 | 당장 못 올리더라도 업그레이드 계획을 세워야 한다. |
| Deprecated | 문서는 남아 있어도 유지보수 기대치가 크게 떨어지는 구간 | 새 기능을 기대하지 말고 마이그레이션을 준비한다. |
| End of Life | 패치가 더 이상 나오지 않는 구간 | 실운영 장기 유지 대상으로는 피해야 한다. |

P-2. dbt platform release track을 고르는 기준

| release track | 성격 | 누가 먼저 고려하나 |
| --- | --- | --- |
| Latest Fusion | 새 엔진의 최신 build를 가장 먼저 받는 축 | Fusion 실험과 최신 기능 추적이 중요한 팀 |
| Latest | dbt platform의 최신 기능을 가장 빠르게 받는 축 | 새 기능을 빨리 쓰고 싶은 팀 |
| Compatible | 최근 dbt Core 공개 버전과의 호환성을 더 중시하는 월간 cadence | Core와 platform을 함께 쓰는 hybrid 팀 |
| Extended | Compatible보다 한 단계 더 완만한 cadence | 변화 흡수가 느린 엔터프라이즈 팀 |
| Fallback | 가장 느린 cadence 계열 | 변경 리스크를 최소화해야 하는 팀 |

P-3. behavior changes와 deprecations는 같은 것이 아니다

behavior change flags는 새 기본 동작으로 넘어가기 전의 이행 창구에 가깝고, deprecations는 앞으로 제거될 문법/행동을 경고하는 신호에 가깝다. 둘 다 “나중에 보자”로 미루기 쉬운데, 실제로는 버전 업그레이드 품질의 절반이 여기서 갈린다.

# dbt_project.yml

flags:

require_generic_test_arguments_property: true

state_modified_compare_more_unrendered_values: true

• 업그레이드는 dev 환경에서 먼저 시도하고, selectors로 범위를 좁혀 smoke test를 돈다.

• deprecation 경고는 릴리스 직전이 아니라 분기 초반에 정리해야 팀 전체 비용이 낮다.

• packages와 adapter의 require-dbt-version 조건도 함께 확인한다.

AI · Copilot · MCP 빠른 안내

Q-1. 어떤 AI 기능을 어디에 쓰면 좋은가

| 기능 | 잘하는 일 | 주의점 |
| --- | --- | --- |
| Copilot | 문서, 테스트, metric, semantic model, SQL 초안 생성 | 생성 결과를 바로 merge하지 말고 프로젝트 규칙으로 다시 리뷰한다. |
| Local MCP | 로컬 코드·모델·문서 컨텍스트를 에이전트에 제공 | 로컬 환경 권한과 tool access를 최소화한다. |
| Remote MCP | Semantic Layer, Discovery, SQL 등 원격 서비스형 MCP 사용 | plan/preview 상태와 데이터 접근 범위를 먼저 점검한다. |
| Studio agent / Canvas AI | 브라우저 기반 초안 생성과 리팩터링 보조 | 생성 편의성과 최종 품질 검증은 별개다. |

| 실무 권장 순서• 먼저 source/ref/test/docs 규칙을 사람 기준으로 고정한다.• 그 다음 Copilot이나 MCP를 붙여 속도를 높인다.• AI가 만든 산출물도 결국 contracts, tests, CI, owners 같은 인간 규칙 아래에 있어야 한다. |
| --- |

Trino와 NoSQL + SQL Layer 실전 메모

Trino는 단일 저장소라기보다 다양한 원천 위에서 SQL을 실행하고 조합하는 query engine에 가깝다. dbt 입장에서는 write 가능한 catalog와 schema를 고르고, materialization이 실제로 만들어질 위치를 명확히 하는 것이 첫 번째 과제다.

V-1. Trino를 어디에 쓰면 좋은가

| 상황 | 장점 | 주의점 |
| --- | --- | --- |
| 여러 원천을 한 SQL로 조합하고 싶을 때 | catalog를 넘나드는 federation과 cross-source join | 모든 connector가 write를 지원하는 것은 아니다 |
| 팀이 이미 Trino/Starburst를 운영할 때 | dbt-trino로 동일한 SQL 워크플로 유지 | catalog/schema 권한을 미리 정리해야 한다 |
| 빠른 local trial이 필요할 때 | memory catalog로 작은 예제를 즉시 실험 가능 | 재시작 시 데이터와 메타데이터가 사라진다 |
| NoSQL 원천을 SQL로 보고 싶을 때 | MongoDB/Elasticsearch connector로 SQL layer를 만들 수 있다 | type mapping과 predicate pushdown 한계를 이해해야 한다 |

V-2. dbt-trino profile 예시

| trino_lab: target: dev outputs: dev: type: trino method: none user: trino host: localhost port: 8080 database: memory schema: raw_retail threads: 4 |
| --- |

YAML

여기서 database는 Trino의 catalog 이름이고 schema는 그 catalog 안의 schema다. 따라서 “어느 connector 위에 relation을 만들 것인가”를 먼저 정해야 한다.

V-3. memory catalog를 이용한 가장 빠른 실험

| # Trino catalog file connector.name=memory memory.max-data-per-node=128MB # day1 raw bootstrap trino -f 03_platform_bootstrap/retail/trino/setup_day1.sql # dbt-trino build dbt build -s retail+ |
| --- |

BASH

memory catalog는 빠른 실험에는 좋지만, 재시작 시 데이터가 사라진다는 점을 항상 기억하자.

V-4. NoSQL + SQL Layer 패턴: MongoDB를 예로

이 책에서 NoSQL + SQL Layer는 “원천을 문서형으로 유지하되, 분석 변환은 SQL 계층에서 수행한다”는 뜻으로 사용한다. companion pack은 MongoDB JSONL과 Trino MongoDB connector 설정 예시를 같이 제공한다.

| # 1) MongoDB에 raw 문서 적재 bash 03_platform_bootstrap/nosql_sql_layer_mongodb_via_trino/subscription/setup_day1_mongodb.sh # 2) Trino catalog 설정 connector.name=mongodb mongodb.connection-url=mongodb://localhost:27017/ # 3) dbt는 SQL layer에 연결 type: trino database: mongodb schema: raw_billing |
| --- |

BASH

같은 발상은 Elasticsearch/OpenSearch에도 적용된다. 다만 search index는 relation처럼 단순하지 않기 때문에, source 레벨에서 타입과 키를 더 보수적으로 모델링하는 편이 안전하다.

V-5. Trino/NoSQL에서 특히 조심할 점

• write가 필요한 dbt 모델은 write-capable connector 위에 materialize해야 한다.

• federation join은 편하지만, cost와 latency가 플랫폼 단일 실행보다 커질 수 있다.

• 문서형 원천은 키 누락과 nested field 타입 차이가 흔하므로 staging에서 flatten 규칙을 먼저 정한다.

• Trino profile의 database/catalog와 실제 source schema 이름을 혼동하지 말아야 한다.
