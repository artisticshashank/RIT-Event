import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:autonexa/models/fuel_dashboard_model.dart';
import 'package:autonexa/models/service_transaction_model.dart';
import 'package:autonexa/models/enums.dart';

final fuelRepositoryProvider = Provider((ref) {
  return FuelRepository(supabase: Supabase.instance.client);
});

class FuelRepository {
  final SupabaseClient _supabase;

  FuelRepository({required SupabaseClient supabase}) : _supabase = supabase;

  // ── Overview: computed from the fuel_station_analytics VIEW ──────────────
  Future<FuelStationOverviewModel> fetchOverview(String stationId) async {
    try {
      final res = await _supabase
          .from('fuel_station_analytics')
          .select()
          .eq('station_id', stationId)
          .maybeSingle();

      if (res != null) {
        return FuelStationOverviewModel(
          activeRequests: res['active_requests'] as int? ?? 0,
          activeGrowth: '+${res['active_requests'] ?? 0}',
          doneRequests: res['done_requests'] as int? ?? 0,
          doneGrowth: '+${res['done_requests'] ?? 0}',
          revenue: (res['revenue'] as num?)?.toDouble() ?? 0.0,
          revenueGrowth: '',
        );
      }
    } catch (e) {
      print('Fuel overview fetch error (using mock): $e');
    }

    // Fallback mock
    await Future.delayed(const Duration(milliseconds: 400));
    return FuelStationOverviewModel(
      activeRequests: 12,
      activeGrowth: '+5%',
      doneRequests: 48,
      doneGrowth: '+12%',
      revenue: 1200.0,
      revenueGrowth: '+8%',
    );
  }

  // ── Incoming requests: service_requests WHERE type=fuel_share + JOIN users ─
  Future<List<FuelRequestModel>> fetchIncomingRequests(String stationId) async {
    try {
      final res = await _supabase
          .from('service_requests')
          .select('''
            id, vehicle_info, fuel_quantity, fuel_type, price, distance_km,
            status, created_at,
            requester:requester_id ( id, name, avatar_url )
          ''')
          .eq('request_type', ServiceType.fuel_share.value)
          .eq('status', ServiceStatus.searching.value)
          .order('created_at', ascending: false);

      if (res.isNotEmpty) {
        return (res as List).map((e) {
          final requester = e['requester'] as Map<String, dynamic>? ?? {};
          return FuelRequestModel(
            id: e['id'] ?? '',
            customerName: requester['name'] ?? 'Customer',
            carInfo: e['vehicle_info'] ?? '',
            distance: e['distance_km'] ?? '',
            fuelQuantity: e['fuel_quantity'] ?? '',
            price: (e['price'] as num?)?.toDouble() ?? 0.0,
            status: e['status'] ?? 'searching',
            fuelType: e['fuel_type'] ?? '',
            imageUrl: requester['avatar_url'] ?? '',
          );
        }).toList();
      }
    } catch (e) {
      print('Fuel requests fetch error (using mock): $e');
    }

    // Fallback mock
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      FuelRequestModel(
        id: '1', customerName: 'Alex Rivera', carInfo: 'Tesla Model 3 • Silver',
        distance: '2.4 km', fuelQuantity: '20 Liters', price: 45.00,
        status: 'searching', fuelType: '95 OCT', imageUrl: '',
      ),
      FuelRequestModel(
        id: '2', customerName: 'Sarah Jenkins', carInfo: 'BMW X5 • Black',
        distance: '0.8 km', fuelQuantity: '45 Liters', price: 82.50,
        status: 'searching', fuelType: 'DIESEL', imageUrl: '',
      ),
      FuelRequestModel(
        id: '3', customerName: 'Marcus Thorne', carInfo: 'Audi A4 • Blue',
        distance: '5.1 km', fuelQuantity: '15 Liters', price: 34.20,
        status: 'searching', fuelType: '98 OCT', imageUrl: '',
      ),
    ];
  }

  // ── History: completed fuel requests handled by this station ─────────────
  Future<List<FuelRequestModel>> fetchHistory(String stationId) async {
    try {
      final res = await _supabase
          .from('service_requests')
          .select('''
            id, vehicle_info, fuel_quantity, fuel_type, price, distance_km,
            status, created_at,
            requester:requester_id ( id, name, avatar_url )
          ''')
          .eq('request_type', ServiceType.fuel_share.value)
          .eq('responder_id', stationId)
          .eq('status', ServiceStatus.completed.value)
          .order('created_at', ascending: false)
          .limit(50);

      if (res.isNotEmpty) {
        return (res as List).map((e) {
          final requester = e['requester'] as Map<String, dynamic>? ?? {};
          return FuelRequestModel(
            id: e['id'] ?? '',
            customerName: requester['name'] ?? 'Customer',
            carInfo: e['vehicle_info'] ?? '',
            distance: e['distance_km'] ?? '',
            fuelQuantity: e['fuel_quantity'] ?? '',
            price: (e['price'] as num?)?.toDouble() ?? 0.0,
            status: 'completed',
            fuelType: e['fuel_type'] ?? '',
            imageUrl: requester['avatar_url'] ?? '',
          );
        }).toList();
      }
    } catch (e) {
      print('Fuel history fetch error (using mock): $e');
    }
    return [];
  }

  // ── Accept a request: mark responder + status ─────────────────────────────
  Future<void> acceptRequest(String requestId, String stationId, double agreedPrice) async {
    await _supabase.from('service_requests').update({
      'responder_id': stationId,
      'status': ServiceStatus.accepted.value,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', requestId);

    // Create the transaction row
    await _supabase.from('service_transactions').insert({
      'service_request_id': requestId,
      'provider_id': stationId,
      'customer_id': await _getRequesterId(requestId),
      'agreed_amount': agreedPrice,
      'payment_status': PaymentStatus.pending.value,
    });
  }

  // ── Decline a request ─────────────────────────────────────────────────────
  Future<void> declineRequest(String requestId) async {
    await _supabase.from('service_requests').update({
      'status': ServiceStatus.cancelled.value,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', requestId);
  }

  // ── Mark payment received → triggers DB function to set invoice_generated ─
  Future<void> markPaymentReceived(String transactionId) async {
    await _supabase.from('service_transactions').update({
      'payment_status': PaymentStatus.received.value,
    }).eq('id', transactionId);
  }

  // ── Fetch earnings for analytics screen ──────────────────────────────────
  Future<List<ServiceTransactionModel>> fetchEarnings(String stationId) async {
    try {
      final res = await _supabase
          .from('service_transactions')
          .select()
          .eq('provider_id', stationId)
          .order('created_at', ascending: false);

      return (res as List).map((e) => ServiceTransactionModel.fromMap(e)).toList();
    } catch (e) {
      print('Fuel earnings fetch error: $e');
      return [];
    }
  }

  // ── Mark provider arriving at location ──────────────────────────────────
  Future<void> markArriving(String requestId) async {
    await _supabase.from('service_requests').update({
      'status': ServiceStatus.arriving.value,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', requestId);
  }

  // ── Mark job complete ─────────────────────────────────────────────────────
  Future<void> markComplete(String requestId) async {
    await _supabase.from('service_requests').update({
      'status': ServiceStatus.completed.value,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', requestId);
  }

  Future<String> _getRequesterId(String requestId) async {
    final res = await _supabase
        .from('service_requests')
        .select('requester_id')
        .eq('id', requestId)
        .single();
    return res['requester_id'] ?? '';
  }
}
