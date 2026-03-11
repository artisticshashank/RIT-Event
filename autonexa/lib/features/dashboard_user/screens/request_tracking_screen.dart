import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/models/service_request_model.dart';
import 'package:autonexa/models/enums.dart';
import 'package:autonexa/features/dashboard_user/widgets/live_tracking_card.dart';
import 'package:autonexa/features/dashboard_user/widgets/tracking_timeline.dart';
import 'package:autonexa/features/dashboard_user/widgets/active_request_card.dart';

class RequestTrackingScreen extends StatelessWidget {
  final ServiceRequestModel request;

  const RequestTrackingScreen({super.key, required this.request});

  String get _providerTitle {
    switch (request.requestType) {
      case ServiceType.fuel_share:
        return 'Fuel Technician';
      case ServiceType.towing:
        return 'Tow Operator';
      default:
        return 'Technician';
    }
  }

  String get _etatLabel {
    switch (request.status) {
      case ServiceStatus.accepted:
        return 'Provider Assigned';
      case ServiceStatus.arriving:
        return 'En Route to You';
      case ServiceStatus.completed:
        return 'Completed';
      default:
        return 'Searching...';
    }
  }

  Color _etaColor(BuildContext context) {
    switch (request.status) {
      case ServiceStatus.accepted:
        return Colors.teal;
      case ServiceStatus.arriving:
        return Pallete.secondaryColor;
      case ServiceStatus.completed:
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subText = isDark ? Colors.white60 : Colors.black54;
    final responder = request.responder;

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
          'Live Tracking',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0).copyWith(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Status banner ────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: _etaColor(context).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _etaColor(context).withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.circle, color: _etaColor(context), size: 10),
                  const SizedBox(width: 10),
                  Text(
                    _etatLabel,
                    style: TextStyle(
                      color: _etaColor(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    request.requestType.displayName,
                    style: TextStyle(color: subText, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'LIVE TRACKING',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    letterSpacing: 1.2,
                  ),
                ),
                const Row(
                  children: [
                    Icon(Icons.circle, color: Pallete.secondaryColor, size: 8),
                    SizedBox(width: 4),
                    Text(
                      'LIVE UPDATE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Pallete.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const LiveTrackingCard(),
            const SizedBox(height: 24),
            const TrackingTimeline(),
            const SizedBox(height: 32),

            // ── Provider info card ─────────────────────────────────────
            if (responder != null) ...[
              Text(
                'YOUR PROVIDER',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E2436) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.05),
                  ),
                ),
                child: Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Pallete.secondaryColor.withValues(
                        alpha: 0.15,
                      ),
                      backgroundImage:
                          responder.avatarUrl != null &&
                              responder.avatarUrl!.isNotEmpty
                          ? NetworkImage(responder.avatarUrl!)
                          : null,
                      child: responder.avatarUrl == null
                          ? const Icon(
                              Icons.person,
                              color: Pallete.secondaryColor,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            responder.name,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _providerTitle,
                            style: TextStyle(color: subText, fontSize: 12),
                          ),
                          if (responder.rating != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    responder.rating!.toStringAsFixed(1),
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Contact icons
                    Row(
                      children: [
                        _contactBtn(
                          icon: Icons.phone,
                          isDark: isDark,
                          onTap: () {},
                        ),
                        const SizedBox(width: 8),
                        _contactBtn(
                          icon: Icons.message,
                          isDark: isDark,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // ── Request Details ────────────────────────────────────────
            Text(
              'REQUEST DETAILS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: textColor,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            ActiveRequestCard(
              status: request.status.name.toUpperCase().replaceAll('_', ' '),
              statusColor: _etaColor(context),
              title: request.vehicleInfo ?? 'Your Vehicle',
              subtitle: request.issueType ?? request.requestType.displayName,
              icon: _iconForType(request.requestType),
              buttonText: 'Refresh Status',
              buttonIcon: Icons.refresh,
              buttonAction: () {},
              primaryButton: false,
              extraContent: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (request.locationAddress != null)
                    _detailRow(
                      Icons.location_on,
                      request.locationAddress!,
                      isDark,
                    ),
                  if (request.price != null)
                    _detailRow(
                      Icons.payments,
                      '\$${request.price!.toStringAsFixed(2)} agreed price',
                      isDark,
                    ),
                  if (request.fuelType != null)
                    _detailRow(
                      Icons.local_gas_station,
                      '${request.fuelQuantity ?? ''} ${request.fuelType}',
                      isDark,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactBtn({
    required IconData icon,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.06),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Pallete.secondaryColor),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(ServiceType type) {
    switch (type) {
      case ServiceType.towing:
        return Icons.rv_hookup;
      case ServiceType.fuel_share:
        return Icons.local_gas_station;
      case ServiceType.flat_tire:
        return Icons.tire_repair;
      case ServiceType.jump_start:
        return Icons.battery_charging_full;
      default:
        return Icons.build;
    }
  }
}
