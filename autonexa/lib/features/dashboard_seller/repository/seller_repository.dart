import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:autonexa/models/seller_dashboard_model.dart';
import 'package:autonexa/core/providers/supabase_provider.dart';

final sellerRepositoryProvider = Provider((ref) {
  return SellerRepository(supabase: ref.watch(supabaseProvider));
});

class SellerRepository {
  final SupabaseClient _supabase;

  SellerRepository({required SupabaseClient supabase}) : _supabase = supabase;

  Future<SellerOverviewModel> fetchSellerOverview(String sellerId) async {
    try {
      // Attempt to fetch from backend fully
      final res = await _supabase
          .from('seller_analytics')
          .select()
          .eq('seller_id', sellerId)
          .maybeSingle();

      if (res != null) {
        // Map backend response if it exists
        final recentOrdersData = await _supabase
            .from('recent_orders')
            .select()
            .eq('seller_id', sellerId)
            .limit(3);

        return SellerOverviewModel(
          totalSales: (res['total_sales'] as num?)?.toDouble() ?? 0,
          salesGrowth: (res['sales_growth'] as num?)?.toDouble() ?? 0,
          ordersPending: (res['orders_pending'] as num?)?.toInt() ?? 0,
          weeklySales:
              (res['weekly_sales'] as List<dynamic>?)
                  ?.map(
                    (e) => SalesDailyModel(
                      day: e['day'] ?? 'MON',
                      amount: (e['amount'] as num?)?.toDouble() ?? 0,
                    ),
                  )
                  .toList() ??
              [],
          recentOrders: recentOrdersData
              .map((e) => RecentOrderModel.fromMap(e))
              .toList(),
        );
      }
    } catch (e) {
      // Print backend error
      print("Error fetching from Supabase, reverting to mockup data: $e");
    }

    // Fallback Mock Data matching the UI perfectly so the user
    // sees the required mockup instantly while the backend schema is built.
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate network
    return SellerOverviewModel(
      totalSales: 4250.0,
      salesGrowth: 15.0,
      ordersPending: 12,
      weeklySales: [
        SalesDailyModel(day: 'MON', amount: 300),
        SalesDailyModel(day: 'TUE', amount: 500),
        SalesDailyModel(day: 'WED', amount: 800), // Max height
        SalesDailyModel(day: 'THU', amount: 480),
        SalesDailyModel(day: 'FRI', amount: 650),
        SalesDailyModel(day: 'SAT', amount: 200),
        SalesDailyModel(day: 'SUN', amount: 450),
      ],
      recentOrders: [
        RecentOrderModel(
          id: '1',
          orderNumber: '#AN-9021',
          title: 'V8 Engine Gasket Set',
          price: 189.00,
          status: 'NEW',
          iconCode: 'engine',
        ),
        RecentOrderModel(
          id: '2',
          orderNumber: '#AN-8955',
          title: 'Performance Brake Pads',
          price: 75.50,
          status: 'PROCESSING',
          iconCode: 'brakes',
        ),
        RecentOrderModel(
          id: '3',
          orderNumber: '#AN-8840',
          title: 'Synthetic Oil Filter x5',
          price: 42.00,
          status: 'SHIPPED',
          iconCode: 'oil',
        ),
      ],
    );
  }

  Future<List<InventoryProductModel>> fetchInventory(String sellerId) async {
    try {
      final res = await _supabase
          .from('inventory')
          .select()
          .eq('seller_id', sellerId);

      if (res.isNotEmpty) {
        return res.map((e) => InventoryProductModel.fromMap(e)).toList();
      }
    } catch (e) {
      print(
        "Error fetching inventory from Supabase, reverting to mockup data: $e",
      );
    }

    // Fallback Mock Data matching the UI perfectly
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate network
    return [
      InventoryProductModel(
        id: '1',
        name: 'Performance Brake Pads',
        sku: 'AN-8955',
        price: 120.00,
        stock: 15,
        iconCode: 'brakes',
      ),
      InventoryProductModel(
        id: '2',
        name: 'V8 Engine Gasket Set',
        sku: 'AN-9021',
        price: 189.00,
        stock: 8,
        iconCode: 'engine',
      ),
      InventoryProductModel(
        id: '3',
        name: 'Synthetic Oil Filter x5',
        sku: 'AN-8840',
        price: 42.00,
        stock: 2,
        iconCode: 'oil',
      ),
      InventoryProductModel(
        id: '4',
        name: 'Aluminium Radiator',
        sku: 'AN-7722',
        price: 215.00,
        stock: 24,
        iconCode: 'parts',
      ),
    ];
  }

  Future<List<DetailedOrderModel>> fetchOrders(String sellerId) async {
    try {
      final res = await _supabase
          .from('orders')
          .select()
          .eq('seller_id', sellerId);

      if (res.isNotEmpty) {
        return res.map((e) => DetailedOrderModel.fromMap(e)).toList();
      }
    } catch (e) {
      print(
        "Error fetching orders from Supabase, reverting to mockup data: $e",
      );
    }

    // Fallback Mock Data matching the UI perfectly
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate network
    return [
      DetailedOrderModel(
        id: '1',
        status: 'PENDING',
        orderNumber: '#AN-9924',
        customerName: 'Marcus Sterling',
        info: '1x Apex GT Suspension Kit',
        date: 'Oct 26, 2023',
        price: 89450.00,
        imageUrl: '', // Will show icon or placeholder if empty
      ),
      DetailedOrderModel(
        id: '2',
        status: 'SHIPPED',
        orderNumber: '#AN-9812',
        customerName: 'Elena Rodriguez',
        info: 'Tracking: NEXA-77382-US',
        date: 'Oct 24, 2023',
        price: 1240.00,
        imageUrl: '',
      ),
      DetailedOrderModel(
        id: '3',
        status: 'DELIVERED',
        orderNumber: '#AN-8744',
        customerName: 'David Chen',
        info: 'Delivered Oct 23, 2023',
        date: 'Oct 21, 2023',
        price: 4500.00,
        imageUrl: '',
      ),
    ];
  }
}
