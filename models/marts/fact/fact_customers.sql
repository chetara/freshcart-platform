with orders as (
    select * from {{ ref('fact_orders') }}
),

customers as (
    select
        customer_id,
        lpad(cast(customer_zip_code as string), 5, '0') as zip_code_key
    from {{ ref('stg_customers') }}
),

geo as (
    select
        lpad(cast(zip_code_prefix as string), 5, '0') as zip_code_key,
        city,
        state,
        avg(latitude) as latitude,
        avg(longitude) as longitude
    from {{ ref('stg_geolocation') }}
    group by zip_code_key, city, state
),

orders_with_geo as (
    select
        o.customer_id,
        o.order_id,
        o.total_payment,
        o.avg_review_score,
        o.order_date,
        c.zip_code_key,
        g.city,
        g.state,
        g.latitude,
        g.longitude
    from orders o
    left join customers c on o.customer_id = c.customer_id
    left join geo g on c.zip_code_key = g.zip_code_key
)

select
    customer_id,
    count(distinct order_id) as total_orders,
    sum(total_payment) as total_spent,
    round(avg(total_payment), 2) as avg_order_value,
    round(avg(avg_review_score), 2) as avg_review_score,
    min(order_date) as first_order_date,
    max(order_date) as last_order_date,

    coalesce(MAX(city), 'Unknown') as city,
    coalesce(MAX(state), 'Unknown') as state,
    AVG(latitude) as latitude,
    AVG(longitude) as longitude,

    case
        when sum(total_payment) >= 1000 then 'High Value'
        when sum(total_payment) >= 500 then 'Medium Value'
        else 'Low Value'
    end as customer_segment

from orders_with_geo
group by customer_id
