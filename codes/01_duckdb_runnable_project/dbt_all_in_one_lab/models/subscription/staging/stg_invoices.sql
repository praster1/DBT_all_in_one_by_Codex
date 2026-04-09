select
  invoice_id,
  subscription_id,
  cast(invoice_date as date) as invoice_date,
  cast(amount as double) as amount
from {{ source('raw_billing', 'invoices') }}
