-- 11_lead_time_analysis.sql
-- Business question:
-- How do planned procurement lead times vary by mine?
-- Lead time = PO due date - PO creation date.
-- This is NOT actual supplier delivery time.

SELECT
    mine,
    COUNT(*) AS total_valid_orders,
    ROUND(AVG(lead_time_days), 2) AS avg_lead_time_days,
    MIN(lead_time_days) AS shortest_lead_time_days,
    MAX(lead_time_days) AS longest_lead_time_days,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY lead_time_days)::NUMERIC,
        2
    ) AS median_lead_time_days
FROM staging.purchase_orders
WHERE lead_time_days >= 0
GROUP BY mine
ORDER BY avg_lead_time_days DESC;