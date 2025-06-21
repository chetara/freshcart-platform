with geo as (
    select * from {{ ref('stg_geolocation') }}
),

aggregated as (
    select
        zip_code_prefix,
        city,
        state,
        avg(latitude) as latitude,
        avg(longitude) as longitude
    from geo
    group by zip_code_prefix, city, state
)

select * from aggregated
