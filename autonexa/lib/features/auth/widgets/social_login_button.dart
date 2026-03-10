import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';

class SocialLoginButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inputColor = Theme.of(context).cardColor;
    final mainTextColor = isDark ? Colors.white : Pallete.textColor;

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: iconColor, size: 28),
      label: Text(
        label,
        style: TextStyle(color: mainTextColor, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: inputColor,
        foregroundColor: mainTextColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
    );
  }
}
