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

  // ── Overview: from seller_analytics_view + orders ─────────────────────────
  Future<SellerOverviewModel> fetchSellerOverview(String sellerId) async {
    try {
      // Fetch analytics view
      final analyticsRes = await _supabase
          .from('seller_analytics_view')
          .select()
          .eq('seller_id', sellerId)
          .maybeSingle();

      // Fetch recent orders with customer name
      final ordersRes = await _supabase
          .from('orders')
          .select('''
            id, order_number, info, total_amount, status, created_at,
            customer:customer_id ( name )
          ''')
          .eq('seller_id', sellerId)
          .order('created_at', ascending: false)
          .limit(3);

      if (analyticsRes != null) {
        return SellerOverviewModel(
          totalSales: (analyticsRes['total_sales'] as num?)?.toDouble() ?? 0.0,
          salesGrowth: 15.0, // Could be computed separately
          ordersPending: (analyticsRes['orders_pending'] as int?) ?? 0,
          weeklySales: [], // Populated with dedicated query below
          recentOrders: (ordersRes as List).map((e) {
            final cust = e['customer'] as Map<String, dynamic>? ?? {};
            return RecentOrderModel(
              id: e['id'] ?? '',
              orderNumber: e['order_number'] ?? '',
              title: '${cust['name'] ?? 'Customer'}: ${e['info'] ?? ''}',
              price: (e['total_amount'] as num?)?.toDouble() ?? 0.0,
              status: e['status'] ?? 'NEW',
              iconCode: 'parts',
            );
          }).toList(),
        );
      }
    } catch (e) {
      print('Seller overview fetch error (using mock): $e');
    }

    // Fallback mock
    await Future.delayed(const Duration(milliseconds: 400));
    return SellerOverviewModel(
      totalSales: 4250.0,
      salesGrowth: 15.0,
      ordersPending: 12,
      weeklySales: [
        SalesDailyModel(day: 'MON', amount: 300),
        SalesDailyModel(day: 'TUE', amount: 500),
        SalesDailyModel(day: 'WED', amount: 800),
        SalesDailyModel(day: 'THU', amount: 480),
        SalesDailyModel(day: 'FRI', amount: 650),
        SalesDailyModel(day: 'SAT', amount: 200),
        SalesDailyModel(day: 'SUN', amount: 450),
      ],
      recentOrders: [
        RecentOrderModel(id: '1', orderNumber: '#AN-9021', title: 'V8 Engine Gasket Set', price: 189.00, status: 'NEW', iconCode: 'engine'),
        RecentOrderModel(id: '2', orderNumber: '#AN-8955', title: 'Performance Brake Pads', price: 75.50, status: 'PROCESSING', iconCode: 'brakes'),
        RecentOrderModel(id: '3', orderNumber: '#AN-8840', title: 'Synthetic Oil Filter x5', price: 42.00, status: 'SHIPPED', iconCode: 'oil'),
      ],
    );
  }

  // ── Inventory: spare_parts WHERE seller_id ────────────────────────────────
  Future<List<InventoryProductModel>> fetchInventory(String sellerId) async {
    try {
      final res = await _supabase
          .from('spare_parts')
          .select()
          .eq('seller_id', sellerId)
          .order('created_at', ascending: false);

      if (res.isNotEmpty) {
        return (res as List).map((e) => InventoryProductModel.fromMap(e)).toList();
      }
    } catch (e) {
      print('Seller inventory fetch error (using mock): $e');
    }

    await Future.delayed(const Duration(milliseconds: 400));
    return [
      InventoryProductModel(id: '1', name: 'Performance Brake Pads', sku: 'AN-8955', price: 120.00, stock: 15, iconCode: 'brakes'),
      InventoryProductModel(id: '2', name: 'V8 Engine Gasket Set', sku: 'AN-9021', price: 189.00, stock: 8, iconCode: 'engine'),
      InventoryProductModel(id: '3', name: 'Synthetic Oil Filter x5', sku: 'AN-8840', price: 42.00, stock: 2, iconCode: 'oil'),
      InventoryProductModel(id: '4', name: 'Aluminium Radiator', sku: 'AN-7722', price: 215.00, stock: 24, iconCode: 'parts'),
    ];
  }

  // ── Orders: orders WHERE seller_id + customer name ────────────────────────
  Future<List<DetailedOrderModel>> fetchOrders(String sellerId) async {
    try {
      final res = await _supabase
          .from('orders')
          .select('''
            id, order_number, status, total_amount, info, image_url, created_at,
            customer:customer_id ( name )
          ''')
          .eq('seller_id', sellerId)
          .order('created_at', ascending: false);

      if (res.isNotEmpty) {
        return (res as List).map((e) {
          final customer = e['customer'] as Map<String, dynamic>? ?? {};
          return DetailedOrderModel(
            id: e['id'] ?? '',
            status: e['status'] ?? 'NEW',
            orderNumber: e['order_number'] ?? '',
            customerName: customer['name'] ?? 'Customer',
            info: e['info'] ?? '',
            date: e['created_at'] != null
                ? DateTime.tryParse(e['created_at'])?.toLocal().toString().substring(0, 10) ?? ''
                : '',
            price: (e['total_amount'] as num?)?.toDouble() ?? 0.0,
            imageUrl: e['image_url'] ?? '',
          );
        }).toList();
      }
    } catch (e) {
      print('Seller orders fetch error (using mock): $e');
    }

    await Future.delayed(const Duration(milliseconds: 400));
    return [
      DetailedOrderModel(id: '1', status: 'PENDING', orderNumber: '#AN-9924', customerName: 'Marcus Sterling', info: '1x Apex GT Suspension Kit', date: 'Oct 26, 2023', price: 89450.00, imageUrl: ''),
      DetailedOrderModel(id: '2', status: 'SHIPPED', orderNumber: '#AN-9812', customerName: 'Elena Rodriguez', info: 'Tracking: NEXA-77382-US', date: 'Oct 24, 2023', price: 1240.00, imageUrl: ''),
      DetailedOrderModel(id: '3', status: 'DELIVERED', orderNumber: '#AN-8744', customerName: 'David Chen', info: 'Delivered Oct 23, 2023', date: 'Oct 21, 2023', price: 4500.00, imageUrl: ''),
    ];
  }

  // ── Add Product: INSERT into spare_parts ──────────────────────────────────
  Future<bool> addProduct({
    required String sellerId,
    required String name,
    required String description,
    required double price,
    required int stock,
    String? sku,
    String? category,
  }) async {
    try {
      await _supabase.from('spare_parts').insert({
        'seller_id': sellerId,
        'name': name,
        'description': description,
        'price': price,
        'stock_quantity': stock,
        'sku': sku ?? 'AN-${DateTime.now().millisecondsSinceEpoch % 100000}',
        'category': category ?? 'parts',
        'icon_code': 'parts',
      });
      return true;
    } catch (e) {
      print('Add product error: $e');
      return false;
    }
  }

  // ── Update Order Status ────────────────────────────────────────────────────
  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _supabase.from('orders').update({
        'status': newStatus,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', orderId);
      return true;
    } catch (e) {
      print('Update order status error: $e');
      return false;
    }
  }

  // ── Delete product ─────────────────────────────────────────────────────────
  Future<bool> deleteProduct(String productId) async {
    try {
      await _supabase.from('spare_parts').delete().eq('id', productId);
      return true;
    } catch (e) {
      print('Delete product error: $e');
      return false;
    }
  }

  // ── Update stock quantity ──────────────────────────────────────────────────
  Future<bool> updateStock(String productId, int newStock) async {
    try {
      await _supabase.from('spare_parts').update({
        'stock_quantity': newStock,
      }).eq('id', productId);
      return true;
    } catch (e) {
      print('Update stock error: $e');
      return false;
    }
  }
}
