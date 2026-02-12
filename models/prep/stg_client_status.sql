-- models/prep/stg_client_status.sql
{{
    config(
        alias='stg_client_status',
        materialized='table'
    )
}}

with source as (
    select * from {{ source('ecommerce_raw', 'client_status') }}
)

select
    cast(client_status_id as integer) as client_status_id,
    trim(status_name) as status_name
from source
