import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/dashboard_mechanic/screens/mechanic_navigation_screen.dart';

class MechanicIncomingRequestScreen extends StatelessWidget {
  const MechanicIncomingRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: isDark ? Colors.black54 : Colors.white54,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Column(
          children: [
            const Text(
              'NEW JOB ALERT',
              style: TextStyle(
                color: Pallete.secondaryColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const Text(
              'Incoming Request',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: isDark ? Colors.black54 : Colors.white54,
              child: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Dummy Map Background
          Container(
            width: double.infinity,
            height: double.infinity,
            color: isDark ? const Color(0xFF1E2333) : Colors.blue.withAlpha(30),
            child: Center(
              child: Icon(Icons.map, size: 200, color: isDark ? Colors.white10 : Colors.black12),
            ),
          ),
          
          // Map Markers
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: MediaQuery.of(context).size.width * 0.4,
            child: CircleAvatar(
               backgroundColor: Pallete.secondaryColor.withAlpha(50),
               radius: 30,
               child: const CircleAvatar(
                 backgroundColor: Pallete.secondaryColor,
                 radius: 20,
                 child: Icon(Icons.location_on, color: Colors.white, size: 20),
               ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3 + 10,
            right: MediaQuery.of(context).size.width * 0.2,
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 22,
              child: CircleAvatar(
                backgroundColor: Color(0xFF2C3146),
                radius: 18,
                child: Icon(Icons.directions_car, color: Colors.white, size: 16),
              ),
            ),
          ),
          
          // Bottom Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1D2D) : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // User info row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Alex\nJohnson',
                                style: TextStyle(
                                  fontSize: 20,
                                  height: 1.1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Pallete.secondaryColor, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    '4.9 (124\nreviews)',
                                    style: TextStyle(
                                      color: Pallete.textSecondaryColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'ESTIMATED\nEARNING',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Pallete.secondaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '\$85.00',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Job Info Grid
                  Row(
                    children: [
                      Expanded(child: _buildInfoItem('VEHICLE', 'Tesla Model 3')),
                      Expanded(child: _buildInfoItem('SERVICE', 'Brake Check')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildInfoItem('DISTANCE', '2.4 miles')),
                      Expanded(child: _buildInfoItem('TRAVEL TIME', '8 mins')),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Customer message
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E2333) : Colors.blue.withAlpha(10), // A dark blue tint in dark mode
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info, color: Colors.blue),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Customer reported squeaking sounds during moderate braking.',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Actions
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to navigation screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MechanicNavigationScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallete.secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Accept Request',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isDark ? Colors.white24 : Colors.black26,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cancel, color: Pallete.textSecondaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'Decline',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Pallete.textSecondaryColor,
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
