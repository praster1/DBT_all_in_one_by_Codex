# CHAPTER 03 · source/ref, selectors, layered modeling, grain, materializations

> 모델 간 계약, DAG 제어, 레이어 설계, fanout 방지, incremental 판단까지 변환의 핵심 설계를 한 장에 묶어 다룬다.

source()와 ref(), selector, 레이어, grain, materialization은 서로 다른 기능처럼 보이지만 실제 프로젝트에서는 하나의 질문으로 연결된다.

> **원천을 어떻게 선언할 것인가 → 모델을 어떤 단위로 나눌 것인가 → 수정 범위를 어떻게 좁힐 것인가 → 결과를 어떤 객체로 저장할 것인가**

이 장은 위 질문을 하나씩 푸는 방식으로 진행한다. 먼저 공통 원리와 판단 기준을 충분히 설명한 뒤, 장 후반에서 **Retail Orders / Event Stream / Subscription & Billing** 세 예제가 이 원리를 어떻게 사용해 성장하는지 연결한다.

![그림 3-1. source/ref, selector, grain, materialization이 하나의 설계 문제로 이어지는 구조](./images/ch03_dag-contracts-and-selection.svg)

*그림 3-1. source/ref, selector, grain, materialization이 하나의 설계 문제로 이어지는 구조*

## 3.1. 왜 이 다섯 주제를 한 장에서 함께 다루는가

많은 초보자는 dbt를 배우면서 `source()`와 `ref()`는 의존성 이야기, `--select`는 실행 명령 이야기, 레이어와 grain은 모델링 이야기, materialization은 성능 이야기라고 따로따로 기억한다. 하지만 실무에서 문제는 이렇게 분리되어 오지 않는다.

예를 들어 주문 fact가 이상하게 커졌다고 해 보자. 원인은 보통 다음 중 하나다.

1. 원천을 잘못 읽었다.
2. 모델 간 연결을 잘못 잡았다.
3. 서로 다른 grain을 그대로 join했다.
4. selector를 넓게 잡아 엉뚱한 범위를 다시 만들었다.
5. incremental 범위를 잘못 설계했다.

즉, 이 다섯 주제는 모두 **모델이 어떤 입력을 받고, 어떤 단위의 행을 만들며, 어떤 범위를 다시 계산할 것인가**라는 한 문제를 다른 각도에서 보는 것이다.

### 3.1.1. 이 장에서 반드시 잡아야 할 기준선

이 장을 다 읽고 나면 최소한 아래 다섯 가지는 설명할 수 있어야 한다.

- `source()`는 프로젝트 바깥 입력, `ref()`는 프로젝트 안 산출물이라는 점
- `--select`는 편의 기능이 아니라 개발 범위를 통제하는 핵심 도구라는 점
- 레이어 분리는 보기 좋으라고 하는 정리가 아니라 변경 비용을 줄이기 위한 설계라는 점
- grain은 SQL을 쓰기 전에 먼저 결정해야 하는 모델의 단위라는 점
- incremental은 “빠르게 만드는 옵션”이 아니라 “어떤 범위를 다시 읽을지 설계하는 패턴”이라는 점

### 3.1.2. 이 장을 읽는 방법

이 장은 크게 네 묶음으로 이루어진다.

1. **계약과 DAG**: `source()`, `ref()`, freshness, selector
2. **모델링과 grain**: staging → intermediate → marts, business key, fanout
3. **저장 전략**: view, table, incremental, ephemeral, materialized_view 관점
4. **예제 적용**: 세 트랙이 위 원리를 어떻게 실제 모델과 파일로 구현하는지

따라서 처음 읽을 때는 문법을 외우기보다, 각 절이 결국 어떤 질문에 답하는지에 집중하는 편이 좋다.

## 3.2. source()와 ref(): 원천과 모델 사이의 계약

`source()`와 `ref()`는 dbt 프로젝트의 가장 중요한 두 함수다. 하지만 둘 다 “테이블 이름을 감추는 함수” 정도로 이해하면 금방 한계에 부딪힌다. 핵심은 이름이 아니라 **계약**이다.

- `source()`는 프로젝트 바깥의 입력을 공식화한다.
- `ref()`는 프로젝트 안에서 만들어진 산출물 간의 의존성을 공식화한다.

이 둘을 통해 dbt는 단순 SQL 파일 모음을 DAG 기반 프로젝트로 바꾼다.

### 3.2.1. source()는 원천을 공식 입력으로 선언한다

`source()`를 쓰기 시작하면 원천 테이블은 단순한 물리 테이블이 아니라 프로젝트의 공식 입력이 된다. 이 순간부터 다음이 가능해진다.

- 원천 설명과 컬럼 설명 작성
- 컬럼 수준 data test 부착
- freshness 기준 정의
- docs lineage에서 시작점 표시
- 원천 rename이나 schema 변경의 영향 범위 추적

실무에서 source 선언이 중요한 이유는 “raw를 읽는다”는 사실을 코드 안의 묵시적 습관이 아니라 프로젝트 수준의 명시적 계약으로 올려주기 때문이다.

#### 3.2.1.1. Retail Orders에서의 기본 source 예시

아래 파일은 이 장에서 계속 참조하는 retail track의 source starter다.

경로: `../codes/02_reference_patterns/ch03/sources_retail.yml`

