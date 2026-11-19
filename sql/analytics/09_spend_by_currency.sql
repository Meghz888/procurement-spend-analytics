-- 09_spend_by_currency.sql
-- Business question:
-- How much USD-equivalent PO value originates from each original transaction currency?

SELECT
    currency AS original_currency,
    COUNT(*) AS total_purchase_orders,
    ROUND(SUM(document_total_usd), 2) AS total_po_value_usd,
    ROUND(
        100.0 * COUNT(*) /
        NULLIF((SELECT COUNT(*) FROM staging.purchase_orders), 0),
        2
    ) AS percentage_of_orders,
    ROUND(
        100.0 * SUM(document_total_usd) /
        NULLIF(
            (SELECT SUM(document_total_usd)
             FROM staging.purchase_orders), 0
        ),
        2
    ) AS percentage_of_total_po_value
FROM staging.purchase_orders
GROUP BY currency
ORDER BY total_po_value_usd DESC;