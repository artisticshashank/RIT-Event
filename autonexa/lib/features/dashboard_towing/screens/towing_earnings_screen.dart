import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';

class TowingEarningsScreen extends StatefulWidget {
  const TowingEarningsScreen({super.key});

  @override
  State<TowingEarningsScreen> createState() => _TowingEarningsScreenState();
}

class _TowingEarningsScreenState extends State<TowingEarningsScreen> {
  int _selectedTabIndex = 1;

  Widget _buildToggle(int index, String title) {
    final isSelected = _selectedTabIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Pallete.secondaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : (isDark ? Colors.white60 : Colors.black54),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceBar(String title, String amount, double precentComplete) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                ),
              ),
              Text(
                amount,
                style: TextStyle(
                  color: Pallete.secondaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 8,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: precentComplete,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Pallete.secondaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutItem(IconData icon, String title, String subtitle, String amount, String status, bool success) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E2436) : Colors.white;
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: success ? Colors.green.withValues(alpha: 0.1) : (isDark ? const Color(0xFF282E46) : Colors.orange.shade100),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: success ? Colors.greenAccent : (isDark ? Colors.blueAccent : Pallete.secondaryColor),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: TextStyle(
                  color: success ? Colors.greenAccent : (isDark ? Colors.white54 : Colors.black54),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageBgColor = isDark ? const Color(0xFF141A28) : Theme.of(context).scaffoldBackgroundColor;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white60 : Colors.black54;
    final cardColor = isDark ? const Color(0xFF1E2436) : Colors.white;
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05);

    return Scaffold(
      backgroundColor: pageBgColor,
      appBar: AppBar(
        title: const Text('Towing Analytics', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: textColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  _buildToggle(0, 'Daily'),
                  _buildToggle(1, 'Weekly'),
                  _buildToggle(2, 'Monthly'),
                  _buildToggle(3, 'Yearly'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Total Earnings Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF232B42) : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Pallete.secondaryColor.withValues(alpha: 0.2)),
                gradient: isDark ? const LinearGradient(
                  colors: [Color(0xFF282B46), Color(0xFF1E2032)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ) : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL EARNINGS',
                    style: TextStyle(
                      color: Pallete.secondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$6,240.50',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.trending_up, color: Colors.greenAccent, size: 12),
                            const SizedBox(width: 4),
                            const Text(
                              '8.5%',
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: subTextColor, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'Calculated from previous week',
                        style: TextStyle(
                          color: subTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Earnings Over Time Chart
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Earnings Over Time',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Last 7 Days',
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: borderColor),
              ),
              padding: const EdgeInsets.only(top: 24, bottom: 16, left: 16, right: 16),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBar(0.3, isDark),
                        _buildBar(0.7, isDark),
                        _buildBar(0.4, isDark),
                        _buildBar(0.5, isDark),
                        _buildBar(0.9, isDark, isActive: true),
                        _buildBar(0.8, isDark),
                        _buildBar(0.6, isDark),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildXAxisLabel('Mon', subTextColor),
                      _buildXAxisLabel('Tue', subTextColor),
                      _buildXAxisLabel('Wed', subTextColor),
                      _buildXAxisLabel('Thu', subTextColor),
                      _buildXAxisLabel('Fri', subTextColor),
                      _buildXAxisLabel('Sat', subTextColor),
                      _buildXAxisLabel('Sun', subTextColor),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Earnings by Service
            Text(
              'Earnings by Service',
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _buildServiceBar('Flatbed Towing', '\$3,120.00', 0.6),
                  _buildServiceBar('Accident Recovery', '\$1,870.00', 0.4),
                  _buildServiceBar('Roadside Assistance', '\$1,250.50', 0.25),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Payout History
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payout History',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'View All',
                  style: TextStyle(
                    color: Pallete.secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPayoutItem(
              Icons.account_balance_wallet,
              'Payout to Bank Account',
              'NOV 02, 2023',
              '+\$1,850.00',
              'SUCCESS',
              true,
            ),
            _buildPayoutItem(
              Icons.receipt_long,
              'Heavy Duty Tow #4211',
              'OCT 30, 2023',
              '+\$680.00',
              'SETTLED',
              false,
            ),
            
            const SizedBox(height: 120), // Floater Nav Margin
          ],
        ),
      ),
    );
  }

  Widget _buildBar(double heightFactor, bool isDark, {bool isActive = false}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: 30,
          height: constraints.maxHeight * heightFactor,
          decoration: BoxDecoration(
            color: isActive ? Pallete.secondaryColor : (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }
    );
  }

  Widget _buildXAxisLabel(String text, Color color) {
    return SizedBox(
      width: 30,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
