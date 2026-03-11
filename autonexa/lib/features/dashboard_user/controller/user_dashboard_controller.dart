import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/features/auth/controller/auth_controller.dart';
import 'package:autonexa/models/spare_part_model.dart';
import 'package:autonexa/features/dashboard_user/repository/user_dashboard_repository.dart';
import 'package:autonexa/models/vehicle_model.dart';
import 'package:autonexa/models/service_request_model.dart';

final userVehiclesProvider = FutureProvider<List<VehicleModel>>((ref) async {
  final user = ref.watch(userProvider);
  if (user == null) return [];
  
  final res = await ref.read(userDashboardRepositoryProvider).getUserVehicles(user.id);
  return res.fold((l) => [], (r) => r);
});

final userServiceRequestsProvider = FutureProvider<List<ServiceRequestModel>>((ref) async {
  final user = ref.watch(userProvider);
  if (user == null) return [];
  
  final res = await ref.read(userDashboardRepositoryProvider).getUserServiceRequests(user.id);
  return res.fold((l) => [], (r) => r);
});

final sparePartsProvider = FutureProvider<List<SparePartModel>>((ref) async {
  final res = await ref.read(userDashboardRepositoryProvider).getSpareParts();
  return res.fold((l) => [], (r) => r);
});
