import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/models/spare_part_model.dart';
import 'package:autonexa/features/dashboard_user/widgets/cart_item_card.dart';
import 'package:autonexa/features/dashboard_user/screens/checkout_screen.dart';

// Since we don't have a real cart state yet, we'll use a local state for demo
class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  // Dummy data similar to the image
  final List<Map<String, dynamic>> _cartItems = [
    {
      'part': SparePartModel(id: '1', sellerId: '', name: 'Performance Brake Pads', price: 120.00),
      'quantity': 1,
    },
    {
      'part': SparePartModel(id: '2', sellerId: '', name: 'Iridium Spark Plugs', price: 45.00),
      'quantity': 4,
    },
    {
      'part': SparePartModel(id: '3', sellerId: '', name: 'Synthetic Motor Oil', price: 60.00),
      'quantity': 1,
    },
  ];

  void _incrementQuantity(int index) {
    setState(() {
      _cartItems[index]['quantity']++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_cartItems[index]['quantity'] > 1) {
        _cartItems[index]['quantity']--;
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
    });
  }

  double get _subtotal {
    return _cartItems.fold(0, (sum, item) => sum + (item['part'].price * item['quantity']));
  }

  double get _shipping => _cartItems.isEmpty ? 0 : 12.50;
  double get _tax => _subtotal * 0.08; // 8% tax
  double get _total => _subtotal + _shipping + _tax;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final surfaceColor = Theme.of(context).cardColor;
    final iconBgColor = isDark ? const Color(0xFF23253B) : Colors.grey.shade200; // Blueish dark grey for circular buttons

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircularButton(
                    icon: Icons.arrow_back,
                    color: iconBgColor,
                    iconColor: textColor!,
                    onTap: () => Navigator.pop(context),
                  ),
                  Text(
                    'Shopping Cart',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  _buildCircularButton(
                    icon: Icons.delete_outline,
                    color: iconBgColor,
                    iconColor: Pallete.secondaryColor,
                    onTap: _clearCart,
                    badge: _cartItems.isNotEmpty,
                  ),
                ],
              ),
            ),
            
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Item List
                    if (_cartItems.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Text('Your cart is empty', style: TextStyle(color: Pallete.textSecondaryColor)),
                        ),
                      )
                    else
                      ...List.generate(
                        _cartItems.length,
                        (index) => CartItemCard(
                          part: _cartItems[index]['part'],
                          quantity: _cartItems[index]['quantity'],
                          onIncrement: () => _incrementQuantity(index),
                          onDecrement: () => _decrementQuantity(index),
                          onRemove: () => _removeItem(index),
                        ),
                      ),
                    
                    const SizedBox(height: 16),
                    Text(
                      'Promo Code',
                      style: TextStyle(
                        fontSize: 14,
                        color: Pallete.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF2C2C35) : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter code',
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                fillColor: Colors.transparent,
                                hintStyle: TextStyle(
                                  color: Pallete.textSecondaryColor.withValues(alpha: 0.7),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Pallete.secondaryColor.withValues(alpha: 0.2), // Translucent orange look
                              foregroundColor: Pallete.secondaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                            ),
                            onPressed: () {},
                            child: const Text('Apply', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Order Summary
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Pallete.textSecondaryColor.withValues(alpha: 0.1)),
                        boxShadow: [
                           BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow('Subtotal', _subtotal, false),
                          const SizedBox(height: 16),
                          _buildSummaryRow('Shipping', _shipping, false),
                          const SizedBox(height: 16),
                          _buildSummaryRow('Tax (8%)', _tax, false),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Divider(color: Pallete.textSecondaryColor.withValues(alpha: 0.2), height: 1),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Amount',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                '\$${_total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Pallete.secondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Proceed to Checkout
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF141414) : Colors.white,
                border: Border(top: BorderSide(color: Pallete.textSecondaryColor.withValues(alpha: 0.1))),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Pallete.secondaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    elevation: 5,
                    shadowColor: Pallete.secondaryColor.withValues(alpha: 0.5),
                  ),
                  onPressed: _cartItems.isEmpty ? null : () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen(totalAmount: _total)));
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Proceed to Checkout',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, bool isTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Pallete.textSecondaryColor,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
    bool badge = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          if (badge)
            Positioned(
              top: 10,
              right: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Pallete.secondaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
