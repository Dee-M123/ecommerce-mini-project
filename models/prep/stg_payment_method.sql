-- models/prep/stg_payment_method.sql

{{
    config(
        alias='stg_payment_method',
        materialized='table'
    )
}}

with source as (
    select * from {{ source('ecommerce_raw', 'payment_method') }}
),

transformed as (

    select
        cast(payment_id as integer) as payment_id,
        trim(lower(payment_method)) as payment_method

    from source

    -- Remove duplicates
    qualify row_number() over (
        partition by payment_id
        order by payment_id
    ) = 1
)

select * from transformed
