-- 03_import_csv.sql
-- Create the temporary landing table for CSV import.

CREATE TABLE IF NOT EXISTS raw.import_purchase_orders (
    source_row_id_raw VARCHAR,
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
    invoice_processed_raw TEXT
);

-- Import procurement_purchase_orders.csv into this table
-- using pgAdmin's Import/Export Data interface.
--
-- Format: CSV
-- Header: Yes
-- Encoding: UTF-8