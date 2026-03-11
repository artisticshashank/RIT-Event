import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';

class CustomDropdown extends StatelessWidget {
  final String hint;

  const CustomDropdown({
    super.key,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF28286A) : Colors.grey.shade100;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Pallete.textSecondaryColor.withValues(alpha: 0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint,
              style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.color
                      ?.withValues(alpha: 0.8))),
          icon: const Icon(Icons.keyboard_arrow_down,
              color: Pallete.textSecondaryColor),
          items: const [],
          onChanged: (val) {},
        ),
      ),
    );
  }
}
