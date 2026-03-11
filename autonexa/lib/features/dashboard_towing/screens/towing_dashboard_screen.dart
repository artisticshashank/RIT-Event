import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/core/common/floating_bottom_nav_bar.dart';
import 'package:autonexa/features/dashboard_towing/screens/towing_requests_screen.dart';
import 'package:autonexa/features/dashboard_towing/screens/towing_history_screen.dart';
import 'package:autonexa/features/dashboard_towing/screens/towing_earnings_screen.dart';
import 'package:autonexa/features/dashboard_towing/screens/towing_settings_screen.dart';

class TowingDashboardScreen extends ConsumerStatefulWidget {
  const TowingDashboardScreen({super.key});

  @override
  ConsumerState<TowingDashboardScreen> createState() => _TowingDashboardScreenState();
}

class _TowingDashboardScreenState extends ConsumerState<TowingDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    TowingRequestsScreen(),
    TowingHistoryScreen(),
    TowingEarningsScreen(),
    TowingSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Exact deep background from mockup
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF141A28) : Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
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
          NavBarItem(icon: Icons.list_alt, label: 'REQUESTS'),
          NavBarItem(icon: Icons.history, label: 'HISTORY'),
          NavBarItem(icon: Icons.bar_chart, label: 'STATS'),
          NavBarItem(icon: Icons.settings, label: 'SETTINGS'),
        ],
      ),
    );
  }
}
