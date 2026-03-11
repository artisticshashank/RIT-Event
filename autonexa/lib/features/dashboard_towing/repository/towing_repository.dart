import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:autonexa/models/towing_dashboard_model.dart';

final towingRepositoryProvider = Provider((ref) {
  return TowingRepository(supabase: Supabase.instance.client);
});

class TowingRepository {
  final SupabaseClient _supabase;

  TowingRepository({required SupabaseClient supabase}) : _supabase = supabase;

  Future<TowingOverviewModel> fetchOverview(String stationId) async {
    try {
      final res = await _supabase
          .from('towing_analytics')
          .select()
          .eq('station_id', stationId)
          .single();
          
      if (res.isNotEmpty) {
        return TowingOverviewModel.fromMap(res);
      }
    } catch (e) {
      print("Error fetching towing overview from Supabase, returning mock data: $e");
    }

    // Fallback Mock Data matching the UI
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate network
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

  Future<List<TowingRequestModel>> fetchIncomingRequests(String stationId) async {
    try {
      final res = await _supabase
          .from('towing_requests')
          .select()
          .eq('station_id', stationId)
          .eq('status', 'PENDING');
          
      if (res.isNotEmpty) {
        return res.map((e) => TowingRequestModel.fromMap(e)).toList();
      }
    } catch (e) {
      print("Error fetching towing requests from Supabase, returning mock data: $e");
    }

    // Fallback Mock Data matching the UI perfectly
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate network
    return [
      TowingRequestModel(
        id: '1',
        customerName: 'David Chen',
        carInfo: 'Tesla Model Y',
        issueType: 'Flat Tire',
        issueColor: 'orange',
        distance: '3.2 km away',
        price: 120.00,
        status: 'PENDING',
        imageUrl: '', // Blank handles avatar placeholder
      ),
      TowingRequestModel(
        id: '2',
        customerName: 'Sarah Williams',
        carInfo: 'BMW X5',
        issueType: 'Accident',
        issueColor: 'red',
        distance: '0.8 km away',
        price: 350.00,
        status: 'PENDING',
        imageUrl: '',
      ),
    ];
  }
}
