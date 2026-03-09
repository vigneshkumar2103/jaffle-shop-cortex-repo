with source as (
    select * from {{ source('ecom', 'raw_supplies') }}
),
renamed as (
    select
        id,
        sku,
        name,
        cost,
        perishable
    from source
)
select * from renamed