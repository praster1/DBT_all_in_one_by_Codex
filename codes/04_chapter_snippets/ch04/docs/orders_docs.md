{% docs fct_orders_long_description %}
`fct_orders`는 주문 단위 매출 fact 모델이다.

이 모델은 다음 규칙을 따른다.

1. 주문 grain은 `order_id` 기준이다.
2. 취소 주문은 `gross_revenue = 0`으로 집계한다.
3. `order_status`는 staging에서 표준화된 상태값만 허용한다.
{% enddocs %}
