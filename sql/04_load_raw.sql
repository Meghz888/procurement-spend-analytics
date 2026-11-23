-- 04_load_raw.sql
-- Transfer imported CSV records into the permanent raw table.
-- Execute only once per imported file to avoid duplicate records.

INSERT INTO raw.purchase_orders_raw (
    source_row_id_raw,
    shifted_row_id_raw,
    po_date_raw,
    due_date_raw,
    vendor_raw,
    currency_raw,
    mine_raw,
    buyer_raw,
    document_total_raw,
    po_number_raw,
    cod_ll_ke_raw,
    invoice_processed_raw,
    source_file_name
)
SELECT
    source_row_id_raw,
    shifted_row_id_raw,
    po_date_raw,
    due_date_raw,
    vendor_raw,
    currency_raw,
    mine_raw,
    buyer_raw,
    document_total_raw,
    po_number_raw,
    cod_ll_ke_raw,
    invoice_processed_raw,
    'synthetic_purchase_orders.csv'
FROM raw.import_purchase_orders
ON CONFLICT (source_file_name, source_row_id_raw) DO NOTHING;