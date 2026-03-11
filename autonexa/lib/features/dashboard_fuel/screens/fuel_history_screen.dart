import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';

class FuelHistoryScreen extends StatelessWidget {
  const FuelHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageBgColor = isDark ? const Color(0xFF1E140D) : Theme.of(context).scaffoldBackgroundColor;
    final textColor = isDark ? Colors.white : Colors.black;
    final cardColor = isDark ? const Color(0xFF281E18) : Colors.white;
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05);

    return Scaffold(
      backgroundColor: pageBgColor,
      appBar: AppBar(
        title: const Text('Delivery History', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemCount: 6,
        itemBuilder: (context, index) {
          // Mock data variation
          final String month = ['Oct', 'Nov', 'Dec'][index % 3];
          final String day = (10 + index * 2).toString();
          final String price = (35.50 + index * 12.0).toStringAsFixed(2);
          final String liters = (15 + index * 5).toString();

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Column
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Pallete.secondaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        month,
                        style: const TextStyle(
                          color: Pallete.secondaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        day,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                
                // Delivery Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Premium Fuel Delivery',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.water_drop, color: Pallete.secondaryColor, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            '$liters Liters • 95 OCT',
                            style: TextStyle(
                              color: isDark ? Colors.white54 : Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'COMPLETED',
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Price Details
                Text(
                  '+\$$price',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
