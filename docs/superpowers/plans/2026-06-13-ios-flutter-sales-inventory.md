# iOS Flutter Sales Inventory Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a local-first iOS Flutter app that tracks products, stock batches, sales, revenue, gross profit, discounts, receipts, and barcode/QR scanning on one iPhone.

**Architecture:** Create a Flutter app in `stockmate/` with feature folders and a Drift SQLite data layer. Business rules live in small use-case classes that are unit-tested before UI work; Riverpod wires repositories/use cases to screens; GoRouter provides a bottom-tab shell.

**Tech Stack:** Flutter 3.38.9, Dart 3.10.8, Drift, drift_flutter, Riverpod, GoRouter, mobile_scanner, barcode_widget, pdf, printing, Flutter unit/widget/integration tests.

---

## Source Spec

- `docs/superpowers/specs/2026-06-13-ios-flutter-sales-inventory-design.md`

## File Structure

Create the app under `stockmate/` so the repo can keep planning docs at the root.

- Create: `stockmate/pubspec.yaml` by running `flutter create`, then add dependencies.
- Modify: `stockmate/ios/Runner/Info.plist` for camera usage text.
- Modify: `stockmate/analysis_options.yaml` for stricter linting.
- Create: `stockmate/lib/main.dart` app bootstrap.
- Create: `stockmate/lib/src/app.dart` Material app with router.
- Create: `stockmate/lib/src/router/app_router.dart` GoRouter shell.
- Create: `stockmate/lib/src/shared/money.dart` integer-minor-unit money helpers.
- Create: `stockmate/lib/src/shared/result.dart` small result/error type for use cases.
- Create: `stockmate/lib/src/data/app_database.dart` Drift schema and database.
- Create: `stockmate/lib/src/data/database_provider.dart` Riverpod database provider.
- Create: `stockmate/lib/src/inventory/inventory_repository.dart` product, code, stock, adjustment queries.
- Create: `stockmate/lib/src/inventory/add_stock_use_case.dart` transactional add-product/add-stock workflow.
- Create: `stockmate/lib/src/inventory/stock_adjustment_use_case.dart` simple adjustment workflow.
- Create: `stockmate/lib/src/checkout/cart_models.dart` cart data classes.
- Create: `stockmate/lib/src/checkout/stock_allocator.dart` FIFO batch allocation logic.
- Create: `stockmate/lib/src/checkout/checkout_repository.dart` sale persistence queries.
- Create: `stockmate/lib/src/checkout/complete_sale_use_case.dart` atomic checkout workflow.
- Create: `stockmate/lib/src/scanner/scanner_screen.dart` camera scanner and manual code fallback.
- Create: `stockmate/lib/src/labels/internal_code_generator.dart` internal code generator.
- Create: `stockmate/lib/src/labels/label_screen.dart` generated barcode/QR label preview.
- Create: `stockmate/lib/src/receipts/receipt_pdf_builder.dart` PDF receipt generator.
- Create: `stockmate/lib/src/receipts/receipt_repository.dart` receipt metadata queries.
- Create: `stockmate/lib/src/dashboard/dashboard_screen.dart` dashboard view.
- Create: `stockmate/lib/src/inventory/inventory_screen.dart` inventory list.
- Create: `stockmate/lib/src/inventory/product_form_screen.dart` product/add-stock form.
- Create: `stockmate/lib/src/inventory/product_detail_screen.dart` product detail and adjustment entry.
- Create: `stockmate/lib/src/checkout/checkout_screen.dart` checkout cart.
- Create: `stockmate/lib/src/sales/sales_history_screen.dart` receipt/sale history.
- Create: `stockmate/lib/src/reports/reports_screen.dart` reports view.
- Create tests in `stockmate/test/` mirroring the feature folders.
- Create integration smoke test in `stockmate/integration_test/app_smoke_test.dart`.

## Task 1: Scaffold Flutter App

**Files:**
- Create: `stockmate/`
- Modify: `stockmate/pubspec.yaml`
- Modify: `stockmate/analysis_options.yaml`
- Modify: `stockmate/ios/Runner/Info.plist`
- Create: `stockmate/lib/main.dart`
- Create: `stockmate/lib/src/app.dart`
- Create: `stockmate/lib/src/router/app_router.dart`
- Create: `stockmate/lib/src/shared/money.dart`
- Create: `stockmate/lib/src/shared/result.dart`
- Test: `stockmate/test/app_bootstrap_test.dart`

- [ ] **Step 1: Create the Flutter app**

Run:

```bash
flutter create --platforms=ios --org com.stockmate stockmate
```

Expected: command creates `stockmate/ios`, `stockmate/lib/main.dart`, `stockmate/pubspec.yaml`, and `stockmate/test/widget_test.dart`.

- [ ] **Step 2: Add dependencies**

Run:

```bash
cd stockmate
flutter pub add drift:^2.34.0 drift_flutter:^0.3.0 flutter_riverpod:^3.3.2 go_router:^17.3.0 mobile_scanner:^7.2.0 barcode_widget:^2.0.4 pdf:^3.12.0 printing:^5.14.3 intl uuid collection
flutter pub add --dev drift_dev:^2.34.0 build_runner:^2.15.0
```

Expected: `pubspec.yaml` contains all dependencies and `flutter pub get` completes.

- [ ] **Step 3: Tighten analysis**

Replace `stockmate/analysis_options.yaml` with:

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    always_declare_return_types: true
    avoid_dynamic_calls: true
    prefer_final_locals: true
    require_trailing_commas: true
    sort_child_properties_last: true
```

- [ ] **Step 4: Add iOS camera permission text**

In `stockmate/ios/Runner/Info.plist`, add this key inside the top-level `<dict>`:

```xml
<key>NSCameraUsageDescription</key>
<string>Stockmate uses the camera to scan product barcodes and QR codes.</string>
```

- [ ] **Step 5: Add shared money helper**

Create `stockmate/lib/src/shared/money.dart`:

```dart
import 'package:intl/intl.dart';

class Money {
  const Money(this.minorUnits);

  final int minorUnits;

  static const zero = Money(0);

  factory Money.fromDecimal(String value) {
    final normalized = value.trim();
    final parsed = double.parse(normalized);
    return Money((parsed * 100).round());
  }

  Money operator +(Money other) => Money(minorUnits + other.minorUnits);

  Money operator -(Money other) => Money(minorUnits - other.minorUnits);

  Money operator *(int quantity) => Money(minorUnits * quantity);

  bool get isNegative => minorUnits < 0;

  String format({String symbol = ''}) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(minorUnits / 100);
  }
}
```

- [ ] **Step 6: Add result type**

Create `stockmate/lib/src/shared/result.dart`:

```dart
sealed class AppResult<T> {
  const AppResult();
}

