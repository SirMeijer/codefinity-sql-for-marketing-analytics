-- Write a SQL query to calculate, for each campaign:
--  - total number of impressions
--  - total number of clicks
--  - total number of purchases
--  - conversion rate as (number of purchases / number of impressions) * 100, rounded to 2 decimal places
-- Output columns: campaign_id, campaign_name, impressions, clicks, purchases, conversion_rate_percent
SELECT 
    c.campaign_id,
    c.campaign_name,
    COUNT(CASE WHEN event_type = 'impression' THEN 1 END) AS impressions,
    COUNT(CASE WHEN event_type = 'click' THEN 1 END) AS clicks,
    COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS purchases,
    ROUND(
        COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) * 100
        / NULLIF(COUNT(CASE WHEN event_type = 'impression' THEN 1 END), 0), 2
    ) AS conversion_rate_percent
FROM campaigns c
LEFT JOIN events e ON c.campaign_id = e.campaign_id
GROUP BY c.campaign_id, c.campaign_name
ORDER BY c.campaign_id, c.campaign_name;