-- Write a SQL query to assign each user's purchase to the first campaign event (by event_timestamp) that the user had before or at their purchase time.
-- The result should include: user_id, conversion_event_id, conversion_time, first_touch_campaign_id.
-- Only include users who made a purchase.
SELECT
    e.user_id,
    e.event_id AS conversion_event_id,
    e.event_timestamp AS conversion_time,
    (
        SELECT e2.campaign_id
        FROM events e2
        WHERE e2.user_id = e.user_id
            AND e2.event_timestamp <= e.event_timestamp
            AND e2.campaign_id IS NOT NULL
        ORDER BY e2.event_timestamp ASC
        LIMIT 1
    ) AS first_touch_campaign_id
FROM events e
WHERE e.event_type = 'purchase';