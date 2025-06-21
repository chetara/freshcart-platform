with source as (

    select * from {{ source('raw', 'products') }}

)

select
    cast(product_id as string) as product_id,
    cast(product_category_name as string) as category_name,
    cast(product_name_lenght as float64) as name_length,
    cast(product_description_lenght as float64) as description_length,
    cast(product_photos_qty as float64) as photos_qty,
    cast(product_weight_g as float64) as weight_g,
    cast(product_length_cm as float64) as length_cm,
    cast(product_height_cm as float64) as height_cm,
    cast(product_width_cm as float64) as width_cm

from source
