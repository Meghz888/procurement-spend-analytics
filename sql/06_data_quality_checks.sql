-- 06_data_quality_checks.sql
-- Check negative planned lead times

SELECT
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (
        WHERE lead_time_days < 0
    ) AS negative_lead_time_orders,
    COUNT(*) FILTER (
        WHERE lead_time_days IS NULL
    ) AS missing_lead_time_orders,
    COUNT(*) FILTER (
        WHERE lead_time_days >= 0
    ) AS valid_lead_time_orders
FROM staging.purchase_orders;

-- Verify record counts across pipeline layers

SELECT
    (SELECT COUNT(*) FROM raw.import_purchase_orders)
        AS imported_records,
    (SELECT COUNT(*) FROM raw.purchase_orders_raw)
        AS raw_records,
    (SELECT COUNT(*) FROM staging.purchase_orders)
        AS staging_records;

-- Check that each PO number occurs only once
SELECT
    po_number,
    COUNT(*) AS record_count
FROM staging.purchase_orders
WHERE po_number IS NOT NULL
  AND po_number <> ''
GROUP BY po_number
HAVING COUNT(*) > 1
ORDER BY record_count DESC, po_number;