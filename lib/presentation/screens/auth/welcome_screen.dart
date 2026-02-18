import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../widgets/fx/aurora_background.dart';
import '../../widgets/fx/glass_container.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                
                // Animated Logo
                GlassContainer(
                  padding: const EdgeInsets.all(32),
                  borderRadius: BorderRadius.circular(100),
                  child: Icon(
                    Icons.favorite_rounded, 
                    size: 80, 
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                  ),
                ).animate()
                 .scale(duration: 800.ms, curve: Curves.easeOutBack)
                 .shimmer(delay: 1.seconds, duration: 1200.ms),

                const SizedBox(height: 40),
                
                // Title with animation
                Text(
                  'AI Listener Hub',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  textAlign: TextAlign.center,
                ).animate()
                 .fadeIn(delay: 300.ms, duration: 500.ms)
                 .slideY(begin: 0.3, end: 0),

                const SizedBox(height: 16),
                
                // Description
                Text(
                  'Tempat aman untuk bercerita, didengar dengan empati, dan dipahami tanpa penghakiman.',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ).animate()
                 .fadeIn(delay: 500.ms, duration: 500.ms),

                const Spacer(),
                
                // Buttons
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => context.push('/login'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Masuk', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ).animate()
                     .fadeIn(delay: 700.ms)
                     .slideY(begin: 0.5, end: 0),

                    const SizedBox(height: 16),

                    GlassContainer(
                      padding: EdgeInsets.zero,
                      opacity: 0.05,
                      child: OutlinedButton(
                        onPressed: () => context.push('/register'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(
                          'Daftar Akun Baru',
                          style: TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                    ).animate()
                     .fadeIn(delay: 900.ms)
                     .slideY(begin: 0.5, end: 0),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
