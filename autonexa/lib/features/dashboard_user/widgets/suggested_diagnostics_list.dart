import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';

class SuggestedDiagnosticsList extends StatelessWidget {
  const SuggestedDiagnosticsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 48.0, bottom: 12),
          child: Text(
            'SUGGESTED DIAGNOSTICS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Theme.of(
                context,
              ).textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
              letterSpacing: 1.2,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 48.0, right: 24.0, bottom: 24.0),
          child: Row(
            children: [
              _buildDiagnosticChip(context, 'Scan Dashboard', Icons.scanner),
              const SizedBox(width: 12),
              _buildDiagnosticChip(context, 'Check Oil Life', Icons.oil_barrel),
              const SizedBox(width: 12),
              _buildDiagnosticChip(context, 'Tire Pressure', Icons.tire_repair),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDiagnosticChip(
    BuildContext context,
    String label,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.transparent : Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: Pallete.textSecondaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Pallete.secondaryColor, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
