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
