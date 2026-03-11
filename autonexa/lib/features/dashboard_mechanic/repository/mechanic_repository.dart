import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:autonexa/models/service_request_model.dart';
import 'package:autonexa/models/enums.dart';
import 'package:autonexa/core/providers/supabase_provider.dart';

final mechanicRepositoryProvider = Provider((ref) {
  return MechanicRepository(supabase: ref.read(supabaseProvider));
});

class MechanicRepository {
  final sb.SupabaseClient _supabase;

  MechanicRepository({required sb.SupabaseClient supabase}) : _supabase = supabase;

  // Stream of pending jobs (searching for a mechanic)
  Stream<List<ServiceRequestModel>> getPendingJobs() {
    return _supabase
        .from('service_requests')
        .stream(primaryKey: ['id'])
        .eq('status', ServiceStatus.searching.value)
        .order('created_at', ascending: false)
        .map((events) => events.map((e) => ServiceRequestModel.fromMap(e)).toList());
  }

  // Stream of active jobs for this specific mechanic
  Stream<List<ServiceRequestModel>> getActiveJobs(String mechanicId) {
    return _supabase
        .from('service_requests')
        .stream(primaryKey: ['id'])
        .eq('responder_id', mechanicId)
        .order('created_at', ascending: false)
        .map((events) => events
            .map((e) => ServiceRequestModel.fromMap(e))
            .where((j) =>
                j.status == ServiceStatus.accepted ||
                j.status == ServiceStatus.arriving)
            .toList());
  }
}
