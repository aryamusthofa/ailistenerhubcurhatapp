import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ai_curhat_app/presentation/widgets/fx/glass_container.dart';
import 'package:ai_curhat_app/presentation/providers/theme/theme_provider.dart';
import 'package:ai_curhat_app/presentation/providers/user_provider.dart';
import 'package:ai_curhat_app/presentation/widgets/mood_selector.dart';
import '../../../../presentation/providers/conversation_provider.dart';
import 'package:ai_curhat_app/presentation/widgets/premium_overlay.dart';
import 'package:ai_curhat_app/presentation/widgets/language_picker.dart';
import 'package:ai_curhat_app/core/localization/app_localizations.dart';
import '../../../../presentation/widgets/fx/aurora_background.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We use AuroraBackground for the base, so we remove the explicit gradient container
    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, ref),
                const SizedBox(height: 32),
                
                // Fluid Section 1: Mood
                Text(
                  context.translate('what_do_you_feel'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ).animate().fadeIn().slideX(begin: -0.1, end: 0),
                const SizedBox(height: 16),
                const MoodSelector().animate().fadeIn(delay: 200.ms),
                
                const SizedBox(height: 32),
                
                // Fluid Section 2: Personalization & Status (Swipable or Stacked)
                _buildPersonalizationCard(context).animate().scale(delay: 300.ms),
                
                const SizedBox(height: 32),
                
                // Fluid Section 3: Topics (Flowing Grid)
                Text(
                  context.translate('select_topic'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn().slideX(begin: -0.1, end: 0),
                const SizedBox(height: 16),
                _buildCategoryGrid(context).animate().fadeIn(delay: 400.ms),
                
                const SizedBox(height: 100), // Space for FAB
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildPremiumFAB(context, ref).animate().scale(delay: 500.ms, curve: Curves.elasticOut),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.translate('hello_friend'),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                context.translate('ready_to_start_day'),
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withValues(alpha: 0.7),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const LanguagePicker(),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => context.push('/settings'),
          tooltip: context.translate('settings'),
        ),
      ],
    );
  }

  Widget _buildPersonalizationCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/personalization'),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.face, color: Theme.of(context).colorScheme.primary, size: 28),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Atur Konteks AI', // Hardcoded for now, can be localized
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Biarkan AI mengenalmu lebih dalam.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    final categories = [
      {'name': context.translate('topic_work_stress'), 'icon': Icons.work_outline, 'color': Colors.orangeAccent},
      {'name': context.translate('topic_love'), 'icon': Icons.favorite_border, 'color': Colors.pinkAccent},
      {'name': context.translate('topic_family'), 'icon': Icons.family_restroom, 'color': Colors.greenAccent},
      {'name': context.translate('topic_motivation'), 'icon': Icons.lightbulb_outline, 'color': Colors.yellowAccent},
    ];

    // Using Wrap for "Fluid" Masonry feel instead of rigid GridView
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: categories.map((category) {
        return SizedBox(
          width: (MediaQuery.of(context).size.width - 48 - 12) / 2, // Half width minus padding
          child: GlassContainer(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(category['icon'] as IconData, color: category['color'] as Color, size: 32),
                const SizedBox(height: 12),
                Text(
                  category['name'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPremiumFAB(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0, // Handled by container
        ),
        onPressed: () async {
          final id = await ref.read(conversationProvider.notifier).createNewConversation();
          if (context.mounted) {
            context.push('/chat/$id');
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.chat_bubble_outline),
            const SizedBox(width: 12),
            Text(
              context.translate('start_chat'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final currentTheme = ref.watch(themeProvider);
        final userState = ref.watch(userProvider);
        final isPremium = userState.asData?.value.isPremium ?? false;

        return GlassContainer(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  context.translate('select_vibe'),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _buildThemeOption(context, ref, 'Light', AppThemeMode.light, Icons.light_mode, false, currentTheme),
                      _buildThemeOption(context, ref, 'Dark', AppThemeMode.dark, Icons.dark_mode, false, currentTheme),
                      _buildThemeOption(context, ref, 'Calming', AppThemeMode.calming, Icons.spa, true, currentTheme, isPremium),
                      _buildThemeOption(context, ref, 'Cyberpunk', AppThemeMode.cyberpunk, Icons.bolt, true, currentTheme, isPremium),
                      _buildThemeOption(context, ref, 'RGB', AppThemeMode.rgb, Icons.gamepad, true, currentTheme, isPremium),
                      _buildThemeOption(context, ref, 'Vintage', AppThemeMode.vintage, Icons.history_edu, true, currentTheme, isPremium),
                      _buildThemeOption(context, ref, 'Ocean', AppThemeMode.ocean, Icons.water_drop, true, currentTheme, isPremium),
                      _buildThemeOption(context, ref, 'Flower', AppThemeMode.flower, Icons.local_florist, true, currentTheme, isPremium),
                      _buildThemeOption(context, ref, 'Electro', AppThemeMode.electro, Icons.memory, true, currentTheme, isPremium),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
      BuildContext context,
      WidgetRef ref,
      String label,
      AppThemeMode mode,
      IconData icon,
      bool isPremiumTheme,
      AppThemeMode current,
      [bool isUserPremium = false]) {
    final isSelected = current == mode;
    final isLocked = isPremiumTheme && !isUserPremium;

    return GestureDetector(
      onTap: () {
        if (isLocked) {
          Navigator.pop(context);
          _showPremiumDialog(context, ref);
        } else {
          ref.read(themeProvider.notifier).setTheme(mode);
          Navigator.pop(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
              : Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(icon,
                    size: 28,
                    color: isLocked
                        ? Colors.grey
                        : (isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).iconTheme.color)),
                if (isLocked)
                  const Positioned(
                    right: -4,
                    top: -4,
                    child: Icon(Icons.lock, size: 14, color: Colors.amber),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: isLocked ? Colors.grey : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPremiumDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => PremiumOverlay(
        message: 'Tema ini hanya untuk pengguna Premium. Upgrade sekarang?',
        onUpgrade: () {
          ref.read(userProvider.notifier).upgradeToPremium();
          Navigator.pop(context);
        },
      ),
    );
  }
}
