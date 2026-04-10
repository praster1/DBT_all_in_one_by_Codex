select *
from {{ ref('finance_core', 'fct_mrr') }}
