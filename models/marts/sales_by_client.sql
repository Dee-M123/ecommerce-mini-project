{{
    config(
        materialized='table',
        schema='REPORTING'
    )
}}

select
    c.client_key,
    sum(f.quantity * f.price_unit) as total_sales
from {{ ref('fct_sales') }} f
join {{ ref('dim_client') }} c
    on f.client_key = c.client_key
group by 1

