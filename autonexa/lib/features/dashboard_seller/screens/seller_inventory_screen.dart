import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/core/common/loader.dart';
import 'package:autonexa/models/seller_dashboard_model.dart';
import 'package:autonexa/features/dashboard_seller/controller/seller_controller.dart';
import 'package:autonexa/features/dashboard_seller/widgets/inventory_product_tile.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/dashboard_seller/screens/seller_add_product_screen.dart';

class SellerInventoryScreen extends ConsumerStatefulWidget {
  const SellerInventoryScreen({super.key});

  @override
  ConsumerState<SellerInventoryScreen> createState() =>
      _SellerInventoryScreenState();
}

class _SellerInventoryScreenState extends ConsumerState<SellerInventoryScreen> {
  Future<void> _confirmDelete(
      BuildContext context, InventoryProductModel product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Product',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to delete "${product.name}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    final success =
        await ref.read(deleteProductProvider.notifier).delete(product.id);

    if (!mounted) return;
    if (success) {
      ref.invalidate(sellerInventoryProvider);
      ref.invalidate(sellerOverviewProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${product.name}" deleted.'),
          backgroundColor: Pallete.secondaryColor,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete. Try again.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final inventoryFuture = ref.watch(sellerInventoryProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = Pallete.secondaryColor;
    final textColor = isDark ? Colors.white : Pallete.textColor;
    final searchBgColor = isDark ? const Color(0xFF1E1E1E) : Colors.grey[200];
    final subTextColor = isDark ? Colors.white60 : Pallete.textSecondaryColor;

    return Stack(
      children: [
        inventoryFuture.when(
          data: (products) => SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AUTONEXA',
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          'Inventory Management',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.notifications_active,
                          color: textColor,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: searchBgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: subTextColor),
                      hintText: 'Search for spare parts...',
                      hintStyle: TextStyle(color: subTextColor),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Title and Filter Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Products (${products.length})',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Filter',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Inventory List
                ...products.map(
                  (product) => InventoryProductTile(
                    product: product,
                    onEdit: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Edit product coming soon'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    onDelete: () => _confirmDelete(context, product),
                  ),
                ),

                // Extra padding for FAB & Bottom Nav
                const SizedBox(height: 120),
              ],
            ),
          ),
          loading: () => const Loader(),
          error: (error, stack) => Center(
            child: Text(error.toString(), style: TextStyle(color: textColor)),
          ),
        ),

        // FAB pinned to bottom right above the bottom nav bar
        Positioned(
          bottom: 110,
          right: 24,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.4),
                  blurRadius: 16,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SellerAddProductScreen(),
                  ),
                );
              },
              backgroundColor: accentColor,
              elevation: 0,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white, size: 32),
            ),
          ),
        ),
      ],
    );
  }
}