class AppSuccess<T> extends AppResult<T> {
  const AppSuccess(this.value);

  final T value;
}

class AppFailure<T> extends AppResult<T> {
  const AppFailure(this.message);

  final String message;
}
```

- [ ] **Step 7: Replace app bootstrap**

Create `stockmate/lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';

void main() {
  runApp(const ProviderScope(child: StockmateApp()));
}
```

Create `stockmate/lib/src/app.dart`:

```dart
import 'package:flutter/material.dart';

import 'router/app_router.dart';

class StockmateApp extends StatelessWidget {
  const StockmateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Stockmate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F7A5A)),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
```

Create `stockmate/lib/src/router/app_router.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../checkout/checkout_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../inventory/inventory_screen.dart';
import '../reports/reports_screen.dart';
import '../sales/sales_history_screen.dart';
import '../scanner/scanner_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: navigationShell.goBranch,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
              NavigationDestination(icon: Icon(Icons.inventory_2), label: 'Inventory'),
              NavigationDestination(icon: Icon(Icons.qr_code_scanner), label: 'Scan'),
              NavigationDestination(icon: Icon(Icons.point_of_sale), label: 'Sales'),
              NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Reports'),
            ],
          ),
        );
      },
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/dashboard', builder: (_, _) => const DashboardScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/inventory', builder: (_, _) => const InventoryScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/scan', builder: (_, _) => const ScannerScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/sales', builder: (_, _) => const SalesHistoryScreen()),
          GoRoute(path: '/checkout', builder: (_, _) => const CheckoutScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/reports', builder: (_, _) => const ReportsScreen()),
        ]),
      ],
    ),
  ],
);
```

- [ ] **Step 8: Add temporary screen stubs**

Create these files with the same structure and the class name shown:

`stockmate/lib/src/dashboard/dashboard_screen.dart`

```dart
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Dashboard')));
  }
}
```

`stockmate/lib/src/inventory/inventory_screen.dart`

```dart
import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Inventory')));
  }
}
```

`stockmate/lib/src/scanner/scanner_screen.dart`

```dart
import 'package:flutter/material.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Scan')));
  }
}
```

`stockmate/lib/src/checkout/checkout_screen.dart`

```dart
import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Checkout')));
  }
}
```

`stockmate/lib/src/sales/sales_history_screen.dart`

```dart
import 'package:flutter/material.dart';

class SalesHistoryScreen extends StatelessWidget {
  const SalesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Sales')));
  }
}
```

`stockmate/lib/src/reports/reports_screen.dart`

```dart
import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Reports')));
  }
}
```

- [ ] **Step 9: Write the bootstrap widget test**

Replace `stockmate/test/widget_test.dart` with `stockmate/test/app_bootstrap_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/main.dart' as app;

