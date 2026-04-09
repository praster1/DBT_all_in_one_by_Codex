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
