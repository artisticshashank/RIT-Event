import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';

class SellerAddProductScreen extends StatefulWidget {
  const SellerAddProductScreen({super.key});

  @override
  State<SellerAddProductScreen> createState() => _SellerAddProductScreenState();
}

class _SellerAddProductScreenState extends State<SellerAddProductScreen> {
  int _inventoryQuantity = 1;
  bool _isFeatured = true;

  Widget _buildLabel(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    String? hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
    required BuildContext context,
  }) {
    final cardColor = Theme.of(context).cardColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.1);

    return TextField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
        filled: true,
        fillColor: cardColor,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: maxLines > 1 ? 16 : 0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Pallete.secondaryColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = Pallete.secondaryColor;
    final textColor = isDark ? Colors.white : Pallete.textColor;
    final secondaryTextColor = isDark
        ? Colors.white60
        : Pallete.textSecondaryColor;
    final cardColor = Theme.of(context).cardColor;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.1);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Add New Spare Part',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Product Photos Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Product Photos',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '0 / 4 images',
                    style: TextStyle(color: secondaryTextColor, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Photos Row
              Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.5),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add_a_photo_outlined,
                        color: accentColor,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ...List.generate(
                    3,
                    (index) => Container(
                      width: 72,
                      height: 72,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image_outlined,
                          color: secondaryTextColor.withValues(alpha: 0.5),
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              _buildLabel('Product Name', textColor),
              _buildTextField(
                hintText: 'e.g. Turbocharged Intake Manifold',
                context: context,
              ),

              _buildLabel('Category', textColor),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 54, // To match regular text field height roughly
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Category',
                      style: TextStyle(
                        color: isDark ? Colors.white38 : Colors.black38,
                        fontSize: 16,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, color: secondaryTextColor),
                  ],
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Price (\$)', textColor),
                        _buildTextField(
                          hintText: '0.00',
                          keyboardType: TextInputType.number,
                          context: context,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('SKU Number', textColor),
                        _buildTextField(hintText: 'AN-12345', context: context),
                      ],
                    ),
                  ),
                ],
              ),

              _buildLabel('Inventory Quantity', textColor),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_inventoryQuantity > 1) {
                        setState(() => _inventoryQuantity--);
                      }
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: Icon(Icons.remove, color: textColor),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: Center(
                        child: Text(
                          '$_inventoryQuantity',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() => _inventoryQuantity++);
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: Icon(Icons.add, color: textColor),
                    ),
                  ),
                ],
              ),

              _buildLabel('Description', textColor),
              _buildTextField(
                hintText:
                    'Enter high-performance specifications and compatibility details...',
                maxLines: 4,
                context: context,
              ),

              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.stars, color: accentColor, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Featured Product',
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Highlight this item in your store',
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isFeatured,
                      onChanged: (val) => setState(() => _isFeatured = val),
                      activeColor: Colors.white,
                      activeTrackColor: accentColor,
                      inactiveThumbColor: secondaryTextColor,
                      inactiveTrackColor: isDark
                          ? Colors.black26
                          : Colors.white24,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.upload_rounded, color: Colors.white),
                  label: const Text(
                    'List Product Now',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

              // Padding for floating bottom nav
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}
