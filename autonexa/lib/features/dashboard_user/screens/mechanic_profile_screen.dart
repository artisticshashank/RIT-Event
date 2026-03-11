import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/dashboard_user/widgets/mechanic_stat_card.dart';
import 'package:autonexa/features/dashboard_user/widgets/service_offered_card.dart';
import 'package:autonexa/features/dashboard_user/widgets/customer_review_card.dart';

class MechanicProfileScreen extends StatelessWidget {
  const MechanicProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
          'Mechanic Profile',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: textColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(24.0).copyWith(bottom: 120),
            children: [
              // Avatar
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Pallete.secondaryColor, width: 3),
                        image: const DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1632823465306-eddc87597148?q=80&w=200&auto=format&fit=crop'), // Example mechanic
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
                        child: const Icon(Icons.verified, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Name and Title
              Text(
                'Alex Rivera',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Master Technician at AutoNexa Pro',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Pallete.secondaryColor,
                ),
              ),
              const SizedBox(height: 8),
              
              // Rating / Experience
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '4.9 (850 reviews)   •   12 years exp.',
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor?.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? const Color(0xFF25256D) : Colors.blue.shade800,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      icon: const Icon(Icons.chat_bubble_outline, size: 18),
                      label: const Text('Message', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Pallete.textSecondaryColor.withValues(alpha: 0.3)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      icon: const Icon(Icons.call, size: 18),
                      label: const Text('Call', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Stats
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const MechanicStatCard(
                      title: 'Repairs',
                      value: '1.2k+',
                      subtitle: '↗ 5% this mo',
                      subtitleColor: Colors.tealAccent,
                    ),
                    const SizedBox(width: 12),
                    const MechanicStatCard(
                      title: 'Speed',
                      value: 'Fast',
                      subtitle: 'TOP 10%',
                      subtitleColor: Pallete.secondaryColor,
                    ),
                    const SizedBox(width: 12),
                    const MechanicStatCard(
                      title: 'Warranty',
                      value: '12 Mo.',
                      subtitle: 'On all parts',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // About
              Text(
                'About',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Specializing in European performance vehicles and hybrid systems. Certified Master Mechanic dedicated to precision and quality service using genuine parts. Known for transparent pricing and quick turnaround times.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Pallete.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 32),

              // Services Offered
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Services Offered',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const Text(
                    'EST. PRICES',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Pallete.secondaryColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const ServiceOfferedCard(
                icon: Icons.oil_barrel,
                title: 'Full Synthetic Oil Change',
                description: 'Includes filter and 21-point inspection',
                price: '\$85+',
              ),
              const ServiceOfferedCard(
                icon: Icons.settings, // brake icon analog
                title: 'Brake Pad Replacement',
                description: 'Per axle, ceramic pads',
                price: '\$180+',
              ),
              const ServiceOfferedCard(
                icon: Icons.auto_graph,
                title: 'Engine Diagnostic',
                description: 'Full scan and detailed report',
                price: '\$120+',
              ),
              const SizedBox(height: 32),
              
              // Customer Reviews
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Customer Reviews',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Pallete.secondaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const CustomerReviewCard(
                name: 'Michael Chen',
                timeAgo: '2 days ago',
                rating: 5,
                reviewText: 'Alex is incredibly knowledgeable. He fixed a sensor issue that three other shops couldn\'t figure out. Highly recommend for high-end cars.',
              ),
              const CustomerReviewCard(
                name: 'Sarah Jenkins',
                timeAgo: '1 week ago',
                rating: 5,
                reviewText: 'Fair pricing and very professional. He took the time to explain what was wrong with my brakes without being condescending.',
              ),
            ],
          ),

          // Bottom Action Button
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.secondaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  elevation: 10,
                  shadowColor: Pallete.secondaryColor.withValues(alpha: 0.5),
                ),
                icon: const Icon(Icons.calendar_month),
                label: const Text(
                  'BOOK SERVICE NOW',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
