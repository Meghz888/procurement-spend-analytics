-- 07_spend_by_mine.sql
-- Total USD-equivalent purchase order value by mine

SELECT
    mine,
    COUNT(*) AS total_purchase_orders,
    SUM(document_total_usd) AS total_po_value_usd,
    ROUND(AVG(document_total_usd), 2) AS average_po_value_usd
FROM staging.purchase_orders
GROUP BY mine
ORDER BY total_po_value_usd DESC;