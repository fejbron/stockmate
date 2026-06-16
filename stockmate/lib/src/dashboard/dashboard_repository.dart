import '../data/app_database.dart';

class DashboardMetrics {
  const DashboardMetrics({
    required this.revenueMinor,
    required this.grossProfitMinor,
    required this.salesCount,
    required this.lowStockCount,
  });

  final int revenueMinor;
  final int grossProfitMinor;
  final int salesCount;
  final int lowStockCount;
}

class DashboardRepository {
  DashboardRepository(this.db);

  final AppDatabase db;

  Stream<DashboardMetrics> watchMetrics() {
    return db
        .customSelect(
          '''
          SELECT
            COALESCE((SELECT SUM(total_minor) FROM sales), 0) AS revenue_minor,
            COALESCE((SELECT SUM(gross_profit_minor) FROM sales), 0) AS gross_profit_minor,
            COALESCE((SELECT COUNT(*) FROM sales), 0) AS sales_count,
            COALESCE((
              SELECT COUNT(*)
              FROM (
                SELECT
                  p.id,
                  p.low_stock_threshold,
                  COALESCE(SUM(sb.quantity_remaining), 0) AS stock_quantity
                FROM products p
                LEFT JOIN stock_batches sb ON sb.product_id = p.id
                WHERE p.is_active = 1
                GROUP BY p.id, p.low_stock_threshold
                HAVING stock_quantity <= p.low_stock_threshold
              ) low_stock_products
            ), 0) AS low_stock_count
          ''',
          readsFrom: {db.sales, db.products, db.stockBatches},
        )
        .watchSingle()
        .map(
          (row) => DashboardMetrics(
            revenueMinor: row.read<int>('revenue_minor'),
            grossProfitMinor: row.read<int>('gross_profit_minor'),
            salesCount: row.read<int>('sales_count'),
            lowStockCount: row.read<int>('low_stock_count'),
          ),
        );
  }
}
