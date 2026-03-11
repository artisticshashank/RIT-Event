import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';

class ChatMessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final Widget? embeddedCard;
  final String date;

  const ChatMessageBubble({
    super.key,
    required this.text,
    required this.isUser,
    required this.date,
    this.embeddedCard,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // User is orange, AI is dark blue/grey
    final bgColor = isUser
        ? Pallete.secondaryColor
        : (isDark ? const Color(0xFF1B1B2F) : Colors.grey.shade200);

    final textColor = isUser
        ? Colors.white
        : Theme.of(context).textTheme.bodyLarge?.color;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Pallete.secondaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
          ],

          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isUser ? 20 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      if (embeddedCard != null) ...[
                        const SizedBox(height: 16),
                        embeddedCard!,
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Pallete.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),

          if (isUser) ...[
            const SizedBox(
              width: 48,
            ), // Push message bubble slightly from the edge to match AI chat spacing.
          ] else ...[
            const SizedBox(width: 48), // Padding on opposite side
          ],
        ],
      ),
    );
  }
}