void main() {
  testWidgets('app boots to dashboard tab', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Inventory'), findsOneWidget);
    expect(find.text('Scan'), findsOneWidget);
    expect(find.text('Sales'), findsOneWidget);
    expect(find.text('Reports'), findsOneWidget);
  });
}
```

- [ ] **Step 10: Run tests**

Run:

```bash
cd stockmate
flutter test test/app_bootstrap_test.dart
```

Expected: PASS.

- [ ] **Step 11: Commit**

```bash
git add stockmate
git commit -m "feat: scaffold stockmate flutter app"
```

## Task 2: Create Drift Database Schema

**Files:**
- Create: `stockmate/lib/src/data/app_database.dart`
- Create: `stockmate/lib/src/data/database_provider.dart`
- Test: `stockmate/test/data/app_database_test.dart`

- [ ] **Step 1: Write failing database schema test**

Create `stockmate/test/data/app_database_test.dart`:

```dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:stockmate/src/data/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('stores product with unique code and stock batch', () async {
    final productId = await db.into(db.products).insert(
          ProductsCompanion.insert(
            name: 'Milo Tin',
            sellingPriceMinor: 2500,
            lowStockThreshold: const Value(3),
          ),
        );

    await db.into(db.productCodes).insert(
          ProductCodesCompanion.insert(
            productId: productId,
            codeValue: '8991234567890',
            codeType: 'barcode',
            source: 'manufacturer',
            isPrimary: const Value(true),
          ),
        );

    await db.into(db.stockBatches).insert(
          StockBatchesCompanion.insert(
            productId: productId,
            quantityReceived: 12,
            quantityRemaining: 12,
            costPerUnitMinor: 1700,
          ),
        );

    final product = await db.select(db.products).getSingle();
    final code = await db.select(db.productCodes).getSingle();
    final batch = await db.select(db.stockBatches).getSingle();

    expect(product.name, 'Milo Tin');
    expect(code.codeValue, '8991234567890');
    expect(batch.quantityRemaining, 12);
  });

  test('prevents duplicate product codes', () async {
    final first = await db.into(db.products).insert(
          ProductsCompanion.insert(name: 'Item A', sellingPriceMinor: 1000),
        );
    final second = await db.into(db.products).insert(
          ProductsCompanion.insert(name: 'Item B', sellingPriceMinor: 1200),
        );

    await db.into(db.productCodes).insert(
          ProductCodesCompanion.insert(
            productId: first,
            codeValue: 'DUPLICATE',
            codeType: 'internal',
            source: 'generated',
          ),
        );

    expect(
      () => db.into(db.productCodes).insert(
            ProductCodesCompanion.insert(
              productId: second,
              codeValue: 'DUPLICATE',
              codeType: 'internal',
              source: 'generated',
            ),
          ),
      throwsA(isA<SqliteException>()),
    );
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run:

```bash
cd stockmate
flutter test test/data/app_database_test.dart
```

Expected: FAIL because `AppDatabase` and generated Drift classes do not exist.

- [ ] **Step 3: Create database schema**

Create `stockmate/lib/src/data/app_database.dart`:

```dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get category => text().nullable()();
  IntColumn get sellingPriceMinor => integer()();
  IntColumn get lowStockThreshold => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class ProductCodes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Products, #id)();
  TextColumn get codeValue => text().unique()();
  TextColumn get codeType => text()();
  TextColumn get source => text()();
  BoolColumn get isPrimary => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class StockBatches extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get quantityReceived => integer()();
  IntColumn get quantityRemaining => integer()();
  IntColumn get costPerUnitMinor => integer()();
  DateTimeColumn get receivedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class StockAdjustments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get adjustmentQuantity => integer()();
  TextColumn get reason => text()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Sales extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get receiptNumber => text().unique()();
  DateTimeColumn get soldAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get subtotalMinor => integer()();
  IntColumn get discountTotalMinor => integer().withDefault(const Constant(0))();
  IntColumn get totalMinor => integer()();
  IntColumn get costTotalMinor => integer()();
  IntColumn get grossProfitMinor => integer()();
  TextColumn get paymentMethod => text()();
  IntColumn get amountPaidMinor => integer().nullable()();
  IntColumn get changeDueMinor => integer().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class SaleLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleId => integer().references(Sales, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get quantity => integer()();
  IntColumn get unitPriceMinor => integer()();
  IntColumn get discountAmountMinor => integer().withDefault(const Constant(0))();
  IntColumn get lineTotalMinor => integer()();
  IntColumn get costTotalMinor => integer()();
  IntColumn get grossProfitMinor => integer()();
}

class SaleLineBatchAllocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleLineId => integer().references(SaleLines, #id)();
  IntColumn get stockBatchId => integer().references(StockBatches, #id)();
  IntColumn get quantity => integer()();
  IntColumn get costPerUnitMinor => integer()();
  IntColumn get costTotalMinor => integer()();
}

class Receipts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleId => integer().references(Sales, #id)();
  TextColumn get receiptNumber => text().unique()();
  TextColumn get pdfPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastSharedAt => dateTime().nullable()();
  DateTimeColumn get lastPrintedAt => dateTime().nullable()();
}

@DriftDatabase(
  tables: [
    Products,
    ProductCodes,
    StockBatches,
    StockAdjustments,
    Sales,
    SaleLines,
    SaleLineBatchAllocations,
    Receipts,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.defaults() : super(driftDatabase(name: 'stockmate'));

  @override
  int get schemaVersion => 1;
}
```

Create `stockmate/lib/src/data/database_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase.defaults();
  ref.onDispose(database.close);
  return database;
});
```

- [ ] **Step 4: Generate Drift code**

Run:

```bash
cd stockmate
dart run build_runner build --delete-conflicting-outputs
```

Expected: `stockmate/lib/src/data/app_database.g.dart` is generated.

- [ ] **Step 5: Run database tests**

Run:

```bash
cd stockmate
flutter test test/data/app_database_test.dart
```

Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add stockmate/lib/src/data stockmate/test/data
git commit -m "feat: add local sqlite schema"
```

## Task 3: Implement FIFO Stock Allocation

**Files:**
- Create: `stockmate/lib/src/checkout/stock_allocator.dart`
- Test: `stockmate/test/checkout/stock_allocator_test.dart`

- [ ] **Step 1: Write failing tests**

Create `stockmate/test/checkout/stock_allocator_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/checkout/stock_allocator.dart';

void main() {
  test('allocates oldest batches first and calculates cost', () {
    final allocator = StockAllocator();
    final result = allocator.allocate(
      requestedQuantity: 8,
      batches: const [
        AvailableBatch(id: 1, quantityRemaining: 5, costPerUnitMinor: 100),
        AvailableBatch(id: 2, quantityRemaining: 10, costPerUnitMinor: 150),
      ],
    );

    expect(result.isSuccess, true);
    expect(result.allocations, [
      const BatchAllocation(stockBatchId: 1, quantity: 5, costPerUnitMinor: 100),
      const BatchAllocation(stockBatchId: 2, quantity: 3, costPerUnitMinor: 150),
    ]);
    expect(result.costTotalMinor, 950);
  });

  test('fails when available stock is too low', () {
    final allocator = StockAllocator();
    final result = allocator.allocate(
      requestedQuantity: 4,
      batches: const [
        AvailableBatch(id: 1, quantityRemaining: 2, costPerUnitMinor: 100),
      ],
    );

    expect(result.isSuccess, false);
    expect(result.message, 'Only 2 units available.');
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run:

```bash
cd stockmate
flutter test test/checkout/stock_allocator_test.dart
```

Expected: FAIL because `stock_allocator.dart` does not exist.

- [ ] **Step 3: Implement allocator**

Create `stockmate/lib/src/checkout/stock_allocator.dart`:

```dart
class AvailableBatch {
  const AvailableBatch({
    required this.id,
    required this.quantityRemaining,
    required this.costPerUnitMinor,
  });

  final int id;
  final int quantityRemaining;
  final int costPerUnitMinor;
}

class BatchAllocation {
  const BatchAllocation({
    required this.stockBatchId,
    required this.quantity,
    required this.costPerUnitMinor,
  });

  final int stockBatchId;
  final int quantity;
  final int costPerUnitMinor;

  int get costTotalMinor => quantity * costPerUnitMinor;

  @override
  bool operator ==(Object other) {
    return other is BatchAllocation &&
        other.stockBatchId == stockBatchId &&
        other.quantity == quantity &&
        other.costPerUnitMinor == costPerUnitMinor;
  }

  @override
  int get hashCode => Object.hash(stockBatchId, quantity, costPerUnitMinor);
}

class AllocationResult {
  const AllocationResult.success(this.allocations)
      : message = '',
        isSuccess = true;

  const AllocationResult.failure(this.message)
      : allocations = const [],
        isSuccess = false;

  final bool isSuccess;
  final String message;
  final List<BatchAllocation> allocations;

  int get costTotalMinor {
    return allocations.fold(0, (total, allocation) => total + allocation.costTotalMinor);
  }
}

class StockAllocator {
  AllocationResult allocate({
    required int requestedQuantity,
    required List<AvailableBatch> batches,
  }) {
    final available = batches.fold(0, (total, batch) => total + batch.quantityRemaining);
    if (available < requestedQuantity) {
      return AllocationResult.failure('Only $available units available.');
    }

    var remaining = requestedQuantity;
    final allocations = <BatchAllocation>[];

    for (final batch in batches) {
      if (remaining == 0) {
        break;
      }
      final quantity = batch.quantityRemaining < remaining ? batch.quantityRemaining : remaining;
      allocations.add(
        BatchAllocation(
          stockBatchId: batch.id,
          quantity: quantity,
          costPerUnitMinor: batch.costPerUnitMinor,
        ),
      );
      remaining -= quantity;
    }

    return AllocationResult.success(allocations);
  }
}
```

- [ ] **Step 4: Run allocator tests**

Run:

```bash
cd stockmate
flutter test test/checkout/stock_allocator_test.dart
```

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add stockmate/lib/src/checkout/stock_allocator.dart stockmate/test/checkout/stock_allocator_test.dart
git commit -m "feat: add fifo stock allocator"
```

## Task 4: Implement Inventory Repositories and Add Stock

**Files:**
- Create: `stockmate/lib/src/inventory/inventory_repository.dart`
- Create: `stockmate/lib/src/inventory/add_stock_use_case.dart`
- Create: `stockmate/lib/src/inventory/stock_adjustment_use_case.dart`
- Test: `stockmate/test/inventory/add_stock_use_case_test.dart`
- Test: `stockmate/test/inventory/stock_adjustment_use_case_test.dart`

- [ ] **Step 1: Write add-stock test**

Create `stockmate/test/inventory/add_stock_use_case_test.dart`:

```dart
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/data/app_database.dart';
import 'package:stockmate/src/inventory/add_stock_use_case.dart';
import 'package:stockmate/src/inventory/inventory_repository.dart';

void main() {
  late AppDatabase db;
  late AddStockUseCase useCase;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    useCase = AddStockUseCase(InventoryRepository(db));
  });

  tearDown(() => db.close());

  test('creates product, code alias, and stock batch in one workflow', () async {
    final productId = await useCase.createProductWithStock(
      name: 'Rice 5kg',
      codeValue: 'INT-RICE-5KG',
      codeType: 'internal',
      source: 'generated',
      sellingPriceMinor: 12000,
      quantityReceived: 10,
      costPerUnitMinor: 9000,
      lowStockThreshold: 2,
    );

    final product = await (db.select(db.products)..where((row) => row.id.equals(productId))).getSingle();
    final code = await db.select(db.productCodes).getSingle();
    final batch = await db.select(db.stockBatches).getSingle();

    expect(product.name, 'Rice 5kg');
    expect(code.codeValue, 'INT-RICE-5KG');
    expect(batch.quantityRemaining, 10);
  });
}
```

- [ ] **Step 2: Write adjustment test**

Create `stockmate/test/inventory/stock_adjustment_use_case_test.dart`:

```dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/data/app_database.dart';
import 'package:stockmate/src/inventory/inventory_repository.dart';
import 'package:stockmate/src/inventory/stock_adjustment_use_case.dart';

void main() {
  late AppDatabase db;
  late StockAdjustmentUseCase useCase;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    useCase = StockAdjustmentUseCase(InventoryRepository(db));
  });

  tearDown(() => db.close());

  test('blocks negative adjustment beyond available stock', () async {
    final productId = await db.into(db.products).insert(
          ProductsCompanion.insert(name: 'Soap', sellingPriceMinor: 700),
        );
    await db.into(db.stockBatches).insert(
          StockBatchesCompanion.insert(
            productId: productId,
            quantityReceived: 3,
            quantityRemaining: 3,
            costPerUnitMinor: 450,
          ),
        );

    final result = await useCase.adjustStock(
      productId: productId,
      adjustmentQuantity: -4,
      reason: 'loss',
      note: 'Count correction',
    );

    expect(result.isSuccess, false);
    expect(result.message, 'Cannot reduce stock below zero. Available stock is 3.');
  });
}
```

- [ ] **Step 3: Run tests to verify they fail**

Run:

```bash
cd stockmate
flutter test test/inventory
```

Expected: FAIL because inventory repository and use cases do not exist.

- [ ] **Step 4: Implement inventory repository**

Create `stockmate/lib/src/inventory/inventory_repository.dart`:

```dart
import 'package:drift/drift.dart';

import '../data/app_database.dart';

class InventoryRepository {
  InventoryRepository(this.db);

  final AppDatabase db;

  Future<int> currentStock(int productId) async {
    final batches = await (db.select(db.stockBatches)..where((row) => row.productId.equals(productId))).get();
    return batches.fold(0, (total, batch) => total + batch.quantityRemaining);
  }

  Future<int> createProductWithStock({
    required String name,
    required String codeValue,
    required String codeType,
    required String source,
    required int sellingPriceMinor,
    required int quantityReceived,
    required int costPerUnitMinor,
    required int lowStockThreshold,
  }) {
    return db.transaction(() async {
      final productId = await db.into(db.products).insert(
            ProductsCompanion.insert(
              name: name,
              sellingPriceMinor: sellingPriceMinor,
              lowStockThreshold: Value(lowStockThreshold),
            ),
          );

      await db.into(db.productCodes).insert(
            ProductCodesCompanion.insert(
              productId: productId,
              codeValue: codeValue,
              codeType: codeType,
              source: source,
              isPrimary: const Value(true),
            ),
          );

      await db.into(db.stockBatches).insert(
            StockBatchesCompanion.insert(
              productId: productId,
              quantityReceived: quantityReceived,
              quantityRemaining: quantityReceived,
              costPerUnitMinor: costPerUnitMinor,
            ),
          );

      return productId;
    });
  }

  Future<void> addStockAdjustment({
    required int productId,
    required int adjustmentQuantity,
    required String reason,
    required String? note,
  }) {
    return db.transaction(() async {
      await db.into(db.stockAdjustments).insert(
            StockAdjustmentsCompanion.insert(
              productId: productId,
              adjustmentQuantity: adjustmentQuantity,
              reason: reason,
              note: Value(note),
            ),
          );

      if (adjustmentQuantity > 0) {
        await db.into(db.stockBatches).insert(
              StockBatchesCompanion.insert(
                productId: productId,
                quantityReceived: adjustmentQuantity,
                quantityRemaining: adjustmentQuantity,
                costPerUnitMinor: 0,
                note: const Value('Manual stock increase'),
              ),
            );
      } else if (adjustmentQuantity < 0) {
        var remainingToRemove = -adjustmentQuantity;
        final batches = await (db.select(db.stockBatches)
              ..where((row) => row.productId.equals(productId) & row.quantityRemaining.isBiggerThanValue(0))
              ..orderBy([(row) => OrderingTerm.asc(row.receivedAt), (row) => OrderingTerm.asc(row.id)]))
            .get();

        for (final batch in batches) {
          if (remainingToRemove == 0) {
            break;
          }
          final remove = batch.quantityRemaining < remainingToRemove ? batch.quantityRemaining : remainingToRemove;
          await (db.update(db.stockBatches)..where((row) => row.id.equals(batch.id))).write(
            StockBatchesCompanion(quantityRemaining: Value(batch.quantityRemaining - remove)),
          );
          remainingToRemove -= remove;
        }
      }
    });
  }
}
```

- [ ] **Step 5: Implement use cases**

Create `stockmate/lib/src/inventory/add_stock_use_case.dart`:

```dart
import 'inventory_repository.dart';

class AddStockUseCase {
  AddStockUseCase(this.repository);

  final InventoryRepository repository;

  Future<int> createProductWithStock({
    required String name,
    required String codeValue,
    required String codeType,
    required String source,
    required int sellingPriceMinor,
    required int quantityReceived,
    required int costPerUnitMinor,
    required int lowStockThreshold,
  }) {
    return repository.createProductWithStock(
      name: name,
      codeValue: codeValue,
      codeType: codeType,
      source: source,
      sellingPriceMinor: sellingPriceMinor,
      quantityReceived: quantityReceived,
      costPerUnitMinor: costPerUnitMinor,
      lowStockThreshold: lowStockThreshold,
    );
  }
}
```

Create `stockmate/lib/src/inventory/stock_adjustment_use_case.dart`:

```dart
import '../shared/result.dart';
import 'inventory_repository.dart';

class StockAdjustmentUseCase {
  StockAdjustmentUseCase(this.repository);

  final InventoryRepository repository;

  Future<AdjustmentResult> adjustStock({
    required int productId,
    required int adjustmentQuantity,
    required String reason,
    required String? note,
  }) async {
    final available = await repository.currentStock(productId);
    if (adjustmentQuantity < 0 && -adjustmentQuantity > available) {
      return AdjustmentResult.failure(
        'Cannot reduce stock below zero. Available stock is $available.',
      );
    }

    await repository.addStockAdjustment(
      productId: productId,
      adjustmentQuantity: adjustmentQuantity,
      reason: reason,
      note: note,
    );
    return const AdjustmentResult.success();
  }
}

class AdjustmentResult {
  const AdjustmentResult.success()
      : isSuccess = true,
        message = '';

  const AdjustmentResult.failure(this.message) : isSuccess = false;

  final bool isSuccess;
  final String message;
}
```

- [ ] **Step 6: Run inventory tests**

Run:

```bash
cd stockmate
flutter test test/inventory
```

Expected: PASS.

- [ ] **Step 7: Commit**

```bash
git add stockmate/lib/src/inventory stockmate/test/inventory
git commit -m "feat: add inventory stock workflows"
```

## Task 5: Implement Checkout and Atomic Sale Completion

**Files:**
- Create: `stockmate/lib/src/checkout/cart_models.dart`
- Create: `stockmate/lib/src/checkout/checkout_repository.dart`
- Create: `stockmate/lib/src/checkout/complete_sale_use_case.dart`
- Test: `stockmate/test/checkout/complete_sale_use_case_test.dart`

- [ ] **Step 1: Write failing checkout test**

Create `stockmate/test/checkout/complete_sale_use_case_test.dart`:

```dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/checkout/cart_models.dart';
import 'package:stockmate/src/checkout/checkout_repository.dart';
import 'package:stockmate/src/checkout/complete_sale_use_case.dart';
import 'package:stockmate/src/checkout/stock_allocator.dart';
import 'package:stockmate/src/data/app_database.dart';

void main() {
  late AppDatabase db;
  late CompleteSaleUseCase useCase;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    useCase = CompleteSaleUseCase(
      repository: CheckoutRepository(db),
      allocator: StockAllocator(),
    );
  });

  tearDown(() => db.close());

  test('completes discounted sale and consumes oldest stock batches', () async {
    final productId = await db.into(db.products).insert(
          ProductsCompanion.insert(name: 'Milk', sellingPriceMinor: 500),
        );
    await db.into(db.stockBatches).insert(
          StockBatchesCompanion.insert(
            productId: productId,
            quantityReceived: 2,
            quantityRemaining: 2,
            costPerUnitMinor: 300,
            receivedAt: Value(DateTime(2026, 1, 1)),
          ),
        );
    await db.into(db.stockBatches).insert(
          StockBatchesCompanion.insert(
            productId: productId,
            quantityReceived: 5,
            quantityRemaining: 5,
            costPerUnitMinor: 350,
            receivedAt: Value(DateTime(2026, 2, 1)),
          ),
        );

    final result = await useCase.completeSale(
      cart: Cart(
        lines: [
          CartLine(
            productId: productId,
            name: 'Milk',
            quantity: 4,
            unitPriceMinor: 500,
            discountMinor: 100,
          ),
        ],
        paymentMethod: 'cash',
        amountPaidMinor: 2000,
      ),
    );

    expect(result.isSuccess, true);
    final sale = await db.select(db.sales).getSingle();
    final batches = await (db.select(db.stockBatches)..orderBy([(row) => OrderingTerm.asc(row.id)])).get();
    final allocations = await db.select(db.saleLineBatchAllocations).get();

    expect(sale.subtotalMinor, 2000);
    expect(sale.discountTotalMinor, 100);
    expect(sale.totalMinor, 1900);
    expect(sale.costTotalMinor, 1300);
    expect(sale.grossProfitMinor, 600);
    expect(batches[0].quantityRemaining, 0);
    expect(batches[1].quantityRemaining, 3);
    expect(allocations.length, 2);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run:

```bash
cd stockmate
flutter test test/checkout/complete_sale_use_case_test.dart
```

Expected: FAIL because checkout repository and use case do not exist.

- [ ] **Step 3: Create cart models**

Create `stockmate/lib/src/checkout/cart_models.dart`:

```dart
class Cart {
  const Cart({
    required this.lines,
    required this.paymentMethod,
    required this.amountPaidMinor,
  });

  final List<CartLine> lines;
  final String paymentMethod;
  final int? amountPaidMinor;

  int get subtotalMinor {
    return lines.fold(0, (total, line) => total + line.subtotalMinor);
  }

  int get discountTotalMinor {
    return lines.fold(0, (total, line) => total + line.discountMinor);
  }

  int get totalMinor => subtotalMinor - discountTotalMinor;
}

class CartLine {
  const CartLine({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unitPriceMinor,
    required this.discountMinor,
  });

  final int productId;
  final String name;
  final int quantity;
  final int unitPriceMinor;
  final int discountMinor;

  int get subtotalMinor => quantity * unitPriceMinor;
  int get lineTotalMinor => subtotalMinor - discountMinor;
}
```

- [ ] **Step 4: Implement checkout repository**

Create `stockmate/lib/src/checkout/checkout_repository.dart`:

```dart
import 'package:drift/drift.dart';

import '../data/app_database.dart';
import 'cart_models.dart';
import 'stock_allocator.dart';

class CheckoutRepository {
  CheckoutRepository(this.db);

  final AppDatabase db;

  Future<List<AvailableBatch>> availableBatches(int productId) async {
    final batches = await (db.select(db.stockBatches)
          ..where((row) => row.productId.equals(productId) & row.quantityRemaining.isBiggerThanValue(0))
          ..orderBy([(row) => OrderingTerm.asc(row.receivedAt), (row) => OrderingTerm.asc(row.id)]))
        .get();

    return [
      for (final batch in batches)
        AvailableBatch(
          id: batch.id,
          quantityRemaining: batch.quantityRemaining,
          costPerUnitMinor: batch.costPerUnitMinor,
        ),
    ];
  }

  Future<int> persistSale({
    required Cart cart,
    required Map<int, List<BatchAllocation>> allocationsByProduct,
  }) {
    return db.transaction(() async {
      final receiptNumber = 'R-${DateTime.now().millisecondsSinceEpoch}';
      final costTotal = allocationsByProduct.values
          .expand((allocations) => allocations)
          .fold(0, (total, allocation) => total + allocation.costTotalMinor);
      final saleId = await db.into(db.sales).insert(
            SalesCompanion.insert(
              receiptNumber: receiptNumber,
              subtotalMinor: cart.subtotalMinor,
              discountTotalMinor: Value(cart.discountTotalMinor),
              totalMinor: cart.totalMinor,
              costTotalMinor: costTotal,
              grossProfitMinor: cart.totalMinor - costTotal,
              paymentMethod: cart.paymentMethod,
              amountPaidMinor: Value(cart.amountPaidMinor),
              changeDueMinor: Value(
                cart.amountPaidMinor == null ? null : cart.amountPaidMinor! - cart.totalMinor,
              ),
            ),
          );

      for (final line in cart.lines) {
        final allocations = allocationsByProduct[line.productId]!;
        final lineCostTotal = allocations.fold(0, (total, allocation) => total + allocation.costTotalMinor);
        final saleLineId = await db.into(db.saleLines).insert(
              SaleLinesCompanion.insert(
                saleId: saleId,
                productId: line.productId,
                quantity: line.quantity,
                unitPriceMinor: line.unitPriceMinor,
                discountAmountMinor: Value(line.discountMinor),
                lineTotalMinor: line.lineTotalMinor,
                costTotalMinor: lineCostTotal,
                grossProfitMinor: line.lineTotalMinor - lineCostTotal,
              ),
            );

        for (final allocation in allocations) {
          await db.into(db.saleLineBatchAllocations).insert(
                SaleLineBatchAllocationsCompanion.insert(
                  saleLineId: saleLineId,
                  stockBatchId: allocation.stockBatchId,
                  quantity: allocation.quantity,
                  costPerUnitMinor: allocation.costPerUnitMinor,
                  costTotalMinor: allocation.costTotalMinor,
                ),
              );

          final batch = await (db.select(db.stockBatches)
                ..where((row) => row.id.equals(allocation.stockBatchId)))
              .getSingle();
          await (db.update(db.stockBatches)..where((row) => row.id.equals(batch.id))).write(
            StockBatchesCompanion(
              quantityRemaining: Value(batch.quantityRemaining - allocation.quantity),
            ),
          );
        }
      }

      await db.into(db.receipts).insert(
            ReceiptsCompanion.insert(
              saleId: saleId,
              receiptNumber: receiptNumber,
            ),
          );

      return saleId;
    });
  }
}
```

- [ ] **Step 5: Implement sale use case**

Create `stockmate/lib/src/checkout/complete_sale_use_case.dart`:

```dart
import 'cart_models.dart';
import 'checkout_repository.dart';
import 'stock_allocator.dart';

class CompleteSaleUseCase {
  CompleteSaleUseCase({
    required this.repository,
    required this.allocator,
  });

  final CheckoutRepository repository;
  final StockAllocator allocator;

  Future<CompleteSaleResult> completeSale({required Cart cart}) async {
    final allocationsByProduct = <int, List<BatchAllocation>>{};

    for (final line in cart.lines) {
      final batches = await repository.availableBatches(line.productId);
      final result = allocator.allocate(
        requestedQuantity: line.quantity,
        batches: batches,
      );
      if (!result.isSuccess) {
        return CompleteSaleResult.failure(result.message);
      }
      allocationsByProduct[line.productId] = result.allocations;
    }

    final saleId = await repository.persistSale(
      cart: cart,
      allocationsByProduct: allocationsByProduct,
    );
    return CompleteSaleResult.success(saleId);
  }
}

class CompleteSaleResult {
  const CompleteSaleResult.success(this.saleId)
      : isSuccess = true,
        message = '';

  const CompleteSaleResult.failure(this.message)
      : isSuccess = false,
        saleId = null;

  final bool isSuccess;
  final String message;
  final int? saleId;
}
```

- [ ] **Step 6: Run checkout tests**

Run:

```bash
cd stockmate
flutter test test/checkout
```

Expected: PASS.

- [ ] **Step 7: Commit**

```bash
git add stockmate/lib/src/checkout stockmate/test/checkout
git commit -m "feat: complete sales with fifo stock costing"
```

## Task 6: Implement Internal Codes, Labels, and Receipts

**Files:**
- Create: `stockmate/lib/src/labels/internal_code_generator.dart`
- Create: `stockmate/lib/src/labels/label_screen.dart`
- Create: `stockmate/lib/src/receipts/receipt_pdf_builder.dart`
- Create: `stockmate/lib/src/receipts/receipt_repository.dart`
- Test: `stockmate/test/labels/internal_code_generator_test.dart`
- Test: `stockmate/test/receipts/receipt_pdf_builder_test.dart`

- [ ] **Step 1: Write internal code test**

Create `stockmate/test/labels/internal_code_generator_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/labels/internal_code_generator.dart';

void main() {
  test('generates stable internal code format', () {
    final generator = InternalCodeGenerator();

    final code = generator.generate(productId: 42);

    expect(code, startsWith('INT-000042-'));
    expect(code.length, greaterThan(14));
  });
}
```

- [ ] **Step 2: Implement internal code generator**

Create `stockmate/lib/src/labels/internal_code_generator.dart`:

```dart
import 'package:uuid/uuid.dart';

class InternalCodeGenerator {
  InternalCodeGenerator({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  String generate({required int productId}) {
    final suffix = _uuid.v4().split('-').first.toUpperCase();
    return 'INT-${productId.toString().padLeft(6, '0')}-$suffix';
  }
}
```

- [ ] **Step 3: Create label preview screen**

Create `stockmate/lib/src/labels/label_screen.dart`:

```dart
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

class LabelScreen extends StatelessWidget {
  const LabelScreen({
    required this.code,
    super.key,
  });

  final String code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Label')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BarcodeWidget(
              barcode: Barcode.qrCode(),
              data: code,
              width: 220,
              height: 220,
            ),
            const SizedBox(height: 16),
            SelectableText(code, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Write receipt PDF test**

Create `stockmate/test/receipts/receipt_pdf_builder_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/receipts/receipt_pdf_builder.dart';

void main() {
  test('builds non-empty receipt pdf bytes', () async {
    final builder = ReceiptPdfBuilder();

    final bytes = await builder.build(
      receiptNumber: 'R-1',
      soldAt: DateTime(2026, 6, 13, 9, 30),
      lines: const [
        ReceiptLine(name: 'Milk', quantity: 2, unitPriceMinor: 500, discountMinor: 100),
      ],
      subtotalMinor: 1000,
      discountTotalMinor: 100,
      totalMinor: 900,
      paymentMethod: 'cash',
    );

    expect(bytes.length, greaterThan(500));
  });
}
```

- [ ] **Step 5: Implement receipt PDF builder**

Create `stockmate/lib/src/receipts/receipt_pdf_builder.dart`:

```dart
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReceiptLine {
  const ReceiptLine({
    required this.name,
    required this.quantity,
    required this.unitPriceMinor,
    required this.discountMinor,
  });

  final String name;
  final int quantity;
  final int unitPriceMinor;
  final int discountMinor;

  int get lineTotalMinor => quantity * unitPriceMinor - discountMinor;
}

class ReceiptPdfBuilder {
  Future<Uint8List> build({
    required String receiptNumber,
    required DateTime soldAt,
    required List<ReceiptLine> lines,
    required int subtotalMinor,
    required int discountTotalMinor,
    required int totalMinor,
    required String paymentMethod,
  }) async {
    final doc = pw.Document();

    String money(int minor) => (minor / 100).toStringAsFixed(2);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Stockmate Receipt', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Text(receiptNumber),
              pw.Text(soldAt.toIso8601String()),
              pw.SizedBox(height: 12),
              for (final line in lines)
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(line.name),
                    pw.Text('${line.quantity} x ${money(line.unitPriceMinor)}   ${money(line.lineTotalMinor)}'),
                  ],
                ),
              pw.Divider(),
              pw.Text('Subtotal: ${money(subtotalMinor)}'),
              pw.Text('Discount: ${money(discountTotalMinor)}'),
              pw.Text('Total: ${money(totalMinor)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('Payment: $paymentMethod'),
            ],
          );
        },
      ),
    );

    return doc.save();
  }
}
```

- [ ] **Step 6: Create receipt repository**

Create `stockmate/lib/src/receipts/receipt_repository.dart`:

```dart
import 'package:drift/drift.dart';

