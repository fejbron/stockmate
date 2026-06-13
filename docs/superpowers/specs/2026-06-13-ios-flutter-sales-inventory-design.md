# iOS Flutter Sales Inventory App Design

## Overview

Build a single-device, local-first iOS Flutter app for a shop owner to track products, stock, sales, revenue, gross profit, discounts, and receipts. The app works offline and stores all business data on the iPhone. It scans existing product barcodes or QR codes when available and generates internal codes for products without labels.

## Goals

- Add products to inventory by scanning an existing product code or generating an internal product code.
- Record stock batches with quantity, cost per unit, received date, and remaining quantity.
- Sell products through a checkout flow that scans or searches products, applies discounts, records payment details, generates receipts, and reduces stock.
- Calculate revenue and gross profit using the actual stock batch cost consumed by each sale.
- Support simple inventory adjustments for damage, loss, returns, or count corrections.
- Provide dashboard and report views for sales, revenue, gross profit, low stock, top products, and stock value.

## Non-Goals for v1

- Multi-device sync.
- Staff accounts, roles, or permissions.
- Multi-branch inventory.
- Tax calculation.
- Cloud backup, cloud restore, or backend APIs.
- Supplier management, purchase orders, or full accounting.
- Refunds and exchanges beyond simple stock adjustments.

## Architecture

The app is a Flutter iOS application with local SQLite persistence. It does not require user login or internet access. The data layer uses Drift for typed SQLite tables, migrations, queries, and transactions. The UI state and business workflows use Riverpod. Routing uses GoRouter with a tabbed shell and detail routes.

The core architecture has these layers:

- Presentation: Flutter screens and widgets for dashboard, inventory, scanner, checkout, sales, receipts, reports, and settings.
- Application: Riverpod providers and use cases for add-stock, complete-sale, adjust-stock, generate-receipt, and report queries.
- Data: Drift database, DAOs, migrations, and repository implementations.
- Platform integrations: camera scanning, PDF receipt generation, iOS print/share sheet, and generated barcode/QR rendering.

## Main App Areas

### Dashboard

Shows today’s revenue, gross profit, sales count, low-stock products, and quick actions for scan, add stock, and checkout.

### Inventory

Shows products, search/filter tools, product detail, code aliases, stock batches, current stock, selling price, low-stock threshold, and simple stock adjustments.

### Scan

Provides a shared scanner entry point. A scanned code can:

- Open an existing product.
- Add stock to an existing product.
- Add an item to the checkout cart.
- Start a new product flow when no matching code exists.

### Sales

Provides checkout, receipt generation, receipt history, and sale detail. The checkout flow supports item quantity changes, item-level or order-level discounts, payment method, amount paid, and receipt sharing/printing.

### Reports

Shows date-filtered revenue, gross profit, sales count, average sale value, top-selling products, low-stock products, and stock value.

## Data Model

### Product

Represents an item sold by the shop.

Fields:

- id
- name
- description
- category
- selling_price
- low_stock_threshold
- is_active
- created_at
- updated_at

### ProductCode

Represents a scan code that identifies a product. A product can have multiple codes so manufacturer codes and internal generated codes can both point to the same product.

Fields:

- id
- product_id
- code_value
- code_type: barcode, qr, internal
- source: manufacturer, generated, manual
- is_primary
- created_at

Rules:

- code_value must be unique.
- duplicate scans show the linked product.
- reassigning a code requires deliberate confirmation.

### StockBatch

Represents stock received at a specific cost.

Fields:

- id
- product_id
- quantity_received
- quantity_remaining
- cost_per_unit
- received_at
- note
- created_at

Rules:

- quantity_remaining cannot go below zero.
- sales consume oldest available batches first.
- gross profit uses the actual cost from consumed batches.

### StockAdjustment

Represents a manual stock correction.

Fields:

- id
- product_id
- adjustment_quantity
- reason: damage, loss, return, recount, other
- note
- created_at

Rules:

- negative adjustments cannot reduce stock below zero.
- simple adjustments are included in stock history but do not create full audit-grade accounting.

### Sale

Represents a completed checkout.

Fields:

- id
- receipt_number
- sold_at
- subtotal
- discount_total
- total
- cost_total
- gross_profit
- payment_method
- amount_paid
- change_due
- note
- created_at

Rules:

- total equals subtotal minus discounts.
- gross_profit equals total minus cost_total.
- sale completion is atomic: sale, lines, batch consumption, payment, receipt record, and stock updates all succeed or all roll back.

### SaleLine

Represents one product line in a sale.

Fields:

- id
- sale_id
- product_id
- quantity
- unit_price
- discount_amount
- line_total
- cost_total
- gross_profit

