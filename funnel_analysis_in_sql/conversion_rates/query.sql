-- Write a SQL query to calculate the conversion rates between each consecutive funnel step.
-- Your query should output the columns: from_step, to_step, from_users, to_users, conversion_rate_percent
-- conversion_rate_percent should be a percentage rounded to two decimal places.
WITH step_counts AS (
    SELECT
        fs.step_order,
        fs.event_type,
        COUNT(DISTINCT e.user_id) AS users_at_step
    FROM funnel_steps fs
    LEFT JOIN events e ON fs.event_type = e.event_type
    GROUP BY fs.step_order, fs.event_type
    ORDER BY fs.step_order
),
conversion_rates AS (
    SELECT
        s1.event_type AS from_step,
        s2.event_type AS to_step,
        s1.users_at_step AS from_users,
        s2.users_at_step AS to_users,
        ROUND(
            CASE WHEN s1.users_at_step > 0
                THEN (s2.users_at_step::decimal / s1.users_at_step) * 100
                ELSE 0 END, 2
        ) AS conversion_rate_percent
    FROM step_counts s1
    JOIN step_counts s2 ON s1.step_order + 1 = s2.step_order
)
SELECT * FROM conversion_rates