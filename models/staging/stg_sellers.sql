
with source as (

    select * from {{ source('raw', 'sellers') }}

)

select
    cast(seller_id as string) as seller_id,
    cast(seller_zip_code_prefix as int64) as seller_zip_code_prefix,
    cast(seller_city as string) as seller_city,
    cast(seller_state as string) as seller_state

from source