import '../data/app_database.dart';

class ReceiptRepository {
  ReceiptRepository(this.db);

  final AppDatabase db;

  Future<void> markShared(int receiptId, DateTime sharedAt) {
    return (db.update(db.receipts)..where((row) => row.id.equals(receiptId))).write(
      ReceiptsCompanion(lastSharedAt: Value(sharedAt)),
    );
  }

  Future<void> markPrinted(int receiptId, DateTime printedAt) {
    return (db.update(db.receipts)..where((row) => row.id.equals(receiptId))).write(
      ReceiptsCompanion(lastPrintedAt: Value(printedAt)),
    );
  }
}
```

- [ ] **Step 7: Run label and receipt tests**

Run:

```bash
cd stockmate
flutter test test/labels test/receipts
```

Expected: PASS.

- [ ] **Step 8: Commit**

```bash
git add stockmate/lib/src/labels stockmate/lib/src/receipts stockmate/test/labels stockmate/test/receipts
git commit -m "feat: add labels and receipt pdf generation"
```

## Task 7: Implement Scanner Flow

**Files:**
- Modify: `stockmate/lib/src/scanner/scanner_screen.dart`
- Create: `stockmate/lib/src/scanner/manual_code_entry.dart`
- Test: `stockmate/test/scanner/manual_code_entry_test.dart`

- [ ] **Step 1: Write manual code entry widget test**

Create `stockmate/test/scanner/manual_code_entry_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/scanner/manual_code_entry.dart';

