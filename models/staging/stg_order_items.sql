with source as (

    select * from {{ source('raw', 'order_items') }}

)

select
    cast(order_id as string) as order_id,
    cast(order_item_id as int64) as order_item_id,
    cast(product_id as string) as product_id,
    cast(seller_id as string) as seller_id,
    cast(shipping_limit_date as timestamp) as shipping_limit_date,
    cast(price as float64) as price,
    cast(freight_value as float64) as freight_value

from source
