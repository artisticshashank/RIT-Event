import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/models/seller_dashboard_model.dart';

class SalesAnalyticsChart extends StatelessWidget {
  final List<SalesDailyModel> data;

  const SalesAnalyticsChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final accentColor = Pallete.secondaryColor;
    final inactiveBarColor = accentColor.withValues(alpha: 0.3);
    final secondaryTextColor = isDark
        ? Colors.white60
        : Pallete.textSecondaryColor;

    // Find max value to determine heights
    double maxValue = 1;
    for (var d in data) {
      if (d.amount > maxValue) maxValue = d.amount;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: data.map((d) {
              final isMax = d.amount == maxValue;
              final heightRatio = d.amount / maxValue;

              return Column(
                children: [
                  Container(
                    width: 20,
                    height: 120 * heightRatio, // Max height is 120
                    decoration: BoxDecoration(
                      color: isMax ? accentColor : inactiveBarColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    d.day,
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
