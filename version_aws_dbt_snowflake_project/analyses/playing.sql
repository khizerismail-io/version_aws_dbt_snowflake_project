{% set nights_booked = 1 %}

SELECT * FROM {{ ref('bronze_bookings') }}
WHERE NIGHTS_BOOKED > {{ nights_booked }}