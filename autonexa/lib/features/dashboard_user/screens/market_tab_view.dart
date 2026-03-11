import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/dashboard_user/controller/user_dashboard_controller.dart';
import 'package:autonexa/features/dashboard_user/widgets/market_app_bar.dart';
import 'package:autonexa/models/spare_part_model.dart';
import 'package:autonexa/features/dashboard_user/screens/product_details_screen.dart';

class MarketTabView extends ConsumerWidget {
  const MarketTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partsAsync = ref.watch(sparePartsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MarketAppBar(),
          const SizedBox(height: 16),
          // Search Bar & Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search spare parts...',
                        prefixIcon: const Icon(Icons.search),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        fillColor: Colors.transparent,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        hintStyle: TextStyle(
                          color: Pallete.textSecondaryColor.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Pallete.secondaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.tune, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Categories
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                _buildCategoryPill(context, 'All', Icons.grid_view, true),
                const SizedBox(width: 12),
                _buildCategoryPill(context, 'Engine', Icons.settings, false),
                const SizedBox(width: 12),
                _buildCategoryPill(
                  context,
                  'Brakes',
                  Icons.warning_amber_rounded,
                  false,
                ),
                const SizedBox(width: 12),
                _buildCategoryPill(
                  context,
                  'Interior',
                  Icons.airline_seat_recline_normal,
                  false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Grid View
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: partsAsync.when(
              data: (parts) {
                // If API returns empty, use dummy items for visuals as per image
                final List<SparePartModel> displayParts = parts.isEmpty
                    ? _getDummyParts()
                    : parts;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: displayParts.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(context, displayParts[index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error loading parts')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPill(
    BuildContext context,
    String label,
    IconData icon,
    bool isSelected,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? Pallete.secondaryColor
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected ? Colors.white : Pallete.textSecondaryColor,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white70 : Pallete.textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, SparePartModel part) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = Theme.of(context).cardColor;

    // We stub images/rating since the model doesn't have it natively
    final imageUrl = _getImageForPart(part.name);
    final rating = (4.0 + (part.hashCode % 10) / 10).toStringAsFixed(1);
    final reviews = 50 + (part.hashCode % 150);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(part: part),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(24),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Box
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      color: isDark ? Colors.black26 : Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        size: 16,
                        color: Colors
                            .white, // As per image it's just white heart or grey if unselected
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Details Box
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    part.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Pallete.secondaryColor,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '($reviews)',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Pallete.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${part.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Pallete.secondaryColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Pallete.secondaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_shopping_cart,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getImageForPart(String name) {
    if (name.toLowerCase().contains('brake'))
      return 'https://images.unsplash.com/photo-1600705685834-31b672803bba?q=80&w=200&auto=format&fit=crop';
    if (name.toLowerCase().contains('spark'))
      return 'https://plus.unsplash.com/premium_photo-1664303323067-1ea5d3ee4531?q=80&w=200&auto=format&fit=crop';
    if (name.toLowerCase().contains('battery'))
      return 'https://images.unsplash.com/photo-1620353459146-248358e820ef?q=80&w=200&auto=format&fit=crop';
    return 'https://images.unsplash.com/photo-1599369325997-6a2c31fd32b5?q=80&w=200&auto=format&fit=crop';
  }

  List<SparePartModel> _getDummyParts() {
    return [
      SparePartModel(
        id: '1',
        sellerId: 's1',
        name: 'Performance Brakes',
        price: 89.99,
      ),
      SparePartModel(
        id: '2',
        sellerId: 's2',
        name: 'V8 Spark Plugs (Set)',
        price: 12.50,
      ),
      SparePartModel(
        id: '3',
        sellerId: 's1',
        name: 'LED Headlight Kit',
        price: 145.00,
      ),
      SparePartModel(
        id: '4',
        sellerId: 's3',
        name: 'Sport Air Filter',
        price: 45.00,
      ),
      SparePartModel(
        id: '5',
        sellerId: 's2',
        name: 'MaxPower Battery',
        price: 199.99,
      ),
      SparePartModel(
        id: '6',
        sellerId: 's1',
        name: 'Synthetic Motor Oil',
        price: 34.99,
      ),
    ];
  }
}
