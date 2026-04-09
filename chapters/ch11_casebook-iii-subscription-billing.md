CHAPTER 11

Casebook III · Subscription & Billing

상태 변화와 계약을 다루는 구독 도메인으로 snapshot, versions, contracts, metric layer를 입체적으로 본다.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

Subscription & Billing 예제는 상태 변화와 공용 정의가 중요한 도메인을 보여 준다. 구독의 상태는 시간에 따라 바뀌고, 취소와 trialing과 active의 의미는 metric에 직접 영향을 주며, MRR 같은 지표는 정의가 조금만 흔들려도 실무에 큰 혼선을 만든다.

이 장은 subscriptions day1/day2, invoices, plans, accounts raw에서 시작해 stg_subscriptions, fct_mrr, status snapshot, contracts, versions, semantic metric, governed sharing까지 이어지는 흐름을 보여 준다. 세 예제 중 거버넌스와 semantic layer의 가치를 가장 강하게 느끼기 좋은 장이다.

이 예제를 시작할 때 가장 먼저 확인할 파일

| 구분 | 파일 경로 | 왜 먼저 보는가 |
| --- | --- | --- |
| bootstrap | 03_platform_bootstrap/subscription/<platform>/setup_day1.sql | accounts/plans/subscriptions/invoices raw를 생성 |
| day2 변경 | 03_platform_bootstrap/subscription/<platform>/apply_day2.sql | 상태 변경과 취소를 day2로 주입 |
| source 정의 | models/subscription/subscription_sources.yml | raw_subscription source 범위 확인 |
| 핵심 모델 | models/subscription/staging/stg_subscriptions.sql | 상태 변화와 월금액을 표준화 |
| 핵심 mart | models/subscription/marts/fct_mrr.sql | MRR을 계산하는 기준점 |

Subscription & Billing 예제는 companion ZIP의 `03_platform_bootstrap/subscription/` 아래 bootstrap 스크립트와 `01_duckdb_runnable_project/dbt_all_in_one_lab/models/` 아래 모델 파일이 함께 움직인다. day1은 안정된 초기 상태를, day2는 실제 프로젝트에서 흔히 생기는 변경을 흉내 낸다. 따라서 이 장의 핵심은 단순히 모델 결과를 보는 것이 아니라, day1과 day2 사이의 변화가 어떤 dbt 장치들을 필요로 하게 만드는지 추적하는 데 있다.

구독 도메인이 특별한 이유

구독 도메인은 상태 변화와 계약의 일관성이 핵심이다. active, trialing, canceled 같은 상태는 단순한 문자열이 아니라 metric 계산 규칙과 직결되고, MRR 정의는 팀마다 조금만 달라도 큰 혼선을 만든다. 따라서 이 예제는 snapshot, contracts, versions, semantic metric의 필요성을 가장 설득력 있게 보여 준다.

핵심 staging · stg_subscriptions

| select subscription_id, account_id, plan_id, lower(status) as subscription_status, cast(started_at as date) as started_at, nullif(cancelled_at, '') as cancelled_at_raw, cast(monthly_amount as double) as monthly_amount, cast(updated_at as timestamp) as updated_at from {{ source('raw_billing', 'subscriptions') }} |
| --- |

코드 · SQL

핵심 mart · fct_mrr

| with subs as ( select subscription_id, account_id, plan_id, subscription_status, started_at, case when cancelled_at_raw is null or cancelled_at_raw = '' then null else cast(cancelled_at_raw as date) end as cancelled_at, monthly_amount from {{ ref('stg_subscriptions') }} ), active as ( select * from subs where subscription_status in ('active', 'trialing') ) select plan_id, count(*) as active_subscriptions, sum(monthly_amount) as mrr from active |
| --- |

코드 · SQL

snapshot과 versioned API

Subscription 예제는 day1/day2 사이에서 구독 상태가 바뀌도록 설계되어 있어 snapshot의 가치를 바로 체감하기 좋다. subscriptions_status_snapshot은 상태 변화 이력을 row version 형태로 남기고, downstream에서는 현재 유효 상태를 보는 모델과 과거 상태 변화를 보는 모델을 구분해 설계할 수 있다. 또한 MRR 모델은 contracts와 versions를 붙여 “이 버전의 MRR 정의를 믿고 써도 되는가”를 코드로 설명하기 좋다.

subscription snapshot 예시

| {% snapshot subscriptions_status_snapshot %} {{ config( target_schema='snapshots', unique_key='subscription_id', strategy='check', check_cols=['subscription_status', 'plan_id', 'monthly_amount'], updated_at='updated_at' ) }} select * from {{ ref('stg_subscriptions') }} {% endsnapshot %} |
| --- |

코드 · SQL

semantic과 governed sharing

구독 도메인에서는 semantic layer가 단순 편의 기능이 아니라 정의 충돌을 줄이는 장치가 되기 쉽다. active_subscriptions, mrr, churn-like metrics를 semantic model과 metric으로 명시하면, BI와 reverse ETL, AI surface가 같은 정의를 바라보게 만들기 좋다. 이때 versions와 group/access/grants를 함께 붙이면 한 프로젝트 안에서도 “어떤 팀이 어떤 정의를 공용 API처럼 소비하는가”를 더 명확히 관리할 수 있다.

contracts / versions 예시

| version: 2 groups: - name: finance owner: name: finance-data email: finance-data@example.com models: - name: fct_orders config: access: public group: finance contract: enforced: true grants: select: ['reporter', 'bi_reader'] columns: - name: order_id data_type: bigint constraints: - type: not_null - name: gross_revenue data_type: numeric - name: fct_mrr latest_version: 2 versions: |
| --- |

코드 · YAML

| Subscription & Billing 실험 루틴 1) setup_day1.sql 실행 → 2) dbt build -s subscription → 3) fct_mrr expected 결과 비교 → 4) apply_day2.sql 실행 → 5) dbt snapshot으로 상태 이력 생성 → 6) contracts, versions, semantic metric을 붙여 governed API처럼 다듬기 |
| --- |

PART IV · 플랫폼 플레이북

플랫폼 플레이북

플랫폼 장은 단순한 profile 모음이 아니다. 앞에서 배운 모든 원리가 각 실행 환경에서 어떤 형태로 바뀌는지, 세 예제를 실제로 어떻게 올리고 운영하는지 보여 주는 장이다.
