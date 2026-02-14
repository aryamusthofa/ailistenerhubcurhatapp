
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/theme/theme_provider.dart';
import '../providers/security_provider.dart';
import '../widgets/fx/aurora_background.dart';
import '../widgets/fx/glass_container.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: Column(
            children: [
              GlassContainer(
                margin: const EdgeInsets.all(16),
                height: 60,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.pop(),
                    ),
                    const Expanded(
                      child: Text(
                        'Settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance current back button
                  ],
                ),
              ),
              
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const _SectionHeader(title: 'Appearance'),
                    const SizedBox(height: 8),
                    GlassContainer(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                           _SettingsTile(
                            title: 'Theme Mode',
                            trailing: DropdownButton<AppThemeMode>(
                              value: ref.watch(themeProvider),
                              onChanged: (AppThemeMode? newValue) {
                                if (newValue != null) {
                                  ref.read(themeProvider.notifier).setTheme(newValue);
                                }
                              },
                              underline: const SizedBox(),
                              items: AppThemeMode.values.map((AppThemeMode mode) {
                                return DropdownMenuItem<AppThemeMode>(
                                  value: mode,
                                  child: Text(mode.toString().split('.').last.toUpperCase()),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    const _SectionHeader(title: 'Security'),
                    const SizedBox(height: 8),
                    GlassContainer(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _SettingsTile(
                            title: 'Biometric Lock',
                            trailing: Switch(
                              value: ref.watch(securityProvider).isBiometricEnabled,
                              onChanged: (val) {
                                ref.read(securityProvider.notifier).toggleBiometric(val);
                              },
                            ),
                          ),
                          const Divider(),
                          _SettingsTile(
                            title: 'Screen Shield',
                             subtitle: 'Blocks screenshots & recording',
                            trailing: Switch(
                              value: ref.watch(securityProvider).isScreenShieldEnabled,
                              onChanged: (val) {
                                ref.read(securityProvider.notifier).toggleScreenShield(val);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    const _SectionHeader(title: 'Danger Zone', isDanger: true),
                    const SizedBox(height: 8),
                    GlassContainer(
                      padding: const EdgeInsets.all(16),
                      color: Colors.red.withValues(alpha: 0.1),
                      child: ListTile(
                        title: const Text('Wipe All Data', style: TextStyle(color: Colors.red)),
                        subtitle: const Text('Permanently delete all chat history and keys.'),
                        trailing: const Icon(Icons.delete_forever, color: Colors.red),
                        onTap: () async {
                           final confirm = await showDialog<bool>(
                             context: context,
                             builder: (context) => AlertDialog(
                               title: const Text('Wipe Everything?'),
                               content: const Text(
                                 'This will delete ALL chat capabilities, history, and keys. \n\nThis action cannot be undone.',
                               ),
                               actions: [
                                 TextButton(
                                   onPressed: () => Navigator.pop(context, false),
                                   child: const Text('Cancel'),
                                 ),
                                 TextButton(
                                   onPressed: () => Navigator.pop(context, true),
                                   child: const Text('WIPE IT', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                 ),
                               ],
                             ),
                           );

                           if (confirm == true) {
                             // trigger panic mode
                             // 1. Clear Hive
                             // 2. Clear Secure Storage
                             // 3. Clear Prefs
                             // 4. Force App Restart / Exit
                             
                             // For now, simpler implementation:
                             // ignore: use_build_context_synchronously
                             ScaffoldMessenger.of(context).showSnackBar(
                               const SnackBar(content: Text('Wiping data... (Simulated)')),
                             );
                             
                             // Call provider method (to be implemented more fully)
                             ref.read(securityProvider.notifier).wipeData();
                           }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDanger;

  const _SectionHeader({required this.title, this.isDanger = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDanger ? Colors.red : Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget trailing;

  const _SettingsTile({
    required this.title,
    this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!, style: const TextStyle(fontSize: 12)) : null,
      trailing: trailing,
    );
  }
}
