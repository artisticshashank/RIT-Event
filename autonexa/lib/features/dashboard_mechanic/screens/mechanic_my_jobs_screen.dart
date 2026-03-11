import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/models/service_request_model.dart';
import 'package:autonexa/models/enums.dart';
import 'package:autonexa/core/common/loader.dart';
import 'package:autonexa/features/dashboard_mechanic/controller/mechanic_controller.dart';
import 'package:autonexa/features/dashboard_mechanic/widgets/job_summary_card.dart';
import 'package:autonexa/features/dashboard_mechanic/widgets/mechanic_job_card.dart';
import 'package:autonexa/features/dashboard_mechanic/screens/mechanic_navigation_screen.dart';

class MechanicMyJobsScreen extends ConsumerStatefulWidget {
  const MechanicMyJobsScreen({super.key});

  @override
  ConsumerState<MechanicMyJobsScreen> createState() =>
      _MechanicMyJobsScreenState();
}

class _MechanicMyJobsScreenState
    extends ConsumerState<MechanicMyJobsScreen> {
  // 0 = Today (active), 1 = History
  int _tabIndex = 0;

  Future<void> _handleStatusUpdate(ServiceRequestModel job) async {
    if (job.status == ServiceStatus.accepted) {
      await _doStatusAction(
        label: 'Mark Arriving',
        action: () =>
            ref.read(markArrivingProvider.notifier).markArriving(job.id),
      );
    } else if (job.status == ServiceStatus.arriving) {
      await _doStatusAction(
        label: 'Mark Complete',
        action: () =>
            ref.read(markCompleteProvider.notifier).markComplete(job.id),
      );
    }
  }

  Future<void> _doStatusAction({
    required String label,
    required Future<bool> Function() action,
  }) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to $label?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('No')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('Yes',
                  style: TextStyle(color: Pallete.secondaryColor))),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    final success = await action();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Status updated!' : 'Failed. Try again.'),
        backgroundColor:
            success ? Pallete.secondaryColor : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final activeAsync = ref.watch(activeJobsProvider);
    final historyAsync = ref.watch(mechanicJobHistoryProvider);

    final activeCount = activeAsync.value?.length ?? 0;
    final historyCount = historyAsync.value?.length ?? 0;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Today's Jobs",
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Pallete.secondaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$activeCount ACTIVE',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Summary cards (live counts)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      JobSummaryCard(
                        title: 'Active',
                        count: activeAsync
                                .value
                                ?.where((j) =>
                                    j.status == ServiceStatus.arriving)
                                .length
                                .toString() ??
                            '0',
                        colorOverride: Pallete.primaryColor,
                      ),
                      const SizedBox(width: 12),
                      JobSummaryCard(
                        title: 'Accepted',
                        count: activeAsync
                                .value
                                ?.where((j) =>
                                    j.status == ServiceStatus.accepted)
                                .length
                                .toString() ??
                            '0',
                      ),
                      const SizedBox(width: 12),
                      JobSummaryCard(
                        title: 'History',
                        count: historyCount.toString(),
                        colorOverride: isDark
                            ? Colors.green.withAlpha(50)
                            : Colors.green.withAlpha(20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Tab row
                Row(
                  children: [
                    _buildTabLabel('Today', 0),
                    const SizedBox(width: 24),
                    _buildTabLabel('History', 1),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 3,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Pallete.secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // ── Tab content: Today / History ────────────────────────────────
        if (_tabIndex == 0)
          activeAsync.when(
            data: (jobs) {
              if (jobs.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(Icons.assignment_turned_in,
                            size: 64,
                            color: Pallete.textSecondaryColor),
                        const SizedBox(height: 16),
                        const Text(
                          'No active jobs right now.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Pallete.textSecondaryColor,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final job = jobs[index];
                      return IntrinsicHeight(
                        child: Row(
                          children: [
                            // Timeline
                            SizedBox(
                              width: 40,
                              child: Column(
                                children: [
                                  Container(
                                    height: 16,
                                    width: 16,
                                    decoration: BoxDecoration(
                                      color: index == 0
                                          ? Pallete.secondaryColor
                                          : Colors.grey,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isDark
                                            ? Colors.black
                                            : Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _statusShort(job),
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color:
                                            Pallete.textSecondaryColor),
                                  ),
                                  Expanded(
                                    child: Container(
                                        width: 2,
                                        color: Colors.grey.withAlpha(50)),
                                  ),
                                ],
                              ),
                            ),
                            // Card
                            Expanded(
                              child: MechanicJobCard(
                                job: job,
                                onNavigate: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          MechanicNavigationScreen(
                                              serviceRequest: job),
                                    ),
                                  );
                                },
                                onStatusUpdate: () =>
                                    _handleStatusUpdate(job),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: jobs.length,
                  ),
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(child: Loader()),
            error: (e, _) => SliverToBoxAdapter(
                child: Center(child: Text(e.toString()))),
          )
        else
          // History tab
          historyAsync.when(
            data: (jobs) {
              if (jobs.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: const [
                        Icon(Icons.history,
                            size: 64,
                            color: Pallete.textSecondaryColor),
                        SizedBox(height: 16),
                        Text('No completed jobs yet.',
                            style: TextStyle(
                                color: Pallete.textSecondaryColor,
                                fontSize: 16)),
                      ],
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final job = jobs[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: isDark
                                  ? Colors.white12
                                  : Colors.black12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check_circle,
                                  color: Colors.green, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    job.requestType.displayName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    job.vehicleInfo ?? job.description ?? '—',
                                    style: const TextStyle(
                                        color: Pallete.textSecondaryColor,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  job.price != null
                                      ? '\$${job.price!.toStringAsFixed(0)}'
                                      : '—',
                                  style: const TextStyle(
                                    color: Pallete.secondaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text('COMPLETED',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: jobs.length,
                  ),
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(child: Loader()),
            error: (e, _) => SliverToBoxAdapter(
                child: Center(child: Text(e.toString()))),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildTabLabel(String label, int idx) {
    final isSelected = _tabIndex == idx;
    return GestureDetector(
      onTap: () => setState(() => _tabIndex = idx),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight:
              isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? Pallete.secondaryColor
              : Pallete.textSecondaryColor,
        ),
      ),
    );
  }

  String _statusShort(ServiceRequestModel job) {
    switch (job.status) {
      case ServiceStatus.accepted:
        return 'ACCEPTED';
      case ServiceStatus.arriving:
        return 'EN ROUTE';
      default:
        return '';
    }
  }
}
