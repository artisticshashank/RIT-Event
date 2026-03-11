import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/models/vehicle_model.dart';
import 'package:autonexa/models/service_request_model.dart';
import 'package:autonexa/models/spare_part_model.dart';
import 'package:fpdart/fpdart.dart';

final userDashboardRepositoryProvider = Provider((ref) {
  return UserDashboardRepository(supabase: Supabase.instance.client);
});

class UserDashboardRepository {
  final SupabaseClient _supabase;

  UserDashboardRepository({required SupabaseClient supabase}) : _supabase = supabase;

  Future<Either<String, List<VehicleModel>>> getUserVehicles(String userId) async {
    try {
      final res = await _supabase.from('vehicles').select().eq('user_id', userId);
      return right((res as List).map((e) => VehicleModel.fromMap(e)).toList());
    } catch (e) {
      // In case table is empty or error, catch and return empty list instead of failing
      // return left(e.toString());
      return right([]);
    }
  }

  Future<Either<String, List<ServiceRequestModel>>> getUserServiceRequests(String userId) async {
    try {
      final res = await _supabase.from('service_requests').select().eq('requester_id', userId).order('created_at', ascending: false);
      return right((res as List).map((e) => ServiceRequestModel.fromMap(e)).toList());
    } catch (e) {
      // return left(e.toString());
      return right([]);
    }
  }

  Future<Either<String, List<SparePartModel>>> getSpareParts() async {
    try {
      final res = await _supabase.from('spare_parts').select().order('created_at', ascending: false);
      return right((res as List).map((e) => SparePartModel.fromMap(e)).toList());
    } catch (e) {
      return right([]);
    }
  }
}
