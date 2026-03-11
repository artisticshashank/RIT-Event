import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/dashboard_user/widgets/chat_message_bubble.dart';
import 'package:autonexa/features/dashboard_user/widgets/suggested_diagnostics_list.dart';
import 'package:autonexa/features/dashboard_user/widgets/chat_bottom_input.dart';
import 'package:autonexa/features/dashboard_user/widgets/recommended_part_card.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80, // slightly taller so robot fits nicely
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 12, bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C1E16) : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.smart_toy,
              color: Pallete.secondaryColor,
              size: 24,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AutoNexa AI',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.circle, color: Colors.green, size: 8),
                const SizedBox(width: 4),
                Text(
                  'Online & Ready',
                  style: TextStyle(
                    color: Pallete.textSecondaryColor.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 24.0),
            icon: Icon(Icons.settings, color: Theme.of(context).textTheme.bodyLarge?.color),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: Pallete.textSecondaryColor.withValues(alpha: 0.1), height: 1),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(24.0).copyWith(bottom: 120),
            children: [
              const ChatMessageBubble(
                text: "Hello! I'm your AutoNexa assistant. I can help diagnose car issues, suggest maintenance, or find parts. How can I assist your drive today?",
                isUser: false,
                date: '10:24 AM',
              ),
              const SuggestedDiagnosticsList(),
              const SizedBox(height: 12),
              const ChatMessageBubble(
                text: "I'm hearing a clicking sound when I turn the steering wheel. What could it be?",
                isUser: true,
                date: '10:26 AM',
              ),
              const ChatMessageBubble(
                text: "A clicking noise during turns often points to worn **CV Axle Joints**.",
                isUser: false,
                date: '10:26 AM',
                embeddedCard: RecommendedPartCard(),
              ),
            ],
          ),
          
          Positioned(
            left: 24,
            right: 24,
            bottom: 120, // Sit just above the bottom padding so Nav Bar clears it
            child: const ChatBottomInput(),
          ),
        ],
      ),
    );
  }
}
