import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/core/common/loader.dart';
import 'package:autonexa/features/auth/controller/auth_controller.dart';
import 'package:autonexa/features/dashboard_seller/controller/seller_controller.dart';
import 'package:autonexa/features/dashboard_seller/widgets/dashboard_top_metric_card.dart';
import 'package:autonexa/features/dashboard_seller/widgets/sales_analytics_chart.dart';
import 'package:autonexa/features/dashboard_seller/widgets/recent_order_tile.dart';
import 'package:autonexa/theme/pallete.dart';

class SellerOverviewScreen extends ConsumerWidget {
  const SellerOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final sellerFuture = ref.watch(sellerOverviewProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = Pallete.secondaryColor;
    final textColor = isDark ? Colors.white : Pallete.textColor;
    final secondaryTextColor = isDark
        ? Colors.white60
        : Pallete.textSecondaryColor;

    return sellerFuture.when(
      data: (data) => SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom App Bar Area
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.eco, color: accentColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AUTONEXA',
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        user?.name ?? 'Alex Rivera',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.notifications_active, color: textColor),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Dashboard Overview
            Text(
              'Dashboard Overview',
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Here's how your shop is performing today.",
              style: TextStyle(color: secondaryTextColor, fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Top Metrics Row
            Row(
              children: [
                DashboardTopMetricCard(
                  icon: Icons.payments_outlined,
                  title: 'Total Sales',
                  value: '\$${data.totalSales.toStringAsFixed(0)}',
                  badgeText: '+${data.salesGrowth.toStringAsFixed(0)}%',
                ),
                const SizedBox(width: 16),
                DashboardTopMetricCard(
                  icon: Icons.assignment_outlined,
                  title: 'Orders Pending',
                  value: '${data.ordersPending}',
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Sales Analytics Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sales Analytics',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Weekly',
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Chart
            SalesAnalyticsChart(data: data.weeklySales),
            const SizedBox(height: 32),

            // Recent Orders Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Orders',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'View All',
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Recent Orders List
            ...data.recentOrders.map((order) => RecentOrderTile(order: order)),

            // Extra padding for bottom nav
            const SizedBox(height: 100),
          ],
        ),
      ),
      loading: () => const Loader(),
      error: (error, stack) => Center(
        child: Text(error.toString(), style: TextStyle(color: textColor)),
      ),
    );
  }
}
