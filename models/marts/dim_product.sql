{{
    config(
        alias='dim_product',
        materialized='table',
        tags=['star_schema']
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_key,
    product_id,
    product_name,
    category,
    price
from {{ ref('stg_product') }}
