import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/dashboard_mechanic/widgets/nearby_request_card.dart';
import 'package:autonexa/features/dashboard_mechanic/screens/mechanic_incoming_request_screen.dart';

class MechanicDiscoverScreen extends StatefulWidget {
  const MechanicDiscoverScreen({super.key});

  @override
  State<MechanicDiscoverScreen> createState() => _MechanicDiscoverScreenState();
}

class _MechanicDiscoverScreenState extends State<MechanicDiscoverScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    final allCards = [
      NearbyRequestCard(
        statusLabel: 'EMERGENCY',
        statusColor: Pallete.secondaryColor,
        distance: '0.8 miles away',
        carTitle: 'Tesla Model 3 • White',
        description: 'Suddenly lost power on the highway. Screen shows electrical fault.',
        timeText: 'Requested 4m ago',
        isEmergency: true,
        isPrimaryAction: true,
        onAccept: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const MechanicIncomingRequestScreen()));
        },
      ),
      NearbyRequestCard(
        statusLabel: 'NEARBY',
        statusColor: Colors.blue,
        distance: '2.4 miles away',
        carTitle: 'Toyota RAV4 • Silver',
        description: 'Flat tire. Have spare but no jack kit.',
        timeText: 'Requested 15m ago',
        onAccept: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const MechanicIncomingRequestScreen()));
        },
      ),
      NearbyRequestCard(
        statusLabel: 'SCHEDULED',
        statusColor: Colors.green,
        distance: '5.1 miles away',
        carTitle: 'BMW 5 Series • Blue',
        description: 'Brake pad replacement. Owner has parts.',
        timeText: 'Today, 4:00 PM',
        onAccept: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const MechanicIncomingRequestScreen()));
        },
      ),
    ];

    final emergencyCards = allCards.where((card) => card.isEmergency).toList();
    final scheduledCards = allCards.where((card) => card.statusLabel == 'SCHEDULED').toList();

    List<NearbyRequestCard> getCardsForTab() {
      if (_selectedTabIndex == 1) return emergencyCards;
      if (_selectedTabIndex == 2) return scheduledCards;
      return allCards;
    }

    Widget buildTab(String title, IconData icon, int index) {
      bool isSelected = _selectedTabIndex == index;
      Color color = isSelected 
          ? Pallete.secondaryColor 
          : Pallete.textSecondaryColor;
      
      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 3,
              width: 40,
              decoration: BoxDecoration(
                color: isSelected ? Pallete.secondaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Dummy Map Container
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E2333) : Colors.grey[300],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Stack(
                  children: [
                    // Mock roads/grid
                    Center(
                      child: Icon(Icons.map, size: 100, color: isDark ? Colors.white10 : Colors.black12),
                    ),
                    // Online Status Button
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2C3146) : Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Online & Available',
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Map Pins
                    Positioned(
                      top: 100,
                      left: 100,
                      child: Icon(Icons.location_on, size: 40, color: Pallete.secondaryColor),
                    ),
                    Positioned(
                      top: 150,
                      right: 120,
                      child: Icon(Icons.location_pin, size: 30, color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildTab('All', Icons.list, 0),
                    buildTab('Emergency', Icons.bolt, 1),
                    buildTab('Scheduled', Icons.calendar_today, 2),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Nearby Requests',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Sorted by distance',
                      style: TextStyle(color: Pallete.textSecondaryColor, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        
        // List of Dummy Request Cards
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildListDelegate(getCardsForTab()),
          ),
        ),
        
        const SliverToBoxAdapter(child: SizedBox(height: 100)), // Bottom nav spacer
      ],
    );
  }
}
