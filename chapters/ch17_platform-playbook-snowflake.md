CHAPTER 17

Platform Playbook · Snowflake

엔터프라이즈 DW에서 권한, warehouse, refresh 전략을 함께 관리하는 법.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

Snowflake는 역할, warehouse, database, schema, task/dynamic table 같은 운영 요소가 비교적 명료하게 분리된 엔터프라이즈 DW다. 따라서 dbt를 통한 변환 운영뿐 아니라 dev/prod 격리, grants, contracts, semantic layer, governed sharing 같은 주제를 함께 읽기 좋다.

이 장은 Snowflake profile과 권한 구조, 세 예제 raw bootstrap, warehouse 크기와 비용, dynamic table/materialized_view 감각, contracts와 versions의 적용, Semantic Layer 및 platform 운영 관점을 함께 정리한다.

가장 먼저 확인할 profile / setup 예시

Snowflake profile 예시

| my_snowflake: target: dev outputs: dev: type: snowflake account: acme.ap-northeast-2 user: analytics_user password: "{{ env_var('DBT_ENV_SECRET_SNOWFLAKE_PASSWORD') }}" role: transformer database: ANALYTICS |
| --- |

코드 · YAML

| 예제 | day1 bootstrap 경로 | day2 변경 경로 |
| --- | --- | --- |
| Retail Orders | 03_platform_bootstrap/retail/snowflake/setup_day1.sql | 03_platform_bootstrap/retail/snowflake/apply_day2.sql |
| Event Stream | 03_platform_bootstrap/events/snowflake/setup_day1.sql | 03_platform_bootstrap/events/snowflake/apply_day2.sql |
| Subscription & Billing | 03_platform_bootstrap/subscription/snowflake/setup_day1.sql | 03_platform_bootstrap/subscription/snowflake/apply_day2.sql |

Snowflake chapter의 포인트는 warehouse와 권한, 그리고 governed API를 함께 보는 데 있다. 같은 dbt 모델이라도 어떤 warehouse에서 실행하는지, 어떤 role과 grant로 노출하는지에 따라 운영 감각이 크게 달라진다.

세 예제를 Snowflake에서 진행할 때의 기준

Retail Orders는 dev/prod 격리와 grants, contracts를 실험하기 좋고, Event Stream은 dynamic table이나 refresh 전략을 고민하기 좋은 예제다. Subscription & Billing은 versions, semantic layer, governed sharing을 가장 입체적으로 묶어 볼 수 있다. 따라서 Snowflake 플레이북은 기능 자체보다 “운영 면과 거버넌스를 어떻게 설계할 것인가”를 먼저 읽는 편이 좋다.
