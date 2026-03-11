import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/core/common/floating_bottom_nav_bar.dart';
import 'package:autonexa/features/dashboard_seller/screens/seller_overview_screen.dart';
import 'package:autonexa/features/dashboard_seller/screens/seller_inventory_screen.dart';
import 'package:autonexa/features/dashboard_seller/screens/seller_orders_screen.dart';
import 'package:autonexa/features/dashboard_seller/screens/seller_profile_screen.dart';

class SellerDashboardScreen extends ConsumerStatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  ConsumerState<SellerDashboardScreen> createState() =>
      _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends ConsumerState<SellerDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    SellerOverviewScreen(),
    SellerInventoryScreen(),
    SellerOrdersScreen(),
    SellerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: _pages),
      ),
      extendBody: true,
      bottomNavigationBar: FloatingBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          NavBarItem(icon: Icons.home_rounded, label: 'HOME'),
          NavBarItem(icon: Icons.inventory_2_rounded, label: 'INVENTORY'),
          NavBarItem(icon: Icons.shopping_cart_rounded, label: 'ORDERS'),
          NavBarItem(icon: Icons.person_rounded, label: 'PROFILE'),
        ],
      ),
    );
  }
}
