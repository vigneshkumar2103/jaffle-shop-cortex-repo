with

source as (

    select * from {{ source('ecom', 'raw_customers') }}

),

final as (

    select
        id,       
        name      
    from source

)

select * from final