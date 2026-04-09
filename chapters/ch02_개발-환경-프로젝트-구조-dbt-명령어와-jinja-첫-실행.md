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
