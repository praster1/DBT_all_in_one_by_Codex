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
