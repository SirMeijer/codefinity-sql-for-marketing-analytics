-- Write a query to calculate the monthly retention rate for each signup cohort.
-- Your result should include these columns:
--   cohort_month (start of signup month),
--   month_number (0 for signup month, 1 for the next month, etc),
--   users_active (distinct users active in that month),
--   cohort_size (total users in that cohort),
--   retention_rate_percent (percentage of users_active out of cohort_size, rounded to 1 decimal)

-- Do not include any comments or print statements in your query.
WITH cohort_activity AS (
    SELECT
        u.user_id,
        DATE_TRUNC('month', u.signup_date) AS cohort_month,
        DATE_TRUNC('month', e.event_timestamp) AS activity_month,
        EXTRACT(MONTH FROM e.event_timestamp) - EXTRACT(MONTH FROM u.signup_date) AS month_number
    FROM users u
    JOIN events e ON u.user_id = e.user_id
    WHERE e.event_timestamp >= u.signup_date
),
cohort_sizes AS (
    SELECT
        DATE_TRUNC('month', signup_date) AS cohort_month,
        COUNT(DISTINCT user_id) AS cohort_size
    FROM users
    GROUP BY cohort_month
)
SELECT 
    ca.cohort_month,
    ca.month_number,
    COUNT(DISTINCT ca.user_id) AS users_active,
    cs.cohort_size,
    ROUND(100.0 * COUNT(DISTINCT ca.user_id) / cs.cohort_size, 1) AS retention_rate_percent
FROM cohort_activity ca
JOIN cohort_sizes cs ON ca.cohort_month = cs. cohort_month
GROUP BY ca.cohort_month, ca.month_number, cs.cohort_size
ORDER BY ca.cohort_month, ca.month_number