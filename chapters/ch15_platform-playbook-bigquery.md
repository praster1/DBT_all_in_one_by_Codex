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
