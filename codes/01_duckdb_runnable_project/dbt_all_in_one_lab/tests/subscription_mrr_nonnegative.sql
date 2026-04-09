select *
from {{ ref('fct_mrr') }}
where mrr < 0
