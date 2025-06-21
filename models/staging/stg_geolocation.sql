with source as (

    select * from {{ source('raw', 'geolocation') }}

)

select
    cast(geolocation_zip_code_prefix as integer) as zip_code_prefix,
    cast(geolocation_lat as float64) as latitude,
    cast(geolocation_lng as float64) as longitude,
    cast(geolocation_city as string) as city,
    cast(geolocation_state as string) as state

from source
