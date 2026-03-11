import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';

class MechanicEarningsScreen extends StatefulWidget {
  const MechanicEarningsScreen({super.key});

  @override
  State<MechanicEarningsScreen> createState() => _MechanicEarningsScreenState();
}

class _MechanicEarningsScreenState extends State<MechanicEarningsScreen> {
  int _selectedPeriod = 1; // 0: Daily, 1: Weekly, 2: Monthly, 3: Yearly

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    // We'll use the theme's card color and primary/secondary colors
    Color cardColor = Theme.of(context).cardColor;
    Color highlightColor = Pallete.secondaryColor;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Earnings Analytics',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.calendar_month, color: Pallete.textSecondaryColor),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Segmented Control
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white12 : Colors.black.withAlpha(10),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      _buildPeriodButton('Daily', 0, highlightColor),
                      _buildPeriodButton('Weekly', 1, highlightColor),
                      _buildPeriodButton('Monthly', 2, highlightColor),
                      _buildPeriodButton('Yearly', 3, highlightColor),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Total Earnings Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.black12,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TOTAL EARNINGS',
                        style: TextStyle(
                          color: Pallete.textSecondaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            '\$8,450.00',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withAlpha(30),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.trending_up, color: Colors.green, size: 14),
                                const SizedBox(width: 4),
                                const Text(
                                  '14.2%',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.info_outline, size: 14, color: Pallete.textSecondaryColor),
                          const SizedBox(width: 6),
                          Text(
                            'Calculated from previous week',
                            style: TextStyle(
                              color: Pallete.textSecondaryColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Earnings Over Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Earnings Over Time',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Last 7 Days',
                      style: TextStyle(
                        fontSize: 12,
                        color: Pallete.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Mock Chart Area
                Container(
                  height: 180,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withAlpha(5) : Colors.black.withAlpha(5),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Dummy bars
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildMockBar(40, isDark),
                            _buildMockBar(60, isDark),
                            _buildMockBar(80, isDark),
                            _buildMockBar(30, isDark),
                            _buildMockBar(90, isDark, true),
                            _buildMockBar(50, isDark),
                            _buildMockBar(70, isDark),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // X Axis
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text('Mon', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          Text('Tue', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          Text('Wed', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          Text('Thu', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          Text('Fri', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          Text('Sat', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          Text('Sun', style: TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Earnings by Service
                const Text(
                  'Earnings by Service',
                  style: TextStyle(
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
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.black12,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildServiceProgress('Engine Repairs', '\$4,225.00', 0.55, highlightColor, isDark),
                      const SizedBox(height: 16),
                      _buildServiceProgress('Routine Maintenance', '\$2,535.00', 0.35, highlightColor, isDark),
                      const SizedBox(height: 16),
                      _buildServiceProgress('Diagnostics', '\$1,690.00', 0.20, highlightColor, isDark),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Payout History
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Payout History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 14,
                        color: highlightColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                _buildPayoutCard(
                  title: 'Payout to Bank Account',
                  date: 'OCT 24, 2023',
                  amount: '+\$1,250.00',
                  status: 'SUCCESS',
                  statusColor: Colors.green,
                  icon: Icons.account_balance_wallet,
                  iconBgColor: Colors.green.withAlpha(30),
                  iconColor: Colors.green,
                  isDark: isDark,
                  cardColor: cardColor,
                ),
                _buildPayoutCard(
                  title: 'Brake Service #9921',
                  date: 'OCT 22, 2023',
                  amount: '+\$420.00',
                  status: 'SETTLED',
                  statusColor: Pallete.textSecondaryColor,
                  icon: Icons.receipt_long,
                  iconBgColor: Colors.blue.withAlpha(30),
                  iconColor: Colors.blue,
                  isDark: isDark,
                  cardColor: cardColor,
                ),
                _buildPayoutCard(
                  title: 'Full Engine Overhaul',
                  date: 'OCT 20, 2023',
                  amount: '+\$2,800.00',
                  status: 'SETTLED',
                  statusColor: Pallete.textSecondaryColor,
                  icon: Icons.build,
                  iconBgColor: Pallete.secondaryColor.withAlpha(30),
                  iconColor: Pallete.secondaryColor,
                  isDark: isDark,
                  cardColor: cardColor,
                ),
                
                const SizedBox(height: 100), // Space for fab
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodButton(String text, int index, Color highlightColor) {
    bool isSelected = _selectedPeriod == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPeriod = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? highlightColor : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Pallete.textSecondaryColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMockBar(double heightPct, bool isDark, [bool isHighlighted = false]) {
    return Container(
      width: 24,
      height: heightPct,
      decoration: BoxDecoration(
        color: isHighlighted 
            ? Pallete.secondaryColor 
            : (isDark ? Colors.white.withAlpha(20) : Colors.black.withAlpha(20)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
    );
  }

  Widget _buildServiceProgress(String title, String amount, double progress, Color highlightColor, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: highlightColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? Colors.white12 : Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: highlightColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildPayoutCard({
    required String title,
    required String date,
    required String amount,
    required String status,
    required Color statusColor,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required bool isDark,
    required Color cardColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black12,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    color: Pallete.textSecondaryColor,
                    fontSize: 11,
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
