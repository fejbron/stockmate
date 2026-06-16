# Barcode Alias Inventory Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a functional flow for linking multiple barcodes to one inventory product and adding stock through that link.

**Architecture:** Build on the existing `product_codes` alias table. Add repository methods for listing, linking, and removing codes; add a scan-driven link screen; extend product edit with barcode management; keep checkout lookup unchanged because it already searches `product_codes`.

**Tech Stack:** Flutter, Riverpod, Drift, SQLite, Flutter widget tests.

---

### Task 1: Repository Alias Operations

**Files:**
- Modify: `lib/src/inventory/inventory_repository.dart`
- Test: `test/inventory/inventory_repository_test.dart`

- [ ] Add failing tests for linking a barcode to an existing product with stock, rejecting duplicate barcodes, listing product codes, and deleting secondary codes.
- [ ] Run `flutter test test/inventory/inventory_repository_test.dart` and confirm the new tests fail because methods are missing.
- [ ] Implement `ProductCodeItem`, `ProductLookupItem`, `watchProductCodes`, `watchActiveProductLookup`, `linkCodeToExistingProduct`, and `deleteProductCode`.
- [ ] Run `flutter test test/inventory/inventory_repository_test.dart` and confirm all tests pass.

### Task 2: Link Existing Product Flow

**Files:**
- Create: `lib/src/inventory/link_barcode_screen.dart`
- Modify: `lib/src/scanner/scanner_screen.dart`
- Test: `test/scanner/scanner_screen_test.dart`

- [ ] Add a failing widget test that an unknown scanned code shows `Link to Existing Product`.
- [ ] Add the link screen with product dropdown, quantity field, cost field, validation, and save button.
- [ ] Wire scanner unknown-code actions to open `ProductFormScreen(initialCode: code)` or `LinkBarcodeScreen(codeValue: code)`.
- [ ] Run scanner tests and confirm they pass.

### Task 3: Product Edit Barcode Management

**Files:**
- Modify: `lib/src/inventory/product_form_screen.dart`
- Test: `test/inventory/product_form_screen_test.dart`

- [ ] Add a failing widget test that edit mode shows linked barcodes and can add a secondary barcode.
- [ ] Add a barcode aliases card in edit mode with existing codes, add-code field, and delete action for secondary codes.
- [ ] Run product form tests and confirm they pass.

### Task 4: Verification And Commit

**Files:**
- All touched files.

- [ ] Run `dart format` on touched Dart files.
- [ ] Run focused tests for inventory and scanner.
- [ ] Run `flutter test`.
- [ ] Run `flutter analyze`.
- [ ] Run `flutter run -d 00008130-001A5959369A001C --release --no-resident`.
- [ ] Commit code changes without staging unrelated `ios/Runner.xcodeproj/project.pbxproj`.
