import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';

class TrackingTimeline extends StatelessWidget {
  const TrackingTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTimelineStep(context, 'ASSIGNED', true, true),
        Expanded(
          child: Container(
            height: 2,
            color: Pallete.secondaryColor,
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          ),
        ),
        _buildTimelineStep(context, 'EN ROUTE', true, false, icon: Icons.navigation),
        Expanded(
          child: Container(
            height: 2,
            color: Pallete.textSecondaryColor.withValues(alpha: 0.2),
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          ),
        ),
        _buildTimelineStep(context, 'WORKING', false, false, icon: Icons.build),
      ],
    );
  }

  Widget _buildTimelineStep(BuildContext context, String label, bool isCompleted, bool isCheck, {IconData? icon}) {
    final color = isCompleted ? Pallete.secondaryColor : Pallete.textSecondaryColor;
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isCompleted ? Pallete.secondaryColor : Pallete.textSecondaryColor.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCheck ? Icons.check : (icon ?? Icons.circle),
            size: 14,
            color: isCompleted ? Colors.white : Pallete.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