void main() {
  testWidgets('submits trimmed manual code', (tester) async {
    String? submitted;
    await tester.pumpWidget(
      MaterialApp(
        home: ManualCodeEntry(
          onSubmitted: (value) => submitted = value,
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '  ABC-123  ');
    await tester.tap(find.text('Use Code'));
    await tester.pump();

    expect(submitted, 'ABC-123');
  });
}
```

- [ ] **Step 2: Implement manual code entry**

Create `stockmate/lib/src/scanner/manual_code_entry.dart`:

```dart
import 'package:flutter/material.dart';

class ManualCodeEntry extends StatefulWidget {
  const ManualCodeEntry({
    required this.onSubmitted,
    super.key,
  });

  final ValueChanged<String> onSubmitted;

  @override
  State<ManualCodeEntry> createState() => _ManualCodeEntryState();
}

class _ManualCodeEntryState extends State<ManualCodeEntry> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Enter barcode or internal code'),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.isNotEmpty) {
                widget.onSubmitted(value);
              }
            },
            child: const Text('Use Code'),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: Implement scanner screen**

Replace `stockmate/lib/src/scanner/scanner_screen.dart` with:

```dart
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'manual_code_entry.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String? lastCode;

  void _handleCode(String code) {
    setState(() => lastCode = code);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Scanned $code')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Product')),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (capture) {
                final code = capture.barcodes.firstOrNull?.rawValue;
                if (code != null && code != lastCode) {
                  _handleCode(code);
                }
              },
            ),
          ),
          ManualCodeEntry(onSubmitted: _handleCode),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run scanner widget test**

Run:

```bash
cd stockmate
flutter test test/scanner/manual_code_entry_test.dart
```

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add stockmate/lib/src/scanner stockmate/test/scanner
git commit -m "feat: add scanner and manual code entry"
```

