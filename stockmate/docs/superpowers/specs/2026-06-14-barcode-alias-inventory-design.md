# Barcode Alias Inventory Design

## Goal

Allow multiple barcodes to identify the same product so scanning a different package barcode for the same item can add stock to the existing product instead of creating duplicates.

## Behavior

When a scanned code already exists, the app finds the linked product and continues with the current scan result/sale behavior.

When a scanned code is unknown, the scan result offers two choices:
- Create a new product with the scanned code.
- Link the scanned code to an existing product.

The link flow lets the user search/select an active product, enter quantity and cost, then saves the scanned code as a barcode alias for that product and adds the stock batch to that same product.

The edit product screen shows all linked barcodes. Users can scan/type another barcode for that product and remove incorrect secondary codes. The primary code remains protected so every product keeps at least one identifier.

## Data Model

Use the existing `product_codes` table. Each barcode row points to one product and `code_value` stays globally unique. No schema change is required for alias support.

Stock remains stored in `stock_batches`, keyed by product. Linking a barcode and adding stock are performed in one repository transaction.

## Error Handling

If a code is already linked to any product, show a friendly error and do not duplicate it.

If the selected product is inactive or missing, show an error and do not add stock.

If quantity or cost is invalid, the form validation blocks saving.

## Testing

Repository tests cover linking a new barcode to an existing product, preventing duplicate code links, adding a stock batch during linking, and removing secondary codes while protecting the primary code.

Widget tests cover the unknown-scan link action and product edit barcode list affordances.
