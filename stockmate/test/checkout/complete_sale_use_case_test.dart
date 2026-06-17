import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/checkout/cart_models.dart';
import 'package:stockmate/src/checkout/checkout_repository.dart';
import 'package:stockmate/src/checkout/complete_sale_use_case.dart';
import 'package:stockmate/src/checkout/stock_allocator.dart';
import 'package:stockmate/src/data/app_database.dart';
import 'package:stockmate/src/shared/result.dart';

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
    final productId = await db
        .into(db.products)
        .insert(ProductsCompanion.insert(name: 'Milk', sellingPriceMinor: 500));
    await db
        .into(db.stockBatches)
        .insert(
          StockBatchesCompanion.insert(
            productId: productId,
            quantityReceived: 2,
            quantityRemaining: 2,
            costPerUnitMinor: 300,
            receivedAt: Value(DateTime(2026, 1, 1)),
          ),
        );
    await db
        .into(db.stockBatches)
        .insert(
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
    final batches = await (db.select(
      db.stockBatches,
    )..orderBy([(row) => OrderingTerm.asc(row.id)])).get();
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

  test(
    'handles duplicate product lines without double-consuming stock',
    () async {
      final productId = await db
          .into(db.products)
          .insert(
            ProductsCompanion.insert(name: 'Rice', sellingPriceMinor: 500),
          );
      await db
          .into(db.stockBatches)
          .insert(
            StockBatchesCompanion.insert(
              productId: productId,
              quantityReceived: 5,
              quantityRemaining: 5,
              costPerUnitMinor: 100,
            ),
          );

      final result = await useCase.completeSale(
        cart: Cart(
          lines: [
            CartLine(
              productId: productId,
              name: 'Rice',
              quantity: 1,
              unitPriceMinor: 500,
              discountMinor: 0,
            ),
            CartLine(
              productId: productId,
              name: 'Rice',
              quantity: 2,
              unitPriceMinor: 500,
              discountMinor: 0,
            ),
          ],
          paymentMethod: 'cash',
          amountPaidMinor: 1500,
        ),
      );

      expect(result.isSuccess, true);
      final sale = await db.select(db.sales).getSingle();
      final batch = await db.select(db.stockBatches).getSingle();
      final lines = await db.select(db.saleLines).get();
      final allocations = await db.select(db.saleLineBatchAllocations).get();

      expect(sale.costTotalMinor, 300);
      expect(batch.quantityRemaining, 2);
      expect(lines.length, 2);
      expect(allocations.length, 2);
      expect(allocations[0].quantity, 1);
      expect(allocations[1].quantity, 2);
    },
  );

  test('records partial payment and consumes stock', () async {
    final productId = await db
        .into(db.products)
        .insert(ProductsCompanion.insert(name: 'Tea', sellingPriceMinor: 800));
    await db
        .into(db.stockBatches)
        .insert(
          StockBatchesCompanion.insert(
            productId: productId,
            quantityReceived: 2,
            quantityRemaining: 2,
            costPerUnitMinor: 300,
          ),
        );

    final result = await useCase.completeSale(
      cart: Cart(
        lines: [
          CartLine(
            productId: productId,
            name: 'Tea',
            quantity: 1,
            unitPriceMinor: 800,
            discountMinor: 0,
          ),
        ],
        paymentMethod: 'cash',
        amountPaidMinor: 500,
      ),
    );

    expect(result.isSuccess, true);
    final sale = await db.select(db.sales).getSingle();
    expect(sale.totalMinor, 800);
    expect(sale.amountPaidMinor, 500);
    expect(sale.changeDueMinor, 0);
    expect((await db.select(db.stockBatches).getSingle()).quantityRemaining, 1);
  });

  test('returns failure without writing a sale when cart is empty', () async {
    final result = await useCase.completeSale(
      cart: const Cart(lines: [], paymentMethod: 'cash', amountPaidMinor: null),
    );

    expect(result.isSuccess, false);
    expect(await db.select(db.sales).get(), isEmpty);
  });

  test(
    'does not oversell when two sales race for the same single unit of stock',
    () async {
      final productId = await db
          .into(db.products)
          .insert(
            ProductsCompanion.insert(name: 'Sugar', sellingPriceMinor: 500),
          );
      await db
          .into(db.stockBatches)
          .insert(
            StockBatchesCompanion.insert(
              productId: productId,
              quantityReceived: 1,
              quantityRemaining: 1,
              costPerUnitMinor: 200,
            ),
          );

      Cart buildCart() => Cart(
        lines: [
          CartLine(
            productId: productId,
            name: 'Sugar',
            quantity: 1,
            unitPriceMinor: 500,
            discountMinor: 0,
          ),
        ],
        paymentMethod: 'cash',
        amountPaidMinor: 500,
      );

      // Both sales read the same remaining quantity before either persists.
      // Exactly one must succeed; the other must return a clean AppFailure
      // (never throw, never oversell past the CHECK(quantity_remaining >= 0)).
      late List<AppResult<CompleteSaleResult>> results;
      await expectLater(() async {
        results = await Future.wait([
          useCase.completeSale(cart: buildCart()),
          useCase.completeSale(cart: buildCart()),
        ]);
      }(), completes);

      final successes = results.where((r) => r.isSuccess).length;
      final failures = results.where((r) => !r.isSuccess).length;
      expect(successes, 1);
      expect(failures, 1);

      final batch = await db.select(db.stockBatches).getSingle();
      expect(batch.quantityRemaining, 0);
      final sales = await db.select(db.sales).get();
      expect(sales.length, 1);
    },
  );
}
