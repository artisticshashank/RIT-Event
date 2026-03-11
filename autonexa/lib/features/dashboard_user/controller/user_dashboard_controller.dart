import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:autonexa/features/auth/controller/auth_controller.dart';
import 'package:autonexa/models/spare_part_model.dart';
import 'package:autonexa/features/dashboard_user/repository/user_dashboard_repository.dart';
import 'package:autonexa/models/vehicle_model.dart';
import 'package:autonexa/models/service_request_model.dart';
import 'package:autonexa/models/enums.dart';

// ── User vehicles ─────────────────────────────────────────────────────────────
final userVehiclesProvider = FutureProvider<List<VehicleModel>>((ref) async {
  final user = ref.watch(userProvider);
  if (user == null) return [];
  final res = await ref.read(userDashboardRepositoryProvider).getUserVehicles(user.id);
  return res.fold((_) => [], (r) => r);
});

// ── User service requests (all statuses) ──────────────────────────────────────
final userServiceRequestsProvider = FutureProvider<List<ServiceRequestModel>>((ref) async {
  final user = ref.watch(userProvider);
  if (user == null) return [];
  final res = await ref.read(userDashboardRepositoryProvider).getUserServiceRequests(user.id);
  return res.fold((_) => [], (r) => r);
});

// ── Active-only requests ───────────────────────────────────────────────────────
final activeRequestsProvider = Provider<AsyncValue<List<ServiceRequestModel>>>((ref) {
  return ref.watch(userServiceRequestsProvider).whenData(
    (all) => all
        .where((r) =>
            r.status == ServiceStatus.searching ||
            r.status == ServiceStatus.accepted ||
            r.status == ServiceStatus.arriving)
        .toList(),
  );
});

// ── Completed requests (history) ──────────────────────────────────────────────
final requestHistoryProvider = Provider<AsyncValue<List<ServiceRequestModel>>>((ref) {
  return ref.watch(userServiceRequestsProvider).whenData(
    (all) => all.where((r) => r.status == ServiceStatus.completed).toList(),
  );
});

// ── Spare parts marketplace ────────────────────────────────────────────────────
final sparePartsProvider = FutureProvider<List<SparePartModel>>((ref) async {
  final res = await ref.read(userDashboardRepositoryProvider).getSpareParts();
  return res.fold((_) => [], (r) => r);
});

// ── Add Vehicle action ─────────────────────────────────────────────────────────
class AddVehicleNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> addVehicle({
    required String make,
    required String model,
    required int year,
    required String licensePlate,
    String fuelType = '95 OCT',
  }) async {
    state = const AsyncLoading();
    try {
      final user = ref.read(userProvider);
      if (user == null) throw Exception('Not authenticated');
      final repo = ref.read(userDashboardRepositoryProvider);
      final res = await repo.addVehicle(
        userId: user.id,
        make: make,
        model: model,
        year: year,
        licensePlate: licensePlate,
        fuelType: fuelType,
      );
      state = const AsyncData(null);
      return res.fold((_) => false, (_) => true);
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final addVehicleProvider =
    AsyncNotifierProvider<AddVehicleNotifier, void>(AddVehicleNotifier.new);

// ── Create service request ────────────────────────────────────────────────────
class CreateServiceRequestNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> create({
    required ServiceType requestType,
    required double locationLat,
    required double locationLng,
    String? locationAddress,
    String? vehicleInfo,
    String? description,
    String? fuelQuantity,
    String? fuelType,
    String? issueType,
    double? price,
  }) async {
    state = const AsyncLoading();
    try {
      final user = ref.read(userProvider);
      if (user == null) throw Exception('Not authenticated');
      final repo = ref.read(userDashboardRepositoryProvider);
      final res = await repo.createServiceRequest(
        requesterId: user.id,
        requestType: requestType,
        locationLat: locationLat,
        locationLng: locationLng,
        locationAddress: locationAddress,
        vehicleInfo: vehicleInfo,
        description: description,
        fuelQuantity: fuelQuantity,
        fuelType: fuelType,
        issueType: issueType,
        price: price,
      );
      state = const AsyncData(null);
      // Invalidate so the list refreshes
      ref.invalidate(userServiceRequestsProvider);
      return res.fold((_) => false, (_) => true);
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final createServiceRequestProvider =
    AsyncNotifierProvider<CreateServiceRequestNotifier, void>(
        CreateServiceRequestNotifier.new);

// ── Cancel service request ────────────────────────────────────────────────────
class CancelRequestNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> cancel(String requestId) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(userDashboardRepositoryProvider);
      final res = await repo.cancelServiceRequest(requestId);
      state = const AsyncData(null);
      ref.invalidate(userServiceRequestsProvider);
      return res.fold((_) => false, (_) => true);
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final cancelRequestProvider =
    AsyncNotifierProvider<CancelRequestNotifier, void>(CancelRequestNotifier.new);

// ── P2P availability toggle ───────────────────────────────────────────────────
final p2pAvailabilityProvider = StateProvider<bool>((ref) => false);

// ── Update P2P availability + location ───────────────────────────────────────
Future<void> updateP2pAvailability(
    WidgetRef ref, bool isAvailable, {double? lat, double? lng}) async {
  final user = ref.read(userProvider);
  if (user == null) return;
  await ref.read(userDashboardRepositoryProvider).updateP2pAvailability(
    user.id, isAvailable, lat: lat, lng: lng,
  );
  ref.read(p2pAvailabilityProvider.notifier).state = isAvailable;
}
