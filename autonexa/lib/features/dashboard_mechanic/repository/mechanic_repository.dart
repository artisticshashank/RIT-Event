import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:autonexa/models/service_request_model.dart';
import 'package:autonexa/models/service_transaction_model.dart';
import 'package:autonexa/models/enums.dart';
import 'package:autonexa/core/providers/supabase_provider.dart';

final mechanicRepositoryProvider = Provider((ref) {
  return MechanicRepository(supabase: ref.read(supabaseProvider));
});

class MechanicRepository {
  final sb.SupabaseClient _supabase;

  MechanicRepository({required sb.SupabaseClient supabase})
    : _supabase = supabase;

  // ── Stream of pending jobs of all types a mechanic can handle ─────────────
  Stream<List<ServiceRequestModel>> getPendingJobs() {
    return _supabase
        .from('service_requests')
        .stream(primaryKey: ['id'])
        .eq('status', ServiceStatus.searching.value)
        .order('created_at', ascending: false)
        .map(
          (events) =>
              events.map((e) => ServiceRequestModel.fromMap(e)).toList(),
        );
  }

  // ── Stream of active jobs for this mechanic ───────────────────────────────
  Stream<List<ServiceRequestModel>> getActiveJobs(String mechanicId) {
    return _supabase
        .from('service_requests')
        .stream(primaryKey: ['id'])
        .eq('responder_id', mechanicId)
        .order('created_at', ascending: false)
        .map(
          (events) => events
              .map((e) => ServiceRequestModel.fromMap(e))
              .where(
                (j) =>
                    j.status == ServiceStatus.accepted ||
                    j.status == ServiceStatus.arriving,
              )
              .toList(),
        );
  }

  // ── Completed jobs history for mechanic ───────────────────────────────────
  Future<List<ServiceRequestModel>> getJobHistory(String mechanicId) async {
    try {
      final res = await _supabase
          .from('service_requests')
          .select('''
            *,
            requester:requester_id ( id, name, avatar_url )
          ''')
          .eq('responder_id', mechanicId)
          .eq('status', ServiceStatus.completed.value)
          .order('created_at', ascending: false)
          .limit(50);

      return (res as List).map((e) => ServiceRequestModel.fromMap(e)).toList();
    } catch (e) {
      print('Mechanic job history error: $e');
      return [];
    }
  }

  // ── Accept a job: assign this mechanic as responder ───────────────────────
  Future<bool> acceptJob(String requestId, String mechanicId) async {
    try {
      // 1. Get the current request to find requester + price
      final req = await _supabase
          .from('service_requests')
          .select()
          .eq('id', requestId)
          .single();

      // 2. Update the request
      await _supabase
          .from('service_requests')
          .update({
            'responder_id': mechanicId,
            'status': ServiceStatus.accepted.value,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', requestId);

      // 3. Create transaction row
      await _supabase.from('service_transactions').insert({
        'service_request_id': requestId,
        'provider_id': mechanicId,
        'customer_id': req['requester_id'],
        'agreed_amount': req['price'] ?? 0.0,
        'payment_status': PaymentStatus.pending.value,
      });

      return true;
    } catch (e) {
      print('Accept job error: $e');
      return false;
    }
  }

  // ── Mark mechanic arrived at location ─────────────────────────────────────
  Future<bool> markArriving(String requestId) async {
    try {
      await _supabase
          .from('service_requests')
          .update({
            'status': ServiceStatus.arriving.value,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', requestId);
      return true;
    } catch (e) {
      print('Mark arriving error: $e');
      return false;
    }
  }

  // ── Mark job complete ─────────────────────────────────────────────────────
  Future<bool> markJobComplete(String requestId) async {
    try {
      await _supabase
          .from('service_requests')
          .update({
            'status': ServiceStatus.completed.value,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', requestId);
      return true;
    } catch (e) {
      print('Mark complete error: $e');
      return false;
    }
  }

  // ── Mark payment received → DB trigger sets invoice_generated ─────────────
  Future<bool> markPaymentReceived(String transactionId) async {
    try {
      await _supabase
          .from('service_transactions')
          .update({'payment_status': PaymentStatus.received.value})
          .eq('id', transactionId);
      return true;
    } catch (e) {
      print('Mark payment received error: $e');
      return false;
    }
  }

  // ── Fetch mechanic earnings ───────────────────────────────────────────────
  Future<List<ServiceTransactionModel>> getEarnings(String mechanicId) async {
    try {
      final res = await _supabase
          .from('service_transactions')
          .select()
          .eq('provider_id', mechanicId)
          .order('created_at', ascending: false);
      return (res as List)
          .map((e) => ServiceTransactionModel.fromMap(e))
          .toList();
    } catch (e) {
      print('Mechanic earnings error: $e');
      return [];
    }
  }

  // ── Update mechanic availability ──────────────────────────────────────────
  Future<void> updateAvailability(String mechanicId, bool isOnline) async {
    try {
      await _supabase
          .from('users')
          .update({'is_online': isOnline, 'is_available_for_p2p': isOnline})
          .eq('id', mechanicId);
    } catch (e) {
      print('Mechanic availability update error: $e');
    }
  }
}
