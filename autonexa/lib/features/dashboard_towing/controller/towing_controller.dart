import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/models/towing_dashboard_model.dart';
import 'package:autonexa/models/service_transaction_model.dart';
import 'package:autonexa/features/auth/controller/auth_controller.dart';
import 'package:autonexa/features/dashboard_towing/repository/towing_repository.dart';

// ── Overview stats ────────────────────────────────────────────────────────────
final towingOverviewProvider = FutureProvider<TowingOverviewModel>((ref) async {
  final user = ref.watch(userProvider);
  if (user == null) throw Exception('User is not authenticated');
  return ref.watch(towingRepositoryProvider).fetchOverview(user.id);
});

// ── Incoming (searching) requests ────────────────────────────────────────────
final towingRequestsProvider =
    FutureProvider<List<TowingRequestModel>>((ref) async {
  final user = ref.watch(userProvider);
  if (user == null) throw Exception('User is not authenticated');
  return ref.watch(towingRepositoryProvider).fetchIncomingRequests(user.id);
});

// ── Completed job history ────────────────────────────────────────────────────
final towingHistoryProvider =
    FutureProvider<List<TowingRequestModel>>((ref) async {
  final user = ref.watch(userProvider);
  if (user == null) throw Exception('User is not authenticated');
  return ref.watch(towingRepositoryProvider).fetchHistory(user.id);
});

// ── Earnings / transactions ──────────────────────────────────────────────────
final towingEarningsProvider =
    FutureProvider<List<ServiceTransactionModel>>((ref) async {
  final user = ref.watch(userProvider);
  if (user == null) throw Exception('User is not authenticated');
  return ref.watch(towingRepositoryProvider).fetchEarnings(user.id);
});

// ── Assign / accept a towing request ─────────────────────────────────────────
class AssignTowingDriverNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async => false;

  Future<bool> assign(String requestId, double price) async {
    state = const AsyncLoading();
    try {
      final user = ref.read(userProvider);
      if (user == null) throw Exception('Not authenticated');
      await ref
          .read(towingRepositoryProvider)
          .assignDriver(requestId, user.id, price);
      ref.invalidate(towingRequestsProvider);
      ref.invalidate(towingOverviewProvider);
      state = const AsyncData(true);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final assignTowingDriverProvider =
    AsyncNotifierProvider<AssignTowingDriverNotifier, bool>(
        AssignTowingDriverNotifier.new);

// ── Decline request ──────────────────────────────────────────────────────────
class DeclineTowingRequestNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async => false;

  Future<bool> decline(String requestId) async {
    state = const AsyncLoading();
    try {
      await ref.read(towingRepositoryProvider).declineRequest(requestId);
      ref.invalidate(towingRequestsProvider);
      ref.invalidate(towingOverviewProvider);
      state = const AsyncData(true);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final declineTowingRequestProvider =
    AsyncNotifierProvider<DeclineTowingRequestNotifier, bool>(
        DeclineTowingRequestNotifier.new);

// ── Mark payment received ────────────────────────────────────────────────────
class TowingMarkPaymentNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async => false;

  Future<bool> markReceived(String transactionId) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(towingRepositoryProvider)
          .markPaymentReceived(transactionId);
      ref.invalidate(towingEarningsProvider);
      state = const AsyncData(true);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final towingMarkPaymentProvider =
    AsyncNotifierProvider<TowingMarkPaymentNotifier, bool>(
        TowingMarkPaymentNotifier.new);

// ── Mark Arriving ────────────────────────────────────────────────────────────
class TowingMarkArrivingNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async => false;

  Future<bool> markArriving(String requestId) async {
    state = const AsyncLoading();
    try {
      await ref.read(towingRepositoryProvider).markArriving(requestId);
      state = const AsyncData(true);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final towingMarkArrivingProvider =
    AsyncNotifierProvider<TowingMarkArrivingNotifier, bool>(
        TowingMarkArrivingNotifier.new);

// ── Mark Complete ────────────────────────────────────────────────────────────
class TowingMarkCompleteNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async => false;

  Future<bool> markComplete(String requestId) async {
    state = const AsyncLoading();
    try {
      await ref.read(towingRepositoryProvider).markComplete(requestId);
      ref.invalidate(towingHistoryProvider);
      ref.invalidate(towingOverviewProvider);
      state = const AsyncData(true);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final towingMarkCompleteProvider =
    AsyncNotifierProvider<TowingMarkCompleteNotifier, bool>(
        TowingMarkCompleteNotifier.new);
