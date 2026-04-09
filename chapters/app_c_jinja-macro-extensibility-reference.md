CHAPTER C

Jinja, Macro, Extensibility Reference

템플릿 문법, helper, macro 패턴, custom test와 package author 관점을 하나로 묶는다.

| 핵심 개념 → 사례 → 운영 기준 | 설명을 먼저 충분히 풀고, 이후 장에서 예제 케이스북과 플랫폼 플레이북으로 다시 가져간다. |
| --- | --- |

Jinja는 문법만 외우면 되는 영역이 아니라, 가독성을 해치지 않으면서 반복성을 얻는 기술이다. 이 부록은 delimiter, helper, macro 기본형부터 custom generic test, materialization, package author 관점까지를 한 자리에서 다시 보게 해 준다.

Jinja 문법 레퍼런스

Jinja는 SQL을 대체하지 않는다. 좋은 dbt 코드는 SQL이 중심이고, Jinja는 반복 제거·환경 분기·재사용을 돕는 보조 장치다. 그래서 이 appendix는 “얼마나 화려하게 쓸 수 있는가”보다 “어디까지 쓰면 읽기 쉬운가”에 초점을 둔다.

U-1. 세 가지 delimiter

| 형태 | 의미 | 예시 |
| --- | --- | --- |
| {{ ... }} | 표현식. 값을 출력한다 | {{ ref('fct_orders') }} |
| {% ... %} | 문장. 제어 흐름과 선언에 쓴다 | {% if target.name == "prod" %} |
| {# ... #} | Jinja 주석 | {# compile 시 제거됨 #} |

U-2. 가장 자주 쓰는 문법 조각

| {% set payment_methods = ["card", "bank_transfer", "gift_card"] %} select order_id, {% for method in payment_methods %} sum(case when payment_method = '{{ method }}' then amount end) as {{ method }}_amount, {% endfor %} sum(amount) as total_amount from {{ ref('stg_payments') }} group by 1 |
| --- |

JINJA + SQL

• `set`은 리스트나 문자열을 미리 선언할 때 쓴다.

• `for`는 반복 컬럼 생성이나 pivot 패턴에서 자주 등장한다.

• `if`는 target, var, flags에 따라 분기할 때 유용하다.

U-3. dbt 프로젝트에서 많이 쓰는 helper

| helper | 언제 쓰나 | 짧은 예시 |
| --- | --- | --- |
| ref() | 프로젝트 내부 모델 참조 | {{ ref('stg_orders') }} |
| source() | 프로젝트 외부 raw 입력 참조 | {{ source('raw_retail', 'orders') }} |
| var() | 프로젝트 변수 읽기 | {{ var('lookback_days', 3) }} |
| env_var() | 환경변수 읽기 | {{ env_var('DBT_ENV_SECRET_PASSWORD') }} |
| target | 현재 target 정보 분기 | {% if target.name == 'prod' %} |
| this | 현재 relation 자신을 가리킬 때 | {{ this }} |
| run_query() | 컴파일/실행 시 쿼리 결과를 읽을 때 | {% set rs = run_query('select 1') %} |
| log() | Jinja 디버깅 로그 | {{ log('debug here', info=True) }} |

U-4. macro 기본형과 인수 전달

| {% macro cents_to_currency(column_name, scale=2) %} round({{ column_name }} / 100.0, {{ scale }}) {% endmacro %} select {{ cents_to_currency('gross_revenue_cents') }} as gross_revenue from {{ ref('fct_orders_raw') }} |
| --- |

JINJA

문자열 인수는 quote를 붙이고, 컬럼명 자체를 넘길 때도 문자열처럼 전달한다는 점을 자주 잊는다. 반대로 이미 Jinja 변수인 값을 다시 `{{ }}` 안에서 감싸는 중첩 curly는 피한다.

U-5. whitespace control과 가독성

| {%- for col in ["a", "b", "c"] -%} {{ col }}{%- if not loop.last -%}, {%- endif -%} {%- endfor -%} |
| --- |

JINJA

• `{%-`와 `-%}`는 앞뒤 공백을 줄인다.

• 공백을 너무 aggressively 줄이면 compiled SQL이 읽기 어려워질 수 있다.

• DRY보다 읽기 쉬운 SQL이 우선이다.

U-6. 필터와 짧은 함수형 패턴

| 패턴 | 의미 | 예시 |
| --- | --- | --- |
| \| lower | 소문자화 | {{ target.name \| lower }} |
| \| upper | 대문자화 | {{ var('country') \| upper }} |
| \| default(...) | 기본값 지정 | {{ var('threads') \| default(4) }} |
| \| join(...) | 리스트 결합 | {{ payment_methods \| join(', ') }} |
| loop.last | 반복 마지막 원소 확인 | {% if not loop.last %}, {% endif %} |
| is none / is not none | null 분기 | {% if my_value is not none %} |

U-7. run_query와 agate는 언제 필요한가

run_query는 warehouse의 결과를 받아 다음 SQL을 생성해야 할 때만 꺼내는 것이 좋다. 예를 들어 동적 pivot 컬럼 목록을 만들거나 정보 스키마를 읽어 union 순서를 맞출 때 유용하다. 반대로 단순 모델 작성 단계에서는 ref/source/select만으로도 충분한 경우가 많다.

| {% set rs = run_query("select distinct payment_method from " ~ ref("stg_payments")) %} {% if execute %} {% set methods = rs.columns[0].values() %} {% else %} {% set methods = [] %} {% endif %} |
| --- |

JINJA

U-8. 자주 발생하는 실수

• 하나의 모델 전체를 macro 호출 하나로 감싸서 원본 SQL이 보이지 않게 만드는 것

• 환경 분기가 너무 많아 compiled SQL을 봐야만 이해할 수 있게 만드는 것

• `source()`와 `ref()` 대신 문자열 테이블명을 직접 조합하는 것

• `run_query()`를 남용해 compile 시 warehouse round-trip을 과도하게 만드는 것

확장 개발자 트랙

R-1. custom generic test는 가장 좋은 첫 확장 포인트

generic test는 팀 규칙을 재사용 가능한 품질 규칙으로 바꾸는 가장 쉬운 출발점이다.

R-2. materialization은 고급 기능이지만, 내부 구조를 읽어 보면 dbt 실행 모델이 보인다

custom materialization 자체를 자주 만들지는 않더라도, built-in materialization이 macro 조합이라는 점을 이해하면 dbt 실행 모델을 더 깊게 읽을 수 있다.

R-3. package author 관점에서 보면

| 관점 | 먼저 챙길 것 |
| --- | --- |
| 테스트 | 지원 dbt version·adapter 조합을 먼저 명시한다. |
| 문서 | README, examples, require-dbt-version을 함께 둔다. |
| 배포 | override 우선순위와 dispatch 구조를 이해한다. |
| 유지보수 | deprecation·behavior changes를 먼저 읽는다. |