```yaml
version: 2
sources:
  - name: raw
    description: "소매 주문 예제의 원천 입력"
    schema: raw
    loaded_at_field: ingested_at
    freshness:
      warn_after: {count: 6, period: hour}
      error_after: {count: 24, period: hour}
    tables:
      - name: customers
        description: "고객 원천"
        columns:
          - name: customer_id
            data_tests:
              - not_null
              - unique
      - name: orders
        description: "주문 헤더 원천"
        columns:
          - name: order_id
            data_tests:
              - not_null
              - unique
      - name: order_items
        description: "주문 라인 원천"
        columns:
          - name: order_item_id
            data_tests:
              - not_null
              - unique
      - name: products
        description: "상품 원천"
        columns:
          - name: product_id
            data_tests:
              - not_null
              - unique
```

### 3.2.2. ref()는 모델 간 관계를 코드로 고정한다

`ref()`는 프로젝트 내부 모델 사이의 관계를 선언한다. 이 함수가 중요한 이유는 세 가지다.

1. 실행 순서를 자동으로 정한다.
2. 문서화와 lineage를 만든다.
3. selector로 upstream/downstream 범위를 제어할 수 있게 한다.

즉, `ref()`는 단순히 스키마와 테이블명을 대신 적어 주는 편의 기능이 아니라, **모델을 그래프로 묶는 핵심 함수**다.

```sql
select *
from {{ ref('stg_orders') }}
```

#### 3.2.2.1. source()와 ref()를 어떻게 구분할까

| 상황 | 써야 할 것 | 이유 |
| --- | --- | --- |
| 프로젝트 바깥의 raw 입력 | `source()` | 프로젝트 외부 입력이기 때문 |
| 같은 dbt 프로젝트 안의 다른 모델 | `ref()` | DAG와 실행 순서를 자동으로 연결하기 때문 |
| seed 파일 | 보통 `ref()` | dbt가 만든 리소스로 다루기 때문 |
| 다른 프로젝트의 공개 모델 | 뒤 장의 `cross-project ref` | 별도 프로젝트 계약을 따르기 때문 |

#### 3.2.2.2. 하드코딩이 왜 위험한가

`from raw.orders`처럼 relation 이름을 직접 쓰면 당장은 한 줄이 짧아 보인다. 하지만 다음 비용이 생긴다.

- docs에 원천 계약이 드러나지 않는다.
- rename이나 schema 변경에 취약하다.
- 환경이 달라질 때 relation naming이 흔들린다.
- source-level description, freshness, test와 자연스럽게 연결되지 않는다.

실무 규칙으로는 다음 한 줄이 강력하다.

> **원천을 직접 읽는 첫 모델은 항상 `source()`에서 시작한다.**

### 3.2.3. source freshness는 원천의 시간 계약이다

freshness는 “이 원천이 얼마나 최신 상태여야 하는가”를 정의하는 장치다. 초보자에게는 화려한 모니터링 기능처럼 보일 수 있지만, 실제로는 원천 데이터와 downstream 변환 사이의 **시간 계약**을 표현하는 기본 도구다.

- `loaded_at_field`는 freshness 계산의 기준 시각을 제공한다.
- `warn_after`는 늦어졌음을 알린다.
- `error_after`는 기준을 넘으면 실패로 처리한다.

```bash
dbt source freshness
dbt build --select "source_status:fresher+"
```

#### 3.2.3.1. freshness를 너무 늦게 넣으면 생기는 문제

freshness가 없으면 “왜 오늘 리포트가 비었는가” 같은 질문에 답하기 어려워진다. 모델 로직이 아니라 원천 도착 지연 때문일 수도 있는데, 이 둘을 분리할 근거가 없기 때문이다.

#### 3.2.3.2. 세 예제에서 freshness가 쓰이는 자리

- **Retail Orders**: POS/주문 적재가 끊기지 않았는지 확인
- **Event Stream**: 이벤트 수집 파이프라인이 늦게 도착했는지 확인
- **Subscription & Billing**: 청구/구독 변경 이벤트가 SLA 안에 들어왔는지 확인

### 3.2.4. 세 예제에서 source/ref가 실제로 어떻게 쓰이는가

#### 3.2.4.1. Retail Orders

- `source('raw', 'orders')`로 주문 헤더 입력을 읽는다.
- `ref('stg_orders')`로 정리된 주문 모델을 downstream에서 재사용한다.
- `ref('int_order_lines')`로 주문 라인 조인을 fact 모델에서 소비한다.

특히 주문 `5003`은 이 장의 대표 레코드로 계속 추적한다. day1에서는 일반 주문이지만, day2에서는 상태가 바뀌며 downstream 집계와 business rule 논의의 출발점이 된다.

#### 3.2.4.2. Event Stream

- `source('raw', 'events')`는 append-only 이벤트 입력의 시작점이다.
- `ref('stg_events')`는 event_time, user_id, event_type 정규화 결과를 뜻한다.
- `ref('int_sessions')`는 세션화 또는 event enrichment를 위한 중간 모델이 된다.

이 트랙에서는 `source()`가 특히 중요하다. 이벤트 수집 계층은 schema drift, 필드 nullable, late arrival 문제가 자주 생기기 때문이다.

#### 3.2.4.3. Subscription & Billing

- `source('raw', 'subscription_events')`
- `source('raw', 'invoice_lines')`
- `ref('stg_subscription_events')`
- `ref('int_subscription_changes')`

이 트랙에서는 `ref()`가 특히 business rule 연결의 의미를 가진다. 같은 고객의 상태 변화가 여러 단계 모델에서 재사용되기 때문에, relation 하드코딩보다 DAG 계약이 훨씬 중요해진다.

### 3.2.5. 직접 해보기

1. retail source 파일에 `orders.customer_id`의 `not_null` test를 추가한다.
2. `loaded_at_field`와 freshness 기준을 읽고, 현재 예제에 맞는 `warn_after` / `error_after`를 한국어 문장으로 다시 설명한다.
3. `stg_orders.sql`에서 `source()` 대신 raw relation을 직접 적었다고 가정하고, 어떤 운영 비용이 생기는지 세 가지 적는다.

