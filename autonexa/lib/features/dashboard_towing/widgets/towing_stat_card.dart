import 'package:flutter/material.dart';

class TowingStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Widget? prefixIcon;
  final Color? leftBorderColor;
  final Color titleColor;
  final Color valueColor;

  const TowingStatCard({
    super.key,
    required this.title,
    required this.value,
    this.prefixIcon,
    this.leftBorderColor,
    this.titleColor = Colors.white60,
    this.valueColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Darker blueish/slate tint matching mockup background block
    final cardBgColor = isDark ? const Color(0xFF1E2436) : Colors.white;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ]
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              border: leftBorderColor != null
                  ? Border(left: BorderSide(color: leftBorderColor!, width: 4))
                  : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (prefixIcon != null) ...[
                      prefixIcon!,
                      const SizedBox(width: 6),
                    ],
                    Text(
                      title,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
