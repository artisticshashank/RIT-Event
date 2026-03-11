import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/dashboard_user/widgets/profile_stat_card.dart';
import 'package:autonexa/features/dashboard_user/widgets/profile_list_tile.dart';
import 'package:autonexa/features/auth/controller/auth_controller.dart';

class ProfileTabView extends ConsumerWidget {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // We use a deep blueish background for dark mode, like the reference image
    final bgColor = isDark ? const Color(0xFF13132B) : Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Container(
      color: bgColor,
      child: SafeArea( // Ensuring content doesn't hit top notch
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0).copyWith(bottom: 120),
          child: Column(
            children: [
              // Settings Icon top right
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1B1B3A) : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.settings, color: textColor, size: 20),
                ),
              ),
              
              const SizedBox(height: 16),

              // Avatar
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Pallete.secondaryColor, width: 3),
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200&auto=format&fit=crop'), // Dummy user image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Pallete.secondaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: bgColor, width: 2),
                      ),
                      child: const Icon(Icons.edit, color: Colors.white, size: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                'Alex Rivera',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'alex.rivera@autonexa.com',
                style: TextStyle(
                  fontSize: 14,
                  color: Pallete.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 32),

              // Stats Row
              Row(
                children: [
                  const ProfileStatCard(value: '3', label: 'VEHICLES'),
                  const SizedBox(width: 16),
                  const ProfileStatCard(value: '12', label: 'ORDERS'),
                  const SizedBox(width: 16),
                  const ProfileStatCard(value: '1,250', label: 'POINTS'),
                ],
              ),
              const SizedBox(height: 32),

              // Menu List
              ProfileListTile(icon: Icons.directions_car, title: 'My Garage', onTap: () {}),
              ProfileListTile(icon: Icons.history, title: 'Service History', onTap: () {}),
              ProfileListTile(icon: Icons.account_balance_wallet, title: 'Payment Methods', onTap: () {}),
              ProfileListTile(icon: Icons.location_on, title: 'Addresses', onTap: () {}),
              ProfileListTile(icon: Icons.notifications_active, title: 'Notifications', onTap: () {}),
              ProfileListTile(icon: Icons.card_giftcard, title: 'Refer a Friend', onTap: () {}),
              ProfileListTile(icon: Icons.help_outline, title: 'Help & Support', onTap: () {}),
              
              const SizedBox(height: 16),
              
              ProfileListTile(
                icon: Icons.logout,
                title: 'Logout',
                isDestructive: true,
                onTap: () {
                  ref.read(authControllerProvider.notifier).logOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
