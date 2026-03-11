import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';

class ProductReviews extends StatelessWidget {
  const ProductReviews({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final cardBgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reviews & Ratings',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const Text(
                'See all',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Pallete.secondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Pallete.textSecondaryColor.withValues(alpha: 0.1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      '4.8',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          color: Pallete.secondaryColor,
                          size: 12,
                        ),
                        Icon(
                          Icons.star,
                          color: Pallete.secondaryColor,
                          size: 12,
                        ),
                        Icon(
                          Icons.star,
                          color: Pallete.secondaryColor,
                          size: 12,
                        ),
                        Icon(
                          Icons.star,
                          color: Pallete.secondaryColor,
                          size: 12,
                        ),
                        Icon(
                          Icons.star_half,
                          color: Pallete.secondaryColor,
                          size: 12,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '248 reviews',
                      style: TextStyle(
                        fontSize: 10,
                        color: Pallete.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 1,
                  height: 60,
                  color: Pallete.textSecondaryColor.withValues(alpha: 0.2),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                ),
                Expanded(
                  child: Column(
                    children: [
                      _buildRatingBar(context, '5', 0.8, '80%'),
                      const SizedBox(height: 4),
                      _buildRatingBar(context, '4', 0.12, '12%'),
                      const SizedBox(height: 4),
                      _buildRatingBar(context, '3', 0.05, '5%'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Featured Review
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF5A3A1A), // Dark brownish
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'JD',
                    style: TextStyle(
                      color: Pallete.secondaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jason D.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Pallete.secondaryColor,
                          size: 12,
                        ),
                        Icon(
                          Icons.star,
                          color: Pallete.secondaryColor,
                          size: 12,
                        ),
                        Icon(
                          Icons.star,
                          color: Pallete.secondaryColor,
                          size: 12,
                        ),
                        Icon(
                          Icons.star,
                          color: Pallete.secondaryColor,
                          size: 12,
                        ),
                        Icon(
                          Icons.star,
                          color: Pallete.secondaryColor,
                          size: 12,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '"Installed these on my M4 last weekend. The bite is incredible and absolutely no squeal. Best upgrade so far."',
                      style: TextStyle(
                        fontSize: 12,
                        color: Pallete.textSecondaryColor,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(
    BuildContext context,
    String star,
    double percentage,
    String label,
  ) {
    return Row(
      children: [
        Text(
          star,
          style: const TextStyle(
            fontSize: 10,
            color: Pallete.textSecondaryColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Pallete.textSecondaryColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    height: 4,
                    width: constraints.maxWidth * percentage,
                    decoration: BoxDecoration(
                      color: Pallete.secondaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 24,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Pallete.textSecondaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
