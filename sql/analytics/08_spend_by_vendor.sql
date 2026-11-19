-- 08_spend_by_vendor.sql
-- Business question:
-- Which suppliers account for the highest USD PO value?

SELECT
    vendor,
    COUNT(*) AS total_purchase_orders,
    ROUND(SUM(document_total_usd), 2) AS total_po_value_usd,
    ROUND(AVG(document_total_usd), 2) AS average_po_value_usd
FROM staging.purchase_orders
WHERE vendor IS NOT NULL
  AND TRIM(vendor) <> ''
GROUP BY vendor
ORDER BY total_po_value_usd DESC;