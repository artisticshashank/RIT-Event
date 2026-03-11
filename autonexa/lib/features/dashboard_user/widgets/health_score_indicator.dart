import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';

class HealthScoreIndicator extends StatelessWidget {
  final int score;
  final String status;

  const HealthScoreIndicator({
    super.key,
    required this.score,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 12,
            backgroundColor: Pallete.textSecondaryColor.withValues(alpha: 0.15),
            valueColor: const AlwaysStoppedAnimation<Color>(
              Pallete.secondaryColor,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$score%',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              Text(
                status.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Pallete.secondaryColor,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
