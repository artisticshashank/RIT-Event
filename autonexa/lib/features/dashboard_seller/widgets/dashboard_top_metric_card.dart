import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';

class DashboardTopMetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String? badgeText;

  const DashboardTopMetricCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final accentColor = Pallete.secondaryColor;
    final textColor = isDark ? Colors.white : Pallete.textColor;
    final secondaryTextColor = isDark
        ? Colors.white60
        : Pallete.textSecondaryColor;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: accentColor, size: 28),
                if (badgeText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      badgeText!,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
