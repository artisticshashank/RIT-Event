import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/models/service_request_model.dart';
import 'package:autonexa/models/enums.dart';
import 'package:autonexa/features/dashboard_user/controller/user_dashboard_controller.dart';
import 'package:autonexa/features/dashboard_user/screens/post_request_screen.dart';
import 'package:autonexa/features/dashboard_user/screens/request_tracking_screen.dart';
import 'package:autonexa/features/dashboard_user/widgets/active_request_card.dart';
import 'package:autonexa/core/common/loader.dart';

class RequestListScreen extends ConsumerStatefulWidget {
  const RequestListScreen({super.key});

  @override
  ConsumerState<RequestListScreen> createState() => _RequestListScreenState();
}

class _RequestListScreenState extends ConsumerState<RequestListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _cancelRequest(String requestId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cancel Request',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
            'Are you sure you want to cancel this service request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Yes, Cancel',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    final success =
        await ref.read(cancelRequestProvider.notifier).cancel(requestId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(success ? 'Request cancelled.' : 'Could not cancel. Try again.'),
        backgroundColor: success ? Pallete.secondaryColor : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ── Status badge ────────────────────────────────────────────────────────────
  String _statusLabel(ServiceRequestModel r) {
    switch (r.status.name) {
      case 'searching':
        return 'AWAITING RESPONSES';
      case 'accepted':
        return 'TECHNICIAN ASSIGNED';
      case 'arriving':
        return 'WORK IN PROGRESS';
      default:
        return r.status.name.toUpperCase();
    }
  }

  Color _statusColor(ServiceRequestModel r) {
    switch (r.status.name) {
      case 'searching':
        return Colors.orange;
      case 'accepted':
        return Colors.teal;
      case 'arriving':
        return Pallete.secondaryColor;
      default:
        return Colors.grey;
    }
  }

  // ── Active requests tab ─────────────────────────────────────────────────────
  Widget _buildActiveTab() {
    final requestsAsync = ref.watch(activeRequestsProvider);
    return requestsAsync.when(
      data: (requests) {
        if (requests.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.playlist_remove,
                      size: 64, color: Pallete.textSecondaryColor),
                  SizedBox(height: 16),
                  Text(
                    'No active requests.',
                    style: TextStyle(
                        color: Pallete.textSecondaryColor, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0).copyWith(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ACTIVE REQUESTS (${requests.length})',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Pallete.textSecondaryColor,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              ...requests.map((r) => ActiveRequestCard(
                    status: _statusLabel(r),
                    statusColor: _statusColor(r),
                    title: r.vehicleInfo ?? 'Your Vehicle',
                    subtitle: r.issueType ?? r.requestType.displayName,
                    icon: _iconForType(r),
                    buttonText: r.status.name == 'accepted' ||
                            r.status.name == 'arriving'
                        ? 'Track Arrival'
                        : 'View Offers',
                    buttonIcon: r.status.name == 'accepted' ||
                            r.status.name == 'arriving'
                        ? Icons.location_on
                        : null,
                    primaryButton: r.status.name != 'searching',
                    buttonAction: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RequestTrackingScreen(request: r),
                        ),
                      );
                    },
                    extraContent: GestureDetector(
                      onTap: () => _cancelRequest(r.id),
                      child: const Text(
                        'Cancel Request',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        );
      },
      loading: () => const Loader(),
      error: (e, _) =>
          Center(child: Text(e.toString())),
    );
  }

  // ── History tab ─────────────────────────────────────────────────────────────
  Widget _buildHistoryTab() {
    final historyAsync = ref.watch(requestHistoryProvider);
    return historyAsync.when(
      data: (requests) {
        if (requests.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('No completed requests yet.',
                  style: TextStyle(color: Pallete.textSecondaryColor)),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(24).copyWith(bottom: 120),
          itemCount: requests.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final r = requests[i];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Pallete.secondaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_iconForType(r),
                        color: Pallete.secondaryColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.requestType.displayName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          r.vehicleInfo ?? '',
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
                        r.price != null
                            ? '\$${r.price!.toStringAsFixed(2)}'
                            : '',
                        style: const TextStyle(
                          color: Pallete.secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('COMPLETED',
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Loader(),
      error: (e, _) => Center(child: Text(e.toString())),
    );
  }

  IconData _iconForType(ServiceRequestModel r) {
    switch (r.requestType) {
      case ServiceType.towing:
        return Icons.rv_hookup;
      case ServiceType.fuel_share:
        return Icons.local_gas_station;
      case ServiceType.flat_tire:
        return Icons.tire_repair;
      case ServiceType.jump_start:
        return Icons.battery_charging_full;
      case ServiceType.mechanical_repair:
        return Icons.precision_manufacturing;
      default:
        return Icons.build;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Requests',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Pallete.secondaryColor,
          labelColor: textColor,
          unselectedLabelColor: Pallete.textSecondaryColor,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'History'),
            Tab(text: 'Drafts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveTab(),
          _buildHistoryTab(),
          const Center(
            child: Text('Drafts coming soon',
                style: TextStyle(color: Pallete.textSecondaryColor)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.secondaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PostRequestScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
