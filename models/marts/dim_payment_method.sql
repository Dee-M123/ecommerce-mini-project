{{
    config(
        alias='dim_payment_method',
        materialized='table',
        tags=['star_schema']
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['payment_id']) }} as payment_key,
    payment_id,
    payment_method
from {{ ref('stg_payment_method') }}
