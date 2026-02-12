{{
    config(
        materialized='table',
        schema='REPORTING'
    )
}}

select
    p.product_name,
    d.YEAR_NUMBER,
    d.MONTH_NAME,
    sum(f.quantity * f.price_unit) as total_sales
from {{ ref('fct_sales') }} f
join {{ ref('dim_product') }} p
    on f.product_key = p.product_key
join {{ ref('dim_time') }} d
    on f.date_key = d.date_key
group by cube(p.product_name, d.YEAR_NUMBER, d.MONTH_NAME)
