import 'package:flutter/material.dart';
import 'package:autonexa/models/spare_part_model.dart';
import 'package:autonexa/features/dashboard_user/widgets/product_image_slider.dart';
import 'package:autonexa/features/dashboard_user/widgets/product_info.dart';
import 'package:autonexa/features/dashboard_user/widgets/product_specs.dart';
import 'package:autonexa/features/dashboard_user/widgets/product_reviews.dart';
import 'package:autonexa/features/dashboard_user/widgets/product_bottom_bar.dart';

class ProductDetailsScreen extends StatelessWidget {
  final SparePartModel part;

  const ProductDetailsScreen({super.key, required this.part});

  String _getImageForPart(String name) {
    if (name.toLowerCase().contains('brake')) {
      return 'https://images.unsplash.com/photo-1600705685834-31b672803bba?q=80&w=600&auto=format&fit=crop';
    }
    if (name.toLowerCase().contains('spark')) {
      return 'https://plus.unsplash.com/premium_photo-1664303323067-1ea5d3ee4531?q=80&w=600&auto=format&fit=crop';
    }
    if (name.toLowerCase().contains('battery')) {
      return 'https://images.unsplash.com/photo-1620353459146-248358e820ef?q=80&w=600&auto=format&fit=crop';
    }
    return 'https://images.unsplash.com/photo-1599369325997-6a2c31fd32b5?q=80&w=600&auto=format&fit=crop';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductImageSlider(imageUrl: _getImageForPart(part.name)),
                  ProductInfo(part: part),
                  const ProductSpecs(),
                  const SizedBox(height: 16),
                  const ProductReviews(),
                ],
              ),
            ),
          ),
          const ProductBottomBar(),
        ],
      ),
    );
  }
}
