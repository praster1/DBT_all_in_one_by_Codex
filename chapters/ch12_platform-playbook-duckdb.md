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