### 3.2.6. 완료 체크리스트

- [ ] `source()`와 `ref()`의 차이를 설명할 수 있다.
- [ ] source freshness가 왜 필요한지 설명할 수 있다.
- [ ] 하드코딩 relation 이름이 왜 위험한지 실무 관점에서 말할 수 있다.

## 3.3. --select, --selector, dbt ls: 개발 범위를 줄이는 문법

프로젝트가 커질수록 중요한 것은 “전체를 잘 만드는 것”만이 아니라 **내가 바꾼 범위만 빠르게 확인하는 것**이다. 이때 핵심이 node selection 문법이다.

### 3.3.1. 왜 선택 실행이 중요한가

초보자는 매번 `dbt build` 전체 실행으로 안심하고 싶어진다. 하지만 프로젝트가 커지면 전체 실행은 가장 느리고 비싼 습관이 된다. 선택 실행을 잘 쓰면 다음이 가능하다.

- 실패 범위를 빠르게 좁힌다.
- 수정 영향이 upstream인지 downstream인지 구분한다.
- 불필요한 warehouse 비용을 줄인다.
- CI에서 필요한 노드만 검증한다.

### 3.3.2. 가장 먼저 익힐 네 가지 패턴

| 명령 | 의미 | 언제 쓰는가 |
| --- | --- | --- |
| `dbt run -s stg_orders` | 현재 모델만 | 수정 직후 가장 빠른 확인 |
| `dbt run -s stg_orders+` | 현재 + downstream | 내 변경이 mart까지 어떻게 퍼지는지 확인 |
| `dbt run -s +fct_orders` | 현재 + upstream | fact가 이상할 때 입력을 함께 확인 |
| `dbt run -s +fct_orders+` | 양방향 | 영향 범위를 크게 보고 싶을 때 |

#### 3.3.2.1. `+`, `n+`, `@`를 어떻게 감각적으로 볼까

- `+model` : model의 upstream 조상 포함
- `model+` : model의 downstream 자손 포함
- `2+model` : 두 단계 upstream까지만 포함
- `@model` : model의 downstream을 만들기 위해 필요한 upstream까지 넓게 포함

처음에는 `+model`, `model+`, `+model+` 세 개만 확실히 익히면 충분하다. `n+`와 `@`는 실무에서 선택 범위를 더 세밀하게 통제할 때 사용한다.

### 3.3.3. 복잡한 선택은 먼저 `dbt ls`로 확인한다

```bash
dbt ls -s +fct_orders+
dbt ls -s tag:daily
dbt ls -s test_type:generic
dbt ls -s test_type:singular
dbt ls -s test_type:unit
```

`dbt ls`는 “내가 머릿속으로 생각한 범위”와 “dbt가 실제로 해석한 범위”를 비교하는 가장 빠른 방법이다. 특히 태그, 경로, graph operator, test_type이 섞이면 바로 실행하기보다 먼저 `ls`로 확인하는 습관이 중요하다.

### 3.3.4. `--select`와 `--selector`를 구분하자

- `--select`는 명령줄에서 selection 표현식을 즉석으로 적는다.
- `--selector`는 `selectors.yml`에 저장한 이름 붙은 selection 정의를 불러온다.

프로젝트가 커질수록 자주 쓰는 선택식을 YAML selector로 저장하는 편이 좋다. selection logic을 코드로 남길 수 있고, 팀 전체가 같은 이름을 공유할 수 있기 때문이다.

경로: `../codes/02_reference_patterns/ch03/selectors.yml`

```yaml
selectors:
  - name: retail_marts_plus_tests
    definition:
      union:
        - method: path
          value: models/retail/marts
        - method: test_type
          value: generic

  - name: changed_core_models
    definition:
      method: state
      value: modified+

  - name: event_incremental_focus
    definition:
      intersection:
        - method: path
          value: models/events
        - method: tag
          value: incremental
```

### 3.3.5. `dbt show`는 preview용이지 대체 실행기가 아니다

`dbt show`는 선택한 단일 모델이나 테스트, analysis, 혹은 `--inline` 쿼리를 컴파일하고 실행해서 결과를 터미널에 미리 보여 준다. 중요한 점은 “이미 만들어진 테이블을 그냥 읽는 것”이 아니라, **선택한 정의를 기준으로 다시 컴파일하고 warehouse에 질의한다**는 것이다.

```bash
dbt show --select stg_orders
dbt show --select fct_orders
```

`dbt show`는 빠른 preview에는 매우 유용하지만, model selection 문법 전체를 대체하지는 않는다. 공식 문서도

### 3.3.6. 세 예제에서 selector가 실제로 어떻게 쓰이는가

#### 3.3.6.1. Retail Orders

- `dbt build -s stg_orders+` : 주문 정리 변경이 fact로 어떻게 퍼지는지 확인
- `dbt test -s fct_orders+` : 주문 fact와 관련 테스트만 확인
- `dbt ls -s +fct_orders+` : `5003` 이슈를 upstream/downstream 시야로 좁혀 보기

#### 3.3.6.2. Event Stream

- `dbt build -s tag:incremental` : 이벤트 트랙의 incremental 노드만 재검증
- `dbt show --select fct_events_daily` : 일별 집계 상단 몇 줄 확인
- `dbt run --selector event_incremental_focus` : 선택식을 YAML로 고정

#### 3.3.6.3. Subscription & Billing

- `dbt build -s int_subscription_changes+` : 상태 변화 중간 모델 이후 범위만 확인
- `dbt test -s test_type:generic,path:models/subscription` : 핵심 품질 규칙만 먼저 확인
- `dbt ls -s +fct_subscription_daily` : 어떤 upstream이 포함되는지 확인

