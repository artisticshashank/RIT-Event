import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:autonexa/models/towing_dashboard_model.dart';
import 'package:autonexa/models/service_transaction_model.dart';
import 'package:autonexa/models/enums.dart';

final towingRepositoryProvider = Provider((ref) {
  return TowingRepository(supabase: Supabase.instance.client);
});

class TowingRepository {
  final SupabaseClient _supabase;

  TowingRepository({required SupabaseClient supabase}) : _supabase = supabase;

  // ── Overview: from towing_station_analytics VIEW ─────────────────────────
  Future<TowingOverviewModel> fetchOverview(String stationId) async {
    try {
      final res = await _supabase
          .from('towing_station_analytics')
          .select()
          .eq('station_id', stationId)
          .maybeSingle();

      if (res != null) {
        return TowingOverviewModel(
          isOnline: true,
          revenue: (res['revenue'] as num?)?.toDouble() ?? 0.0,
          activeDrivers: (res['online_drivers'] as int?) ?? 0,
          totalDrivers: (res['online_drivers'] as int?) ?? 0,
          pendingRequests: (res['active_requests'] as int?) ?? 0,
          activeJobPins: (res['active_requests'] as int?) ?? 0,
          liveTrucks: (res['online_drivers'] as int?) ?? 0,
        );
      }
    } catch (e) {
      print('Towing overview fetch error (using mock): $e');
    }

    // Fallback mock
    await Future.delayed(const Duration(milliseconds: 400));
    return TowingOverviewModel(
      isOnline: true,
      revenue: 850.0,
      activeDrivers: 4,
      totalDrivers: 6,
      pendingRequests: 3,
      activeJobPins: 4,
      liveTrucks: 6,
    );
  }

  // ── Incoming requests: service_requests WHERE type=towing + JOIN users ────
  Future<List<TowingRequestModel>> fetchIncomingRequests(
    String stationId,
  ) async {
    try {
      final res = await _supabase
          .from('service_requests')
          .select('''
            id, vehicle_info, issue_type, price, distance_km, status, created_at,
            requester:requester_id ( id, name, avatar_url )
          ''')
          .eq('request_type', ServiceType.towing.value)
          .eq('status', ServiceStatus.searching.value)
          .order('created_at', ascending: false);

      if (res.isNotEmpty) {
        return (res as List).map((e) {
          final requester = e['requester'] as Map<String, dynamic>? ?? {};
          final issueType = e['issue_type'] as String? ?? 'Breakdown';
          final issueColor = (issueType.toLowerCase().contains('accident'))
              ? 'red'
              : 'orange';
          return TowingRequestModel(
            id: e['id'] ?? '',
            customerName: requester['name'] ?? 'Customer',
            carInfo: e['vehicle_info'] ?? '',
            issueType: issueType,
            issueColor: issueColor,
            distance: e['distance_km'] ?? '',
            price: (e['price'] as num?)?.toDouble() ?? 0.0,
            imageUrl: requester['avatar_url'] ?? '',
            status: e['status'] ?? 'searching',
          );
        }).toList();
      }
    } catch (e) {
      print('Towing requests fetch error (using mock): $e');
    }

    // Fallback mock
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      TowingRequestModel(
        id: '1',
        customerName: 'David Chen',
        carInfo: 'Tesla Model Y',
        issueType: 'Flat Tire',
        issueColor: 'orange',
        distance: '3.2 km away',
        price: 120.00,
        status: 'searching',
        imageUrl: '',
      ),
      TowingRequestModel(
        id: '2',
        customerName: 'Sarah Williams',
        carInfo: 'BMW X5',
        issueType: 'Accident',
        issueColor: 'red',
        distance: '0.8 km away',
        price: 350.00,
        status: 'searching',
        imageUrl: '',
      ),
    ];
  }

  // ── History: completed towing jobs ────────────────────────────────────────
  Future<List<TowingRequestModel>> fetchHistory(String stationId) async {
    try {
      final res = await _supabase
          .from('service_requests')
          .select('''
            id, vehicle_info, issue_type, price, distance_km, status, created_at,
            requester:requester_id ( id, name, avatar_url )
          ''')
          .eq('request_type', ServiceType.towing.value)
          .eq('responder_id', stationId)
          .eq('status', ServiceStatus.completed.value)
          .order('created_at', ascending: false)
          .limit(50);

      if (res.isNotEmpty) {
        return (res as List).map((e) {
          final requester = e['requester'] as Map<String, dynamic>? ?? {};
          final issueType = e['issue_type'] as String? ?? 'Breakdown';
          return TowingRequestModel(
            id: e['id'] ?? '',
            customerName: requester['name'] ?? 'Customer',
            carInfo: e['vehicle_info'] ?? '',
            issueType: issueType,
            issueColor: issueType.toLowerCase().contains('accident')
                ? 'red'
                : 'orange',
            distance: e['distance_km'] ?? '',
            price: (e['price'] as num?)?.toDouble() ?? 0.0,
            imageUrl: requester['avatar_url'] ?? '',
            status: 'completed',
          );
        }).toList();
      }
    } catch (e) {
      print('Towing history fetch error: $e');
    }
    return [];
  }

  // ── Assign driver: set this station as responder ──────────────────────────
  Future<void> assignDriver(
    String requestId,
    String stationId,
    double agreedPrice,
  ) async {
    await _supabase
        .from('service_requests')
        .update({
          'responder_id': stationId,
          'status': ServiceStatus.accepted.value,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', requestId);

    await _supabase.from('service_transactions').insert({
      'service_request_id': requestId,
      'provider_id': stationId,
      'customer_id': await _getRequesterId(requestId),
      'agreed_amount': agreedPrice,
      'payment_status': PaymentStatus.pending.value,
    });
  }

  // ── Decline ───────────────────────────────────────────────────────────────
  Future<void> declineRequest(String requestId) async {
    await _supabase
        .from('service_requests')
        .update({
          'status': ServiceStatus.cancelled.value,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', requestId);
  }

  // ── Mark payment received ─────────────────────────────────────────────────
  Future<void> markPaymentReceived(String transactionId) async {
    await _supabase
        .from('service_transactions')
        .update({'payment_status': PaymentStatus.received.value})
        .eq('id', transactionId);
  }

  // ── Fetch earnings ────────────────────────────────────────────────────────
  Future<List<ServiceTransactionModel>> fetchEarnings(String stationId) async {
    try {
      final res = await _supabase
          .from('service_transactions')
          .select()
          .eq('provider_id', stationId)
          .order('created_at', ascending: false);
      return (res as List)
          .map((e) => ServiceTransactionModel.fromMap(e))
          .toList();
    } catch (e) {
      print('Towing earnings fetch error: $e');
      return [];
    }
  }

  // ── Mark provider arriving at location ──────────────────────────────────
  Future<void> markArriving(String requestId) async {
    await _supabase
        .from('service_requests')
        .update({
          'status': ServiceStatus.arriving.value,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', requestId);
  }

  // ── Mark tow job complete ───────────────────────────────────────────────
  Future<void> markComplete(String requestId) async {
    await _supabase
        .from('service_requests')
        .update({
          'status': ServiceStatus.completed.value,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', requestId);
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
