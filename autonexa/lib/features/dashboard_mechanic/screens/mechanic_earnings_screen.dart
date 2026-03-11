import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/models/service_transaction_model.dart';
import 'package:autonexa/models/enums.dart';
import 'package:autonexa/core/common/loader.dart';
import 'package:autonexa/features/dashboard_mechanic/controller/mechanic_controller.dart';

class MechanicEarningsScreen extends ConsumerStatefulWidget {
  const MechanicEarningsScreen({super.key});

  @override
  ConsumerState<MechanicEarningsScreen> createState() =>
      _MechanicEarningsScreenState();
}

class _MechanicEarningsScreenState
    extends ConsumerState<MechanicEarningsScreen> {
  int _selectedPeriod = 1; // 0: Daily, 1: Weekly, 2: Monthly, 3: Yearly

  double _totalFor(List<ServiceTransactionModel> txns, int periodIndex) {
    final now = DateTime.now();
    return txns
        .where((t) {
          if (t.completedAt == null) return false;
          final diff = now.difference(t.completedAt!);
          if (periodIndex == 0) return diff.inDays < 1;
          if (periodIndex == 1) return diff.inDays < 7;
          if (periodIndex == 2) return diff.inDays < 30;
          return diff.inDays < 365;
        })
        .fold<double>(0, (sum, t) => sum + t.agreedAmount);
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = Theme.of(context).cardColor;
    final Color highlightColor = Pallete.secondaryColor;
    final earningsAsync = ref.watch(mechanicEarningsProvider);

    return earningsAsync.when(
      loading: () => const Loader(),
      error: (e, _) => Center(child: Text('Error loading earnings: $e')),
      data: (transactions) {
        final total = _totalFor(transactions, _selectedPeriod);
        final received = transactions
            .where((t) => t.paymentStatus == PaymentStatus.received)
            .fold<double>(0, (s, t) => s + t.agreedAmount);
        final pending = transactions
            .where((t) => t.paymentStatus == PaymentStatus.pending)
            .fold<double>(0, (s, t) => s + t.agreedAmount);

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
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
                        Icon(
                          Icons.calendar_month,
                          color: Pallete.textSecondaryColor,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Period selector
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white12
                            : Colors.black.withAlpha(10),
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

                    // Total earnings card — REAL data
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
                          ),
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
                              Text(
                                '\$${total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (transactions.isNotEmpty)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 6),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withAlpha(30),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.trending_up,
                                        color: Colors.green,
                                        size: 14,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Active',
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
                              Icon(
                                Icons.info_outline,
                                size: 14,
                                color: Pallete.textSecondaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${transactions.length} total job(s)',
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

                    const SizedBox(height: 24),

                    // Received / Pending split
                    Row(
                      children: [
                        Expanded(
                          child: _buildMiniStat(
                            'RECEIVED',
                            '\$${received.toStringAsFixed(0)}',
                            Colors.green,
                            cardColor,
                            isDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMiniStat(
                            'PENDING',
                            '\$${pending.toStringAsFixed(0)}',
                            Colors.orange,
                            cardColor,
                            isDark,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Mock bar chart
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
                    Container(
                      height: 180,
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withAlpha(5)
                            : Colors.black.withAlpha(5),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [40, 60, 80, 30, 90, 50, 70]
                                  .asMap()
                                  .map(
                                    (i, v) => MapEntry(
                                      i,
                                      _buildMockBar(
                                        v.toDouble(),
                                        isDark,
                                        i == 4,
                                      ),
                                    ),
                                  )
                                  .values
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Mon',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Tue',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Wed',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Thu',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Fri',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Sat',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Sun',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Payout history — REAL transactions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Transaction History',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${transactions.length} records',
                          style: TextStyle(
                            fontSize: 14,
                            color: highlightColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (transactions.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            'No transactions yet.',
                            style: TextStyle(color: Pallete.textSecondaryColor),
                          ),
                        ),
                      )
                    else
                      ...transactions.map(
                        (t) => _buildPayoutCard(
                          title: 'Service Job',
                          date: t.completedAt != null
                              ? '${t.completedAt!.day}/${t.completedAt!.month}/${t.completedAt!.year}'
                              : '—',
                          amount: '+\$${t.agreedAmount.toStringAsFixed(2)}',
                          status: t.paymentStatus.name.toUpperCase(),
                          statusColor: t.paymentStatus == PaymentStatus.received
                              ? Colors.green
                              : Colors.orange,
                          icon: Icons.receipt_long,
                          iconBgColor: Pallete.secondaryColor.withAlpha(30),
                          iconColor: Pallete.secondaryColor,
                          isDark: isDark,
                          cardColor: cardColor,
                        ),
                      ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMiniStat(
    String label,
    String value,
    Color color,
    Color cardColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String text, int index, Color highlightColor) {
    bool isSelected = _selectedPeriod == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPeriod = index),
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

  Widget _buildMockBar(
    double heightPct,
    bool isDark, [
    bool isHighlighted = false,
  ]) {
    return Container(
      width: 24,
      height: heightPct,
      decoration: BoxDecoration(
        color: isHighlighted
            ? Pallete.secondaryColor
            : (isDark
                  ? Colors.white.withAlpha(20)
                  : Colors.black.withAlpha(20)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
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
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
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
