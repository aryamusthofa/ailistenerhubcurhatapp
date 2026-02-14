import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/link_google_account_screen.dart';
import '../providers/auth/auth_provider.dart';

// Private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter(WidgetRef ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: _GoRouterRefreshStream(ref),
    redirect: (context, state) {
      // Watch auth state
      final isAuthenticated = ref.watch(isAuthenticatedProvider);

      // Routes yang tidak memerlukan auth (public routes)
      final publicRoutes = ['/welcome', '/login', '/register'];
      final isPublicRoute = publicRoutes.contains(state.matchedLocation);

      // Jika tidak authenticated dan bukan public route → redirect ke welcome
      if (!isAuthenticated && !isPublicRoute) {
        return '/welcome';
      }

      // Jika authenticated dan di public route → redirect ke home
      if (isAuthenticated && isPublicRoute) {
        return '/home';
      }

      // No redirect needed
      return null;
    },
    routes: [
      // Splash / Loading → auto-redirect dengan auth check
      GoRoute(
        path: '/',
        builder: (context, state) => const _SplashScreen(),
      ),
      // Welcome Screen (Login/Register choice)
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      // Login Screen
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      // Register Screen
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      // Home Dashboard
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      // Chat Room (Venting)
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ChatScreen(conversationId: id);
        },
      ),
      // Settings
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      // Link Google Account
      GoRoute(
        path: '/link-google',
        builder: (context, state) => const LinkGoogleAccountScreen(),
      ),
    ],
    // Error Page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
}

/// Stream listener untuk GoRouter refresh saat auth state berubah
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(this._ref) {
    // Subscribe ke auth state changes
    _ref.listen(
      authProvider,
      (prev, next) {
        notifyListeners();
      },
    );
  }

  final WidgetRef _ref;
}

/// Splash screen that shows a calming loading animation
/// then auto-navigates to /home after 2 seconds.
class _SplashScreen extends StatefulWidget {
  const _SplashScreen();

  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();

    // Navigate to home after 2 seconds
    _navigationTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1A1A2E),
                    const Color(0xFF16213E),
                    const Color(0xFF0F3460),
                  ]
                : [
                    const Color(0xFFE3F2FD),
                    const Color(0xFFBBDEFB),
                    const Color(0xFF90CAF9),
                  ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.spa_outlined,
                    size: 80,
                    color: isDark ? Colors.white70 : const Color(0xFF455A64),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'AI Listener Hub',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: isDark ? Colors.white : const Color(0xFF263238),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ruang aman untuk bercerita',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? Colors.white54
                          : const Color(0xFF607D8B),
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: isDark ? Colors.white54 : const Color(0xFF607D8B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
