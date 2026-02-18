import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/mood_provider.dart';
import 'premium_overlay.dart';

enum VibeMode {
  empathetic,
  logical,
  listener,
  humorous,
}

class MoodSelector extends ConsumerWidget {
  const MoodSelector({super.key});

  void _onMoodSelected(BuildContext context, WidgetRef ref, VibeMode mode) {
    // Logic for premium check if needed
    ref.read(moodProvider.notifier).setMood(mode);
  }

  void _showPremiumOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent, // Let overlay handle blur
      builder: (context) => const PremiumOverlay(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMood = ref.watch(moodProvider);

    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _MoodCard(
            title: 'Empathetic',
            icon: Icons.favorite,
            isSelected: currentMood == VibeMode.empathetic,
            onTap: () => _onMoodSelected(context, ref, VibeMode.empathetic),
          ),
          _MoodCard(
            title: 'Logical',
            icon: Icons.lightbulb,
            isSelected: currentMood == VibeMode.logical,
            onTap: () => _onMoodSelected(context, ref, VibeMode.logical),
          ),
          _MoodCard(
            title: 'Just Listen',
            icon: Icons.hearing,
            isSelected: currentMood == VibeMode.listener,
            onTap: () => _onMoodSelected(context, ref, VibeMode.listener),
          ),
           _MoodCard(
            title: 'Humorous',
            icon: Icons.sentiment_very_satisfied,
            isSelected: currentMood == VibeMode.humorous,
            isPremium: true,
            onTap: () => _showPremiumOverlay(context),
          ),
        ],
      ),
    );
  }
}

class _MoodCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isPremium;

  const _MoodCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isPremium)
              const Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.lock, size: 12, color: Colors.amber),
                ),
              ),
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.iconTheme.color?.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
