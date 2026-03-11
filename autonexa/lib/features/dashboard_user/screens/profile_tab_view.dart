import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/dashboard_user/widgets/profile_stat_card.dart';
import 'package:autonexa/features/dashboard_user/widgets/profile_list_tile.dart';
import 'package:autonexa/features/auth/controller/auth_controller.dart';
import 'package:autonexa/features/dashboard_user/controller/user_dashboard_controller.dart';
import 'package:autonexa/features/dashboard_user/screens/request_list_screen.dart';

class ProfileTabView extends ConsumerWidget {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? const Color(0xFF13132B)
        : Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    // Real user data from Supabase (stored in UserModel)
    final user = ref.watch(userProvider);
    final displayName = user?.name ?? 'User';
    final email = user?.email ?? '';
    final String? avatarUrl = null; // No avatar_url in UserModel yet

    // Real counts
    final vehicles = ref.watch(userVehiclesProvider);
    final requests = ref.watch(userServiceRequestsProvider);

    final vehicleCount = vehicles.value?.length.toString() ?? '0';
    final completedCount =
        requests.value
            ?.where((r) => r.status.name == 'completed')
            .length
            .toString() ??
        '0';

    return Container(
      color: bgColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ).copyWith(bottom: 120),
          child: Column(
            children: [
              // Settings icon
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1B1B3A)
                        : Colors.grey.shade100,
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
                      border: Border.all(
                        color: Pallete.secondaryColor,
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: avatarUrl != null && avatarUrl.isNotEmpty
                          ? Image.network(
                              avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _defaultAvatar(displayName),
                            )
                          : _defaultAvatar(displayName),
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
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Name
              Text(
                displayName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: const TextStyle(
                  fontSize: 14,
                  color: Pallete.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 32),

              // Stats row — real data
              Row(
                children: [
                  ProfileStatCard(value: vehicleCount, label: 'VEHICLES'),
                  const SizedBox(width: 16),
                  ProfileStatCard(value: completedCount, label: 'ORDERS'),
                  const SizedBox(width: 16),
                  const ProfileStatCard(value: '—', label: 'POINTS'),
                ],
              ),
              const SizedBox(height: 32),

              // Menu items
              ProfileListTile(
                icon: Icons.directions_car,
                title: 'My Garage',
                onTap: () {},
              ),
              ProfileListTile(
                icon: Icons.history,
                title: 'Service History',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RequestListScreen(),
                    ),
                  );
                },
              ),
              ProfileListTile(
                icon: Icons.account_balance_wallet,
                title: 'Payment Methods',
                onTap: () {},
              ),
              ProfileListTile(
                icon: Icons.location_on,
                title: 'Addresses',
                onTap: () {},
              ),
              ProfileListTile(
                icon: Icons.notifications_active,
                title: 'Notifications',
                onTap: () {},
              ),
              ProfileListTile(
                icon: Icons.card_giftcard,
                title: 'Refer a Friend',
                onTap: () {},
              ),
              ProfileListTile(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {},
              ),

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

  Widget _defaultAvatar(String name) {
    return Container(
      color: Pallete.secondaryColor.withValues(alpha: 0.2),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'U',
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Pallete.secondaryColor,
          ),
        ),
      ),
    );
  }
}
