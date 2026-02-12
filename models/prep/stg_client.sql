-- models/prep/stg_client.sql

{{
    config(
        alias='stg_client',
        materialized='table'
    )
}}

with source as (

    select * 
    from {{ source('ecommerce_raw', 'client') }}

),

transformed as (

    select
        cast(client_id as integer)                as client_id,
        trim(client_name)                         as client_name,
        lower(trim(email))                        as email,
        trim(phone_number)                        as phone_number,
        trim(address)                             as address,
        cast(type_id as integer)                  as client_type_id,
        cast(status_id as integer)                as client_status_id,
        cast(registration_date as date)           as registration_date
    from source

)

select *
from transformed
