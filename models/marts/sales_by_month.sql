{{
    config(
        materialized='table',
        schema='REPORTING'
    )
}}

select
    d.YEAR_NUMBER,
    d.MONTH_NAME,
    sum(f.quantity * f.price_unit) as total_sales
from {{ ref('fct_sales') }} f
join {{ ref('dim_time') }} d
    on f.date_key = d.date_key
group by 1,2

