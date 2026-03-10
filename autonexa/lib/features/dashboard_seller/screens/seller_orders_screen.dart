import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/core/common/loader.dart';
import 'package:autonexa/models/seller_dashboard_model.dart';
import 'package:autonexa/features/dashboard_seller/controller/seller_controller.dart';
import 'package:autonexa/features/dashboard_seller/widgets/detailed_order_card.dart';
import 'package:autonexa/theme/pallete.dart';

class SellerOrdersScreen extends ConsumerStatefulWidget {
  const SellerOrdersScreen({super.key});

  @override
  ConsumerState<SellerOrdersScreen> createState() => _SellerOrdersScreenState();
}

class _SellerOrdersScreenState extends ConsumerState<SellerOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildOrderList(
    List<DetailedOrderModel> orders,
    String? filterStatus,
  ) {
    final filteredOrders = filterStatus == null
        ? orders
        : orders
              .where(
                (o) => o.status.toUpperCase() == filterStatus.toUpperCase(),
              )
              .toList();

    if (filteredOrders.isEmpty) {
      return Center(
        child: Text(
          'No orders found for this status.',
          style: TextStyle(color: Colors.white60),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 24, bottom: 120, left: 24, right: 24),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        return DetailedOrderCard(order: filteredOrders[index]);
      },
      physics: const BouncingScrollPhysics(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ordersFuture = ref.watch(sellerOrdersProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Attempt to match the specific mockup color gradient, or fallback to the theme's core background.
    // The mockup uses a deep blue tone.
    final bgColor = isDark ? const Color(0xFF1E2856) : Colors.white;
    final accentColor = Pallete.secondaryColor;
    final textColor = isDark ? Colors.white : Pallete.textColor;
    final subTextColor = isDark ? Colors.white60 : Pallete.textSecondaryColor;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: accentColor),
          onPressed: () {},
        ),
        title: Text(
          'Orders',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: textColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: textColor),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: accentColor,
          labelColor: accentColor,
          unselectedLabelColor: subTextColor,
          dividerColor: Colors.transparent, // Disable the gray bar at bottom
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Shipped'),
            Tab(text: 'Delivered'),
          ],
        ),
      ),
      body: ordersFuture.when(
        data: (orders) => TabBarView(
          controller: _tabController,
          children: [
            _buildOrderList(orders, null),
            _buildOrderList(orders, 'PENDING'),
            _buildOrderList(orders, 'SHIPPED'),
            _buildOrderList(orders, 'DELIVERED'),
          ],
        ),
        loading: () => const Loader(),
        error: (error, stack) => Center(
          child: Text(error.toString(), style: TextStyle(color: textColor)),
        ),
      ),
    );
  }
}
