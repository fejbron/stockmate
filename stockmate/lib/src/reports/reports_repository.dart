import '../data/app_database.dart';

class ReportTopProduct {
  const ReportTopProduct({
    required this.name,
    required this.quantitySold,
    required this.revenueMinor,
  });

  final String name;
  final int quantitySold;
  final int revenueMinor;
}

class ReportsSummary {
  const ReportsSummary({
    required this.revenueMinor,
    required this.grossProfitMinor,
    required this.stockValueMinor,
    required this.topProducts,
  });

  final int revenueMinor;
  final int grossProfitMinor;
  final int stockValueMinor;
  final List<ReportTopProduct> topProducts;
}

class ReportsRepository {
  ReportsRepository(this.db);

  final AppDatabase db;

  Stream<ReportsSummary> watchSummary() {
    return db
        .customSelect(
          'SELECT 1 AS refresh_key',
          readsFrom: {db.sales, db.saleLines, db.products, db.stockBatches},
        )
        .watchSingle()
        .asyncMap((_) => _readSummary());
  }

  Future<ReportsSummary> _readSummary() async {
    final totals = await db
        .customSelect(
          '''
          SELECT
            COALESCE(SUM(total_minor), 0) AS revenue_minor,
            COALESCE(SUM(gross_profit_minor), 0) AS gross_profit_minor
          FROM sales
          ''',
          readsFrom: {db.sales},
        )
        .getSingle();

    final stock = await db
        .customSelect(
          '''
          SELECT COALESCE(SUM(quantity_remaining * cost_per_unit_minor), 0)
            AS stock_value_minor
          FROM stock_batches
          ''',
          readsFrom: {db.stockBatches},
        )
        .getSingle();

    final topProductRows = await db
        .customSelect(
          '''
          SELECT
            p.name,
            COALESCE(SUM(sl.quantity), 0) AS quantity_sold,
            COALESCE(SUM(sl.line_total_minor), 0) AS revenue_minor
          FROM sale_lines sl
          INNER JOIN products p ON p.id = sl.product_id
          GROUP BY p.id, p.name
          ORDER BY quantity_sold DESC, revenue_minor DESC, LOWER(p.name)
          LIMIT 5
          ''',
          readsFrom: {db.saleLines, db.products},
        )
        .get();

    return ReportsSummary(
      revenueMinor: totals.read<int>('revenue_minor'),
      grossProfitMinor: totals.read<int>('gross_profit_minor'),
      stockValueMinor: stock.read<int>('stock_value_minor'),
      topProducts: [
        for (final row in topProductRows)
          ReportTopProduct(
            name: row.read<String>('name'),
            quantitySold: row.read<int>('quantity_sold'),
            revenueMinor: row.read<int>('revenue_minor'),
          ),
      ],
    );
  }
}
