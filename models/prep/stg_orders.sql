-- models/prep/stg_orders.sql

{{
    config(
        alias='stg_orders',
        materialized='table'
    )
}}

with source as (
    select * from {{ source('ecommerce_raw', 'orders') }}
),

transformed as (

    select
        cast(order_id as integer) as order_id,
        cast(client_id as integer) as client_id,
        cast(payment_id as integer) as payment_id,

        cast(order_date as date) as order_date,

        lower(trim(status)) as status,

        cast(total_amount as number(12,2)) as total_amount

    from source

    -- Remove duplicates
    qualify row_number() over (
        partition by order_id
        order by order_date desc
    ) = 1
)

select * from transformed
