import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/features/auth/controller/auth_controller.dart';
import 'package:autonexa/core/common/floating_bottom_nav_bar.dart';

// New Reusable Widgets
import 'package:autonexa/features/dashboard_user/widgets/user_app_bar.dart';
import 'package:autonexa/features/dashboard_user/widgets/vehicle_card.dart';
import 'package:autonexa/features/dashboard_user/widgets/quick_actions.dart';
import 'package:autonexa/features/dashboard_user/widgets/maintenance_list.dart';
import 'package:autonexa/features/dashboard_user/screens/market_tab_view.dart';
import 'package:autonexa/features/dashboard_user/screens/sos_tab_view.dart';
import 'package:autonexa/features/dashboard_user/screens/ai_chat_screen.dart';
import 'package:autonexa/features/dashboard_user/screens/profile_tab_view.dart';

class UserDashboardScreen extends ConsumerStatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  ConsumerState<UserDashboardScreen> createState() =>
      _UserDashboardScreenState();
}

class _UserDashboardScreenState extends ConsumerState<UserDashboardScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
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
            child: IndexedStack(
              index: _currentIndex,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    bottom: 120, // Padding to avoid nav bar overlap
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      UserAppBar(),
                      VehicleCard(),
                      QuickActions(),
                      MaintenanceList(),
                    ],
                  ),
                ),
                const MarketTabView(),
                const AiChatScreen(),
                const SosTabView(),
                const ProfileTabView(),
              ],
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
                NavBarItem(icon: Icons.storefront, label: 'Market'),
                NavBarItem(
                  icon: Icons.chat_bubble,
                  label: 'AI Chat',
                  isHighlighted: true,
                ),
                NavBarItem(icon: Icons.warning_rounded, label: 'SOS'),
                NavBarItem(icon: Icons.person_outline, label: 'Profile'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
