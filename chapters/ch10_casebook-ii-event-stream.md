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
