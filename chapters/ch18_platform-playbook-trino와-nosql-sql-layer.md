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