## Task 8: Build Inventory and Checkout Screens

**Files:**
- Modify: `stockmate/lib/src/inventory/inventory_screen.dart`
- Create: `stockmate/lib/src/inventory/product_form_screen.dart`
- Create: `stockmate/lib/src/inventory/product_detail_screen.dart`
- Modify: `stockmate/lib/src/checkout/checkout_screen.dart`
- Test: `stockmate/test/inventory/product_form_screen_test.dart`
- Test: `stockmate/test/checkout/checkout_screen_test.dart`

- [ ] **Step 1: Write product form validation test**

Create `stockmate/test/inventory/product_form_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/inventory/product_form_screen.dart';

void main() {
  testWidgets('requires product name before save', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProductFormScreen()));

    await tester.tap(find.text('Save Product'));
    await tester.pump();

    expect(find.text('Enter product name'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Implement product form screen**

Create `stockmate/lib/src/inventory/product_form_screen.dart`:

```dart
import 'package:flutter/material.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final costController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Product name'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter product name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Selling price'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantity received'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: costController,
              decoration: const InputDecoration(labelText: 'Cost per unit'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => formKey.currentState!.validate(),
              child: const Text('Save Product'),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: Replace inventory screen with navigation surface**

Replace `stockmate/lib/src/inventory/inventory_screen.dart` with:

```dart
import 'package:flutter/material.dart';

import 'product_form_screen.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: const Center(child: Text('No products yet')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const ProductFormScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }
}
```

- [ ] **Step 4: Write checkout widget test**

Create `stockmate/test/checkout/checkout_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/checkout/checkout_screen.dart';

void main() {
  testWidgets('empty checkout prompts scanning or searching', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CheckoutScreen()));

    expect(find.text('Checkout'), findsOneWidget);
    expect(find.text('Scan or search products to add them to the cart.'), findsOneWidget);
  });
}
```

- [ ] **Step 5: Implement checkout screen**

Replace `stockmate/lib/src/checkout/checkout_screen.dart` with:

```dart
import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Scan or search products to add them to the cart.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: null,
            icon: const Icon(Icons.receipt_long),
            label: const Text('Complete Sale'),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 6: Run UI tests**

Run:

```bash
cd stockmate
flutter test test/inventory/product_form_screen_test.dart test/checkout/checkout_screen_test.dart
```

Expected: PASS.

- [ ] **Step 7: Commit**

```bash
git add stockmate/lib/src/inventory stockmate/lib/src/checkout stockmate/test/inventory stockmate/test/checkout
git commit -m "feat: add inventory and checkout screens"
```

## Task 9: Build Dashboard, Sales History, and Reports

**Files:**
- Modify: `stockmate/lib/src/dashboard/dashboard_screen.dart`
- Modify: `stockmate/lib/src/sales/sales_history_screen.dart`
- Modify: `stockmate/lib/src/reports/reports_screen.dart`
- Test: `stockmate/test/dashboard/dashboard_screen_test.dart`
- Test: `stockmate/test/reports/reports_screen_test.dart`

- [ ] **Step 1: Write dashboard test**

Create `stockmate/test/dashboard/dashboard_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/dashboard/dashboard_screen.dart';

void main() {
  testWidgets('dashboard shows sales summary labels', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Revenue'), findsOneWidget);
    expect(find.text('Gross Profit'), findsOneWidget);
    expect(find.text('Low Stock'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Implement dashboard screen**

Replace `stockmate/lib/src/dashboard/dashboard_screen.dart` with:

```dart
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Today')),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: const [
          _MetricTile(label: 'Revenue', value: '0.00'),
          _MetricTile(label: 'Gross Profit', value: '0.00'),
          _MetricTile(label: 'Sales', value: '0'),
          _MetricTile(label: 'Low Stock', value: '0'),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: Write reports test**

Create `stockmate/test/reports/reports_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/reports/reports_screen.dart';

void main() {
  testWidgets('reports screen exposes required report types', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ReportsScreen()));

    expect(find.text('Revenue'), findsOneWidget);
    expect(find.text('Gross Profit'), findsOneWidget);
    expect(find.text('Top Products'), findsOneWidget);
    expect(find.text('Stock Value'), findsOneWidget);
  });
}
```

- [ ] **Step 4: Implement sales and reports screens**

Replace `stockmate/lib/src/sales/sales_history_screen.dart` with:

```dart
import 'package:flutter/material.dart';

class SalesHistoryScreen extends StatelessWidget {
  const SalesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sales')),
      body: const Center(child: Text('No sales recorded yet')),
    );
  }
}
```

Replace `stockmate/lib/src/reports/reports_screen.dart` with:

```dart
import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(title: Text('Revenue'), subtitle: Text('Sales totals after discounts')),
          ListTile(title: Text('Gross Profit'), subtitle: Text('Revenue minus batch costs')),
          ListTile(title: Text('Top Products'), subtitle: Text('Best-selling products by quantity')),
          ListTile(title: Text('Stock Value'), subtitle: Text('Remaining stock valued by batch cost')),
        ],
      ),
    );
  }
}
```

- [ ] **Step 5: Run dashboard/report tests**

Run:

```bash
cd stockmate
flutter test test/dashboard test/reports
```

Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add stockmate/lib/src/dashboard stockmate/lib/src/sales stockmate/lib/src/reports stockmate/test/dashboard stockmate/test/reports
git commit -m "feat: add dashboard sales and reports surfaces"
```

