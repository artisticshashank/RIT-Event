import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/models/service_request_model.dart';
import 'package:autonexa/models/enums.dart';
import 'package:autonexa/features/dashboard_mechanic/widgets/job_summary_card.dart';
import 'package:autonexa/features/dashboard_mechanic/widgets/mechanic_job_card.dart';

class MechanicMyJobsScreen extends StatelessWidget {
  const MechanicMyJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<ServiceRequestModel> allJobs = [
      ServiceRequestModel(
        id: '1',
        requesterId: 'u1',
        requestType: ServiceType.mechanical_repair,
        description: 'Engine Failure / Smoke. 2021 BMW X5 • Blue',
        locationLat: 0,
        locationLng: 0,
        status: ServiceStatus.arriving,
      ),
      ServiceRequestModel(
        id: '2',
        requesterId: 'u2',
        requestType: ServiceType.mechanical_repair,
        description: 'Brake Pad Replacement. 2019 Tesla Model 3 • Grey',
        locationLat: 0,
        locationLng: 0,
        status: ServiceStatus.accepted,
      ),
      ServiceRequestModel(
        id: '3',
        requesterId: 'u3',
        requestType: ServiceType.mechanical_repair,
        description: 'Electrical Issues. 2022 Ford F-150 • White',
        locationLat: 0,
        locationLng: 0,
        status: ServiceStatus.searching,
      ),
    ];

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Today's Jobs",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Pallete.secondaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'ACTIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const JobSummaryCard(
                        title: 'Active',
                        count: '3',
                        colorOverride: Pallete.primaryColor,
                      ),
                      const SizedBox(width: 12),
                      const JobSummaryCard(
                        title: 'Pending',
                        count: '5',
                      ),
                      const SizedBox(width: 12),
                      JobSummaryCard(
                        title: 'Priority',
                        count: '1',
                        colorOverride: isDark
                            ? Colors.red.withAlpha(50)
                            : Colors.red.withAlpha(20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Pallete.secondaryColor,
                      ),
                    ),
                    const Text(
                      'Upcoming',
                      style: TextStyle(
                        fontSize: 16,
                        color: Pallete.textSecondaryColor,
                      ),
                    ),
                    const Text(
                      'History',
                      style: TextStyle(
                        fontSize: 16,
                        color: Pallete.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      height: 3,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Pallete.secondaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final job = allJobs[index];
                return IntrinsicHeight(
                  child: Row(
                    children: [
                      // Timeline column
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
                                  color: isDark ? Colors.black : Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              index == 0 ? "09:00" : (index == 1 ? "11:30" : "14:00"),
                              style: const TextStyle(
                                  fontSize: 10, color: Pallete.textSecondaryColor),
                            ),
                            Expanded(
                              child: Container(
                                width: 2,
                                color: Colors.grey.withAlpha(50),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Card column
                      Expanded(
                        child: MechanicJobCard(
                          job: job,
                          onNavigate: () {},
                          onStatusUpdate: () {},
                        ),
                      ),
                    ],
                  ),
                );
              },
              childCount: allJobs.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)), // Space for fab
      ],
    );
  }
}
