{{ config(
    materialized='incremental',
    unique_key='HOST_ID'
) }}

{% set incremental_flag = 1 %}
{% set incremental_col = 'CREATED_AT' %}

SELECT * FROM {{ source('staging', 'hosts') }}
{% if incremental_flag == 1 and is_incremental() %}
    WHERE {{ incremental_col }} > (SELECT COALESCE(MAX({{ incremental_col }}), '1900-01-01') FROM {{ this }})
{% endif %}