### 3.3.7. 안티패턴

- 항상 전체 `dbt build`만 누른다.
- selection을 복잡하게 적으면서도 `dbt ls`로 먼저 확인하지 않는다.
- 자주 쓰는 selection을 팀 규칙으로 남기지 않는다.
- preview가 필요할 때도 무조건 full run부터 돌린다.

### 3.3.8. 직접 해보기

1. `dbt ls -s stg_orders+`를 실행한다고 가정하고, 어떤 downstream 모델이 포함될지 글로 적어 본다.
2. `test_type:generic`, `test_type:singular`, `test_type:unit`의 차이를 한 문장씩 써 본다.
3. `selectors.yml`에 `subscription_core` selector를 하나 더 만든다고 가정하고 정의를 적어 본다.

### 3.3.9. 완료 체크리스트

- [ ] `+model`, `model+`, `+model+`의 차이를 알고 있다.
- [ ] `dbt ls`로 selection 결과를 먼저 확인해야 하는 이유를 설명할 수 있다.
- [ ] `--select`와 `--selector`의 차이를 설명할 수 있다.
- [ ] `dbt show`의 용도를 안다.

## 3.4. 레이어, grain, business key: 모델링의 뼈대

좋은 dbt 프로젝트는 거대한 SQL 하나를 잘 쓰는 프로젝트가 아니다. 서로 다른 목적을 가진 모델을 레이어로 나누고, 각 모델의 grain을 명확히 하며, fanout을 통제하는 프로젝트다.

### 3.4.1. 레이어를 나누는 이유는 변경 비용을 줄이기 위해서다

| 레이어 | 주된 역할 | 주로 두는 내용 | 가급적 피할 일 |
| --- | --- | --- | --- |
| staging | 원천 정리 | rename, cast, status normalization, 기본 필터 | 복잡한 조인, 최종 KPI |
| intermediate | 재사용 가능한 조인/계산 | reusable joins, helper columns, line-level derivation | 최종 fact/dim 역할까지 동시에 맡기기 |
| marts | 분석용 최종 구조 | fact, dimension, KPI, metric-ready 테이블 | raw 정리 로직 다시 쓰기 |

staging → intermediate → marts 구조는 보기 좋으라고 만든 폴더 체계가 아니다. 어디에서 rename과 cast를 끝내고, 어디에서 재사용 가능한 로직을 묶고, 어디에서 최종 grain과 KPI를 확정할지 결정하는 운영 구조다.

### 3.4.2. grain은 “한 행이 무엇을 대표하는가”라는 한 문장이다

grain을 모르면 SQL을 쓸 수 있어도 모델을 설계했다고 말하기 어렵다. 아래처럼 한 문장으로 적을 수 있어야 한다.

- `stg_orders`: 한 행이 주문 1건을 대표한다.
- `stg_order_items`: 한 행이 주문상품 1건을 대표한다.
- `int_order_lines`: 한 행이 주문상품 1건을 대표한다.
- `fct_orders`: 한 행이 주문 1건을 대표한다.

#### 3.4.2.1. grain을 적지 않으면 왜 위험한가

SQL을 먼저 쓰면 자연스럽게 join과 group by에 끌려가게 된다. 하지만 grain을 먼저 적으면 “지금 이 모델은 주문 1행인가, 주문상품 1행인가, 사용자-세션 1행인가”가 분명해지고, fanout 위험을 훨씬 빨리 발견할 수 있다.

### 3.4.3. fanout은 무엇이고 왜 생기나

fanout은 서로 다른 grain의 테이블을 조인했을 때 행 수가 늘어났는데, 그 사실을 인지하지 못한 채 금액이나 수량을 집계해서 결과가 커지는 현상이다.

대표적인 실수는 이렇다.

1. 주문 1행 테이블이 있다.
2. 주문상품 여러 행 테이블을 조인한다.
3. grain을 다시 주문 1행으로 올리지 않는다.
4. 금액 합계를 내면 주문 수만큼 값이 부풀어 오른다.

![그림 3-2. 세 트랙의 grain 변화와 materialization 선택](./images/ch03_grain-materialization-map.svg)

*그림 3-2. 세 트랙의 grain 변화와 materialization 선택*

#### 3.4.3.1. fanout을 잡는 기본 질문 네 가지

- join 전 모델의 grain은 무엇인가?
- join 후 모델의 grain은 그대로인가, 더 세밀해졌는가?
- fact로 올리기 전에 grain을 다시 의도한 단위로 집계했는가?
- 고유키 테스트와 총합 비교로 이상을 확인했는가?

### 3.4.4. Retail Orders: 5003이 intermediate에서 어떻게 풀리는가

경로: `../codes/02_reference_patterns/ch03/int_order_lines.sql`

```sql
with orders as (
    select *
    from {{ ref('stg_orders') }}
),
items as (
    select *
    from {{ ref('stg_order_items') }}
),
products as (
    select *
    from {{ ref('stg_products') }}
)
select
    i.order_item_id,
    i.order_id,
    o.customer_id,
    o.order_date,
    o.order_status,
    o.payment_method,
    i.product_id,
    p.product_name,
    p.category_name,
    i.quantity,
    i.unit_price,
    i.discount_amount,
    i.line_amount
from items i
join orders o using (order_id)
join products p using (product_id)
```

주문 `5003`은 intermediate 단계에서 주문상품 두 행으로 펼쳐진다. 여기서 grain은 여전히 **주문상품 1행**이다. `fct_orders`로 올라갈 때 다시 **주문 1행**으로 집계해야 한다.