## Task 10: Add Integration Smoke Test and Final Verification

**Files:**
- Create: `stockmate/integration_test/app_smoke_test.dart`
- Modify: `stockmate/pubspec.yaml`
- Test: all tests

- [ ] **Step 1: Add integration test dependency**

Run:

```bash
cd stockmate
flutter pub add integration_test --dev --sdk=flutter
```

Expected: `integration_test` appears under `dev_dependencies`.

- [ ] **Step 2: Create smoke test**

Create `stockmate/integration_test/app_smoke_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:stockmate/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app opens dashboard and navigates main tabs', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsOneWidget);

    await tester.tap(find.text('Inventory'));
    await tester.pumpAndSettle();
    expect(find.text('Inventory'), findsOneWidget);

    await tester.tap(find.text('Scan'));
    await tester.pumpAndSettle();
    expect(find.text('Scan Product'), findsOneWidget);

    await tester.tap(find.text('Sales'));
    await tester.pumpAndSettle();
    expect(find.text('Sales'), findsOneWidget);

    await tester.tap(find.text('Reports'));
    await tester.pumpAndSettle();
    expect(find.text('Reports'), findsOneWidget);
  });
}
```

- [ ] **Step 3: Run unit and widget test suite**

Run:

```bash
cd stockmate
flutter test
```

