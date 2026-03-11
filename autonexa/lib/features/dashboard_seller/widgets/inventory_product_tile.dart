import 'package:flutter/material.dart';
import 'package:autonexa/models/seller_dashboard_model.dart';
import 'package:autonexa/theme/pallete.dart';

class InventoryProductTile extends StatelessWidget {
  final InventoryProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const InventoryProductTile({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  IconData _getIcon() {
    switch (product.iconCode) {
      case 'brakes':
        return Icons.toll_outlined;
      case 'engine':
        return Icons.settings_applications;
      case 'oil':
        return Icons.water_drop_outlined;
      case 'parts':
      default:
        return Icons.inventory_2_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final accentColor = Pallete.secondaryColor;
    final textColor = isDark ? Colors.white : Pallete.textColor;
    final subTextColor = isDark ? Colors.white60 : Pallete.textSecondaryColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isDark ? Colors.white : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_getIcon(), color: Colors.black87, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'SKU: ${product.sku}',
                  style: TextStyle(color: subTextColor, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        '${product.stock} in stock',
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: onEdit,
                icon: Icon(Icons.edit_outlined, color: subTextColor, size: 20),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
              IconButton(
                onPressed: onDelete,
                icon: Icon(Icons.delete_outline, color: subTextColor, size: 20),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
