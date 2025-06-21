with products as (
    select * from {{ ref('stg_products') }}
)

select
    product_id,
    category_name,
    name_length,
    description_length,
    photos_qty,
    weight_g,
    length_cm,
    height_cm,
    width_cm
from products
