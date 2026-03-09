with source as (
    select * from {{ source('ecom', 'raw_stores') }}
),
renamed as (
    select
        id,
        name,
        tax_rate,
        opened_at
    from source
)
select * from renamed