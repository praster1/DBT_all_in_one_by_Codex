with source_data as (
    select *
    from {{ source('rawish', 'orders') }}
),
renamed as (
    select
        order_id,
        customer_id,
        cast(order_date as date) as order_date,
        lower(status) as order_status,
        cast(total_amount as numeric) as total_amount
    from source_data
)
select * from renamed
