import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_curhat_app/presentation/widgets/fx/glass_container.dart';
import 'package:ai_curhat_app/presentation/providers/theme/theme_provider.dart';
import 'package:ai_curhat_app/presentation/providers/user_provider.dart';
import 'package:ai_curhat_app/presentation/widgets/mood_selector.dart';
import '../../../../presentation/providers/conversation_provider.dart';
import 'package:ai_curhat_app/presentation/widgets/premium_overlay.dart';
import 'package:ai_curhat_app/presentation/widgets/language_picker.dart';
import 'package:ai_curhat_app/core/localization/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: themeMode == AppThemeMode.dark
                    ? [
                        const Color(0xFF1A1A2E), // Deep space blue
                        const Color(0xFF16213E),
                        const Color(0xFF0F3460),
                      ]
                    : [
                        const Color(0xFFE3F2FD), // Very light blue
                        const Color(0xFFBBDEFB),
                        const Color(0xFF90CAF9),
                      ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, ref),
                  const SizedBox(height: 32),
                  Text(
                    context.translate('what_do_you_feel'),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const MoodSelector(), // New Widget
                  const SizedBox(height: 32),
                  _buildStatusCard(context),
                  const SizedBox(height: 32),
                  Text(
                    context.translate('select_topic'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryGrid(context),
                  const SizedBox(height: 100), // Space for FAB
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildPremiumFAB(context, ref),
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
        // Theme Switcher Button -> Settings Icon
        IconButton(
          icon: const Icon(Icons.settings), // Changed to Settings
          onPressed: () {
            _showThemePicker(context, ref);
          },
          tooltip: context.translate('theme_settings'),
        ),
      ],
    );
  }

  void _showPremiumDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => PremiumOverlay(
        message:
            'Tema "Calming Grey" hanya untuk pengguna Premium. Upgrade sekarang?',
        onUpgrade: () {
          ref.read(userProvider.notifier).upgradeToPremium();
          Navigator.pop(context);
          // Automatically switch after upgrade
          ref.read(themeProvider.notifier).setTheme(AppThemeMode.calming);
        },
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(12), // Add padding to container itself
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8), // Reduced from 12
            decoration: BoxDecoration(
              color: Colors.blueAccent.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite,
                color: Colors.blueAccent, size: 20), // Reduced size
          ),
          const SizedBox(width: 12), // Reduced space
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.translate('mental_health'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14, // Explicit size to control width
                  ),
                  overflow: TextOverflow.ellipsis, // Safety
                ),
                Text(
                  context.translate('mental_health_status'),
                  style: const TextStyle(
                    fontSize: 11, // Slightly smaller
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 14), // Reduced size
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    final categories = [
      {
        'name': context.translate('topic_work_stress'),
        'icon': Icons.work_outline,
        'color': Colors.orangeAccent
      },
      {
        'name': context.translate('topic_love'),
        'icon': Icons.favorite_border,
        'color': Colors.pinkAccent
      },
      {
        'name': context.translate('topic_family'),
        'icon': Icons.family_restroom,
        'color': Colors.greenAccent
      },
      {
        'name': context.translate('topic_motivation'),
        'icon': Icons.lightbulb_outline,
        'color': Colors.yellowAccent
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0, // Taller items to prevent overflow
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GlassContainer(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Wrap content
            children: [
              Icon(category['icon'] as IconData,
                  color: category['color'] as Color, size: 28),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  category['name'] as String,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2, // Allow 2 lines
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12, // Slightly smaller
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPremiumFAB(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withValues(alpha: 0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () async {
          // Create new conversation and navigate
          final id = await ref
              .read(conversationProvider.notifier)
              .createNewConversation();
          if (context.mounted) {
            context.push('/chat/$id');
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.chat_bubble_outline),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                context.translate('start_chat'),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
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
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.translate('select_vibe'),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
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
                      _buildThemeOption(context, ref, 'Light',
                          AppThemeMode.light, Icons.light_mode, false, currentTheme),
                      _buildThemeOption(context, ref, 'Dark',
                          AppThemeMode.dark, Icons.dark_mode, false, currentTheme),
                      _buildThemeOption(context, ref, 'Calming',
                          AppThemeMode.calming, Icons.spa, true, currentTheme, isPremium),
                      _buildThemeOption(context, ref, 'Cyberpunk',
                          AppThemeMode.cyberpunk, Icons.bolt, true, currentTheme, isPremium),
                      _buildThemeOption(context, ref, 'RGB',
                          AppThemeMode.rgb, Icons.gamepad, true, currentTheme, isPremium),
                      _buildThemeOption(context, ref, 'Vintage',
                          AppThemeMode.vintage, Icons.history_edu, true, currentTheme, isPremium),
                      _buildThemeOption(context, ref, 'Ocean',
                          AppThemeMode.ocean, Icons.water_drop, true, currentTheme, isPremium),
                      _buildThemeOption(context, ref, 'Flower',
                          AppThemeMode.flower, Icons.local_florist, true, currentTheme, isPremium),
                      _buildThemeOption(context, ref, 'Electro',
                          AppThemeMode.electro, Icons.memory, true, currentTheme, isPremium),
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
          Navigator.pop(context); // Close sheet logic
          _showPremiumDialog(context, ref);
        } else {
          ref.read(themeProvider.notifier).setTheme(mode);
          Navigator.pop(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blueAccent.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: Colors.blueAccent, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(icon,
                    size: 30,
                    color: isLocked
                        ? Colors.grey
                        : (isSelected ? Colors.blueAccent : Colors.white)),
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
                fontSize: 10, // Smaller font to fit
                color: isLocked ? Colors.grey : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
