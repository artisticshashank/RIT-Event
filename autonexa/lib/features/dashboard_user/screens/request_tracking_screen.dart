import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/dashboard_user/widgets/live_tracking_card.dart';
import 'package:autonexa/features/dashboard_user/widgets/tracking_timeline.dart';
import 'package:autonexa/features/dashboard_user/widgets/active_request_card.dart';

class RequestTrackingScreen extends StatelessWidget {
  const RequestTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

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
          'Live Tracking',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0).copyWith(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'LIVE TRACKING',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    letterSpacing: 1.2,
                  ),
                ),
                const Row(
                  children: [
                    Icon(Icons.circle, color: Pallete.secondaryColor, size: 8),
                    SizedBox(width: 4),
                    Text(
                      'LIVE UPDATE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Pallete.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const LiveTrackingCard(),
            const SizedBox(height: 24),
            const TrackingTimeline(),
            const SizedBox(height: 48),
            Text(
              'REQUEST DETAILS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: textColor,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            // Dummy showing tracking details for the assigned technician
            ActiveRequestCard(
              status: 'TECHNICIAN ASSIGNED',
              statusColor: Colors.teal,
              title: 'Audi RS6 Avant',
              subtitle: 'Tire Performance Upgrade',
              icon: Icons.tire_repair,
              buttonText: 'Contact Technician',
              buttonIcon: Icons.phone,
              buttonAction: () {},
              primaryButton: false,
              extraContent: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network('https://images.unsplash.com/photo-1599566150163-29194dcaad36?q=80&w=100&auto=format&fit=crop', fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Marcus T.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Text('Elite Tech ★ 4.9', style: TextStyle(fontSize: 10, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
