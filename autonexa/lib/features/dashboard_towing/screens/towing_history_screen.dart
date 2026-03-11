import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/core/common/loader.dart';
import 'package:autonexa/models/towing_dashboard_model.dart';
import 'package:autonexa/features/dashboard_towing/controller/towing_controller.dart';

class TowingHistoryScreen extends ConsumerWidget {
  const TowingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(towingHistoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageBgColor = isDark
        ? const Color(0xFF141A28)
        : Theme.of(context).scaffoldBackgroundColor;
    final textColor = isDark ? Colors.white : Colors.black;
    final cardColor = isDark ? const Color(0xFF1E2436) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.black.withValues(alpha: 0.05);

    return Scaffold(
      backgroundColor: pageBgColor,
      appBar: AppBar(
        title: const Text('Job History',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Pallete.secondaryColor),
            onPressed: () => ref.invalidate(towingHistoryProvider),
          ),
        ],
      ),
      body: historyAsync.when(
        loading: () => const Center(child: Loader()),
        error: (e, _) => Center(
          child: Text('Error loading history: $e',
              style: TextStyle(color: textColor)),
        ),
        data: (history) {
          if (history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.commute,
                      size: 72,
                      color: Pallete.secondaryColor.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text('No completed jobs yet.',
                      style: TextStyle(color: Colors.white60, fontSize: 16)),
                ],
              ),
            );
          }
          return RefreshIndicator(
            color: Pallete.secondaryColor,
            onRefresh: () async => ref.invalidate(towingHistoryProvider),
            child: ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final job = history[index];
                return _TowingHistoryCard(
                  job: job,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  textColor: textColor,
                  isDark: isDark,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _TowingHistoryCard extends StatelessWidget {
  final TowingRequestModel job;
  final Color cardColor;
  final Color borderColor;
  final Color textColor;
  final bool isDark;

  const _TowingHistoryCard({
    required this.job,
    required this.cardColor,
    required this.borderColor,
    required this.textColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isAccident =
        job.issueType.toLowerCase().contains('accident');
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
          // Icon badge
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isAccident
                  ? Colors.red.withValues(alpha: 0.1)
                  : Pallete.secondaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isAccident ? Icons.car_crash : Icons.commute,
              color: isAccident ? Colors.redAccent : Pallete.secondaryColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.customerName,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  job.carInfo.isNotEmpty ? job.carInfo : 'Vehicle',
                  style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black54,
                      fontSize: 12),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on,
                        color: Pallete.secondaryColor, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      job.distance.isNotEmpty
                          ? '${job.distance} towed'
                          : job.issueType,
                      style: TextStyle(
                          color: isDark ? Colors.white54 : Colors.black54,
                          fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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

          // Price
          Text(
            '+\$${job.price.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.greenAccent,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
