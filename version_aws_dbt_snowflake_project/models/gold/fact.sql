{{ config(
    materialized='table',
    schema='gold'
) }}

{% set configs = [
    {
        "table" : "AIRBNB.GOLD.OBT",
        "columns" : "GOLD_obt.BOOKING_ID,GOLD_obt.LISTING_ID,GOLD_obt.HOST_ID,GOLD_obt.TOTAL_AMOUNT, GOLD_obt.SERVICE_FEE, GOLD_obt.CLEANING_FEE, GOLD_obt.ACCOMMODATES, GOLD_obt.BEDROOMS, GOLD_obt.BATHROOMS, GOLD_obt.PRICE_PER_NIGHT, GOLD_obt.RESPONSE_RATE",
        "alias" : "GOLD_obt"
    },
    {
        "table" : "AIRBNB.GOLD.DIM_LISTINGS",
        "columns" : "", 
        "alias" : "DIM_listings",
        "join_condition" : "GOLD_obt.LISTING_ID = DIM_listings.LISTING_ID AND DIM_listings.dbt_valid_to = '9999-12-31'"
    },
    {
        "table" : "AIRBNB.GOLD.DIM_HOSTS",
        "columns" : "",
        "alias" : "DIM_hosts",
        "join_condition" : "GOLD_obt.HOST_ID = DIM_hosts.HOST_ID AND DIM_hosts.dbt_valid_to = '9999-12-31'"
    }
] %}

SELECT DISTINCT  -- Adding DISTINCT here eliminates all identical rows
    {{ configs[0]['columns']}}
        
FROM
    {% for config in configs %}
        {% if loop.first %}
            {{ config['table'] }} AS {{ config['alias'] }}
        {% else %}
            LEFT JOIN {{ config['table'] }} AS {{ config['alias'] }}
            ON {{ config['join_condition'] }}
        {% endif %}
    {% endfor %}