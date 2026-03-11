import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';

class ProfileListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const ProfileListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1B1B3A) : Colors.white;

    final primaryColor = isDestructive 
        ? Colors.redAccent 
        : Theme.of(context).textTheme.bodyLarge?.color;

    final iconBgColor = isDestructive
        ? Colors.redAccent.withValues(alpha: 0.1)
        : Pallete.secondaryColor.withValues(alpha: 0.1);

    final iconColor = isDestructive
        ? Colors.redAccent
        : Pallete.secondaryColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Pallete.textSecondaryColor.withValues(alpha: 0.1)),
          boxShadow: [
             BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDestructive ? Colors.transparent : Pallete.textSecondaryColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
