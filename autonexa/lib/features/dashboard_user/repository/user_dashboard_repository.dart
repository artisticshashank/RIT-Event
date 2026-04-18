import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:autonexa/models/vehicle_model.dart';
import 'package:autonexa/models/service_request_model.dart';
import 'package:autonexa/models/spare_part_model.dart';
import 'package:autonexa/models/user_model.dart';
import 'package:autonexa/models/enums.dart';
import 'package:autonexa/models/seller_dashboard_model.dart';
import 'package:fpdart/fpdart.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDashboardRepositoryProvider = Provider((ref) {
  return UserDashboardRepository(supabase: Supabase.instance.client);
});

class UserDashboardRepository {
  final SupabaseClient _supabase;

  UserDashboardRepository({required SupabaseClient supabase})
    : _supabase = supabase;

  // ── Vehicles for current user ─────────────────────────────────────────────
  Future<Either<String, List<VehicleModel>>> getUserVehicles(
    String userId,
  ) async {
    try {
      final res = await _supabase
          .from('vehicles')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return right((res as List).map((e) => VehicleModel.fromMap(e)).toList());
    } catch (e) {
      print('Get user vehicles error: $e');
      return right([]);
    }
  }

  // ── Add vehicle ───────────────────────────────────────────────────────────
  Future<Either<String, bool>> addVehicle({
    required String userId,
    required String make,
    required String model,
    required int year,
    required String licensePlate,
    String fuelType = '95 OCT',
  }) async {
    try {
      await _supabase.from('vehicles').insert({
        'user_id': userId,
        'make': make,
        'model': model,
        'year': year,
        'license_plate': licensePlate,
        'fuel_type': fuelType,
      });
      return right(true);
    } catch (e) {
      return left('Failed to add vehicle: $e');
    }
  }

  // ── My service requests ───────────────────────────────────────────────────
  Future<Either<String, List<ServiceRequestModel>>> getUserServiceRequests(
    String userId,
  ) async {
    try {
      final res = await _supabase
          .from('service_requests')
          .select('''
            *,
            responder:responder_id ( id, name, rating, avatar_url )
          ''')
          .eq('requester_id', userId)
          .order('created_at', ascending: false);
      return right(
        (res as List).map((e) => ServiceRequestModel.fromMap(e)).toList(),
      );
    } catch (e) {
      print('Get service requests error: $e');
      return right([]);
    }
  }

  // ── Post a new service request ────────────────────────────────────────────
  Future<Either<String, ServiceRequestModel>> createServiceRequest({
    required String requesterId,
    required ServiceType requestType,
    required double locationLat,
    required double locationLng,
    String? locationAddress,
    String? vehicleInfo,
    String? description,
    String? fuelQuantity,
    String? fuelType,
    String? issueType,
    double? price,
    List<File>? evidenceFiles,
  }) async {
    try {
      List<String> imageUrls = [];

      if (evidenceFiles != null && evidenceFiles.isNotEmpty) {
        for (var file in evidenceFiles) {
          final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
          final path = '$requesterId/$fileName';
          
          await _supabase.storage
              .from('service_evidence')
              .upload(path, file);

          final publicUrl = _supabase.storage
              .from('service_evidence')
              .getPublicUrl(path);
          imageUrls.add(publicUrl);
        }
      }

      final res = await _supabase
          .from('service_requests')
          .insert({
            'requester_id': requesterId,
            'request_type': requestType.value,
            'location_lat': locationLat,
            'location_lng': locationLng,
            'location_address': locationAddress,
            'vehicle_info': vehicleInfo,
            'description': description,
            'fuel_quantity': fuelQuantity,
            'fuel_type': fuelType,
            'issue_type': issueType,
            'price': price,
            'status': ServiceStatus.searching.value,
            if (imageUrls.isNotEmpty) 'images': imageUrls,
          })
          .select()
          .single();

      return right(ServiceRequestModel.fromMap(res));
    } catch (e) {
      return left('Failed to create request: $e');
    }
  }

