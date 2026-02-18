import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'presentation/navigation/app_router.dart';
import 'presentation/providers/di_providers.dart';
import 'presentation/providers/theme/theme_provider.dart';
import 'presentation/providers/security_provider.dart';

import 'presentation/providers/language/language_provider.dart';
import 'presentation/screens/auth/biometric_gate.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dotenv
  await dotenv.load(fileName: ".env");

  // Initialize Firebase
  if (!kIsWeb && defaultTargetPlatform != TargetPlatform.linux) {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      debugPrint('Firebase initialization error: $e');
    }
  }
  
  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Create ProviderContainer to initialize services before running app
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
  );

  // Initialize Hive
  try {
    await container.read(hiveServiceProvider).init();
  } catch (e) {
    debugPrint('Hive initialization error: $e');
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const AICurhatApp(),
    ),
  );
}

class AICurhatApp extends ConsumerWidget {
  const AICurhatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the theme provider
    final appThemeMode = ref.watch(themeProvider);
    final appLocale = ref.watch(languageProvider);
    final router = ref.watch(routerProvider);
    
    // Initialize auth state implicitly via router redirect logic

    return MaterialApp.router(
      title: 'AI Listener Hub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getThemeData(appThemeMode),
      darkTheme: AppTheme.getThemeData(appThemeMode),
      themeMode: AppTheme.getThemeMode(appThemeMode),
      routerConfig: router,
      locale: appLocale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('id', ''),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        final securityState = ref.watch(securityProvider);
        return BiometricGate(
          isEnabled: securityState.isBiometricEnabled,
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
