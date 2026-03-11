import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/core/common/loader.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/dashboard_towing/controller/towing_controller.dart';
import 'package:autonexa/features/dashboard_towing/widgets/towing_stat_card.dart';
import 'package:autonexa/features/dashboard_towing/widgets/towing_request_card.dart';
import 'package:autonexa/features/dashboard_towing/screens/towing_request_accepted_screen.dart';
import 'package:autonexa/models/towing_dashboard_model.dart';

class TowingRequestsScreen extends ConsumerWidget {
  const TowingRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewFuture = ref.watch(towingOverviewProvider);
    final requestsFuture = ref.watch(towingRequestsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final accentColor = Pallete.secondaryColor;
    final textColor = isDark ? Colors.white : Colors.black;
    // Deep slate background from the mockup
    final pageBgColor = isDark ? const Color(0xFF141A28) : Theme.of(context).scaffoldBackgroundColor;
    
    return Scaffold(
      backgroundColor: pageBgColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: accentColor,
          onRefresh: () async {
            // ignore: unused_result
            ref.refresh(towingOverviewProvider);
            // ignore: unused_result
            ref.refresh(towingRequestsProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom Header
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Icon(Icons.car_crash, color: Colors.white, size: 28),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AutoNexa',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'TOWING DASHBOARD',
                          style: TextStyle(
                            color: isDark ? Colors.white60 : Colors.black54,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF232B42) : Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.notifications, color: isDark ? Colors.white : Colors.black54, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          image: AssetImage('assets/images/placeholder_part.png'), // generic placeholder
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                    ),
                  ],
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Divider(color: Colors.white12, height: 1),
                ),

                // Stats Row
                overviewFuture.when(
                  data: (overview) => Row(
                    children: [
                      TowingStatCard(
                        title: 'STATUS',
                        value: overview.isOnline ? 'Online' : 'Offline',
                        prefixIcon: Container(
                          width: 8, height: 8,
                          decoration: BoxDecoration(
                            color: overview.isOnline ? Colors.greenAccent : Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      TowingStatCard(
                        title: 'REVENUE',
                        value: '\$${overview.revenue.toInt()}',
                      ),
                      TowingStatCard(
                        title: 'DRIVERS',
                        value: '${overview.activeDrivers}/${overview.totalDrivers}',
                        leftBorderColor: accentColor,
                      ),
                    ],
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Text('Error loading stats: $error', style: TextStyle(color: textColor)),
                ),

                const SizedBox(height: 32),

                // Active Requests Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Active Requests',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    overviewFuture.when(
                      data: (overview) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: accentColor.withValues(alpha: 0.5)),
                        ),
                        child: Text(
                          '${overview.pendingRequests} Pending',
                          style: TextStyle(
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      loading: () => const SizedBox(),
                      error: (_, __) => const SizedBox(),
                    )
                  ],
                ),

                const SizedBox(height: 20),

                // Incoming Requests List
                requestsFuture.when(
                  data: (requests) {
                    if (requests.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              Icon(Icons.car_crash,
                                  size: 56,
                                  color: accentColor.withValues(alpha: 0.3)),
                              const SizedBox(height: 16),
                              Text('No active requests right now.',
                                  style: TextStyle(color: Colors.white60)),
                            ],
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: requests.map((request) {
                        return _TowingRequestCardWrapper(request: request);
                      }).toList(),
                    );
                  },
                  loading: () => const Loader(),
                  error: (error, stack) =>
                      Text(error.toString(), style: TextStyle(color: textColor)),
                ),

                const SizedBox(height: 16),

                // Live Fleet Map Overview Footer Map Area
                overviewFuture.when(
                  data: (overview) => Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2436),
                      borderRadius: BorderRadius.circular(24),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/map_overlay.png'),
                        fit: BoxFit.cover,
                        opacity: 0.4,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Text('LIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: accentColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.map, color: Colors.white, size: 24),
                              ),
                              const SizedBox(height: 12),
                              const Text('Live Fleet Map', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('${overview.activeJobPins} Active job pins • ${overview.liveTrucks} Trucks live', 
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                ),

                const SizedBox(height: 120), // Pad for floating nav bar
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Per-card wrapper that wires assign/decline to real providers ─────────────
class _TowingRequestCardWrapper extends ConsumerWidget {
  final TowingRequestModel request;
  const _TowingRequestCardWrapper({required this.request});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignState = ref.watch(assignTowingDriverProvider);
    final declineState = ref.watch(declineTowingRequestProvider);
    final isLoading =
        assignState is AsyncLoading || declineState is AsyncLoading;

    return TowingRequestCard(
      request: request,
      onAssign: isLoading
          ? () {}
          : () async {
              final ok = await ref
                  .read(assignTowingDriverProvider.notifier)
                  .assign(request.id, request.price);
              if (ok && context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        TowingRequestAcceptedScreen(request: request),
                  ),
                );
              } else if (!ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to assign driver. Please retry.'),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
      onDecline: isLoading
          ? () {}
          : () async {
              final ok = await ref
                  .read(declineTowingRequestProvider.notifier)
                  .decline(request.id);
              if (ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Request declined.'),
                    backgroundColor: Colors.orange.shade700,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              }
            },
    );
  }
}
