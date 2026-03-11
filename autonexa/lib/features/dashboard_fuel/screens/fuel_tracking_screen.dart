import 'package:flutter/material.dart';
import 'package:autonexa/models/fuel_dashboard_model.dart';
import 'package:autonexa/theme/pallete.dart';

class FuelTrackingScreen extends StatelessWidget {
  final FuelRequestModel request;

  const FuelTrackingScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white60 : Colors.black54;

    // Use extreme dark deep brown representing custom map
    final mapBgColor = isDark ? const Color(0xFF140D09) : Colors.grey[300]; 
    final sheetColor = isDark ? const Color(0xFF281E18) : Colors.white;
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05);

    return Scaffold(
      backgroundColor: mapBgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            const Text('On the way', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            Text(
              'ETA: 8 MINS',
              style: TextStyle(color: Pallete.secondaryColor, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Pallete.secondaryColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.help_outline, color: Pallete.secondaryColor, size: 20),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Simulated Map Background
          Positioned.fill(
            child: Container(
               color: mapBgColor,
               child: Center(
                 child: Icon(Icons.map, size: 200, color: Colors.white.withValues(alpha: 0.02)),
               ),
            ),
          ),
          
          // Current User / Tech Marker
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Pallete.secondaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Pallete.secondaryColor.withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      )
                    ]
                  ),
                  child: const Icon(Icons.local_shipping, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Pallete.secondaryColor.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    '${request.customerName.split(" ").first.toUpperCase()} IS HERE',
                    style: const TextStyle(
                      color: Pallete.secondaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Map floating controls
          Positioned(
            top: 120,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: sheetColor,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: borderColor),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'En route to Golden Gate Park',
                        style: TextStyle(color: textColor, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: sheetColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor),
                  ),
                  child: const Icon(Icons.my_location, color: Colors.white70),
                )
              ],
            ),
          ),
          
          Positioned(
            top: 190,
            right: 20,
            child: Container(
              width: 56,
              decoration: BoxDecoration(
                color: sheetColor,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  IconButton(onPressed: (){}, icon: const Icon(Icons.add, color: Colors.white70)),
                  Divider(height: 1, color: borderColor),
                  IconButton(onPressed: (){}, icon: const Icon(Icons.remove, color: Colors.white70)),
                ],
              ),
            ),
          ),

          // Bottom Sheet (Fixed to bottom)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: sheetColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border(top: BorderSide(color: borderColor)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 30,
                    offset: const Offset(0, -10),
                  )
                ]
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pull pill
                  Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Tech Profile Row
                  Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                image: AssetImage('assets/images/placeholder_part.png'), // Will replace
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.greenAccent,
                                shape: BoxShape.circle,
                                border: Border.all(color: sheetColor, width: 3),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              request.customerName,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Technician • Fuel Expert',
                              style: TextStyle(color: subTextColor, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Pallete.secondaryColor, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '4.9',
                            style: TextStyle(color: Pallete.secondaryColor, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      
                      // Contact buttons
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Pallete.secondaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.phone, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                           color: isDark ? const Color(0xFF382315) : Colors.orange.shade100,
                           shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.chat_bubble, color: Pallete.secondaryColor),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Info Cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2E221C) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: borderColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('VEHICLE', style: TextStyle(color: subTextColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                              const SizedBox(height: 8),
                              Text('White Ford F-150', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('NEXA-7729', style: TextStyle(color: Pallete.secondaryColor, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2E221C) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: borderColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ORDER', style: TextStyle(color: subTextColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                              const SizedBox(height: 8),
                              Text('Premium Diesel', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('#OR-99120', style: TextStyle(color: Pallete.secondaryColor, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // View Order Summary button
                  SizedBox(
                     width: double.infinity,
                     height: 60,
                     child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.white,
                           foregroundColor: Colors.black,
                           shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                           )
                        ),
                        child: const Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                              Text('View Order Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              SizedBox(width: 12),
                              Icon(Icons.arrow_forward),
                           ],
                        ),
                     ),
                  ),
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}
