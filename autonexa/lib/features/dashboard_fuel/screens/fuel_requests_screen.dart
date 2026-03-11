import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/core/common/loader.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/dashboard_fuel/controller/fuel_controller.dart';
import 'package:autonexa/features/dashboard_fuel/screens/fuel_request_accepted_screen.dart';
import 'package:autonexa/features/dashboard_fuel/widgets/fuel_stat_card.dart';
import 'package:autonexa/features/dashboard_fuel/widgets/fuel_request_card.dart';

class FuelRequestsScreen extends ConsumerWidget {
  const FuelRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewFuture = ref.watch(fuelOverviewProvider);
    final requestsFuture = ref.watch(fuelRequestsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final accentColor = Pallete.secondaryColor;
    final textColor = isDark ? Colors.white : Pallete.textColor;
    final pageBgColor = isDark ? const Color(0xFF1E140D) : Theme.of(context).scaffoldBackgroundColor; // Deep tinted background styling from mockup
    
    return Scaffold(
      backgroundColor: pageBgColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: accentColor,
          onRefresh: () async {
            // ignore: unused_result
            ref.refresh(fuelOverviewProvider);
            // ignore: unused_result
            ref.refresh(fuelRequestsProvider);
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
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: accentColor, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.ev_station, color: accentColor),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AutoNexa Prime',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: accentColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Online • Station #402',
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.notifications, color: accentColor),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),

                // Stats Row
                overviewFuture.when(
                  data: (overview) => Row(
                    children: [
                      FuelStatCard(
                        title: 'ACTIVE',
                        value: overview.activeRequests.toString(),
                        growth: overview.activeGrowth,
                        leftBorderColor: accentColor,
                        growthColor: Colors.greenAccent,
                      ),
                      FuelStatCard(
                        title: 'DONE',
                        value: overview.doneRequests.toString(),
                        growth: overview.doneGrowth,
                        leftBorderColor: Colors.blueAccent,
                        growthColor: Colors.greenAccent,
                      ),
                      FuelStatCard(
                        title: 'REVENUE',
                        value: '\$${(overview.revenue/1000).toStringAsFixed(1)}k',
                        growth: overview.revenueGrowth,
                        leftBorderColor: Colors.orangeAccent,
                        growthColor: Colors.greenAccent,
                      ),
                    ],
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Text('Error loading stats: $error', style: TextStyle(color: textColor)),
                ),

                const SizedBox(height: 24),

                // Map View Banner
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF14162B), // Dark navy map background
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/map_overlay.png'), // Placeholder
                      fit: BoxFit.cover,
                      opacity: 0.3,
                    ),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.map, color: Pallete.secondaryColor, size: 20),
                          SizedBox(width: 12),
                          Text(
                            'View All Requests on Map',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Incoming Requests Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Incoming Requests',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        'NEW',
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Incoming Requests List
                requestsFuture.when(
                  data: (requests) {
                    if (requests.isEmpty) {
                      return Center(
                        child: Text(
                          'No incoming requests right now.',
                          style: TextStyle(color: Colors.white60),
                        ),
                      );
                    }
                    return Column(
                      children: requests.map((request) {
                        return FuelRequestCard(
                          request: request,
                          onAccept: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FuelRequestAcceptedScreen(request: request),
                              ),
                            );
                          },
                          onDecline: () {},
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const Loader(),
                  error: (error, stack) => Text(error.toString(), style: TextStyle(color: textColor)),
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
