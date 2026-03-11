import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';

class SearchAndFilterBar extends StatelessWidget {
  final String hint;

  const SearchAndFilterBar({
    super.key,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1B1B2F) : Colors.white;
    final inputBgColor = isDark ? const Color(0xFF2A2A4A) : Colors.grey.shade100;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: inputBgColor,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Pallete.textSecondaryColor.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Pallete.textSecondaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: hint,
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Pallete.textSecondaryColor.withValues(alpha: 0.8)),
                        ),
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
                border: Border.all(color: Pallete.textSecondaryColor.withValues(alpha: 0.2)),
              ),
              child: const Icon(Icons.tune, color: Pallete.secondaryColor, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('All', true, context),
              _buildFilterChip('Engine', false, context),
              _buildFilterChip('Tyres', false, context),
              _buildFilterChip('Electrical', false, context),
              _buildFilterChip('Body', false, context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Pallete.secondaryColor : (isDark ? const Color(0xFF1B1B2F) : Colors.white),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: isSelected ? Pallete.secondaryColor : Pallete.textSecondaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }
}
