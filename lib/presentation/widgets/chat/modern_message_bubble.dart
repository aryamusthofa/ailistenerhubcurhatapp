import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../fx/glass_container.dart';

/// Modern Message Bubble dengan glass effect
class ModernMessageBubble extends StatelessWidget {
  final String message;
  final bool isAI;
  final DateTime timestamp;
  final String? modelName;

  const ModernMessageBubble({
    required this.message,
    required this.isAI,
    required this.timestamp,
    this.modelName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: EdgeInsets.only(
        left: isAI ? 8 : 60,
        right: isAI ? 60 : 8,
        top: 8,
        bottom: 8,
      ),
      child: Align(
        alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
        child: GlassContainer(
          blur: 10,
          opacity: isAI ? 0.12 : 0.15,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isAI
                  ? theme.colorScheme.primary.withValues(alpha: 0.08)
                  : theme.colorScheme.secondary.withValues(alpha: 0.12),
            ),
            child: Column(
              crossAxisAlignment:
                  isAI ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isAI && modelName != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          modelName!,
                          style: TextStyle(
                            color: theme.colorScheme.primary.withValues(alpha: 0.8),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Text(
                      _formatTime(timestamp),
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 300.ms).slideX(begin: isAI ? -0.2 : 0.2),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
