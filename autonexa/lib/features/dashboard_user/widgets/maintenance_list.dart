import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/features/dashboard_user/controller/user_dashboard_controller.dart';
import 'package:autonexa/models/enums.dart';

class MaintenanceList extends ConsumerWidget {
  const MaintenanceList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Pallete.textColor;
    final servicesAsync = ref.watch(userServiceRequestsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Maintenance',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                'VIEW ALL',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Pallete.secondaryColor,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          servicesAsync.when(
            data: (services) {
              if (services.isEmpty) {
                // Return dummy items based on image for demonstration, if empty
                return Column(
                  children: [
                    _buildMaintenanceItem(
                      context: context,
                      title: 'Tire Rotation',
                      subtitle: 'Due in 550 miles',
                      icon: Icons.tire_repair,
                      iconColor: Pallete.secondaryColor,
                      isActive: true, // Left orange border
                    ),
                    const SizedBox(height: 16),
                    _buildMaintenanceItem(
                      context: context,
                      title: 'Brake Fluid Check',
                      subtitle: 'Scheduled: Oct 12, 2024',
                      icon: Icons.water_drop,
                      iconColor: Colors.blueAccent,
                      isActive: false,
                    ),
                  ],
                );
              }
              // If there's real data
              return ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return _buildMaintenanceItem(
                    context: context,
                    title: service.requestType.name.split('_').map((e) => e[0].toUpperCase() + e.substring(1)).join(' '),
                    subtitle: service.description ?? 'Scheduled',
                    icon: _getIconForService(service.requestType),
                    iconColor: index == 0 ? Pallete.secondaryColor : Colors.blueAccent,
                    isActive: index == 0,
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemCount: services.length > 3 ? 3 : services.length,
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text(err.toString())),
          ),
        ],
      ),
    );
  }

  IconData _getIconForService(ServiceType type) {
    switch(type) {
      case ServiceType.towing: return Icons.car_crash;
      case ServiceType.mechanical_repair: return Icons.build;
      case ServiceType.fuel_share: return Icons.local_gas_station;
      case ServiceType.jump_start: return Icons.battery_charging_full;
      case ServiceType.flat_tire: return Icons.tire_repair; // Add mapping if needed
      case ServiceType.parts_delivery: return Icons.construction;
    }
  }

  Widget _buildMaintenanceItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required bool isActive,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isActive ? Colors.transparent : Pallete.textSecondaryColor.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        children: [
          if (isActive)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 6,
                decoration: const BoxDecoration(
                  color: Pallete.secondaryColor,
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(24)),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                SizedBox(width: isActive ? 8 : 0),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: iconColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Pallete.textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Pallete.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Pallete.textSecondaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
