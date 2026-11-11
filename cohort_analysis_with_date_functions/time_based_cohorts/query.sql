-- Write a SQL query to analyze user activity in weekly cohort windows after signup.
-- For each user, calculate the number of events performed in each week since signup.
-- Group the result by user_id, signup_date, and week_number (where week 0 = days 0-6, week 1 = days 7-13, etc.).
-- Output columns: user_id, signup_date, week_number, events_in_week
SELECT
    e.user_id, 
    u.signup_date, 
    --EXTRACT(WEEK FROM e.event_timestamp) - EXTRACT(WEEK FROM u.signup_date) AS week_number, 
    FLOOR((e.event_timestamp::date - u.signup_date::date) / 7) AS week_number,
    COUNT(*) AS events_in_week
FROM events e
JOIN users u ON e.user_id = u.user_id
WHERE e.event_timestamp::date >= u.signup_date::date
GROUP BY e.user_id, u.signup_date, week_number
ORDER BY e.user_id, week_number;