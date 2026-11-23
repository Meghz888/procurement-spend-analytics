-- 02_create_raw_tables.sql
-- Permanent raw table for imported purchase order records.
-- Original source fields are preserved as TEXT.

CREATE TABLE IF NOT EXISTS raw.purchase_orders_raw (
    ingest_id BIGSERIAL PRIMARY KEY,
    source_row_id_raw TEXT,
    shifted_row_id_raw TEXT,
    po_date_raw TEXT,
    due_date_raw TEXT,
    vendor_raw TEXT,
    currency_raw TEXT,
    mine_raw TEXT,
    buyer_raw TEXT,
    document_total_raw TEXT,
    po_number_raw TEXT,
    cod_ll_ke_raw TEXT,
    invoice_processed_raw TEXT,
    source_file_name TEXT NOT NULL,
    import_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_purchase_orders_source_row
ON raw.purchase_orders_raw (source_file_name, source_row_id_raw);