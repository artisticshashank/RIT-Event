import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';

class JobSummaryCard extends StatelessWidget {
  final String title;
  final String count;
  final Color? colorOverride;

  const JobSummaryCard({
    super.key,
    required this.title,
    required this.count,
    this.colorOverride,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorOverride ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black12,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: colorOverride != null 
                 ? Colors.white70 
                 : Pallete.textSecondaryColor,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              color: colorOverride != null 
                 ? Colors.white 
                 : (title.toLowerCase() == 'priority' || title.toLowerCase() == 'active' 
                      ? Pallete.secondaryColor 
                      : Theme.of(context).primaryColor),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
