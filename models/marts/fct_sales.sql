{{ 
    config(
        alias='fact_sales',
        materialized='table',
        tags=['star_schema']
    ) 
}}

with order_product as (

    select *
    from {{ ref('stg_order_product') }}

),

orders as (

    select *
    from {{ ref('stg_orders') }}

),

dim_client as (

    select *
    from {{ ref('dim_client') }}

),

dim_product as (

    select *
    from {{ ref('dim_product') }}

),

dim_payment_method as (

    select *
    from {{ ref('dim_payment_method') }}

),

dim_time as (

    select *
    from {{ ref('dim_time') }}

)

select

    {{ dbt_utils.generate_surrogate_key([
        'dc.client_key',
        'dp.product_key',
        'dt.date_key',
        'dpm.payment_key',
        'op.order_product_id'
    ]) }} as sales_key,

    dc.client_key,
    dp.product_key,
    dt.date_key,
    dpm.payment_key,

    op.quantity,
    op.price_unit,
    o.total_amount

from order_product op

join orders o
    on op.order_id = o.order_id

join dim_client dc
    on o.client_id = dc.client_id

join dim_product dp
    on op.product_id = dp.product_id

join dim_payment_method dpm
    on o.payment_id = dpm.payment_id

join dim_time dt
    on o.order_date = dt.calendar_date
