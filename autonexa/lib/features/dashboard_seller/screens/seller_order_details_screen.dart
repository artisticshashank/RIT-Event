import 'package:flutter/material.dart';
import 'package:autonexa/models/seller_dashboard_model.dart';
import 'package:autonexa/theme/pallete.dart';

class SellerOrderDetailsScreen extends StatelessWidget {
  final DetailedOrderModel order;

  const SellerOrderDetailsScreen({super.key, required this.order});

  Widget _buildStepIcon(
    IconData icon,
    String label,
    bool isCompleted,
    bool isCurrent,
  ) {
    final bgColor = isCompleted || isCurrent
        ? Pallete.secondaryColor
        : Colors.white.withValues(alpha: 0.05);
    final textColor = isCompleted || isCurrent
        ? Pallete.secondaryColor
        : Colors.white54;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
          child: Icon(
            icon,
            color: isCompleted || isCurrent
                ? Colors.white
                : Colors.white.withValues(alpha: 0.5),
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 10,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    Color bgColor,
    Color textColor,
  ) {
    return Expanded(
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(
    String name,
    String sku,
    int qty,
    double price,
    String iconCode,
    BuildContext context,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subTextColor = isDark ? Colors.white60 : Pallete.textSecondaryColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isDark ? Colors.white : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              iconCode == 'brakes'
                  ? Icons.toll_outlined
                  : Icons.water_drop_outlined,
              color: Colors.black87,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'SKU: $sku',
                  style: TextStyle(color: subTextColor, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: $qty',
                  style: TextStyle(color: subTextColor, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? null : Colors.white60,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Exact colors from Mockup
    final topBgColor = isDark ? const Color(0xFF232A5C) : Pallete.primaryColor;
    final pageBgColor = isDark
        ? const Color(0xFF141834)
        : Theme.of(context).scaffoldBackgroundColor;
    final cardBgColor = isDark ? const Color(0xFF272D62) : Colors.white;
    final buttonDarkBg = isDark ? const Color(0xFF1A1F45) : Colors.grey[200]!;

    final accentColor = Pallete.secondaryColor;
    final textColor = isDark ? Colors.white : Pallete.textColor;
    final subTextColor = isDark ? Colors.white60 : Pallete.textSecondaryColor;

    return Scaffold(
      backgroundColor: pageBgColor,
      appBar: AppBar(
        backgroundColor: topBgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Order Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section
            Container(
              width: double.infinity,
              color: topBgColor,
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 24,
                top: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ID ${order.orderNumber}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: accentColor,
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Placed on ${order.date}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Fulfillment Status Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Fulfillment Status',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                order.status.toUpperCase(),
                                style: TextStyle(
                                  color: accentColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Stepper
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: 20,
                              left: 30,
                              right: 30,
                              child: Container(
                                height: 2,
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildStepIcon(
                                  Icons.check,
                                  'Pending',
                                  true,
                                  false,
                                ),
                                _buildStepIcon(
                                  Icons.settings,
                                  'Processing',
                                  false,
                                  true,
                                ),
                                _buildStepIcon(
                                  Icons.local_shipping,
                                  'Shipped',
                                  false,
                                  false,
                                ),
                                _buildStepIcon(
                                  Icons.inventory_2,
                                  'Delivered',
                                  false,
                                  false,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Update to Shipped',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_rounded, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Customer Information Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CUSTOMER INFORMATION',
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.customerName,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '1234 Gearhead Lane, Detroit, MI\n48201',
                                    style: TextStyle(
                                      color: subTextColor,
                                      fontSize: 14,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.orange[200],
                                borderRadius: BorderRadius.circular(16),
                                image: const DecorationImage(
                                  image: AssetImage(
                                    'assets/images/placeholder_avatar.png',
                                  ), // Placeholder
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white54,
                                  size: 32,
                                ), // Add default icon if asset missing
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _buildActionButton(
                              Icons.chat_bubble_rounded,
                              'Message',
                              buttonDarkBg,
                              accentColor,
                            ),
                            const SizedBox(width: 16),
                            _buildActionButton(
                              Icons.call,
                              'Call',
                              buttonDarkBg,
                              accentColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Order Items Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Items',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Mock Items Based on UI (We use the total price from the order model roughly)
                        _buildOrderItem(
                          'Brake Pads - Front\n(Ceramic)',
                          'AX-992-B',
                          1,
                          129.99,
                          'brakes',
                          context,
                        ),
                        _buildOrderItem(
                          'Synthetic Oil Filter',
                          'AX-FIL-88',
                          2,
                          18.50,
                          'oil',
                          context,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Subtotal Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow('Subtotal', '\$166.99'),
                        _buildSummaryRow('Shipping Fee', '\$12.00'),
                        _buildSummaryRow('Tax (6%)', '\$10.02'),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Divider(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        _buildSummaryRow(
                          'Total Amount',
                          '\$189.01', // Ideally order.price.toStringAsFixed(2), but hardcoded for mockup fidelity
                          isTotal: true,
                          valueColor: accentColor,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Bottom Actions
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.print, color: Colors.white),
                      label: const Text(
                        'Print Shipping Label',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.copy, color: Colors.white),
                            label: const Text(
                              'Copy Order ID',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: buttonDarkBg,
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.email, color: Colors.white),
                            label: const Text(
                              'Email Invoice',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: buttonDarkBg,
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
