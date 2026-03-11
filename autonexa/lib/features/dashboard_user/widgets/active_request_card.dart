import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';

class ActiveRequestCard extends StatelessWidget {
  final String status;
  final String title;
  final String subtitle;
  final IconData icon;
  final String buttonText;
  final VoidCallback buttonAction;
  final bool primaryButton;
  final Color? statusColor;
  final double statusOpacity;
  final Widget? extraContent;
  final IconData? buttonIcon;

  const ActiveRequestCard({
    super.key,
    required this.status,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.buttonText,
    required this.buttonAction,
    required this.primaryButton,
    this.statusColor,
    this.statusOpacity = 0.1,
    this.extraContent,
    this.buttonIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = isDark ? const Color(0xFF1B1B2F) : Colors.white;
    final badgeColor = statusColor ?? Pallete.secondaryColor;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Pallete.textSecondaryColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: statusOpacity),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF252542) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Pallete.secondaryColor, size: 24),
              ),
            ],
          ),
          if (extraContent != null) ...[
            const SizedBox(height: 16),
            extraContent!,
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryButton
                    ? Pallete.secondaryColor
                    : (isDark ? const Color(0xFF252542) : Colors.grey.shade100),
                foregroundColor: primaryButton
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge?.color,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              onPressed: buttonAction,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    buttonText,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  if (buttonIcon != null) ...[
                    const SizedBox(width: 8),
                    Icon(buttonIcon, size: 16),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
