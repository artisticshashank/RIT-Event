import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/core/common/floating_bottom_nav_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/features/auth/controller/auth_controller.dart';
import 'package:autonexa/models/service_request_model.dart';
import 'package:autonexa/models/enums.dart';
import 'package:autonexa/features/dashboard_mechanic/controller/mechanic_controller.dart';

class MechanicNavigationScreen extends ConsumerStatefulWidget {
  final ServiceRequestModel serviceRequest;
  const MechanicNavigationScreen({super.key, required this.serviceRequest});

  @override
  ConsumerState<MechanicNavigationScreen> createState() =>
      _MechanicNavigationScreenState();
}

class _MechanicNavigationScreenState
    extends ConsumerState<MechanicNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF10141F) : Colors.white,
      body: Stack(
        children: [
          // Dummy Map Background
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF151924) : Colors.grey[300],
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.map,
                    size: 250,
                    color: isDark ? Colors.white10 : Colors.black12,
                  ),
                ),
                // Location ripple
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Pallete.secondaryColor.withAlpha(20),
                    ),
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Pallete.secondaryColor,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.navigation,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                // Map controls
                Positioned(
                  right: 16,
                  top: 140,
                  child: Column(
                    children: [
                      _buildMapButton(Icons.add, isDark),
                      const SizedBox(height: 8),
                      _buildMapButton(Icons.remove, isDark),
                      const SizedBox(height: 24),
                      CircleAvatar(
                        backgroundColor: Pallete.secondaryColor,
                        radius: 24,
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Navigation Header Box
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C3146) : Pallete.primaryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Pallete.secondaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.turn_left,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Turn Left in 200m',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'onto Grand Avenue',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white12,
                    child: IconButton(
                      icon: const Icon(Icons.volume_up),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Sheet / Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1D2D) : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // Profile row
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Pallete.secondaryColor,
                                  width: 2,
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user?.name ?? "Mechanic")}&background=random',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user?.name ?? 'Marcus\nThompson',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      height: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Pallete.secondaryColor.withAlpha(
                                        30,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'ADVANCED\nDIAGNOSTICS',
                                      style: TextStyle(
                                        color: Pallete.secondaryColor,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Action Buttons
                            Row(
                              children: [
                                _buildActionButton(Icons.chat_bubble, isDark),
                                const SizedBox(width: 12),
                                _buildActionButton(
                                  Icons.phone,
                                  true,
                                  color: const Color(0xFF3B4A93),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Stats Row
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard('ETA', '14:45', isDark),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                'TIME',
                                '8 min',
                                isDark,
                                valueColor: Pallete.secondaryColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard('DIST', '3.2 km', isDark),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Arrived / Complete button — REAL
                        Builder(
                          builder: (ctx) {
                            final job = widget.serviceRequest;
                            final arrivingState = ref.watch(
                              markArrivingProvider,
                            );
                            final completeState = ref.watch(
                              markCompleteProvider,
                            );
                            final isArriving =
                                job.status == ServiceStatus.arriving;
                            final isLoading =
                                arrivingState is AsyncLoading ||
                                completeState is AsyncLoading;

                            return SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () async {
                                        if (!isArriving) {
                                          final ok = await ref
                                              .read(
                                                markArrivingProvider.notifier,
                                              )
                                              .markArriving(job.id);
                                          if (ok && ctx.mounted) {
                                            setState(() {});
                                            ScaffoldMessenger.of(
                                              ctx,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                  'Marked as Arriving!',
                                                ),
                                                backgroundColor:
                                                    Pallete.secondaryColor,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                margin: const EdgeInsets.all(
                                                  16,
                                                ),
                                              ),
                                            );
                                          }
                                        } else {
                                          final ok = await ref
                                              .read(
                                                markCompleteProvider.notifier,
                                              )
                                              .markComplete(job.id);
                                          if (ok && ctx.mounted) {
                                            Navigator.pop(ctx);
                                          }
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isArriving
                                      ? Colors.green
                                      : Pallete.secondaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            isArriving
                                                ? Icons.check_circle
                                                : Icons.location_on,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            isArriving
                                                ? 'MARK JOB COMPLETE'
                                                : 'ARRIVED AT LOCATION',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 100), // Space for bottom nav
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Nav Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingBottomNavBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
                if (index != 0) {
                  Navigator.pop(
                    context,
                  ); // Simple pop out if they tap away from navigation tab for demo
                }
              },
              items: [
                NavBarItem(icon: Icons.navigation, label: 'Navigate'),
                NavBarItem(icon: Icons.build, label: 'Jobs'),
                NavBarItem(icon: Icons.history, label: 'History'),
                NavBarItem(icon: Icons.person_outline, label: 'Profile'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton(IconData icon, bool isDark) {
    return CircleAvatar(
      backgroundColor: isDark ? const Color(0xFF1E2333) : Colors.white,
      radius: 24,
      child: Icon(icon, color: isDark ? Colors.white : Colors.black),
    );
  }

  Widget _buildActionButton(IconData icon, bool isDark, {Color? color}) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color ?? (isDark ? Colors.white12 : Colors.black12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    bool isDark, {
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151924) : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Pallete.textSecondaryColor,
              fontSize: 11,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? (isDark ? Colors.white : Colors.black),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
