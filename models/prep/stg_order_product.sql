-- models/prep/stg_order_product.sql

{{
    config(
        alias='stg_order_product',
        materialized='table'
    )
}}

with source as (
    select * from {{ source('ecommerce_raw', 'order_product') }}
),

transformed as (

    select
        cast(order_product_id as integer) as order_product_id,
        cast(order_id as integer) as order_id,
        cast(product_id as integer) as product_id,
        cast(quantity as integer) as quantity,
        cast(price_unit as number(10,2)) as price_unit,

        -- Derived column (important for fact table)
        cast(quantity as integer) * cast(price_unit as number(10,2)) 
            as line_total

    from source

    -- Remove duplicates
    qualify row_number() over (
        partition by order_product_id
        order by order_product_id
    ) = 1
)

select * from transformed
