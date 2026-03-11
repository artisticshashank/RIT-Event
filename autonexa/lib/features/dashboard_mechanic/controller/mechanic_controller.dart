import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:autonexa/features/dashboard_mechanic/repository/mechanic_repository.dart';
import 'package:autonexa/models/service_request_model.dart';
import 'package:autonexa/models/service_transaction_model.dart';
import 'package:autonexa/features/auth/controller/auth_controller.dart';

// ── Pending jobs stream (all open requests the mechanic can grab) ─────────────
final pendingJobsProvider = StreamProvider<List<ServiceRequestModel>>((ref) {
  return ref.read(mechanicRepositoryProvider).getPendingJobs();
});

// ── Active/in-progress jobs for this mechanic ─────────────────────────────────
final activeJobsProvider = StreamProvider<List<ServiceRequestModel>>((ref) {
  final user = ref.watch(userProvider);
  if (user == null) return Stream.value([]);
  return ref.read(mechanicRepositoryProvider).getActiveJobs(user.id);
});

// ── Completed job history ─────────────────────────────────────────────────────
final mechanicJobHistoryProvider = FutureProvider<List<ServiceRequestModel>>((
  ref,
) async {
  final user = ref.watch(userProvider);
  if (user == null) return [];
  return ref.read(mechanicRepositoryProvider).getJobHistory(user.id);
});

// ── Earnings / transactions ───────────────────────────────────────────────────
final mechanicEarningsProvider = FutureProvider<List<ServiceTransactionModel>>((
  ref,
) async {
  final user = ref.watch(userProvider);
  if (user == null) return [];
  return ref.read(mechanicRepositoryProvider).getEarnings(user.id);
});

// ── Online / availability toggle (local state) ────────────────────────────────
final mechanicOnlineProvider = StateProvider<bool>((ref) => false);

// ── Accept job action ─────────────────────────────────────────────────────────
class AcceptJobNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> accept(String requestId) async {
    state = const AsyncLoading();
    try {
      final user = ref.read(userProvider);
      if (user == null) throw Exception('Not authenticated');
      final success = await ref
          .read(mechanicRepositoryProvider)
          .acceptJob(requestId, user.id);
      state = const AsyncData(null);
      // Refresh both providers
      ref.invalidate(pendingJobsProvider);
      ref.invalidate(activeJobsProvider);
      return success;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final acceptJobProvider = AsyncNotifierProvider<AcceptJobNotifier, void>(
  AcceptJobNotifier.new,
);

// ── Mark Arriving ─────────────────────────────────────────────────────────────
class MarkArrivingNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> markArriving(String requestId) async {
    state = const AsyncLoading();
    try {
      final success = await ref
          .read(mechanicRepositoryProvider)
          .markArriving(requestId);
      state = const AsyncData(null);
      ref.invalidate(activeJobsProvider);
      return success;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final markArrivingProvider = AsyncNotifierProvider<MarkArrivingNotifier, void>(
  MarkArrivingNotifier.new,
);

// ── Mark Job Complete ─────────────────────────────────────────────────────────
class MarkCompleteNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> markComplete(String requestId) async {
    state = const AsyncLoading();
    try {
      final success = await ref
          .read(mechanicRepositoryProvider)
          .markJobComplete(requestId);
      state = const AsyncData(null);
      ref.invalidate(activeJobsProvider);
      ref.invalidate(mechanicJobHistoryProvider);
      ref.invalidate(mechanicEarningsProvider);
      return success;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final markCompleteProvider = AsyncNotifierProvider<MarkCompleteNotifier, void>(
  MarkCompleteNotifier.new,
);

// ── Update availability in Supabase ──────────────────────────────────────────
Future<void> updateMechanicAvailability(WidgetRef ref, bool isOnline) async {
  final user = ref.read(userProvider);
  if (user == null) return;
  await ref
      .read(mechanicRepositoryProvider)
      .updateAvailability(user.id, isOnline);
  ref.read(mechanicOnlineProvider.notifier).state = isOnline;
}
