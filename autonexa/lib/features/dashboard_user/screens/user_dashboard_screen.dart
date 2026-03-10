import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/features/auth/controller/auth_controller.dart';
import 'package:autonexa/core/common/floating_bottom_nav_bar.dart';
import 'package:autonexa/core/common/gradient_header_card.dart';
import 'package:autonexa/theme/pallete.dart';

class UserDashboardScreen extends ConsumerStatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  ConsumerState<UserDashboardScreen> createState() =>
      _UserDashboardScreenState();
}

class _UserDashboardScreenState extends ConsumerState<UserDashboardScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    if (index == 3) {
      // Logic for profile/logout could go here or route differently
      ref.read(authControllerProvider.notifier).logOut();
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    if (user == null) return const SizedBox();

    return Scaffold(
      extendBody: true, // Allows content to go behind the bottom nav bar
      body: Stack(
        children: [
          // Background content scrollable area
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                bottom: 120,
              ), // Padding to avoid nav bar overlap
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good Morning!',
                              style: TextStyle(
                                color: Pallete.textSecondaryColor,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.notifications_outlined),
                            color: Pallete.textColor,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Render aesthetic gradient card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: GradientHeaderCard(
                      title: 'Find Your Perfect Ride',
                      subtitle:
                          'Browse thousands of certified vehicles with instant AI pricing.',
                      child: Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () {},
                            child: const Row(
                              children: [
                                Text('Explore'),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_ios, size: 12),
                              ],
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Category Pills
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCategoryPill(Icons.directions_car, 'Sedan', true),
                        _buildCategoryPill(Icons.airport_shuttle, 'SUV', false),
                        _buildCategoryPill(
                          Icons.electric_car,
                          'Electric',
                          false,
                        ),
                      ],
                    ),
                  ),

                  // Empty space placeholder
                  const SizedBox(height: 400),
                ],
              ),
            ),
          ),

          // Floating custom bottom nav
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FloatingBottomNavBar(
              currentIndex: _currentIndex,
              onTap: _onNavTap,
              items: [
                NavBarItem(icon: Icons.home_filled, label: 'Home'),
                NavBarItem(icon: Icons.add_circle_outline, label: 'Sell'),
                NavBarItem(icon: Icons.chat_bubble_outline, label: ''),
                NavBarItem(icon: Icons.person_outline, label: ''),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPill(IconData icon, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? Pallete.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: isSelected
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected ? Colors.white : Pallete.primaryColor,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Pallete.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
