with source as (
    select * from {{ source('ecom', 'raw_orders') }}
),
renamed as (
    select
        id,
        store_id,
        customer,
        subtotal,
        tax_paid,
        order_total,
        ordered_at
    from source
)
select * from renamed