# DBT All In One 북 차터 (강화판)

## 1. 책 기본 정보
- **주제**: dbt 기반 분석 엔지니어링 전 과정을 한 권으로 익히는 올인원 실무 교과서
- **책 유형**: 올인원 교과서 + 실무서 + 레퍼런스 하이브리드
- **대상 독자**: SQL 가능자(입문~중급), Analytics Engineer, 데이터 팀 리드
- **목표 수준**: 단일 프로젝트 실습 → 멀티 플랫폼 운영/검증/배포까지 재현 가능
- **출력물**: PDF, DOCX, Companion ZIP(예제/데이터/부트스트랩/예상 결과)

## 2. 포함 범위 / 제외 범위

### 2.1 반드시 포함할 범위
1. dbt Core 프로젝트 구조, 모델링 레이어(staging/intermediate/marts)
2. 테스트(기본/고급), 문서화, 거버넌스, 운영 자동화(CI/선택 실행)
3. 플랫폼별 실행 전략(duckdb, postgres, bigquery, snowflake, clickhouse, trino)
4. NoSQL + SQL Layer(Trino 경유) 실습 축
5. 실패 재현 데이터와 디버깅 절차

### 2.2 제외 범위
1. 특정 BI 도구의 화면 사용법 상세 튜토리얼
2. 클라우드 인프라(네트워크/VPC/IAM) 심화 설계
3. Python 프레임워크 전반 교육(필요 최소 범위만 포함)

## 3. 예제 트랙(책 전체 관통)

### Example A · Retail Orders
- 핵심 추적 키: `order_id=1001`, `customer_id=10`
- day1/day2 변화: 주문 상태/금액/품목 변화
- 핵심 결과물: `fct_orders`, `dim_customers`

### Example B · Event Stream
- 핵심 추적 키: `user_id=42`, `session_id=s-100`
- day1/day2 변화: 이벤트 유입 증가, 세션 파편화
- 핵심 결과물: `fct_daily_active_users`, `fct_sessions`

### Example C · Subscription & Billing
- 핵심 추적 키: `account_id=200`, `subscription_id=sub_01`
- day1/day2 변화: 플랜 변경, 상태 전이, 청구 이벤트 반영
- 핵심 결과물: `fct_mrr`, `dim_plans`, snapshot

## 4. 플랫폼/환경 범위
- 공통: dbt Core, SQL, YAML, CSV/JSONL 기반 raw 데이터
- 플랫폼: DuckDB / PostgreSQL / MySQL / BigQuery / Snowflake / ClickHouse / Trino
- 확장 축: MongoDB(JSONL) + Trino catalog(SQL Layer)

## 5. 산출물 규칙
1. 본문은 개념/원리/판단 기준 중심으로 작성
2. 실행 세부는 Companion ZIP과 플랫폼 플레이북으로 분리
3. 각 예제는 반드시 다음을 함께 제공
   - 초기 데이터(day1)
   - 변화 데이터(day2)
   - 예상 결과 데이터
   - 실패 재현 입력 데이터
   - 플랫폼별 셋업 스크립트

## 6. 챕터 작성 강제 순서
각 챕터는 아래 순서를 유지한다.
1. 전반 소개(문제·맥락)
2. 핵심 개념과 원리
3. 의사결정 기준(언제 쓰고 언제 피하는가)
4. 절차/패턴/파일 구조
5. 안티패턴/실수/실패 재현
6. Example A/B/C 적용

> 금지: "로드맵 박스"의 기계적 반복, 장마다 새 예제로 리셋, 개념 없는 코드 나열

## 7. 개정 작업 프로토콜
1. **구조 변경인지 내용 보강인지 먼저 판정**
2. 구조 변경이면 본문 전에 `01_outline/master_toc.md`를 선수정
3. 스타일 이슈는 문단 수정보다 `07_styles/style_system.md`를 먼저 수정
4. 대규모 수정은 Part/Chapter 단위 분할 산출 허용

## 8. 완료 정의(Definition of Done)
- 챕터가 개요 수준이 아닌, 독립 학습 가능한 완성 상태
- 예제 A/B/C가 앞장-뒷장 간 연속적으로 이어짐
- 모든 실행 예시가 경로/파일/명령/기대 결과를 포함
- 플랫폼 차이는 전용 플레이북 또는 부록으로 일관 분리
- 용어와 표기(한영 혼용/번역)가 장 간 동일
