
-- 12_supplier_pareto_analysis.sql
-- Supplier spend concentration using synthetic PO data.
-- Rank suppliers and calculate cumulative spend share.

WITH supplier_spend AS (
    SELECT
        vendor,
        SUM(document_total_usd) AS supplier_spend_usd
    FROM staging.purchase_orders
    GROUP BY vendor
),
ranked_suppliers AS (
    SELECT
        vendor,
        supplier_spend_usd,
        ROW_NUMBER() OVER (
            ORDER BY supplier_spend_usd DESC, vendor
        ) AS supplier_rank,
        SUM(supplier_spend_usd) OVER (
            ORDER BY supplier_spend_usd DESC, vendor
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_spend_usd,
        SUM(supplier_spend_usd) OVER () AS total_spend_usd,
        COUNT(*) OVER () AS total_suppliers
    FROM supplier_spend
)
SELECT
    supplier_rank,
    vendor,
    ROUND(supplier_spend_usd, 2) AS supplier_spend_usd,
    ROUND(
        100.0 * supplier_spend_usd
        / NULLIF(total_spend_usd, 0), 2
    ) AS individual_spend_pct,
    ROUND(
        100.0 * cumulative_spend_usd
        / NULLIF(total_spend_usd, 0), 2
    ) AS cumulative_spend_pct,
    ROUND(
        100.0 * supplier_rank
        / NULLIF(total_suppliers, 0), 2
    ) AS cumulative_suppliers_pct
FROM ranked_suppliers
ORDER BY supplier_rank;
