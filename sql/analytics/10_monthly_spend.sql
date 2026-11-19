-- 10_monthly_spend.sql
-- Business question:
-- How did purchase order value and volume change each month?

SELECT
    DATE_TRUNC('month', po_date)::DATE AS po_month,
    COUNT(*) AS total_purchase_orders,
    ROUND(SUM(document_total_usd), 2) AS total_po_value_usd,
    ROUND(AVG(document_total_usd), 2) AS average_po_value_usd

FROM staging.purchase_orders

WHERE po_date IS NOT NULL

GROUP BY DATE_TRUNC('month', po_date)

ORDER BY po_month;