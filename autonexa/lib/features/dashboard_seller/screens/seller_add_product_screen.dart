import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/auth/controller/auth_controller.dart';
import 'package:autonexa/features/dashboard_seller/controller/seller_controller.dart';

class SellerAddProductScreen extends ConsumerStatefulWidget {
  const SellerAddProductScreen({super.key});

  @override
  ConsumerState<SellerAddProductScreen> createState() =>
      _SellerAddProductScreenState();
}

class _SellerAddProductScreenState extends ConsumerState<SellerAddProductScreen> {
  int _inventoryQuantity = 1;
  bool _isFeatured = true;

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _skuController = TextEditingController();

  String? _selectedCategory;
  final List<String> _categories = [
    'Engine Parts',
    'Brakes',
    'Suspension',
    'Oil & Filters',
    'Electrical',
    'Body Parts',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _skuController.dispose();
    super.dispose();
  }

  Future<void> _submitProduct() async {
    final name = _nameController.text.trim();
    final description = _descController.text.trim();
    final priceText = _priceController.text.trim();
    final sellerId = ref.read(userProvider)?.id ?? '';

    if (sellerId.isEmpty) {
      _showSnack('Not authenticated. Please log in again.', isError: true);
      return;
    }
    if (name.isEmpty) {
      _showSnack('Please enter a product name', isError: true);
      return;
    }
    if (priceText.isEmpty) {
      _showSnack('Please enter a price', isError: true);
      return;
    }
    final price = double.tryParse(priceText);
    if (price == null || price <= 0) {
      _showSnack('Enter a valid price', isError: true);
      return;
    }

    final success = await ref.read(addProductProvider.notifier).addProduct(
          sellerId: sellerId,
          name: name,
          description: description,
          price: price,
          stock: _inventoryQuantity,
          sku: _skuController.text.trim().isEmpty ? null : _skuController.text.trim(),
          category: _selectedCategory,
        );

    if (!mounted) return;
    if (success) {
      // Invalidate provider so inventory screen refreshes
      ref.invalidate(sellerInventoryProvider);
      ref.invalidate(sellerOverviewProvider);
      _showSnack('Product listed successfully!');
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) Navigator.pop(context);
    } else {
      _showSnack('Failed to list product. Try again.', isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Pallete.secondaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

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
    required TextEditingController controller,
    required BuildContext context,
  }) {
    final cardColor = Theme.of(context).cardColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.1);

    return TextField(
      controller: controller,
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
    final secondaryTextColor =
        isDark ? Colors.white60 : Pallete.textSecondaryColor;
    final cardColor = Theme.of(context).cardColor;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.1);

    final addState = ref.watch(addProductProvider);
    final isLoading = addState is AsyncLoading;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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

              // Product Photos row (UI only — storage integration is optional)
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
                      ),
                    ),
                    child: Center(
                      child: Icon(Icons.add_a_photo_outlined,
                          color: accentColor, size: 28),
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
                        child: Icon(Icons.image_outlined,
                            color: secondaryTextColor.withValues(alpha: 0.5),
                            size: 28),
                      ),
                    ),
                  ),
                ],
              ),

              // Product Name
              _buildLabel('Product Name *', textColor),
              _buildTextField(
                hintText: 'e.g. Turbocharged Intake Manifold',
                controller: _nameController,
                context: context,
              ),

              // Category Dropdown
              _buildLabel('Category', textColor),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 54,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    dropdownColor: cardColor,
                    style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 16),
                    hint: Text(
                      'Select Category',
                      style: TextStyle(
                          color: isDark ? Colors.white38 : Colors.black38),
                    ),
                    icon: Icon(Icons.keyboard_arrow_down,
                        color: secondaryTextColor),
                    isExpanded: true,
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _selectedCategory = val),
                  ),
                ),
              ),

              // Price + SKU row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Price (\$) *', textColor),
                        _buildTextField(
                          hintText: '0.00',
                          keyboardType: TextInputType.number,
                          controller: _priceController,
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
                        _buildTextField(
                          hintText: 'AN-12345',
                          controller: _skuController,
                          context: context,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Quantity picker
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
                    onTap: () => setState(() => _inventoryQuantity++),
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

              // Description
              _buildLabel('Description', textColor),
              _buildTextField(
                hintText:
                    'Enter high-performance specifications and compatibility details...',
                maxLines: 4,
                controller: _descController,
                context: context,
              ),

              const SizedBox(height: 24),

              // Featured toggle
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 20),
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
                                color: secondaryTextColor, fontSize: 12),
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
                      inactiveTrackColor:
                          isDark ? Colors.black26 : Colors.white24,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : _submitProduct,
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.upload_rounded, color: Colors.white),
                  label: Text(
                    isLoading ? 'Listing...' : 'List Product Now',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
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

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}
