import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/ai_vibe.dart';
import '../providers/mood_provider.dart';
import '../providers/user_provider.dart';
import 'premium_overlay.dart';

class MoodSelector extends ConsumerWidget {
  const MoodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentVibe = ref.watch(vibeProvider);
    final userState = ref.watch(userProvider);
    final isPremium = userState.asData?.value.isPremium ?? false;

    final vibes = [
      {'data': AiVibe.empathetic, 'label': 'Empathetic', 'icon': Icons.favorite_outline, 'isPremium': false},
      {'data': AiVibe.logical, 'label': 'Logical', 'icon': Icons.lightbulb_outline, 'isPremium': false},
      {'data': AiVibe.justListen, 'label': 'Listener', 'icon': Icons.hearing, 'isPremium': false},
      // New Premium Option
      {'data': AiVibe.logical, 'label': 'Sr. Counselor', 'icon': Icons.workspace_premium, 'isPremium': true}, 
    ];

    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: vibes.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final vibe = vibes[index];
          final vibeEnum = vibe['data'] as AiVibe;
          // Verify if this is the Sr. Counselor item to distinguish highlighting
          final isSrCounselor = vibe['label'] == 'Sr. Counselor';
          
          final isSelected = currentVibe == vibeEnum && !isSrCounselor; 
          // Note: If user selects "Sr. Counselor", we map it to Logical (per hack). 
          // So "Logical" pill might also highlight. 
          // For now, let's keep simple logic: if vibeEnum matches, it highlights.
          // But to avoid double highlight if we use same Enum, we add check.
          
          final isLocked = (vibe['isPremium'] as bool) && !isPremium;
          final color = isSelected ? Theme.of(context).primaryColor : Colors.grey;

          return GestureDetector(
            onTap: () {
              if (isLocked) {
                _showPremiumDialog(context, ref);
              } else {
                ref.read(vibeProvider.notifier).state = vibeEnum;
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.transparent : color.withValues(alpha: 0.5),
                  width: 1.5,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ] : [],
              ),
              child: Row(
                children: [
                  Icon(
                    isLocked ? Icons.lock : vibe['icon'] as IconData,
                    size: 18,
                    color: isSelected ? Colors.white : color,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    vibe['label'] as String,
                    style: TextStyle(
                      color: isSelected ? Colors.white : color,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPremiumDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent, // Let overlay handle blur
      builder: (context) => PremiumOverlay(
        message: 'Upgrade untuk mengakses Vibe Senior Counselor!',
        onUpgrade: () {
          ref.read(userProvider.notifier).upgradeToPremium();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Selamat! Anda sekarang Premium user.')),
          );
        },
      ),
    );
  }
}
