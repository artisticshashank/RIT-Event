import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/dashboard_user/widgets/search_and_filter_bar.dart';
import 'package:autonexa/features/dashboard_user/widgets/mechanic_card.dart';
import 'package:autonexa/features/dashboard_user/screens/mechanic_profile_screen.dart';
import 'package:autonexa/features/dashboard_user/controller/user_dashboard_controller.dart';
import 'package:autonexa/core/common/loader.dart';

class MechanicsSearchScreen extends ConsumerWidget {
  const MechanicsSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Find Mechanics',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map, color: Pallete.secondaryColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0).copyWith(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchAndFilterBar(hint: 'Search by name, spec...'),
            const SizedBox(height: 32),
            Text(
              'NEARBY EXPERTS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: textColor?.withValues(alpha: 0.6),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            ref.watch(mechanicsListProvider).when(
              data: (mechanics) {
                if (mechanics.isEmpty) {
                  return const Center(child: Text("No mechanics near you."));
                }
                return Column(
                  children: mechanics.map((m) {
                    return MechanicCard(
                      name: m.name.isNotEmpty ? m.name : 'Unknown Mechanic',
                      specialization: 'General Repair',
                      rating: 4.8,
                      reviews: 120,
                      distance: 2.5,
                      imageUrl:
                          'https://images.unsplash.com/photo-1632823465306-eddc87597148?q=80&w=200&auto=format&fit=crop',
                      onBook: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MechanicProfileScreen(),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
              loading: () => const Loader(),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ],
        ),
      ),
    );
  }
}
