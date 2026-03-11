import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/dashboard_user/screens/mechanics_search_screen.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Pallete.textColor;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionItem(context, Icons.build, 'MECHANIC', onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MechanicsSearchScreen()));
              }),
              _buildActionItem(context, Icons.settings, 'SPARE PARTS'),
              _buildActionItem(context, Icons.warning_amber_rounded, 'ROADSIDE'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, IconData icon, String label, {VoidCallback? onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Card color for the pill
    final cardBgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: (MediaQuery.of(context).size.width - 48 - 32) / 3, // Screen width - horizontal padding - gap between items
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Pallete.textSecondaryColor.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Pallete.secondaryColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Pallete.secondaryColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: isDark ? Colors.white : Pallete.textColor,
            ),
          ),
        ],
      ),
    ),
    );
  }
}
