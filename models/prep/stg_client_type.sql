-- models/prep/stg_client_type.sql

{{
    config(
        alias='stg_client_type',
        materialized='table'
    )
}}

with source as (
    select * from {{ source('ecommerce_raw', 'client_type') }}
)

select
    cast(client_type_id as integer) as client_type_id,
    trim(type_name) as type_name
from source
