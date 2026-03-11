import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/models/fuel_dashboard_model.dart';
import 'package:autonexa/models/service_transaction_model.dart';
import 'package:autonexa/features/auth/controller/auth_controller.dart';
import 'package:autonexa/features/dashboard_fuel/repository/fuel_repository.dart';

// ── Overview stats ────────────────────────────────────────────────────────────
final fuelOverviewProvider = FutureProvider<FuelStationOverviewModel>((
  ref,
) async {
  final user = ref.watch(userProvider);
  if (user == null) throw Exception('User is not authenticated');
  return ref.watch(fuelRepositoryProvider).fetchOverview(user.id);
});

// ── Incoming (searching) requests ────────────────────────────────────────────
final fuelRequestsProvider = FutureProvider<List<FuelRequestModel>>((
  ref,
) async {
  final user = ref.watch(userProvider);
  if (user == null) throw Exception('User is not authenticated');
  return ref.watch(fuelRepositoryProvider).fetchIncomingRequests(user.id);
});

// ── Completed job history ────────────────────────────────────────────────────
final fuelHistoryProvider = FutureProvider<List<FuelRequestModel>>((ref) async {
  final user = ref.watch(userProvider);
  if (user == null) throw Exception('User is not authenticated');
  return ref.watch(fuelRepositoryProvider).fetchHistory(user.id);
});

// ── Earnings / transactions ──────────────────────────────────────────────────
final fuelEarningsProvider = FutureProvider<List<ServiceTransactionModel>>((
  ref,
) async {
  final user = ref.watch(userProvider);
  if (user == null) throw Exception('User is not authenticated');
  return ref.watch(fuelRepositoryProvider).fetchEarnings(user.id);
});

// ── Accept request ───────────────────────────────────────────────────────────
class AcceptFuelRequestNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async => false;

  Future<bool> accept(String requestId, double price) async {
    state = const AsyncLoading();
    try {
      final user = ref.read(userProvider);
      if (user == null) throw Exception('Not authenticated');
      await ref
          .read(fuelRepositoryProvider)
          .acceptRequest(requestId, user.id, price);
      // Refresh providers so UI updates
      ref.invalidate(fuelRequestsProvider);
      ref.invalidate(fuelOverviewProvider);
      state = const AsyncData(true);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final acceptFuelRequestProvider =
    AsyncNotifierProvider<AcceptFuelRequestNotifier, bool>(
      AcceptFuelRequestNotifier.new,
    );

// ── Decline request ──────────────────────────────────────────────────────────
class DeclineFuelRequestNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async => false;

  Future<bool> decline(String requestId) async {
    state = const AsyncLoading();
    try {
      await ref.read(fuelRepositoryProvider).declineRequest(requestId);
      ref.invalidate(fuelRequestsProvider);
      ref.invalidate(fuelOverviewProvider);
      state = const AsyncData(true);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final declineFuelRequestProvider =
    AsyncNotifierProvider<DeclineFuelRequestNotifier, bool>(
      DeclineFuelRequestNotifier.new,
    );

// ── Mark payment received ────────────────────────────────────────────────────
class FuelMarkPaymentNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async => false;

  Future<bool> markReceived(String transactionId) async {
    state = const AsyncLoading();
    try {
      await ref.read(fuelRepositoryProvider).markPaymentReceived(transactionId);
      ref.invalidate(fuelEarningsProvider);
      state = const AsyncData(true);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final fuelMarkPaymentProvider =
    AsyncNotifierProvider<FuelMarkPaymentNotifier, bool>(
      FuelMarkPaymentNotifier.new,
    );

// ── Mark Arriving ────────────────────────────────────────────────────────────
class FuelMarkArrivingNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async => false;

  Future<bool> markArriving(String requestId) async {
    state = const AsyncLoading();
    try {
      await ref.read(fuelRepositoryProvider).markArriving(requestId);
      state = const AsyncData(true);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final fuelMarkArrivingProvider =
    AsyncNotifierProvider<FuelMarkArrivingNotifier, bool>(
      FuelMarkArrivingNotifier.new,
    );

// ── Mark Complete ────────────────────────────────────────────────────────────
class FuelMarkCompleteNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async => false;

  Future<bool> markComplete(String requestId) async {
    state = const AsyncLoading();
    try {
      await ref.read(fuelRepositoryProvider).markComplete(requestId);
      ref.invalidate(fuelHistoryProvider);
      ref.invalidate(fuelOverviewProvider);
      state = const AsyncData(true);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final fuelMarkCompleteProvider =
    AsyncNotifierProvider<FuelMarkCompleteNotifier, bool>(
      FuelMarkCompleteNotifier.new,
    );