  // ── Cancel a service request ──────────────────────────────────────────────
  Future<Either<String, bool>> cancelServiceRequest(String requestId) async {
    try {
      await _supabase
          .from('service_requests')
          .update({
            'status': ServiceStatus.cancelled.value,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', requestId);
      return right(true);
    } catch (e) {
      return left('Failed to cancel: $e');
    }
  }

  // ── Spare parts marketplace ───────────────────────────────────────────────
  Future<Either<String, List<SparePartModel>>> getSpareParts({
    String? searchQuery,
  }) async {
    try {
      var query = _supabase
          .from('spare_parts')
          .select()
          .order('created_at', ascending: false);

      final res = await query;
      var parts = (res as List).map((e) => SparePartModel.fromMap(e)).toList();

      // Client-side filter (for simplicity; use .ilike() for server-side)
      if (searchQuery != null && searchQuery.isNotEmpty) {
        parts = parts
            .where(
              (p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()),
            )
            .toList();
      }

      return right(parts);
    } catch (e) {
      print('Get spare parts error: $e');
      return right([]);
    }
  }

  // ── Update user availability for P2P ─────────────────────────────────────
  Future<void> updateP2pAvailability(
    String userId,
    bool isAvailable, {
    double? lat,
    double? lng,
  }) async {
    try {
      await _supabase
          .from('users')
          .update({
            'is_available_for_p2p': isAvailable,
            if (lat != null) 'last_known_lat': lat,
            if (lng != null) 'last_known_lng': lng,
            'is_online': isAvailable,
          })
          .eq('id', userId);
    } catch (e) {
      print('P2P availability update error: $e');
    }
  }

  // ── Update user location ──────────────────────────────────────────────────
  Future<void> updateUserLocation(String userId, double lat, double lng) async {
    try {
      await _supabase
          .from('users')
          .update({'last_known_lat': lat, 'last_known_lng': lng})
          .eq('id', userId);
    } catch (e) {
      print('Location update error: $e');
    }
  }

  // ── Nearby available P2P users ────────────────────────────────────────────
  Future<Either<String, List<Map<String, dynamic>>>> getNearbyP2pUsers() async {
    try {
      final res = await _supabase
          .from('users')
          .select(
            'id, name, rating, last_known_lat, last_known_lng, avatar_url',
          )
          .eq('is_available_for_p2p', true)
          .eq('is_online', true);
      return right(List<Map<String, dynamic>>.from(res));
    } catch (e) {
      return right([]);
    }
  }

  // ── Fetch Mechanics ────────────────────────────────────────────────────────
  Future<Either<String, List<UserModel>>> getMechanics() async {
    try {
      final res = await _supabase
          .from('users')
          .select()
          .eq('role', ProviderCategory.mechanic.value);
      return right((res as List).map((e) => UserModel.fromMap(e)).toList());
    } catch (e) {
      print('Get mechanics error: $e');
      return right([]);
    }
  }

  // ── Get user orders ────────────────────────────────────────────────────────
  Future<Either<String, List<DetailedOrderModel>>> getUserOrders(String userId) async {
    try {
      final res = await _supabase
          .from('orders')
          .select('''
            id, order_number, status, total_amount, info, image_url, created_at,
            seller:seller_id ( name )
          ''')
          .eq('customer_id', userId)
          .order('created_at', ascending: false);

      return right((res as List).map((e) {
        final seller = e['seller'] as Map<String, dynamic>? ?? {};
        return DetailedOrderModel(
          id: e['id'] ?? '',
          status: e['status'] ?? 'NEW',
          orderNumber: e['order_number'] ?? '',
          customerName: seller['name'] ?? 'Seller', // We use customerName field for Seller name here
          info: e['info'] ?? '',
          date: e['created_at'] != null
              ? DateTime.tryParse(e['created_at'])?.toLocal().toString().substring(0, 10) ?? ''
              : '',
          price: (e['total_amount'] as num?)?.toDouble() ?? 0.0,
          imageUrl: e['image_url'] ?? '',
        );
      }).toList());
    } catch (e) {
      print('Get user orders error: $e');
      return left(e.toString());
    }
  }

  // ── Place Order ────────────────────────────────────────────────────────
  Future<Either<String, bool>> placeOrder({
    required String customerId,
    required List<Map<String, dynamic>> cartItems,
    required double totalAmount,
    required String shippingAddress,
  }) async {
    try {
      Map<String, List<Map<String, dynamic>>> sellerItems = {};
      for (var item in cartItems) {
        final part = item['part'] as SparePartModel;
        if (!sellerItems.containsKey(part.sellerId)) {
          sellerItems[part.sellerId] = [];
        }
        sellerItems[part.sellerId]!.add(item);
      }

      for (var entry in sellerItems.entries) {
        String sellerId = entry.key;
        List<Map<String, dynamic>> items = entry.value;

        double sellerTotal = items.fold(0.0, (sum, item) => sum + ((item['part'] as SparePartModel).price * (item['quantity'] as int)));
        
        String info = items.map((e) => "${e['quantity']}x ${(e['part'] as SparePartModel).name}").join(', ');

        final orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}-${sellerId.substring(0, 3)}';

        await _supabase.from('orders').insert({
          'order_number': orderNumber,
          'customer_id': customerId,
          'seller_id': sellerId,
          'total_amount': sellerTotal,
          'status': 'NEW',
          'info': info,
          'shipping_address': shippingAddress,
        });
      }
      return right(true);
    } catch (e) {
      print('Place order error: $e');
      return left(e.toString());
    }
  }
}
