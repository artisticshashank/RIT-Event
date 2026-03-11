import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/core/common/loader.dart';
import 'package:autonexa/models/service_transaction_model.dart';
import 'package:autonexa/models/enums.dart';
import 'package:autonexa/features/dashboard_fuel/controller/fuel_controller.dart';

class FuelEarningsScreen extends ConsumerStatefulWidget {
  const FuelEarningsScreen({super.key});

  @override
  ConsumerState<FuelEarningsScreen> createState() => _FuelEarningsScreenState();
}

class _FuelEarningsScreenState extends ConsumerState<FuelEarningsScreen> {
  int _selectedTabIndex = 1; // 0:Daily 1:Weekly 2:Monthly 3:Yearly

  // ── Filter transactions by selected period ───────────────────────────────
  double _totalFor(List<ServiceTransactionModel> txns, int period) {
    final now = DateTime.now();
    return txns
        .where((t) {
          if (t.completedAt == null) return false;
          final diff = now.difference(t.completedAt!);
          if (period == 0) return diff.inDays < 1;
          if (period == 1) return diff.inDays < 7;
          if (period == 2) return diff.inDays < 30;
          return diff.inDays < 365;
        })
        .fold<double>(0, (sum, t) => sum + t.agreedAmount);
  }

  Widget _buildToggle(int index, String title, bool isDark) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
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
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white60 : Colors.black54),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final earningsAsync = ref.watch(fuelEarningsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageBgColor = isDark
        ? const Color(0xFF1E140D)
        : Theme.of(context).scaffoldBackgroundColor;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white60 : Colors.black54;
    final cardColor = isDark ? const Color(0xFF281E18) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.black.withValues(alpha: 0.05);

    return Scaffold(
      backgroundColor: pageBgColor,
      appBar: AppBar(
        title: const Text(
          'Earnings Analytics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Pallete.secondaryColor),
            onPressed: () => ref.invalidate(fuelEarningsProvider),
          ),
        ],
      ),
      body: earningsAsync.when(
        loading: () => const Center(child: Loader()),
        error: (e, _) => Center(
          child: Text('Error: $e', style: TextStyle(color: textColor)),
        ),
        data: (transactions) {
          final total = _totalFor(transactions, _selectedTabIndex);
          final received = transactions
              .where((t) => t.paymentStatus == PaymentStatus.received)
              .fold<double>(0, (s, t) => s + t.agreedAmount);
          final pending = transactions
              .where((t) => t.paymentStatus == PaymentStatus.pending)
              .fold<double>(0, (s, t) => s + t.agreedAmount);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Period toggle
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      _buildToggle(0, 'Daily', isDark),
                      _buildToggle(1, 'Weekly', isDark),
                      _buildToggle(2, 'Monthly', isDark),
                      _buildToggle(3, 'Yearly', isDark),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Total earnings card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2F1D0D)
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Pallete.secondaryColor.withValues(alpha: 0.2),
                    ),
                    gradient: isDark
                        ? const LinearGradient(
                            colors: [Color(0xFF381F0A), Color(0xFF241508)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
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
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _earningsBadge(
                            'Received',
                            received,
                            Colors.greenAccent,
                          ),
                          const SizedBox(width: 16),
                          _earningsBadge(
                            'Pending',
                            pending,
                            Colors.orangeAccent,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Mini bar chart (last 7 days visual)
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
                      style: TextStyle(color: subTextColor, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 180,
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: _buildDailyBars(transactions, isDark),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children:
                            ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                                .map(
                                  (d) => SizedBox(
                                    width: 30,
                                    child: Center(
                                      child: Text(
                                        d,
                                        style: TextStyle(
                                          color: subTextColor,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Payout history
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transaction History',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${transactions.length} total',
                      style: TextStyle(color: subTextColor, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (transactions.isEmpty)
                  Center(
                    child: Text(
                      'No transactions yet.',
                      style: TextStyle(color: Colors.white60),
                    ),
                  )
                else
                  ...transactions
                      .take(20)
                      .map(
                        (t) => _TxnCard(
                          txn: t,
                          cardColor: cardColor,
                          borderColor: borderColor,
                          isDark: isDark,
                        ),
                      ),

                const SizedBox(height: 120),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _earningsBadge(String label, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDailyBars(
    List<ServiceTransactionModel> txns,
    bool isDark,
  ) {
    final now = DateTime.now();
    final days = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));
    final dailyAmounts = days.map((day) {
      return txns
          .where(
            (t) =>
                t.completedAt != null &&
                t.completedAt!.year == day.year &&
                t.completedAt!.month == day.month &&
                t.completedAt!.day == day.day,
          )
          .fold<double>(0, (s, t) => s + t.agreedAmount);
    }).toList();

    final maxAmt = dailyAmounts
        .reduce((a, b) => a > b ? a : b)
        .clamp(1.0, double.infinity);

    return List.generate(7, (i) {
      final factor = dailyAmounts[i] / maxAmt;
      final isToday = i == 6;
      return LayoutBuilder(
        builder: (_, constraints) => Container(
          width: 30,
          height: (constraints.maxHeight * factor).clamp(6.0, double.infinity),
          decoration: BoxDecoration(
            color: isToday
                ? Pallete.secondaryColor
                : (isDark
                      ? Colors.white.withValues(alpha: 0.15)
                      : Colors.black.withValues(alpha: 0.12)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    });
  }
}

class _TxnCard extends StatelessWidget {
  final ServiceTransactionModel txn;
  final Color cardColor;
  final Color borderColor;
  final bool isDark;

  const _TxnCard({
    required this.txn,
    required this.cardColor,
    required this.borderColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isReceived = txn.paymentStatus == PaymentStatus.received;
    final dateStr = txn.completedAt != null
        ? '${txn.completedAt!.day}/${txn.completedAt!.month}/${txn.completedAt!.year}'
        : '—';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isReceived
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isReceived ? Icons.check_circle : Icons.pending_actions,
              color: isReceived ? Colors.greenAccent : Colors.orangeAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fuel Delivery',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  dateStr,
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
                '+\$${txn.agreedAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                txn.paymentStatus.name.toUpperCase(),
                style: TextStyle(
                  color: isReceived ? Colors.greenAccent : Colors.orangeAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
