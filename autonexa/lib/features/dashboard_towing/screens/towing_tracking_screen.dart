import 'package:flutter/material.dart';
import 'package:autonexa/models/towing_dashboard_model.dart';
import 'package:autonexa/theme/pallete.dart';

class TowingTrackingScreen extends StatelessWidget {
  final TowingRequestModel request;

  const TowingTrackingScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E2436) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white60 : Colors.black54;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? Colors.black54 : Colors.white.withValues(alpha: 0.8),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? Colors.black54 : Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tow En Route',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              SizedBox(width: 8),
              Icon(Icons.circle, color: Pallete.secondaryColor, size: 8),
              SizedBox(width: 4),
              Text(
                'ETA: 12 MINS',
                style: TextStyle(color: Pallete.secondaryColor, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Simulated Map Background
          Positioned.fill(
            child: Container(
              color: isDark ? const Color(0xFF1E2436) : Colors.grey[300],
              child: Image.asset(
                'assets/images/map_overlay.png', // Generic map slice assuming the user has one or it fails silently
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: isDark ? const Color(0xFF1A1F2C) : Colors.grey[300],
                    child: Center(
                      child: Icon(Icons.map, size: 100, color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Floating Icon on map (Customer)
          Align(
            alignment: const Alignment(0, -0.4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    request.customerName,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 4),
                const Icon(Icons.location_on, color: Colors.red, size: 36),
              ],
            ),
          ),

          // Tow Truck Pin
          Align(
            alignment: const Alignment(0.3, 0.1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Pallete.secondaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Tow Truck',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 4),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Pallete.secondaryColor.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Icon(Icons.local_shipping, color: Pallete.secondaryColor, size: 28),
                  ],
                ),
              ],
            ),
          ),

          // Map Controls
          Positioned(
            right: 16,
            bottom: MediaQuery.of(context).size.height * 0.45,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.my_location, color: textColor),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.add, color: textColor),
                        onPressed: () {},
                      ),
                      Container(width: 24, height: 1, color: isDark ? Colors.white24 : Colors.black12),
                      IconButton(
                        icon: Icon(Icons.remove, color: textColor),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Sheet Custom Mockup Design
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
               height: MediaQuery.of(context).size.height * 0.41,
               decoration: BoxDecoration(
                 color: cardColor,
                 borderRadius: const BorderRadius.only(
                   topLeft: Radius.circular(32),
                   topRight: Radius.circular(32),
                 ),
                 boxShadow: [
                   BoxShadow(
                     color: Colors.black.withValues(alpha: 0.2),
                     blurRadius: 20,
                     offset: const Offset(0, -5),
                   )
                 ],
               ),
               child: Column(
                 children: [
                   // Handle
                   Center(
                     child: Container(
                       margin: const EdgeInsets.only(top: 12, bottom: 20),
                       width: 40,
                       height: 4,
                       decoration: BoxDecoration(
                         color: isDark ? Colors.white24 : Colors.black12,
                         borderRadius: BorderRadius.circular(2),
                       ),
                     ),
                   ),

                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 24),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Row(
                           children: [
                             // Driver Avatar
                             Container(
                               width: 56,
                               height: 56,
                               decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 border: Border.all(color: Pallete.secondaryColor, width: 2),
                                 image: const DecorationImage(
                                   image: AssetImage('assets/images/placeholder_part.png'),
                                   fit: BoxFit.cover,
                                 ),
                               ),
                             ),
                             const SizedBox(width: 16),
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                   'Marcus Johnson',
                                   style: TextStyle(
                                     color: textColor,
                                     fontSize: 18,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                                 const SizedBox(height: 4),
                                 Row(
                                   children: [
                                     Text(
                                       'Tow Operator',
                                       style: TextStyle(
                                         color: subTextColor,
                                         fontSize: 13,
                                       ),
                                     ),
                                     const SizedBox(width: 8),
                                     const Icon(Icons.star, color: Colors.orange, size: 14),
                                     const SizedBox(width: 2),
                                     Text(
                                       '4.9',
                                       style: TextStyle(
                                         color: textColor,
                                         fontSize: 12,
                                         fontWeight: FontWeight.bold,
                                       ),
                                     ),
                                   ],
                                 ),
                               ],
                             ),
                           ],
                         ),
                         // Contact Buttons
                         Row(
                           children: [
                             Container(
                               width: 40,
                               height: 40,
                               decoration: BoxDecoration(
                                 color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                                 shape: BoxShape.circle,
                               ),
                               child: Icon(Icons.message, color: textColor, size: 20),
                             ),
                             const SizedBox(width: 12),
                             Container(
                               width: 40,
                               height: 40,
                               decoration: BoxDecoration(
                                 color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                                 shape: BoxShape.circle,
                               ),
                               child: Icon(Icons.phone, color: textColor, size: 20),
                             ),
                           ],
                         ),
                       ],
                     ),
                   ),

                   const SizedBox(height: 24),

                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 24),
                     child: Row(
                       children: [
                         Expanded(
                           child: Container(
                             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                             decoration: BoxDecoration(
                               color: isDark ? const Color(0xFF141A28) : Colors.grey[50],
                               borderRadius: BorderRadius.circular(16),
                               border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05)),
                             ),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                   'TRUCK INFO',
                                   style: TextStyle(
                                     color: subTextColor,
                                     fontSize: 10,
                                     fontWeight: FontWeight.bold,
                                     letterSpacing: 1,
                                   ),
                                 ),
                                 const SizedBox(height: 4),
                                 Text(
                                   'Ford F-450 Flatbed',
                                   style: TextStyle(
                                     color: textColor,
                                     fontSize: 13,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                                 const SizedBox(height: 2),
                                 Text(
                                   'LP: AX-9921',
                                   style: TextStyle(
                                     color: Pallete.secondaryColor,
                                     fontSize: 12,
                                     fontWeight: FontWeight.w500,
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ),
                         const SizedBox(width: 12),
                         Expanded(
                           child: Container(
                             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                             decoration: BoxDecoration(
                               color: isDark ? const Color(0xFF141A28) : Colors.grey[50],
                               borderRadius: BorderRadius.circular(16),
                               border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05)),
                             ),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                   'ORDER',
                                   style: TextStyle(
                                     color: subTextColor,
                                     fontSize: 10,
                                     fontWeight: FontWeight.bold,
                                     letterSpacing: 1,
                                   ),
                                 ),
                                 const SizedBox(height: 4),
                                 Text(
                                   '#TOW-9821-RX',
                                   style: TextStyle(
                                     color: textColor,
                                     fontSize: 14,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                                 const SizedBox(height: 2),
                                 Text(
                                   'Total: \$${request.price.toInt()}',
                                   style: const TextStyle(
                                     color: Colors.greenAccent,
                                     fontSize: 12,
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

                   const Spacer(),

                   Container(
                     padding: const EdgeInsets.all(24),
                     decoration: BoxDecoration(
                       border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
                     ),
                     child: InkWell(
                       onTap: () {},
                       child: Container(
                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                         decoration: BoxDecoration(
                           color: isDark ? Colors.white : Colors.black,
                           borderRadius: BorderRadius.circular(100),
                         ),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text(
                               'View Order Summary',
                               style: TextStyle(
                                 color: isDark ? Colors.black : Colors.white,
                                 fontWeight: FontWeight.bold,
                                 fontSize: 16,
                               ),
                             ),
                             Container(
                               padding: const EdgeInsets.all(4),
                               decoration: BoxDecoration(
                                 color: isDark ? Colors.black.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.2),
                                 shape: BoxShape.circle,
                               ),
                               child: Icon(Icons.arrow_forward, color: isDark ? Colors.black : Colors.white, size: 20),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                 ],
               ),
            ),
          )
        ],
      ),
    );
  }
}
