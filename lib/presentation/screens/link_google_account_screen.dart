import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth/auth_provider.dart';
import '../widgets/fx/glass_container.dart';

class LinkGoogleAccountScreen extends ConsumerStatefulWidget {
  const LinkGoogleAccountScreen({super.key});

  @override
  ConsumerState<LinkGoogleAccountScreen> createState() =>
      _LinkGoogleAccountScreenState();
}

class _LinkGoogleAccountScreenState
    extends ConsumerState<LinkGoogleAccountScreen> {
  bool _isLoading = false;

  Future<void> _linkGoogleAccount() async {
    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).linkGoogleAccount();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Akun Google berhasil ditautkan!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menautkan: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _unlinkGoogleAccount() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Putuskan Google?'),
        content: const Text(
          'Anda masih dapat login dengan email dan password Anda',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batalkan'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya, Putuskan'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).unlinkGoogleAccount();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google account berhasil diputuskan'),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() {}); // Refresh UI
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memutuskan: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final isGoogleLinked =
        authState.linkedProviders.contains('google.com');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Kelola Akun Google'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Koneksi Google',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isGoogleLinked
                    ? 'Akun Google sudah ditautkan ke akun Anda'
                    : 'Tautkan Google untuk login lebih mudah',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),

              // Status Card
              GlassContainer(
                borderRadius: BorderRadius.circular(16),
                blur: 10,
                color: isGoogleLinked
                    ? Colors.green.withValues(alpha: 0.1)
                    : theme.colorScheme.surface.withValues(alpha: 0.3),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isGoogleLinked
                              ? Colors.green.withValues(alpha: 0.2)
                              : theme.colorScheme.surface,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.g_mobiledata,
                            size: 28,
                            color: isGoogleLinked
                                ? Colors.green
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Google Account',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isGoogleLinked ? 'Terhubung' : 'Belum terhubung',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isGoogleLinked
                                    ? Colors.green
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isGoogleLinked)
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Info Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Keuntungan Menautkan Google:',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _InfoPoint(
                      icon: Icons.flash_on,
                      title: 'Login Cepat',
                      subtitle: 'Tidak perlu mengetik email & password',
                    ),
                    const SizedBox(height: 8),
                    _InfoPoint(
                      icon: Icons.security,
                      title: 'Lebih Aman',
                      subtitle:
                          'Menggunakan keamanan Google 2-step verification',
                    ),
                    const SizedBox(height: 8),
                    _InfoPoint(
                      icon: Icons.backup,
                      title: 'Sinkronisasi',
                      subtitle: 'Data tersimpan aman di akun Google Anda',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Action Button
              if (!isGoogleLinked)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primaryContainer,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: _isLoading ? null : _linkGoogleAccount,
                        child: Center(
                          child: _isLoading
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Tautkan Google',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: GlassContainer(
                    borderRadius: BorderRadius.circular(12),
                    blur: 10,
                    color: Colors.red.withValues(alpha: 0.1),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: _isLoading ? null : _unlinkGoogleAccount,
                        child: Center(
                          child: _isLoading
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.red,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Putuskan Google',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoPoint extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoPoint({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