### 3.4.5. Event Stream: 이벤트는 append-only라서 grain 관리가 더 중요하다

이벤트 트랙에서는 기본 grain이 “이벤트 1행”일 때가 많다. 그런데 세션화가 들어가면 grain이 “세션 1행”으로 바뀐다. 일별 집계는 또 “날짜 × 사용자” 또는 “날짜 × 이벤트 유형”으로 바뀐다. 이때 intermediate 없이 바로 fact로 점프하면 아래 문제가 생긴다.

- session boundary logic이 여러 모델에 복제된다.
- late event 처리 범위가 흔들린다.
- incremental 설계와 grain 설계가 동시에 꼬인다.

즉, Event Stream 트랙에서는 intermediate가 더 중요한 경우가 많다.

### 3.4.6. Subscription & Billing: 상태 변화 모델은 grain이 더 자주 바뀐다

구독 데이터는 한 고객, 한 구독, 한 청구 라인, 한 날짜 기준 MRR처럼 grain 축이 자주 바뀐다.

- raw subscription event: 상태 변화 이벤트 1행
- intermediate change log: 구독 × 변화 시점 1행
- daily snapshot/fact: 날짜 × 구독 1행
- customer rollup: 날짜 × 고객 1행

이런 모델은 grain 문장을 먼저 적지 않으면 계약 조건, 업셀/다운셀, churn 처리 로직이 쉽게 꼬인다.

### 3.4.7. grain 클리닉: 모델을 쓰기 전에 적어야 할 템플릿

아래 템플릿을 모델 주석이나 설계 메모에 먼저 적는 습관을 권한다.

```text
모델 이름:
이 모델의 grain:
비즈니스 키:
upstream 입력:
이 모델에서 새로 생기는 계산 규칙:
다음 레이어에서 기대하는 grain:
```

이 템플릿은 SQL보다 먼저 쓰는 것이 좋다. grain과 business key가 분명해지면 join, group by, test 설계도 함께 선명해진다.

### 3.4.8. 안티패턴

- join을 먼저 쓰고 grain을 나중에 생각한다.
- staging에서 최종 KPI까지 계산한다.
- intermediate를 생략한 채 같은 조인을 여러 mart에 반복한다.
- fact 모델에서 원천 정리 로직을 다시 쓴다.

### 3.4.9. 직접 해보기

1. Retail Orders의 `stg_orders`, `stg_order_items`, `int_order_lines`, `fct_orders` 각각에 대해 grain을 한 줄씩 적는다.
2. Event Stream에서 “세션 1행” fact를 만들려면 intermediate가 왜 필요한지 적는다.
3. Subscription 트랙에서 `daily_mrr` 모델의 grain을 한 문장으로 정의한다.

### 3.4.10. 완료 체크리스트

- [ ] 레이어별 책임을 구분할 수 있다.
- [ ] grain을 한 문장으로 정의할 수 있다.
- [ ] fanout이 왜 생기는지 설명할 수 있다.
- [ ] business key와 최종 집계 위치를 구분할 수 있다.

## 3.5. Materializations와 incremental: 저장 전략은 운영 결정이다

SQL은 “무엇을 계산할 것인가”를 말하지만, materialization은 “그 결과를 어떤 객체로 남길 것인가”를 결정한다. 이 결정은 성능, 비용, 디버깅, 운영 방식과 직결된다.

### 3.5.1. 대표 materialization을 어떻게 비교할까

| 유형 | 특징 | 잘 맞는 자리 | 주의점 |
| --- | --- | --- | --- |
| `view` | 쿼리 정의만 저장 | staging, 가벼운 intermediate | 조회 시 비용/지연이 발생할 수 있음 |
| `table` | 결과를 물리 테이블로 저장 | 자주 읽히는 marts | 재계산 비용이 큼 |
| `incremental` | 새 데이터 중심 갱신 | 대용량 fact, append/update 혼합 모델 | 범위/키 설계가 틀리면 조용히 틀림 |
| `ephemeral` | 상위 모델에 인라인 | 아주 작은 helper logic | 디버깅/재사용 범위가 제한됨 |
| `materialized_view` | 플랫폼 지원 시 엔진이 관리하는 뷰/테이블 하이브리드 | adapter-specific 최적화 영역 | 지원 범위가 플랫폼별로 다름 |

### 3.5.2. 입문자에게 staging=view, marts=table이 안전한 이유

초반에는 모델 구조와 grain이 흔들리기 쉽다. 이 시점에서 incremental까지 동시에 붙이면 무엇이 문제인지 분리하기 어렵다. 그래서 처음에는 아래 출발점이 가장 안정적이다.

- staging = `view`
- intermediate = `view` 또는 작은 경우 `ephemeral`
- marts = `table`

이렇게 시작하면 구조와 테스트를 먼저 안정화한 뒤, 나중에 성능이 필요할 때 incremental을 검토할 수 있다.

### 3.5.3. incremental을 붙이기 전에 반드시 물어야 할 다섯 가지

1. 새로 들어온 행을 구분할 기준 시각이나 키가 있는가?
2. 과거 행이 수정(update)될 수 있는가?
3. `unique_key`는 무엇인가?
4. late-arriving data를 어디까지 다시 읽을 것인가?
5. 문제가 생겼을 때 `full-refresh`로 복구할 수 있는가?

### 3.5.4. Event Stream에서 incremental이 자연스러운 이유

이벤트 트랙은 append-only 성격이 강해서 incremental이 가장 먼저 떠오르는 예시다. 하지만 “append-only처럼 보인다”와 “incremental 설계가 안전하다”는 다르다.

경로: `../codes/02_reference_patterns/ch03/fct_events_incremental.sql`

