import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/dashboard_user/widgets/search_and_filter_bar.dart';
import 'package:autonexa/features/dashboard_user/widgets/mechanic_card.dart';
import 'package:autonexa/features/dashboard_user/screens/mechanic_profile_screen.dart';

class MechanicsSearchScreen extends StatelessWidget {
  const MechanicsSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            MechanicCard(
              name: 'Elite Auto Care',
              specialization: 'General Repair & Maintenance',
              rating: 4.8,
              reviews: 124,
              distance: 2.1,
              imageUrl:
                  'https://images.unsplash.com/photo-1632823465306-eddc87597148?q=80&w=200&auto=format&fit=crop', // Garage
              onBook: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MechanicProfileScreen(),
                  ),
                );
              },
            ),
            MechanicCard(
              name: 'Swift Engine Masters',
              specialization: 'Engine & Transmission Specialst',
              rating: 4.9,
              reviews: 312,
              distance: 4.5,
              imageUrl:
                  'https://images.unsplash.com/photo-1530046339160-ce3e530cfcd1?q=80&w=200&auto=format&fit=crop', // Mechanic
              onBook: () {},
            ),
            MechanicCard(
              name: 'City Tyres & Brakes',
              specialization: 'Tire Replacement, Brake Service',
              rating: 4.5,
              reviews: 89,
              distance: 1.2,
              imageUrl:
                  'https://images.unsplash.com/photo-1549646537-8e68449ce710?q=80&w=200&auto=format&fit=crop', // Tires
              onBook: () {},
            ),
          ],
        ),
      ),
    );
  }
}
