with source as (
    select * from {{ source('ecom', 'raw_products') }}
),
renamed as (
    select
        sku,
        name,
        type,
        description,
        price
    from source
)
select * from renamed