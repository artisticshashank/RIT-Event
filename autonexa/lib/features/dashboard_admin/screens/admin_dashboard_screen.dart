import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/features/auth/controller/auth_controller.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Console'),
        actions: [
          IconButton(
            onPressed: () => ref.read(authControllerProvider.notifier).logOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Super Admin: ${user.name}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'System Management & Analytics',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
