import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/auth/controller/auth_controller.dart';
import 'package:autonexa/core/common/floating_bottom_nav_bar.dart';
import 'package:autonexa/features/dashboard_mechanic/screens/mechanic_my_jobs_screen.dart';
import 'package:autonexa/features/dashboard_mechanic/screens/mechanic_discover_screen.dart';
import 'package:autonexa/features/dashboard_mechanic/screens/mechanic_earnings_screen.dart';
import 'package:autonexa/features/dashboard_mechanic/screens/mechanic_profile_screen.dart';

class MechanicDashboardScreen extends ConsumerStatefulWidget {
  const MechanicDashboardScreen({super.key});

  @override
  ConsumerState<MechanicDashboardScreen> createState() =>
      _MechanicDashboardScreenState();
}

class _MechanicDashboardScreenState
    extends ConsumerState<MechanicDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    final List<Widget> pages = [
      const MechanicDiscoverScreen(),
      const MechanicMyJobsScreen(),
      const MechanicEarningsScreen(),
      const MechanicProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AutoNexa',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Mechanic Portal',
              style: TextStyle(
                color: Pallete.textSecondaryColor,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => ref.read(authControllerProvider.notifier).logOut(),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                    'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user?.name ?? "Mechanic")}&background=random'),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: pages,
          ),
          
          // Floating Nav Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingBottomNavBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                NavBarItem(icon: Icons.explore_outlined, label: 'Discover'),
                NavBarItem(icon: Icons.assignment_outlined, label: 'My Jobs'),
                NavBarItem(icon: Icons.account_balance_wallet_outlined, label: 'Earnings'),
                NavBarItem(icon: Icons.person_outline, label: 'Profile'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