```sql
{{ config(
    materialized='incremental',
    unique_key='event_id',
    on_schema_change='append_new_columns'
) }}

with src as (
    select *
    from {{ ref('stg_events') }}
    {% if is_incremental() %}
      where event_time >= (
        select coalesce(max(event_time) - interval '2 hour', cast('1900-01-01' as timestamp))
        from {{ this }}
      )
    {% endif %}
)
select
    event_id,
    user_id,
    session_id,
    event_time,
    event_type,
    device_type,
    event_date
from src
```

여기서 중요한 것은 `materialized='incremental'` 자체보다도, `is_incremental()` 안에서 **몇 시간의 backfill window를 다시 읽는지**와 `unique_key='event_id'`가 어떤 계약을 뜻하는지다.

### 3.5.5. Subscription & Billing에서 incremental이 더 어려운 이유

구독/청구 트랙은 단순 append-only가 아니라 상태 변화와 재계산이 많다. 예를 들어 day2에 과거 계약 상태가 수정되면, 단순히 “최근 도착분만 append”로는 정확한 daily MRR을 보장하기 어렵다. 이럴 때는 아래 중 하나를 명확히 결정해야 한다.

- 최근 N일 재계산 window를 둔다.
- 상태 변화 intermediate를 다시 계산한 뒤 daily fact를 rebuild한다.
- 아예 초기 버전에서는 `table`로 유지하고 운영 안정화 후 incremental로 전환한다.

경로: `../codes/02_reference_patterns/ch03/fct_subscription_daily.sql`

```sql
with changes as (
    select *
    from {{ ref('int_subscription_changes') }}
),
daily as (
    select
        customer_id,
        subscription_id,
        snapshot_date,
        sum(mrr_delta) as mrr_change,
        max(is_active) as is_active
    from changes
    group by 1, 2, 3
)
select
    customer_id,
    subscription_id,
    snapshot_date,
    sum(mrr_change) over (
        partition by customer_id, subscription_id
        order by snapshot_date
        rows between unbounded preceding and current row
    ) as ending_mrr,
    is_active
from daily
```

이 모델은 당장 incremental을 넣지 않아도 된다. 오히려 초기에는 `table`로 정확성을 먼저 확보하는 것이 더 안전하다.

### 3.5.6. `ephemeral`은 언제만 써야 하나

`ephemeral`은 아주 작은 helper logic을 상위 모델에 인라인할 때 유용하다. 하지만 아래 상황에서는 남용을 피하는 편이 좋다.

- 여러 모델에서 재사용해야 할 때
- compiled SQL이 지나치게 길어질 때
- 디버깅에서 중간 relation을 눈으로 확인하고 싶을 때

즉, `ephemeral`은 “작고 한정적인 보조 로직”에 쓰는 편이 안전하다.

### 3.5.7. `full-refresh`, `on_schema_change`, `unique_key`를 함께 봐야 하는 이유

- `unique_key`는 어떤 행을 동일한 비즈니스 행으로 볼지 정한다.
- `on_schema_change`는 컬럼 구조가 바뀔 때 어떤 태도를 취할지 정한다.
- `full-refresh`는 전체 재계산을 허용할지 금지할지 정한다.

이 셋은 따로따로 외우기보다, **incremental 모델을 운영 가능한 상태로 유지하기 위한 안전장치**로 함께 이해해야 한다.

### 3.5.8. 안티패턴

- 느려 보인다는 이유만으로 곧바로 incremental을 붙인다.
- `unique_key` 없이도 괜찮겠지 하고 넘어간다.
- late-arriving data를 고려하지 않는다.
- `full-refresh` 전략 없이 incremental을 운영한다.
- adapter-specific materialized view를 공통 개념처럼 설명한다.

### 3.5.9. 직접 해보기

1. Retail Orders의 `fct_orders`를 왜 처음에는 `table`로 두는 편이 안전한지 적는다.
2. Event Stream incremental 예시에서 `- interval '2 hour'`가 왜 필요한지 설명한다.
3. Subscription 트랙에서 incremental을 나중으로 미루는 이유를 한 문장으로 적는다.

### 3.5.10. 완료 체크리스트

- [ ] 대표 materialization의 특징을 비교할 수 있다.
- [ ] incremental을 붙이기 전에 물어야 할 질문을 알고 있다.
- [ ] `unique_key`, `full-refresh`, `on_schema_change`의 역할을 설명할 수 있다.
- [ ] 세 트랙에서 incremental 난이도가 왜 다른지 설명할 수 있다.

## 3.6. 세 예제가 이 장의 개념을 실제로 어떻게 사용해 나가는가

지금까지는 공통 원리를 설명했다. 이제 이 원리가 세 예제에서 어떻게 구체화되는지 정리한다. 중요한 점은 각 예제가 같은 기능을 똑같이 쓰지 않는다는 것이다. **같은 도구를 서로 다른 문제 구조에 맞게 쓰는 방식**이 다르다.

### 3.6.1. Retail Orders: 가장 먼저 배워야 할 정석형 트랙

Retail Orders는 이 장의 모든 개념을 가장 직선적으로 보여 준다.

1. `source()`로 raw 주문 데이터를 선언한다.
2. `stg_orders`, `stg_order_items`, `stg_products`에서 이름/타입을 정리한다.
3. `int_order_lines`에서 reusable join을 만든다.
4. `fct_orders`에서 주문 1행 grain으로 다시 집계한다.
5. selector로 `stg_orders+`, `+fct_orders+` 범위를 점검한다.
6. 초기 버전은 `table` 중심으로 두고 정확성을 먼저 확보한다.

