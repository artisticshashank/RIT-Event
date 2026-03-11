import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/models/spare_part_model.dart';

class ProductInfo extends StatelessWidget {
  final SparePartModel part;

  const ProductInfo({super.key, required this.part});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    // We mock the original price to show the discount as per the image
    final originalPrice = part.price + 29.01;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  part.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Pallete.secondaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  'In\nStock',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Pallete.secondaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${part.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Pallete.secondaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  '\$${originalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Pallete.textSecondaryColor,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Description',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            part.description ??
                'Engineered for extreme performance, this product offers unparalleled stability. The compound provides a consistent feel and reduces fade even under heavy use. Designed for durability and long-term emission control.',
            style: const TextStyle(
              fontSize: 13,
              color: Pallete.textSecondaryColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
