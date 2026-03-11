import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/models/fuel_dashboard_model.dart';
import 'package:autonexa/features/auth/controller/auth_controller.dart';
import 'package:autonexa/features/dashboard_fuel/repository/fuel_repository.dart';

final fuelOverviewProvider = FutureProvider<FuelStationOverviewModel>((ref) async {
  final user = ref.watch(userProvider);
  if (user == null) {
    throw Exception('User is not authenticated');
  }

  final repository = ref.watch(fuelRepositoryProvider);
  return repository.fetchOverview(user.id);
});

final fuelRequestsProvider = FutureProvider<List<FuelRequestModel>>((ref) async {
  final user = ref.watch(userProvider);
  if (user == null) {
    throw Exception('User is not authenticated');
  }

  final repository = ref.watch(fuelRepositoryProvider);
  return repository.fetchIncomingRequests(user.id);
});
