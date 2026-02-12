{{
    config(
        alias='dim_client_status',
        materialized='table',
        tags=['star_schema']
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['client_status_id']) }} as client_status_key,
    client_status_id,
    status_name
from {{ ref('stg_client_status') }}
