-- models/marts/dim_client.sql

{{ 
    config(
        alias='dim_client',
        materialized='table',
        schema='STAR_SCHEMA'
    ) 
}}

with source as (

    select *
    from {{ ref('stg_client') }}

)

select
    {{ dbt_utils.generate_surrogate_key(['client_id']) }} as client_key,
    client_id,
    {{ data_anonymization('email') }} as email_hash,
    client_status_id,
    registration_date

from source
