import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/dashboard_user/screens/post_request_screen.dart';
import 'package:autonexa/features/dashboard_user/screens/request_tracking_screen.dart';
import 'package:autonexa/features/dashboard_user/widgets/active_request_card.dart';

class RequestListScreen extends StatefulWidget {
  const RequestListScreen({super.key});

  @override
  State<RequestListScreen> createState() => _RequestListScreenState();
}

class _RequestListScreenState extends State<RequestListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          'Requests',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Pallete.secondaryColor,
          labelColor: textColor,
          unselectedLabelColor: Pallete.textSecondaryColor,
          tabs: const [
            Tab(text: 'Active (3)'),
            Tab(text: 'History'),
            Tab(text: 'Drafts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveTab(context),
          const Center(child: Text('History Data')),
          const Center(child: Text('Drafts Data')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.secondaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostRequestScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildActiveTab(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0).copyWith(bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ACTIVE REQUESTS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          ActiveRequestCard(
            status: 'WORK IN PROGRESS',
            title: 'Porsche 911 Carrera',
            subtitle: 'Brake System Malfunction',
            icon: Icons.precision_manufacturing,
            buttonText: 'View Progress',
            buttonAction: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const RequestTrackingScreen()));
            },
            primaryButton: true,
            extraContent: Row(
              children: [
                const Icon(Icons.chat_bubble_outline, size: 14, color: Pallete.secondaryColor),
                const SizedBox(width: 4),
                const Text('4 Responses', style: TextStyle(fontSize: 12, color: Pallete.textSecondaryColor)),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 14, color: Pallete.secondaryColor),
                const SizedBox(width: 4),
                const Text('Est. 2h remaining', style: TextStyle(fontSize: 12, color: Pallete.textSecondaryColor)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ActiveRequestCard(
            status: 'AWAITING RESPONSES',
            statusOpacity: 0.2,
            title: 'BMW M4 Competition',
            subtitle: 'Oil Leak Inspection',
            icon: Icons.oil_barrel,
            buttonText: 'View Offers  >',
            buttonAction: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const RequestTrackingScreen()));
            },
            primaryButton: false,
            extraContent: Row(
              children: [
                const Icon(Icons.handshake_outlined, size: 14, color: Pallete.secondaryColor),
                const SizedBox(width: 4),
                const Text('2 Bids Received', style: TextStyle(fontSize: 12, color: Pallete.textSecondaryColor)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ActiveRequestCard(
            status: 'TECHNICIAN ASSIGNED',
            statusColor: Colors.teal,
            title: 'Audi RS6 Avant',
            subtitle: 'Tire Performance Upgrade',
            icon: Icons.tire_repair,
            buttonText: 'Track Arrival',
            buttonIcon: Icons.location_on,
            buttonAction: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const RequestTrackingScreen()));
            },
            primaryButton: true,
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
    );
  }
}
