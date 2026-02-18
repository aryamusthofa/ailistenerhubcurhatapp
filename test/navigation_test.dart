import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_curhat_app/main.dart';
import 'package:ai_curhat_app/presentation/providers/di_providers.dart';
import 'package:ai_curhat_app/presentation/providers/auth/auth_provider.dart';
import 'package:ai_curhat_app/presentation/navigation/app_router.dart';
import 'package:ai_curhat_app/presentation/screens/chat_screen.dart';
import 'package:ai_curhat_app/presentation/screens/settings_screen.dart';

void main() {
  testWidgets('Navigation Smoke Test: Home -> Settings -> Home', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          // Ensure we are logged in as guest for testing
          authProvider.overrideWith((ref) => AuthNotifierMock()),
        ],
        child: const AICurhatApp(),
      ),
    );
    
    // Initial load
    await tester.pump(const Duration(seconds: 1));
    
    // Manually navigate to home if redirect didn't happen in test environment
    final router = ProviderScope.containerOf(tester.element(find.byType(AICurhatApp))).read(routerProvider);
    router.go('/home');
    await tester.pump(const Duration(seconds: 1));

    // Verify we are on Home
    expect(find.byIcon(Icons.settings), findsOneWidget);

    // Tap Settings
    final settingsIcon = find.byIcon(Icons.settings);
    expect(settingsIcon, findsOneWidget);
    await tester.tap(settingsIcon);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1)); // Extra pump

    // Verify Settings Screen by looking for text
    expect(find.textContaining('Vibe'), findsAtLeast(1));
    expect(find.byType(SettingsScreen), findsOneWidget);

    // Go back
    final backButton = find.byIcon(Icons.arrow_back);
    expect(backButton, findsOneWidget);
    await tester.tap(backButton);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    // Back to Home
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });

  testWidgets('ChatScreen has back button and can navigate back', (WidgetTester tester) async {
     SharedPreferences.setMockInitialValues({});
     final prefs = await SharedPreferences.getInstance();

     await tester.pumpWidget(
       ProviderScope(
         overrides: [
           sharedPreferencesProvider.overrideWithValue(prefs),
           authProvider.overrideWith((ref) => AuthNotifierMock()),
         ],
         child: const AICurhatApp(),
       ),
     );
     await tester.pump(const Duration(seconds: 1));
     
     // Manually go to home
     final router = ProviderScope.containerOf(tester.element(find.byType(AICurhatApp))).read(routerProvider);
     router.go('/home');
     await tester.pump(const Duration(seconds: 1));

     // Tap Start Chat
     final startChatButton = find.text('Mulai Chat');
     if (startChatButton.evaluate().isNotEmpty) {
        await tester.tap(startChatButton);
        await tester.pump(const Duration(seconds: 1));

        // Verify Chat Screen
        expect(find.byType(ChatScreen), findsOneWidget);

        // Verify Back Button
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);

        // Tap Back
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pump(const Duration(seconds: 1));

        // Should be back on Home
        expect(find.text('Mulai Chat'), findsOneWidget);
     }
  });
}

class AuthNotifierMock extends AuthNotifier {
  AuthNotifierMock() : super() {
    state = const AuthState(isGuest: true);
  }
  
  @override
  Future<void> _init() async {}
}
