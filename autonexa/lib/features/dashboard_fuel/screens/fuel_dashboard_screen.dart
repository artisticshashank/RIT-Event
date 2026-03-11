import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/core/common/floating_bottom_nav_bar.dart';
import 'package:autonexa/features/dashboard_fuel/screens/fuel_requests_screen.dart';
import 'package:autonexa/features/dashboard_fuel/screens/fuel_history_screen.dart';
import 'package:autonexa/features/dashboard_fuel/screens/fuel_earnings_screen.dart';
import 'package:autonexa/features/dashboard_fuel/screens/fuel_settings_screen.dart';

class FuelDashboardScreen extends ConsumerStatefulWidget {
  const FuelDashboardScreen({super.key});

  @override
  ConsumerState<FuelDashboardScreen> createState() => _FuelDashboardScreenState();
}

class _FuelDashboardScreenState extends ConsumerState<FuelDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    FuelRequestsScreen(),
    FuelHistoryScreen(),
    FuelEarningsScreen(),
    FuelSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Exact deep background from mockup
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E140D) : Theme.of(context).scaffoldBackgroundColor;

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
          NavBarItem(icon: Icons.local_gas_station, label: 'REQUESTS'),
          NavBarItem(icon: Icons.history, label: 'HISTORY'),
          NavBarItem(icon: Icons.bar_chart, label: 'STATS'),
          NavBarItem(icon: Icons.settings, label: 'SETTINGS'),
        ],
      ),
    );
  }
}
