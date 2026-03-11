import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/dashboard_user/screens/shopping_cart_screen.dart';

class MarketAppBar extends StatelessWidget {
  const MarketAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Pallete.secondaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.local_shipping,
                  color: Pallete.secondaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'AutoNexa',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Stack(
                children: [
                   IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    color: Theme.of(context).iconTheme.color,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShoppingCartScreen(),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Pallete.secondaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                color: Theme.of(context).iconTheme.color,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
