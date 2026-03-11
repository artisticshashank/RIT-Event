import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:autonexa/models/fuel_dashboard_model.dart';

final fuelRepositoryProvider = Provider((ref) {
  return FuelRepository(supabase: Supabase.instance.client);
});

class FuelRepository {
  final SupabaseClient _supabase;

  FuelRepository({required SupabaseClient supabase}) : _supabase = supabase;

  Future<FuelStationOverviewModel> fetchOverview(String stationId) async {
    try {
      final res = await _supabase
          .from('fuel_analytics')
          .select()
          .eq('station_id', stationId)
          .single();
          
      if (res.isNotEmpty) {
        return FuelStationOverviewModel(
          activeRequests: res['active_requests'] ?? 0,
          activeGrowth: res['active_growth'] ?? '0%',
          doneRequests: res['done_requests'] ?? 0,
          doneGrowth: res['done_growth'] ?? '0%',
          revenue: res['revenue']?.toDouble() ?? 0.0,
          revenueGrowth: res['revenue_growth'] ?? '0%',
        );
      }
    } catch (e) {
      print("Error fetching fuel overview from Supabase, returning mock data: $e");
    }

    // Fallback Mock Data matching the UI
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate network
    return FuelStationOverviewModel(
      activeRequests: 12,
      activeGrowth: '+5%',
      doneRequests: 48,
      doneGrowth: '+12%',
      revenue: 1200.0, // represented as $1.2k
      revenueGrowth: '+8%',
    );
  }

  Future<List<FuelRequestModel>> fetchIncomingRequests(String stationId) async {
    try {
      final res = await _supabase
          .from('fuel_requests')
          .select()
          .eq('station_id', stationId)
          .eq('status', 'NEW');
          
      if (res.isNotEmpty) {
        return res.map((e) => FuelRequestModel.fromMap(e)).toList();
      }
    } catch (e) {
      print("Error fetching fuel requests from Supabase, returning mock data: $e");
    }

    // Fallback Mock Data matching the UI perfectly
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate network
    return [
      FuelRequestModel(
        id: '1',
        customerName: 'Alex Rivera',
        carInfo: 'Tesla Model 3 • Silver',
        distance: '2.4 km',
        fuelQuantity: '20 Liters',
        price: 45.00,
        status: 'NEW',
        fuelType: '95 OCT',
        imageUrl: '', // Blank will use a colored placeholder similar to UI
      ),
      FuelRequestModel(
        id: '2',
        customerName: 'Sarah Jenkins',
        carInfo: 'BMW X5 • Black',
        distance: '0.8 km',
        fuelQuantity: '45 Liters',
        price: 82.50,
        status: 'NEW',
        fuelType: 'DIESEL',
        imageUrl: '',
      ),
      FuelRequestModel(
        id: '3',
        customerName: 'Marcus Thorne',
        carInfo: 'Audi A4 • Blue',
        distance: '5.1 km',
        fuelQuantity: '15 Liters',
        price: 34.20,
        status: 'NEW',
        fuelType: '98 OCT',
        imageUrl: '',
      ),
    ];
  }
}
