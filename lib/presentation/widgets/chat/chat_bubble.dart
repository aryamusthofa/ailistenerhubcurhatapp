import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime timestamp;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser
              ? theme.colorScheme.primaryContainer
              : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(2),
            bottomRight: isUser ? const Radius.circular(2) : const Radius.circular(16),
          ),
          boxShadow: [
            if (!isUser)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isUser ? theme.colorScheme.onPrimaryContainer : Colors.black87,
          ),
        ),
      ).animate()
       .scale(
         duration: 400.ms, 
         curve: Curves.easeOutBack, 
         begin: const Offset(0.8, 0.8), 
         end: const Offset(1.0, 1.0)
       )
       .slideY(
         begin: 0.5, 
         end: 0, 
         duration: 300.ms, 
         curve: Curves.easeOutQuad
       )
       .fadeIn(duration: 200.ms),
    );
  }
}
