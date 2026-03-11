import 'package:flutter/material.dart';

class FuelStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String growth;
  final Color leftBorderColor;
  final Color titleColor;
  final Color valueColor;
  final Color growthColor;

  const FuelStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.growth,
    required this.leftBorderColor,
    this.titleColor = Colors.white60,
    this.valueColor = Colors.white,
    this.growthColor = Colors.greenAccent,
  });

  @override
  Widget build(BuildContext context) {
    // Exact colors from mockup
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // In the mockup, cards have a very dark brown/black tint #221711
    final cardBgColor = isDark ? const Color(0xFF281E18) : Colors.white;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        // To implement the thick left border smoothly:
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: leftBorderColor, width: 4),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.trending_up, color: growthColor, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      growth,
                      style: TextStyle(
                        color: growthColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