Expected: PASS for all unit and widget tests.

- [ ] **Step 4: Run analyzer**

Run:

```bash
cd stockmate
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 5: Run iOS simulator smoke test**

Run:

```bash
cd stockmate
flutter test integration_test/app_smoke_test.dart
```

Expected: PASS on a configured iOS simulator. If no simulator is available, record the exact device error and run `flutter devices` to confirm the environment state.

- [ ] **Step 6: Build iOS debug app**

Run:

```bash
cd stockmate
flutter build ios --debug --no-codesign
```

Expected: iOS debug build completes without code signing.

- [ ] **Step 7: Commit**

```bash
git add stockmate
git commit -m "test: add integration smoke coverage"
```

## Final Verification Commands

Run these before claiming the build is ready:

```bash
cd stockmate
dart run build_runner build --delete-conflicting-outputs
flutter test
flutter analyze
flutter build ios --debug --no-codesign
```

Expected:

- Drift generated files are current.
- All tests pass.
- Analyzer reports no issues.
- iOS debug build succeeds.

## Implementation Notes

- Store all money as integer minor units to avoid floating-point rounding errors.
- Keep sales atomic. A sale must not save unless stock batch allocation, sale rows, batch updates, and receipt metadata all succeed.
- Use oldest stock batches first for gross profit.
- Keep scanning usable without camera permission by preserving manual code entry.
- Treat backup, sync, tax, staff accounts, and multi-branch support as post-v1 work.

## Sources Checked on 2026-06-13

- `drift` package page: Drift is a reactive SQLite persistence library for Dart and Flutter.
- `drift_flutter` package page: provides Flutter-specific Drift database opening helpers.
- `mobile_scanner` package page: supports barcode and QR scanning on iOS through Apple Vision and AVFoundation.
- Flutter testing overview: unit, widget, and integration tests are the relevant test layers.
