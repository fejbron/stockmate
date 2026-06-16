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

  @override
  List<String> get customConstraints => [
    'CHECK (selling_price_minor >= 0)',
    'CHECK (low_stock_threshold >= 0)',
  ];
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

  @override
  List<String> get customConstraints => [
    'CHECK (quantity_received >= 0)',
    'CHECK (quantity_remaining >= 0)',
    'CHECK (quantity_remaining <= quantity_received)',
    'CHECK (cost_per_unit_minor >= 0)',
  ];
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
  IntColumn get discountTotalMinor =>
      integer().withDefault(const Constant(0))();
  IntColumn get totalMinor => integer()();
  IntColumn get costTotalMinor => integer()();
  IntColumn get grossProfitMinor => integer()();
  TextColumn get paymentMethod => text()();
  IntColumn get amountPaidMinor => integer().nullable()();
  IntColumn get changeDueMinor => integer().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => [
    'CHECK (subtotal_minor >= 0)',
    'CHECK (discount_total_minor >= 0)',
    'CHECK (total_minor >= 0)',
    'CHECK (cost_total_minor >= 0)',
    'CHECK (amount_paid_minor IS NULL OR amount_paid_minor >= 0)',
    'CHECK (change_due_minor IS NULL OR change_due_minor >= 0)',
  ];
}

class SaleLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleId => integer().references(Sales, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get quantity => integer()();
  IntColumn get unitPriceMinor => integer()();
  IntColumn get discountAmountMinor =>
      integer().withDefault(const Constant(0))();
  IntColumn get lineTotalMinor => integer()();
  IntColumn get costTotalMinor => integer()();
  IntColumn get grossProfitMinor => integer()();

  @override
  List<String> get customConstraints => [
    'CHECK (quantity > 0)',
    'CHECK (unit_price_minor >= 0)',
    'CHECK (discount_amount_minor >= 0)',
    'CHECK (line_total_minor >= 0)',
    'CHECK (cost_total_minor >= 0)',
  ];
}

class SaleLineBatchAllocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleLineId => integer().references(SaleLines, #id)();
  IntColumn get stockBatchId => integer().references(StockBatches, #id)();
  IntColumn get quantity => integer()();
  IntColumn get costPerUnitMinor => integer()();
  IntColumn get costTotalMinor => integer()();

  @override
  List<String> get customConstraints => [
    'CHECK (quantity > 0)',
    'CHECK (cost_per_unit_minor >= 0)',
    'CHECK (cost_total_minor >= 0)',
  ];
}

class Receipts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleId => integer().references(Sales, #id).unique()();
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

  AppDatabase.defaults()
    : super(
        driftDatabase(
          name: 'stockmate',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
