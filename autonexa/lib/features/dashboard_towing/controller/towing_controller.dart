import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/models/towing_dashboard_model.dart';
import 'package:autonexa/features/auth/controller/auth_controller.dart';
import 'package:autonexa/features/dashboard_towing/repository/towing_repository.dart';

final towingOverviewProvider = FutureProvider<TowingOverviewModel>((ref) async {
  final user = ref.watch(userProvider);
  if (user == null) {
    throw Exception('User is not authenticated');
  }

  final repository = ref.watch(towingRepositoryProvider);
  return repository.fetchOverview(user.id);
});

final towingRequestsProvider = FutureProvider<List<TowingRequestModel>>((ref) async {
  final user = ref.watch(userProvider);
  if (user == null) {
    throw Exception('User is not authenticated');
  }

  final repository = ref.watch(towingRepositoryProvider);
  return repository.fetchIncomingRequests(user.id);
});
