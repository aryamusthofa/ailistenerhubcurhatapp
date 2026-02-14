import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_notifier.dart';

// Firebase Auth instance provider (Nullable for Linux support)
final firebaseAuthProvider = Provider<FirebaseAuth?>((ref) {
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.linux) {
    return null; // Mock/Bypass for Linux
  }
  return FirebaseAuth.instance;
});

// Google Sign-In instance provider
final googleSignInProvider = Provider((ref) {
  return GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );
});

// AuthNotifier StateNotifierProvider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final googleSignIn = ref.watch(googleSignInProvider);
  
  return AuthNotifier(firebaseAuth, googleSignIn);
});

// Helper untuk check apakah user sudah authenticated
final isAuthenticatedProvider = Provider((ref) {
  final authState = ref.watch(authProvider);
  return authState.isAuthenticated;
});

// Helper untuk get current user
final currentUserProvider = Provider((ref) {
  final authState = ref.watch(authProvider);
  return authState.firebaseUser;
});
