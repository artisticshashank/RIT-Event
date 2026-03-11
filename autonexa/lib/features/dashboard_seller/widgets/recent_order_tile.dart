import 'package:flutter/material.dart';
import 'package:autonexa/models/seller_dashboard_model.dart';
import 'package:autonexa/theme/pallete.dart';

class RecentOrderTile extends StatelessWidget {
  final RecentOrderModel order;

  const RecentOrderTile({super.key, required this.order});

  IconData _getIcon() {
    switch (order.iconCode) {
      case 'engine':
        return Icons.settings_applications;
      case 'brakes':
        return Icons.toll_outlined;
      case 'oil':
        return Icons.water_drop_outlined;
      default:
        return Icons.inventory_2_outlined;
    }
  }

  Color _getStatusColor() {
    switch (order.status) {
      case 'NEW':
        return Colors.blue;
      case 'PROCESSING':
        return Colors.orange;
      case 'SHIPPED':
        return Colors.green;
      default:
        return Colors.grey;
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_getIcon(), color: accentColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.title,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Order ${order.orderNumber}',
                  style: TextStyle(
                    color: subTextColor,
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${order.price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor().withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    color: _getStatusColor(),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
