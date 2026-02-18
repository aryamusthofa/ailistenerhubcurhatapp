import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/theme/theme_provider.dart';
import '../providers/security_provider.dart';
import '../providers/language/language_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/fx/glass_container.dart';
import '../widgets/premium_overlay.dart';
import '../../core/localization/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final securityState = ref.watch(securityProvider);
    final appLocale = ref.watch(languageProvider);
    final userState = ref.watch(userProvider);
    final isPremium = userState.asData?.value.isPremium ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.translate('settings') ?? 'Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, context.translate('vibe_theme') ?? 'Vibe & Theme'),
            const SizedBox(height: 12),
            _buildThemeGrid(context, ref, themeMode, isPremium),
            
            const SizedBox(height: 32),
            _buildSectionHeader(context, context.translate('language') ?? 'Language'),
            const SizedBox(height: 12),
            _buildLanguageToggle(context, ref, appLocale),
            
            const SizedBox(height: 32),
            _buildSectionHeader(context, context.translate('security') ?? 'Security'),
            const SizedBox(height: 12),
            _buildSecuritySettings(context, ref, securityState),
            
            const SizedBox(height: 32),
            _buildSectionHeader(context, 'Danger Zone', isDanger: true),
            const SizedBox(height: 12),
            _buildDangerZone(context, ref),
            
            const SizedBox(height: 40),
            Center(
              child: Text(
                'AI Listener Hub v1.0.0',
                style: TextStyle(
                  color: Theme.of(context).disabledColor,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, {bool isDanger = false}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isDanger ? Colors.redAccent : Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildThemeGrid(BuildContext context, WidgetRef ref, AppThemeMode current, bool isPremium) {
    final themes = [
      {'label': 'Light', 'mode': AppThemeMode.light, 'icon': Icons.light_mode, 'premium': false},
      {'label': 'Dark', 'mode': AppThemeMode.dark, 'icon': Icons.dark_mode, 'premium': false},
      {'label': 'Calming', 'mode': AppThemeMode.calming, 'icon': Icons.spa, 'premium': true},
      {'label': 'Cyberpunk', 'mode': AppThemeMode.cyberpunk, 'icon': Icons.bolt, 'premium': true},
      {'label': 'RGB', 'mode': AppThemeMode.rgb, 'icon': Icons.gamepad, 'premium': true},
      {'label': 'Vintage', 'mode': AppThemeMode.vintage, 'icon': Icons.history_edu, 'premium': true},
      {'label': 'Ocean', 'mode': AppThemeMode.ocean, 'icon': Icons.water_drop, 'premium': true},
      {'label': 'Flower', 'mode': AppThemeMode.flower, 'icon': Icons.local_florist, 'premium': true},
      {'label': 'Electro', 'mode': AppThemeMode.electro, 'icon': Icons.memory, 'premium': true},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: themes.length,
      itemBuilder: (context, index) {
        final theme = themes[index];
        final mode = theme['mode'] as AppThemeMode;
        final isSelected = current == mode;
        final isLocked = (theme['premium'] as bool) && !isPremium;

        return GestureDetector(
          onTap: () {
            if (isLocked) {
              _showPremiumDialog(context, ref);
            } else {
              ref.read(themeProvider.notifier).setTheme(mode);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                  : Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      theme['icon'] as IconData,
                      color: isLocked ? Colors.grey : (isSelected ? Theme.of(context).colorScheme.primary : null),
                    ),
                    if (isLocked)
                      const Positioned(
                        right: -4,
                        top: -4,
                        child: Icon(Icons.lock, size: 12, color: Colors.amber),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  theme['label'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageToggle(BuildContext context, WidgetRef ref, Locale current) {
    return GlassContainer(
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              title: const Text('Bahasa Indonesia'),
              leading: const Text('🇮🇩', style: TextStyle(fontSize: 24)),
              trailing: current.languageCode == 'id' ? const Icon(Icons.check_circle, color: Colors.green) : null,
              onTap: () => ref.read(languageProvider.notifier).setLanguage('id'),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: ListTile(
              title: const Text('English'),
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
              trailing: current.languageCode == 'en' ? const Icon(Icons.check_circle, color: Colors.green) : null,
              onTap: () => ref.read(languageProvider.notifier).setLanguage('en'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySettings(BuildContext context, WidgetRef ref, SecurityState state) {
    return GlassContainer(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Biometric Lock'),
            subtitle: const Text('Require Fingerprint/FaceID to open app'),
            secondary: const Icon(Icons.fingerprint),
            value: state.isBiometricEnabled,
            onChanged: (val) => ref.read(securityProvider.notifier).toggleBiometric(val),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Screen Shield'),
            subtitle: const Text('Prevent screenshots & hide in recent apps'),
            secondary: const Icon(Icons.security),
            value: state.isScreenShieldEnabled,
            onChanged: (val) => ref.read(securityProvider.notifier).toggleScreenShield(val),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZone(BuildContext context, WidgetRef ref) {
    return GlassContainer(
      child: ListTile(
        title: const Text('Panic Mode: Wipe Everything', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        subtitle: const Text('Irreversibly delete all chat history and keys'),
        trailing: const Icon(Icons.delete_forever, color: Colors.red),
        onTap: () => _confirmWipe(context, ref),
      ),
    );
  }

  void _confirmWipe(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you absolutely sure?'),
        content: const Text('This will delete all your data and logout. This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              ref.read(securityProvider.notifier).wipeData();
              context.go('/welcome');
            },
            child: const Text('DELETE EVERYTHING'),
          ),
        ],
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
