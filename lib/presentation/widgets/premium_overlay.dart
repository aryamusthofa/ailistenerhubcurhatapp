import 'package:flutter/material.dart';
import 'dart:ui';

class PremiumOverlay extends StatelessWidget {
  final String? message;
  final VoidCallback? onUpgrade;

  const PremiumOverlay({
    super.key,
    this.message,
    this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blur Effect
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black.withValues(alpha: 0.3),
            alignment: Alignment.center,
          ),
        ),
        // Modal Content
        Align(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.workspace_premium, size: 48, color: Colors.amber),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Fitur Premium',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  message ?? 'Mode ini khusus untuk pengguna Premium. Upgrade sekarang untuk akses penuh!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onUpgrade ?? () {
                    // Navigate to payment or show ad logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber, // Premium color
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Buka Kunci (Upgrade)', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Nanti Saja'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
