import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/models/spare_part_model.dart';

class CartItemCard extends StatelessWidget {
  final SparePartModel part;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.part,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  String _getImageForPart(String name) {
    if (name.toLowerCase().contains('brake'))
      return 'https://images.unsplash.com/photo-1600705685834-31b672803bba?q=80&w=200&auto=format&fit=crop';
    if (name.toLowerCase().contains('spark'))
      return 'https://plus.unsplash.com/premium_photo-1664303323067-1ea5d3ee4531?q=80&w=200&auto=format&fit=crop';
    if (name.toLowerCase().contains('battery'))
      return 'https://images.unsplash.com/photo-1620353459146-248358e820ef?q=80&w=200&auto=format&fit=crop';
    if (name.toLowerCase().contains('oil'))
      return 'https://images.unsplash.com/photo-1620353459146-248358e820ef?q=80&w=200&auto=format&fit=crop'; // dummy oil image
    return 'https://images.unsplash.com/photo-1599369325997-6a2c31fd32b5?q=80&w=200&auto=format&fit=crop';
  }

  String _getSubForPart(String name) {
    if (name.toLowerCase().contains('brake')) return 'AUTONEXA GENUINE';
    if (name.toLowerCase().contains('spark')) return 'HIGH EFFICIENCY SET';
    if (name.toLowerCase().contains('oil')) return '5W-30 FULL SYNTHETIC';
    return 'PREMIUM PART';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Pallete.textSecondaryColor.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 80,
              height: 80,
              color: isDark ? Colors.black26 : Colors.grey.shade100,
              child: Image.network(
                _getImageForPart(part.name),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            part.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getSubForPart(part.name),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Pallete.textSecondaryColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: onRemove,
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Pallete.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${part.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Pallete.secondaryColor,
                      ),
                    ),
                    // Quantity Selector
                    Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF2C2C2C)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildQtyButton(
                            icon: Icons.remove,
                            color: isDark
                                ? const Color(0xFF3C3C3C)
                                : Colors.grey.shade300,
                            iconColor: Pallete.textSecondaryColor,
                            onTap: onDecrement,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              quantity.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ),
                          _buildQtyButton(
                            icon: Icons.add,
                            color: Pallete.secondaryColor,
                            iconColor: Colors.white,
                            onTap: onIncrement,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyButton({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, size: 16, color: iconColor),
      ),
    );
  }
}
