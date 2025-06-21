with distinct_payment_types as (

    select distinct payment_type
    from {{ ref('stg_order_payments') }}

)

select
    payment_type,

    -- Readable label for display
    case
        when payment_type = 'credit_card' then 'Credit Card'
        when payment_type = 'debit_card' then 'Debit Card'
        when payment_type = 'voucher' then 'Store Voucher'
        when payment_type = 'boleto' then 'Bank Boleto'
        else initcap(payment_type)
    end as payment_label,

    -- High-level category
    case
        when payment_type in ('credit_card', 'debit_card') then 'Card'
        when payment_type = 'voucher' then 'Store Credit'
        when payment_type = 'boleto' then 'Bank Transfer'
        else 'Other'
    end as payment_category

from distinct_payment_types