이 트랙은 **source/ref, 레이어, grain, fanout 방지**를 가장 빨리 이해하게 해 주는 정석형 예제다.

### 3.6.2. Event Stream: selector와 incremental 감각을 키우는 트랙

Event Stream은 append-only raw 입력과 대량 처리 때문에 selector와 incremental의 필요성이 더 빨리 드러난다.

1. `source('raw', 'events')`로 이벤트 입력을 선언한다.
2. `stg_events`에서 event_time, event_type, user_id 정규화를 마친다.
3. intermediate에서 sessionization 또는 enrichment를 분리한다.
4. fact 단계에서는 일별 집계 또는 세션 집계를 만든다.
5. `tag:incremental`, YAML selector, `dbt ls`가 특히 자주 쓰인다.
6. backfill window와 late-arriving data 설계가 중요하다.

이 트랙은 **selection discipline**과 **incremental 사고방식**을 훈련하는 데 가장 좋다.

### 3.6.3. Subscription & Billing: grain과 business rule의 난도를 끌어올리는 트랙

Subscription & Billing은 기술적으로 화려해 보여서 어려운 것이 아니라, **grain이 자주 바뀌고 business rule이 민감하기 때문에** 어렵다.

1. raw subscription/invoice 입력을 source로 선언한다.
2. staging에서 status, effective date, amount 표준화를 한다.
3. intermediate에서 상태 변화 로그와 delta를 계산한다.
4. fact 단계에서는 날짜 기준 MRR, 계약 활성 여부, billing rollup을 만든다.
5. incremental보다 먼저 grain과 business key를 안정화한다.
6. 뒤 장의 snapshot, contracts, semantic layer와 자연스럽게 연결된다.

이 트랙은 **business rule을 어디서 확정할지**와 **grain 전환을 어떻게 관리할지**를 깊게 생각하게 만든다.

### 3.6.4. 세 트랙을 비교하며 기억해야 할 한 줄

- Retail Orders: **정석형 관계 모델링**
- Event Stream: **대량 append와 incremental 설계**
- Subscription & Billing: **상태 변화와 grain 전환**

같은 `source()`, `ref()`, selector, materialization을 써도, 어떤 문제를 푸느냐에 따라 설계 포인트가 달라진다.

## 3.7. 장 마무리: 이 장에서 꼭 남겨야 할 판단 기준

### 3.7.1. 먼저 grain, 그다음 join

SQL을 쓰기 전에 grain을 한 문장으로 먼저 적는 습관은 fanout을 줄이는 가장 강력한 방법이다.

### 3.7.2. 먼저 계약, 그다음 이름

원천 입력은 `source()`, 프로젝트 내부 산출물은 `ref()`로 연결해야 장기 운영 비용이 낮아진다.

### 3.7.3. 먼저 범위 축소, 그다음 실행

수정이 생기면 `dbt ls`와 selection으로 범위를 좁힌 뒤 실행하는 습관을 들여야 한다.

### 3.7.4. 먼저 정확성, 그다음 incremental

incremental은 성능 최적화 수단이지, 설계가 모호한 모델을 덮어 주는 마법이 아니다.

## 3.8. 직접 해보기 종합 과제

1. Retail Orders의 `5003`을 기준으로 source → staging → intermediate → mart까지 grain이 어떻게 바뀌는지 적는다.
2. Event Stream에서 `events_daily`와 `sessions_daily` 중 어느 모델이 incremental에 더 잘 맞는지 이유를 적는다.
3. Subscription 트랙에서 daily MRR 모델을 바로 incremental로 만들지 않는 이유를 설명한다.
4. 아래 네 문장을 각각 어떤 절에서 배웠는지 연결한다.
   - 원천은 프로젝트 바깥 입력이다.
   - selection은 개발 범위를 통제한다.
   - grain을 먼저 적어야 fanout을 줄일 수 있다.
   - incremental은 다시 읽을 범위를 설계하는 패턴이다.

## 3.9. 완료 체크리스트

- [ ] `source()`와 `ref()`의 차이를 설명할 수 있다.
- [ ] `dbt ls`, `--select`, `--selector`, `dbt show`를 적절히 구분할 수 있다.
- [ ] 레이어와 grain을 설명할 수 있다.
- [ ] fanout이 생기는 이유와 방지 방법을 말할 수 있다.
- [ ] 대표 materialization의 특징을 비교할 수 있다.
- [ ] Retail / Events / Subscription 세 트랙에서 이 장의 개념이 어떻게 다르게 작동하는지 설명할 수 있다.

## 3.10. 다음 장으로 이어지는 연결

이 장이 “변환 설계의 뼈대”를 다뤘다면, 다음 장은 그 뼈대 위에 **tests, seeds, snapshots, documentation, macros, packages**를 얹어 프로젝트를 더 안전하고 읽기 쉬운 상태로 확장하는 방법을 다룬다. 즉, 이번 장이 구조를 세우는 장이었다면 다음 장은 그 구조를 검증하고 문서화하는 장이다.


## 3.11. Trino / Iceberg에서 `source()`와 incremental 계약을 어떻게 더 엄격하게 봐야 하는가

이 장의 공통 원리는 모든 adapter에 적용되지만, Trino / Iceberg 조합에서는 `source()`와 `incremental_strategy='merge'`를 볼 때 특히 조심해야 하는 현실이 있다.  
업무 메모에 들어 있던 `sources.yml` 샘플과 `case01`, `case03`, `case06` 패턴은 바로 그 지점을 잘 보여 준다.

### 3.11.1. Trino에서 `source()`를 늦추면 하드코딩 비용이 더 빨리 커진다

업무 샘플의 `sources.yml`은 다음과 같은 구조였다.

