with customers as (
    select * from {{ ref('stg_customers') }}
)

select
    customer_id,
    customer_unique_id,
    customer_zip_code as zip_code,
    customer_city as city,
    customer_state as state
from customers
