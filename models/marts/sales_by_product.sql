{{
    config(
        materialized='table',
        schema='REPORTING'
    )
}}

select
    p.product_name,
    sum(f.quantity * f.price_unit) as total_sales
from {{ ref('fct_sales') }} f
join {{ ref('dim_product') }} p
    on f.product_key = p.product_key
group by 1
