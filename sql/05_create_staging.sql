-- 05_create_staging.sql
-- Transform raw purchase order data into an analysis-ready table.
-- document_total_raw already contains USD-equivalent values.

DROP TABLE IF EXISTS staging.purchase_orders;

CREATE TABLE staging.purchase_orders AS
SELECT
    ingest_id,
    NULLIF(TRIM(source_row_id_raw), '')::INTEGER AS source_row_id,
NULLIF(TRIM(shifted_row_id_raw), '')::INTEGER AS shifted_row_id,

NULLIF(TRIM(po_date_raw), '')::DATE AS po_date,
NULLIF(TRIM(due_date_raw), '')::DATE AS due_date,

    (
    NULLIF(TRIM(due_date_raw), '')::DATE
    - NULLIF(TRIM(po_date_raw), '')::DATE
) AS lead_time_days,

CASE
    WHEN NULLIF(TRIM(po_date_raw), '') IS NULL
      OR NULLIF(TRIM(due_date_raw), '') IS NULL
        THEN 'Review Required'
    WHEN NULLIF(TRIM(due_date_raw), '')::DATE
       < NULLIF(TRIM(po_date_raw), '')::DATE
        THEN 'Review Required'
    ELSE 'Valid'
END AS lead_time_status,

    TRIM(vendor_raw) AS vendor,

    CASE
        WHEN UPPER(TRIM(currency_raw)) = 'BRITISH POUND'
            THEN 'GBP'
        WHEN UPPER(TRIM(currency_raw)) = 'CANADIAN DOLLERS'
            THEN 'CAD'
        WHEN UPPER(TRIM(currency_raw)) IN ('EURO', 'EUR')
            THEN 'EUR'
        ELSE UPPER(TRIM(currency_raw))
    END AS currency,

    TRIM(mine_raw) AS mine,
    TRIM(buyer_raw) AS buyer,

    NULLIF(TRIM(document_total_raw), '')::NUMERIC(18,2)
    AS document_total_usd,

    TRIM(po_number_raw) AS po_number,
    TRIM(cod_ll_ke_raw) AS cod_ll_ke,
    TRIM(invoice_processed_raw) AS invoice_processed,

    source_file_name,
    import_timestamp

FROM raw.purchase_orders_raw;