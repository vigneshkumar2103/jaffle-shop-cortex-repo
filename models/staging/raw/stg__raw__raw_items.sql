with source as (
    select * from {{ source('ecom', 'raw_items') }}
),
renamed as (
    select
        id,      -- Was order_item_id
        order_id,
        sku      -- Was product_id
    from source
)
select * from renamed