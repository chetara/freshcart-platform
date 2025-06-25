with source as (

    select * from {{ source('raw', 'order_reviews') }}

)

select
    cast(review_id as string) as review_id,
    cast(order_id as string) as order_id,
    cast(review_score as int64) as review_score,
    cast(review_comment_title as string) as review_comment_title,
    cast(review_comment_message as string) as review_comment_message,
    cast(review_creation_date as date) as review_creation_date,
    cast(review_answer_timestamp as timestamp) as review_answer_ts

from source

-- trigger CI

