import 'package:flutter/material.dart';
import 'package:autonexa/models/seller_dashboard_model.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/dashboard_seller/screens/seller_order_details_screen.dart';

class DetailedOrderCard extends StatelessWidget {
  final DetailedOrderModel order;

  const DetailedOrderCard({super.key, required this.order});

  Color _getStatusColor() {
    switch (order.status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'SHIPPED':
        return Colors.blueAccent;
      case 'DELIVERED':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getInfoIcon() {
    switch (order.status.toUpperCase()) {
      case 'PENDING':
        return Icons.inventory_2_outlined;
      case 'SHIPPED':
        return Icons.local_shipping_outlined;
      case 'DELIVERED':
        return Icons.check_circle_outline;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = Pallete.secondaryColor;
    final textColor = isDark ? Colors.white : Pallete.textColor;
    final subTextColor = isDark ? Colors.white60 : Pallete.textSecondaryColor;

    // Instead of raw colors, for the specific mockup looks, we will use dark solid blues
    // Since we're constrained by Pallete, we'll map `cardColor` but use specific shades for the card gradient.
    final cardBgColor = isDark ? const Color(0xFF2E3B72) : Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          // Order Image Section
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[200],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              image: const DecorationImage(
                image: AssetImage(
                  'assets/images/placeholder_part.png',
                ), // Replace dynamically when doing network
                fit: BoxFit.cover,
              ),
            ),
            // As we don't have exact assets, we'll draw a tinted box for now.
            child: order.imageUrl.isEmpty
                ? Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0.1),
                              Colors.black.withValues(alpha: 0.6),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                      ),
                      Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 60,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                    ],
                  )
                : null,
          ),

          // Order Information Section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        order.status.toUpperCase(),
                        style: TextStyle(
                          color: _getStatusColor(),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Text(
                      order.date,
                      style: TextStyle(color: subTextColor, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order ${order.orderNumber}',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${order.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Customer: ${order.customerName}',
                  style: TextStyle(color: textColor, fontSize: 14),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(_getInfoIcon(), color: subTextColor, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              order.info,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: subTextColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SellerOrderDetailsScreen(order: order),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(fontWeight: FontWeight.bold),
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
}
