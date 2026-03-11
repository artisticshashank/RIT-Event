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
          salesGrowth: 0.0,
          ordersPending: (analyticsRes['orders_pending'] as int?) ?? 0,
          weeklySales: [],
          recentOrders: (ordersRes as List).map((e) {
            final cust = e['customer'] as Map<String, dynamic>? ?? {};
            return DetailedOrderModel(
              id: e['id'] ?? '',
              orderNumber: e['order_number'] ?? '',
              info: e['info'] ?? '',
              price: (e['total_amount'] as num?)?.toDouble() ?? 0.0,
              status: e['status'] ?? 'NEW',
              date: e['created_at'] != null
                  ? DateTime.tryParse(
                          e['created_at'],
                        )?.toLocal().toString().substring(0, 10) ??
                        ''
                  : '',
              customerName: cust['name'] ?? 'Customer',
              imageUrl: e['image_url'] ?? '',
            );
          }).toList(),
        );
      }
    } catch (e) {
      print('Seller overview fetch error: $e');
    }

    // Default real empty state if no view or data
    return SellerOverviewModel(
      totalSales: 0.0,
      salesGrowth: 0.0,
      ordersPending: 0,
      weeklySales: [],
      recentOrders: [],
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
        return (res as List)
            .map((e) => InventoryProductModel.fromMap(e))
            .toList();
      }
    } catch (e) {
      print('Seller inventory fetch error: $e');
    }

    return [];
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
                ? DateTime.tryParse(
                        e['created_at'],
                      )?.toLocal().toString().substring(0, 10) ??
                      ''
                : '',
            price: (e['total_amount'] as num?)?.toDouble() ?? 0.0,
            imageUrl: e['image_url'] ?? '',
          );
        }).toList();
      }
    } catch (e) {
      print('Seller orders fetch error: $e');
    }

    return [];
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

  // ── Update Product: UPDATE spare_parts ────────────────────────────────────
  Future<bool> updateProduct({
    required String productId,
    required String name,
    required String description,
    required double price,
    required int stock,
    String? sku,
    String? category,
  }) async {
    try {
      await _supabase
          .from('spare_parts')
          .update({
            'name': name,
            'description': description,
            'price': price,
            'stock_quantity': stock,
            'sku': sku,
            'category': category,
          })
          .eq('id', productId);
      return true;
    } catch (e) {
      print('Update product error: $e');
      return false;
    }
  }

  // ── Update Order Status ────────────────────────────────────────────────────
  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _supabase
          .from('orders')
          .update({
            'status': newStatus,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId);
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
      await _supabase
          .from('spare_parts')
          .update({'stock_quantity': newStock})
          .eq('id', productId);
      return true;
    } catch (e) {
      print('Update stock error: $e');
      return false;
    }
  }
}
