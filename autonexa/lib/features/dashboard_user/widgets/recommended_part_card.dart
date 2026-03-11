import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';

class RecommendedPartCard extends StatelessWidget {
  const RecommendedPartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF131322) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Pallete.textSecondaryColor.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.shopping_cart,
                    color: Pallete.secondaryColor,
                    size: 14,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'RECOMMENDED SPARE PARTS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Pallete.secondaryColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?q=80&w=200&auto=format&fit=crop',
                        ), // Axle mockup img
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Front CV Axle\nAssembly',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Fits: 2022 Nexa Sport',
                          style: TextStyle(
                            color: Pallete.textSecondaryColor,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$124.99',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'ADD',
                        style: TextStyle(
                          color: Pallete.secondaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildOutlinedButton(context, 'Book Inspection', true),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOutlinedButton(context, 'Watch DIY Video', false),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOutlinedButton(
    BuildContext context,
    String title,
    bool isPrimaryText,
  ) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: Pallete.textSecondaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: isPrimaryText
                ? Pallete.secondaryColor
                : Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
