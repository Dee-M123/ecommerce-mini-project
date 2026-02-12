-- models/prep/stg_product.sql

{{
    config(
        alias='stg_product',
        materialized='table'
    )
}}

with source as (
    select * from {{ source('ecommerce_raw', 'product') }}
),

transformed as (

    select
        cast(product_id as integer) as product_id,

        trim(initcap(product_name)) as product_name,

        trim(lower(category)) as category,

        cast(price as number(10,2)) as price

    from source

    -- Remove duplicates
    qualify row_number() over (
        partition by product_id
        order by product_id
    ) = 1
)

select * from transformed
