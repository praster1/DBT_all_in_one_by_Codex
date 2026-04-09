CHAPTER 13

Platform Playbook · MySQL

레거시 제약이 있는 환경에서 dbt를 조심스럽게 시작하는 방법.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

MySQL은 dbt의 이상적인 분석 플랫폼이라고 보기는 어렵지만, 현실적으로 여전히 만나는 환경이다. 레거시 애플리케이션 데이터와 가까운 곳에서 검증이나 작은 마트를 시작해야 할 때, 혹은 별도 DW가 아직 없는 조직에서 가장 먼저 부딪히는 선택지가 될 수 있다.

이 장은 MySQL adapter의 현실적 한계와 함께, 세 예제를 어떤 범위에서 실험해 볼 수 있는지, full rebuild와 무거운 변환을 어떻게 조심해야 하는지, 운영계와 분석계의 경계를 어디에 그어야 하는지를 정리한다.

가장 먼저 확인할 profile / setup 예시

MySQL profile 예시

| my_mysql: target: dev outputs: dev: type: mysql server: localhost port: 3306 schema: analytics username: analytics password: "{{ env_var('DBT_ENV_SECRET_MYSQL_PASSWORD') }}" |
| --- |

코드 · YAML

| 예제 | day1 bootstrap 경로 | day2 변경 경로 |
| --- | --- | --- |
| Retail Orders | 03_platform_bootstrap/retail/mysql/setup_day1.sql | 03_platform_bootstrap/retail/mysql/apply_day2.sql |
| Event Stream | 03_platform_bootstrap/events/mysql/setup_day1.sql | 03_platform_bootstrap/events/mysql/apply_day2.sql |
| Subscription & Billing | 03_platform_bootstrap/subscription/mysql/setup_day1.sql | 03_platform_bootstrap/subscription/mysql/apply_day2.sql |

MySQL에서는 “가능한가”보다 “어디까지를 여기서 해야 하는가”를 먼저 판단해야 한다. 작은 검증이나 제약된 환경의 마트는 가능하지만, 무거운 재생성이나 대용량 incremental을 운영계와 같은 인스턴스에 올리는 것은 신중해야 한다.

세 예제를 MySQL에서 진행할 때의 기준

Retail Orders는 비교적 무난하지만, Event Stream처럼 이벤트가 빠르게 누적되는 경우는 비용과 잠금, 운영 영향이 빨리 문제로 드러날 수 있다. Subscription & Billing은 상태 추적과 작은 마트 검증 용도로는 괜찮지만, governed API와 heavy CI를 모두 MySQL 위에서 처리하려고 하면 제약이 커진다. 따라서 MySQL 플레이북의 핵심은 “처음 도입하되, 언제 별도 DW로 이동할지”의 기준을 세우는 것이다.
