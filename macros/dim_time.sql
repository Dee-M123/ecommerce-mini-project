{% macro generate_dates_dimension(start_date) %}

WITH dates AS (
    SELECT 
        DATEADD(day, SEQ4(), '{{ start_date }}'::DATE) AS date
    FROM TABLE(GENERATOR(ROWCOUNT => 10000))
),

dates_final AS (
    SELECT 
        date AS calendar_date,
        EXTRACT(DAYOFWEEK FROM date) AS day_of_week,
        TO_CHAR(date, 'DY') AS day_name_short,
        TO_CHAR(date, 'MMMM') AS month_name,
        EXTRACT(DAY FROM date) AS day_of_month,
        EXTRACT(MONTH FROM date) AS month_number,
        EXTRACT(QUARTER FROM date) AS quarter_number,
        CONCAT('Q', EXTRACT(QUARTER FROM date)) AS quarter_name,
        EXTRACT(YEAR FROM date) AS year_number,
        DATE_TRUNC('WEEK', date) AS week_start_date,
        CASE 
            WHEN EXTRACT(DAYOFWEEK FROM date) IN (6,7) THEN TRUE
            ELSE FALSE
        END AS is_weekend
    FROM dates
    WHERE date <= DATEADD(MONTH, 12, CURRENT_DATE())
)

SELECT
    ROW_NUMBER() OVER (ORDER BY calendar_date) AS date_key,
    *
FROM dates_final

{% endmacro %}
