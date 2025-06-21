with orders as (
    select * from {{ ref('stg_orders') }}
),

items as (
    select
        order_id,
        sum(price) as total_price,
        sum(freight_value) as total_freight,
        count(*) as num_items
    from {{ ref('stg_order_items') }}
    group by order_id
),

payments as (
    select
        order_id,
        sum(payment_value) as total_payment
    from {{ ref('stg_order_payments') }}
    group by order_id
),

reviews as (
    select
        order_id,
        avg(review_score) as avg_review_score
    from {{ ref('stg_order_reviews') }}
    group by order_id
)

select
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_ts as order_date,
    o.order_estimated_ts,

    coalesce(i.total_price, 0) as total_price,
    coalesce(i.total_freight, 0) as total_freight,
    coalesce(i.num_items, 0) as num_items,

    coalesce(p.total_payment, 0) as total_payment,
    coalesce(r.avg_review_score, 0) as avg_review_score,

    (coalesce(i.total_price, 0) + coalesce(i.total_freight, 0)) as total_order_cost,
    (coalesce(p.total_payment, 0) - coalesce(i.total_price, 0)) as payment_difference

from orders o
left join items i using(order_id)
left join payments p using(order_id)
left join reviews r using(order_id)
