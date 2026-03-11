import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';

class ChatBottomInput extends StatelessWidget {
  const ChatBottomInput({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1B1B2F) : Colors.grey.shade100;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A4A) : Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              color: Pallete.textSecondaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Icon(
            Icons.camera_alt,
            color: Pallete.textSecondaryColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Ask AutoNexa anything...',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Pallete.textSecondaryColor.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
              ),
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A4A) : Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mic,
              color: Pallete.textSecondaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Pallete.secondaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.send, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
