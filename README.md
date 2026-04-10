# DBT All In One

DBT All In One 원고와 Companion Pack을 GitHub에서 바로 읽고 따라할 수 있게 정리한 저장소입니다.

이 저장소는 책 본문, 예제 케이스북, 플랫폼 플레이북, 부록 레퍼런스, 실행 가능한 코드와 초기 데이터 셋업 파일을 한 곳에 모아 둡니다. 책은 초보자용 입문 흐름에서 시작하지만, 뒤로 갈수록 운영·거버넌스·semantic layer·platform playbook까지 확장되도록 설계되어 있습니다.

## 이 저장소를 어떻게 읽으면 좋은가

1. 먼저 `chapters/00-introduction-and-reading-guide.md`에서 책의 전개 방식과 읽기 순서를 확인합니다.
2. 그다음 `01_outline/master_toc.md`에서 전체 구조를 봅니다.
3. 본문은 `chapters/01-...`부터 순서대로 읽고, 필요한 시점에 `chapters/09-20`의 casebook과 platform playbook을 병행합니다.
4. 직접 실행할 때는 `codes/README.md`를 열고 `01_duckdb_runnable_project/`부터 시작합니다.
5. 명령어·Jinja·트러블슈팅이 필요할 때는 Appendix B, C, D를 참고합니다.

## 저장소 구조

| 경로 | 역할 |
| --- | --- |
| `chapters/` | 책 본문과 부록 Markdown |
| `chapters/images/` | 모든 챕터와 부록에서 참조하는 그림 파일 |
| `00_meta/` | 책의 범위, 독자, 예제, 플랫폼 범위를 정리한 메타 문서 |
| `01_outline/` | 전체 목차와 구조 설계 문서 |
| `07_styles/` | Markdown 스타일 시스템 |
| `codes/` | Companion Pack, 플랫폼 bootstrap, chapter snippets |

## 본문 구성

- Chapter 01~08: 핵심 개념, 모델링, 품질, 디버깅, 운영, 거버넌스, semantic layer
- Chapter 09~11: 세 가지 연속 예제 casebook
- Chapter 12~20: 데이터 플랫폼별 playbook
- Appendix A~D: bootstrap, 명령어, Jinja/macro, 트러블슈팅/지원 매트릭스

## 예제 트랙

1. Retail Orders  
2. Event Stream  
3. Subscription & Billing  

각 예제는 day1/day2 초기 데이터, expected 결과, chapter snippets, 플랫폼별 bootstrap 경로를 함께 제공합니다.

## 플랫폼 범위

DuckDB, MySQL, PostgreSQL, BigQuery, ClickHouse, Snowflake, Trino, NoSQL + SQL Layer, Databricks

## 빠른 시작

- 책을 먼저 읽고 싶다면: `chapters/00-introduction-and-reading-guide.md`
- 코드부터 실행하고 싶다면: `codes/01_duckdb_runnable_project/README.md`
- 전체 구조를 먼저 보고 싶다면: `01_outline/master_toc.md`

## 주의사항

- 이 문서는 ChatGPT를 적극적으로 활용하여 작성되었습니다. 나름의 검수를 하였으나, 잘못된 정보나 오류가 있을 수 있습니다.