### SaleLineBatchAllocation

Records which stock batches were consumed by a sale line.

Fields:

- id
- sale_line_id
- stock_batch_id
- quantity
- cost_per_unit
- cost_total

This makes profit reports stable even if product costs change later.

### Receipt

Represents a generated receipt.

Fields:

- id
- sale_id
- receipt_number
- pdf_path
- created_at
- last_shared_at
- last_printed_at

Rules:

- if receipt sharing or printing fails, the sale stays saved.
- receipt sharing and printing can be retried from receipt history.

## Core Workflows

### Add Product and Stock

1. User scans a manufacturer code or taps generate internal code.
2. App searches ProductCode by code_value.
3. If found, app opens the linked product.
4. If not found, app offers to create a product or attach the code to an existing product.
5. User enters product name, selling price, optional category, quantity received, cost per unit, received date, and low-stock threshold.
6. App saves Product, ProductCode, and StockBatch in one transaction.
7. App shows updated stock.

### Generate Internal Code

1. User creates a product without an existing product code.
2. App generates a unique internal code using a stable prefix such as `INT-` plus a local sequence or UUID segment.
3. App renders the code as a QR code or Code 128 barcode.
4. User can view, share, or print the label.
5. The generated code resolves to the product during future scans.

### Complete Sale

1. User scans or searches products into the cart.
2. User adjusts quantities and applies optional item or order discount.
3. App validates available stock for every cart line.
4. User selects payment method and enters amount paid if needed.
5. App creates the sale in one transaction.
6. For each sale line, app consumes stock batches using oldest-first allocation.
7. App records sale lines, batch allocations, totals, cost_total, gross_profit, payment, and receipt metadata.
8. App generates a receipt PDF and offers share/print.
9. Dashboard, inventory, sales history, and reports reflect the updated numbers.

### Simple Stock Adjustment

1. User opens a product and chooses adjust stock.
2. User enters increase or decrease quantity, reason, and optional note.
3. App blocks negative adjustments that exceed available stock.
4. App records the adjustment and updates available stock.

## Error Handling

- Unknown scan: offer create product, attach to existing product, or cancel.
- Duplicate code: show linked product and block accidental overwrite.
- Insufficient stock: block sale completion and show available quantity.
- Camera permission denied: offer manual search or manual code entry.
- Receipt generation failure: keep the sale saved and mark receipt as retryable.
- Print/share failure: keep receipt record and allow retry from receipt history.
- Database transaction failure: show a clear failure message and leave stock/sale data unchanged.

## Reporting Rules

- Revenue is the sum of completed sale totals after discounts.
- Gross profit is sale total minus the cost of allocated stock batches.
- Stock value is current quantity remaining multiplied by each batch cost per unit.
- Low stock is current product stock less than or equal to the product’s low_stock_threshold.
- Reports can filter by date range.

## Technology Choices

- Flutter for the iOS app.
- Drift for typed SQLite persistence, migrations, queries, and transactions.
- Riverpod for testable state management and business workflow providers.
- GoRouter for tabbed navigation and detail routes.
- mobile_scanner for camera-based barcode and QR scanning on iOS.
- barcode_widget for generated barcode/QR label rendering.
- pdf and printing for receipt PDF creation, preview, share, and iOS printing.

## Testing Strategy

### Unit Tests

Cover:

- FIFO stock batch allocation.
- gross profit calculation.
- discount calculation.
- stock adjustment validation.
- generated internal code uniqueness.
- receipt total calculation.

### Repository Tests

Cover:

- Drift migrations.
- product and code alias uniqueness.
- add-stock transaction.
- complete-sale transaction.
- rollback when stock is insufficient.
- reports after app restart.

### Widget Tests

Cover:

- product creation form validation.
- unknown scan decision screen.
- checkout cart editing.
- insufficient stock message.
- adjustment form.
- receipt history retry action.

### Integration Smoke Test

Run one end-to-end flow:

1. Create a product with generated internal code.
2. Add a stock batch with quantity and cost per unit.
3. Complete a sale with a discount.
4. Restart the app.
5. Verify reduced stock, sale history, receipt history, revenue, and gross profit.

## Release Quality Bar

The v1 build is ready when a shop owner can add stock, scan or search a product into checkout, complete a discounted sale, generate a receipt, and see stock, revenue, gross profit, low-stock status, and reports stay correct after app restart.

## Follow-Up Ideas After v1

- Local export and restore.
- iCloud or cloud backup.
- Multi-device sync.
- Staff accounts and permissions.
- Tax rules.
- Refunds and exchanges.
- Supplier and purchase-order tracking.
- Bluetooth receipt printer support beyond standard iOS printing.
