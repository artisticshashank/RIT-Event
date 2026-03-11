import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/dashboard_user/widgets/health_score_indicator.dart';
import 'package:autonexa/features/dashboard_user/widgets/system_status_card.dart';

class DiagnosticReportScreen extends StatelessWidget {
  const DiagnosticReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1B1B2F) : Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Pallete.secondaryColor,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Column(
          children: [
            Text(
              'Diagnostic Report',
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'VEHICLE ID: AN-98234',
              style: TextStyle(
                color: Pallete.textSecondaryColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1B1B2F) : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.share,
                color: Pallete.secondaryColor,
                size: 20,
              ),
              onPressed: () {},
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            color: Pallete.textSecondaryColor.withValues(alpha: 0.1),
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0).copyWith(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Date Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1B1B2F) : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Text(
                'OCTOBER 24, 2023',
                style: TextStyle(
                  color: Pallete.textSecondaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Health Circle
            const HealthScoreIndicator(score: 85, status: 'Healthy'),
            const SizedBox(height: 24),

            // Subtext Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Your vehicle is in good condition. 1 attention required for optimal performance.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Pallete.textSecondaryColor,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // System Status Heading
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'System Status',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // System Status Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio:
                  1.1, // Adjust slightly to match design proportions
              children: const [
                SystemStatusCard(
                  icon: Icons.directions_car_filled_outlined,
                  title: 'Engine',
                  subtitle: 'Check Misfire',
                  status: SystemStatusLevel.warning,
                ),
                SystemStatusCard(
                  icon: Icons.car_crash_outlined,
                  title: 'Brakes',
                  subtitle: '92% Life',
                  status: SystemStatusLevel.healthy,
                ),
                SystemStatusCard(
                  icon: Icons.bolt,
                  title: 'Electrical',
                  subtitle: 'Optimal',
                  status: SystemStatusLevel.healthy,
                ),
                SystemStatusCard(
                  icon: Icons.alt_route, // closest analog for suspension lines
                  title: 'Suspension',
                  subtitle: 'Strut Leak',
                  status: SystemStatusLevel.critical,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Detailed Findings
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Detailed Findings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF16162C) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Pallete.textSecondaryColor.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'P0300',
                        style: TextStyle(
                          color: Pallete.secondaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 1,
                        height: 16,
                        color: Pallete.textSecondaryColor.withValues(
                          alpha: 0.3,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Random Misfire Detected',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'The powertrain control module (PCM) has detected that one or more cylinders are not firing properly. This can lead to reduced fuel economy and engine damage.',
                    style: TextStyle(
                      color: Pallete.textSecondaryColor,
                      height: 1.5,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Recommended Actions
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recommended Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.secondaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.calendar_month),
                label: const Text(
                  'Book a Mechanic',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? const Color(0xFF1B1B2F)
                      : Colors.grey.shade200,
                  foregroundColor: textColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.shopping_cart),
                label: const Text(
                  'Buy Spare Parts',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
