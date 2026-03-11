import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/auth/controller/auth_controller.dart';

class MechanicProfileScreen extends ConsumerStatefulWidget {
  const MechanicProfileScreen({super.key});

  @override
  ConsumerState<MechanicProfileScreen> createState() =>
      _MechanicProfileScreenState();
}

class _MechanicProfileScreenState extends ConsumerState<MechanicProfileScreen> {
  bool _transmissionEnabled = true;
  bool _brakeSystemsEnabled = false;
  bool _advancedDiagnosticsEnabled = true;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(userProvider);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Technician Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Pallete.secondaryColor.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Pallete.secondaryColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Profile Info
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Pallete.secondaryColor,
                                width: 2,
                              ),
                              image: const DecorationImage(
                                image: NetworkImage('https://i.pravatar.cc/150?img=11'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Pallete.secondaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.verified, color: Colors.white, size: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user?.name ?? 'Marcus Thompson',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Pallete.secondaryColor.withAlpha(20),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Text(
                          'CERTIFIED MASTER MECHANIC',
                          style: TextStyle(
                            color: Pallete.secondaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'AutoNexa Specialist • 12 Years Exp.',
                        style: TextStyle(
                          color: Pallete.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Personal Information
                Row(
                  children: [
                    const Icon(Icons.person, color: Pallete.secondaryColor, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Personal Information',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  title: 'FULL NAME',
                  value: user?.name ?? 'Marcus Thompson',
                  isDark: isDark,
                ),
                _buildInfoCard(
                  title: 'PHONE NUMBER',
                  value: '+1 (555) 012-3456',
                  isDark: isDark,
                ),
                _buildInfoCard(
                  title: 'WORKSHOP LOCATION',
                  value: 'Downtown Service Hub, Detroit',
                  icon: Icons.location_on,
                  isDark: isDark,
                ),
                
                const SizedBox(height: 32),
                
                // Specialized Services
                Row(
                  children: [
                    const Icon(Icons.build, color: Pallete.secondaryColor, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Specialized Services',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                  ),
                  child: Column(
                    children: [
                      _buildServiceToggle(
                        title: 'Engine Repair',
                        icon: Icons.engineering,
                        value: true,
                        onChanged: (val) {},
                      ),
                      const Divider(height: 1, color: Colors.white12),
                      _buildServiceToggle(
                        title: 'Transmission',
                        icon: Icons.settings_applications,
                        value: _transmissionEnabled,
                        onChanged: (val) => setState(() => _transmissionEnabled = val),
                      ),
                      const Divider(height: 1, color: Colors.white12),
                      _buildServiceToggle(
                        title: 'Brake Systems',
                        icon: Icons.warning_amber_rounded,
                        value: _brakeSystemsEnabled,
                        onChanged: (val) => setState(() => _brakeSystemsEnabled = val),
                      ),
                      const Divider(height: 1, color: Colors.white12),
                      _buildServiceToggle(
                        title: 'Advanced Diagnostics',
                        icon: Icons.analytics,
                        value: _advancedDiagnosticsEnabled,
                        onChanged: (val) => setState(() => _advancedDiagnosticsEnabled = val),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Availability
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, color: Pallete.secondaryColor, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Availability',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Text(
                      'Edit Hours',
                      style: TextStyle(
                        color: Pallete.secondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Monday - Friday'),
                          const Text(
                            '08:00 AM - 06:00 PM',
                            style: TextStyle(color: Pallete.secondaryColor, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Saturday'),
                          const Text(
                            '09:00 AM - 02:00 PM',
                            style: TextStyle(color: Pallete.secondaryColor, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Certifications & Documents
                Row(
                  children: [
                    const Icon(Icons.description, color: Pallete.secondaryColor, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Certifications & Documents',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Pallete.secondaryColor.withAlpha(30),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.badge, color: Pallete.secondaryColor),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ASE Master Certificate.pdf',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Verified Oct 2023',
                              style: TextStyle(color: Pallete.textSecondaryColor, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.visibility, color: Pallete.textSecondaryColor, size: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Pallete.secondaryColor.withAlpha(100),
                      style: BorderStyle.none, // We'll mock dashed later if needed
                    ),
                    color: isDark ? Pallete.secondaryColor.withAlpha(10) : Pallete.secondaryColor.withAlpha(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_circle, color: Pallete.secondaryColor, size: 18),
                      const SizedBox(width: 8),
                      const Text(
                        'Upload New Document',
                        style: TextStyle(
                          color: Pallete.secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Footer settings
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                  ),
                  child: Column(
                    children: [
                      _buildSettingsTile('Notification Preferences', Icons.notifications, isDark),
                      const Divider(height: 1, color: Colors.white12),
                      _buildSettingsTile('Security & Password', Icons.lock, isDark),
                      const Divider(height: 1, color: Colors.white12),
                      ListTile(
                        onTap: () => ref.read(authControllerProvider.notifier).logOut(),
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text(
                          'Sign Out',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 100), // FAB spacer
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    IconData? icon,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Pallete.textSecondaryColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: Pallete.textSecondaryColor),
                const SizedBox(width: 6),
              ],
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceToggle({
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Pallete.secondaryColor, size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Pallete.secondaryColor,
            activeTrackColor: Pallete.secondaryColor.withAlpha(50),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(String title, IconData icon, bool isDark) {
    return ListTile(
      leading: Icon(icon, color: Pallete.textSecondaryColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_right, color: Pallete.textSecondaryColor),
    );
  }
}