```yaml
version: 2

sources:
  - name: my_source
    database: iceberg
    schema: sample_db
    tables:
      - name: raw_data
      - name: raw_sales
      - name: raw_sales2
      - name: country
```

이 선언을 먼저 해 두면 model에서는 다음처럼 읽을 수 있다.

```sql
select
    sale_id,
    product_name,
    amount,
    current_timestamp at time zone 'Asia/Seoul' as last_updated
from {{ source('my_source', 'raw_sales') }}
```

이 패턴의 장점은 단순히 SQL이 예뻐지는 데 있지 않다.

- lineage에 raw 입력이 보인다.
- catalog/schema 이름이 바뀌어도 수정 범위를 YAML 쪽으로 모을 수 있다.
- source-level test, freshness, docs를 붙일 수 있다.
- `iceberg.sample_db.raw_sales2`처럼 직접 하드코딩하던 쿼리를 나중에 정리하기 쉬워진다.

특히 `case06` 같은 loop 패턴은 raw 입력을 직접 `iceberg.sample_db.raw_sales2`로 읽기보다, 최종본에서는 `{{ source('my_source', 'raw_sales2') }}`로 바꾸는 것이 맞다. 이 장의 원칙을 operational pattern에도 그대로 적용해야 한다.

### 3.11.2. `incremental`을 “빠른 table” 정도로 생각하면 merge 오류를 피할 수 없다

업무 에러 로그의 핵심은 아래 두 가지였다.

1. `dbt_internal_source.id`를 찾을 수 없음
2. `dbt_internal_dest.id`를 찾을 수 없음

둘 다 같은 뿌리에서 나온다.  
`incremental_strategy='merge'`와 `unique_key='id'`를 줬는데, source 또는 target 어느 한쪽에든 `id`가 없어서 dbt가 match 조건을 만들 수 없었던 것이다.

이 장의 관점에서 다시 말하면, merge incremental은 단순 materialization 선택이 아니라 **record identity contract**다.  
즉, 아래 세 질문이 모두 “예”여야 한다.

- source 결과에 `unique_key`가 있는가
- target relation에도 같은 key가 존재하는가
- 이 key가 business grain을 실제로 대표하는가

셋 중 하나라도 아니면 merge는 설계 단계에서 다시 봐야 한다.

### 3.11.3. `case01`은 incremental 정석이 아니라 “전체 재적재 배치 호환 패턴”으로 읽어야 한다

업무 샘플의 `case01_truncate_insert.sql`은 다음 구조를 가진다.

- `materialized='incremental'`
- `incremental_strategy='append'`
- `pre_hook`에서 `DELETE FROM {{ this }} WHERE 1=1`

이건 업무에선 충분히 쓸 수 있다.  
하지만 교재 관점에선 **incremental의 표준 패턴**이 아니라, “기존 배치 작업을 dbt로 감싸는 과정에서 생기는 전체 재적재형 운영 타협안”으로 읽어야 한다.

왜냐하면 이 경우 실제 동작은 “새 데이터만 효율적으로 합친다”기보다 “기존 결과를 지우고 다시 만든다”에 가깝기 때문이다.  
따라서 이 패턴은 다음처럼 분류하는 편이 좋다.

- 언제 허용 가능한가: 작은 대상 테이블, 일일 full refresh 배치, 정확성이 성능보다 중요할 때
- 언제 피해야 하는가: 대형 fact, 잦은 재실행, merge upsert가 필요한 경우
- 어떤 이름으로 가르쳐야 하는가: **truncate-insert형 운영 패턴**

관련 코드는 `../codes/02_reference_patterns/ch03/trino/case01_truncate_insert.sql`에 넣어 두었다.

### 3.11.4. `case03` merge 오류는 “source-side key”와 “dest-side key”를 따로 확인해야 한다

업무 로그에는 두 가지 오류가 따로 나온다.

- `dbt_internal_source.id` cannot be resolved
- `dbt_internal_dest.id` cannot be resolved

이 둘은 비슷해 보이지만 진단 순서는 다르다.

#### source-side key 오류
compiled SQL 결과에서 최종 `SELECT`가 `id`를 반환하는지 확인해야 한다.  
예를 들어 분기 로직의 어느 한쪽에서만 `id`를 만들고, 다른 쪽에서 누락하면 source-side 오류가 날 수 있다.

#### dest-side key 오류
이미 존재하는 target table 스키마를 확인해야 한다.  
예전에 `id` 없이 만들어 둔 테이블에 나중에 `unique_key='id'`를 도입하면, target relation에 그 컬럼이 없어 dest-side 오류가 발생할 수 있다.

이 때문에 merge incremental은 model SQL만 보는 것이 아니라 **기존 target relation 스키마까지 같이 봐야** 한다.

### 3.11.5. Trino에서 grain과 key를 확인할 때 가장 실용적인 질문

- 이 model의 한 행은 정확히 무엇을 대표하는가
- 그 grain을 식별하는 business key는 무엇인가
- 그 key가 분기/루프/조건부 SQL 안에서도 항상 만들어지는가
- 그 key가 target relation에도 실제 컬럼으로 남는가

이 네 질문을 merge 전에 먼저 통과시키면, uploaded log 같은 오류를 대부분 설계 단계에서 잡을 수 있다.

### 3.11.6. 같이 보면 좋은 코드 경로

- `../codes/02_reference_patterns/ch03/trino/sources.trino.sample.yml`
- `../codes/02_reference_patterns/ch03/trino/case01_truncate_insert.sql`
- `../codes/02_reference_patterns/ch03/trino/case03_branch_query_fixed.sql`
- `../codes/02_reference_patterns/ch03/trino/case06_loop_fixed.sql`
