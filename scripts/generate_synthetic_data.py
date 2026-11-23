
import csv
import random
from datetime import date, timedelta
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path

# Reproducible synthetic data: no original SAP records are used.
rng = random.Random(2026)

NUMBER_OF_ORDERS = 14500
NUMBER_OF_SUPPLIERS = 350

OUTPUT_FILE = (
    Path(__file__).resolve().parent.parent
    / "data"
    / "synthetic_purchase_orders.csv"
)

MINES = ["Mine Alpha", "Mine Beta", "Mine Gamma"]
CURRENCIES = ["USD", "ZAR", "EUR", "GBP", "AUD", "CAD"]
BUYERS = [f"Buyer {i:02d}" for i in range(1, 16)]
SUPPLIERS = [
    f"Vendor {i:03d}"
    for i in range(1, NUMBER_OF_SUPPLIERS + 1)
]

HEADERS = [
    "source_row_id_raw",
    "shifted_row_id_raw",
    "po_date_raw",
    "due_date_raw",
    "vendor_raw",
    "currency_raw",
    "mine_raw",
    "buyer_raw",
    "document_total_raw",
    "po_number_raw",
    "cod_ll_ke_raw",
    "invoice_processed_raw",
]

# Some suppliers receive more orders than others.
# This creates realistic supplier concentration.
supplier_weights = [
    25 if i < 15 else
    10 if i < 65 else
    3 if i < 180 else
    1
    for i in range(NUMBER_OF_SUPPLIERS)
]

start_date = date(2022, 1, 1)
end_date = date(2025, 12, 31)
date_range = (end_date - start_date).days

rows = []

for i in range(1, NUMBER_OF_ORDERS + 1):
    po_date = start_date + timedelta(
        days=rng.randint(0, date_range)
    )

    vendor = rng.choices(
        SUPPLIERS,
        weights=supplier_weights,
        k=1
    )[0]

    mine = rng.choices(
        MINES,
        weights=[45, 35, 20],
        k=1
    )[0]

    currency = rng.choices(
        CURRENCIES,
        weights=[45, 40, 7, 4, 3, 1],
        k=1
    )[0]

    # Artificial USD-equivalent PO amount.
    # Supplier-specific factors create spend concentration.
    supplier_number = int(vendor.split()[1])
    supplier_factor = (
        4.0 if supplier_number <= 15 else
        2.0 if supplier_number <= 65 else
        1.0
    )

    amount = (
        rng.lognormvariate(8.7, 1.25)
        * supplier_factor
    )

    amount = min(amount, 2_500_000)

    amount_usd = Decimal(str(amount)).quantize(
        Decimal("0.01"),
        rounding=ROUND_HALF_UP
    )

    # Planned lead time; some invalid dates for quality checks.
    lead_time = rng.randint(7, 75)

    if rng.random() < 0.006:
        lead_time = -rng.randint(1, 15)

    due_date = po_date + timedelta(days=lead_time)

    rows.append([
        i,
        i + 100000,
        po_date.isoformat(),
        due_date.isoformat(),
        vendor,
        currency,
        mine,
        rng.choice(BUYERS),
        str(amount_usd),
        f"SYN-PO-{i:06d}",
        rng.choice(["Yes", "No"]),
        rng.choice(["Yes", "No"]),
    ])

OUTPUT_FILE.parent.mkdir(parents=True, exist_ok=True)

with OUTPUT_FILE.open(
    "w", newline="", encoding="utf-8"
) as file:
    writer = csv.writer(file)
    writer.writerow(HEADERS)
    writer.writerows(rows)

print("Synthetic dataset generated successfully!")
print(f"Purchase orders: {len(rows):,}")
print(f"Suppliers available: {NUMBER_OF_SUPPLIERS}")
print(f"Output: {OUTPUT_FILE}")
