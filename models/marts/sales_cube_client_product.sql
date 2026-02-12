{{
    config(
        materialized='table',
        schema='REPORTING'
    )
}}

select
    c.client_key,
    p.product_name,
    sum(f.quantity * f.price_unit) as total_sales
from {{ ref('fct_sales') }} f
join {{ ref('dim_client') }} c
    on f.client_key = c.client_key
join {{ ref('dim_product') }} p
    on f.product_key = p.product_key
group by cube(c.client_key, p.product_name)
