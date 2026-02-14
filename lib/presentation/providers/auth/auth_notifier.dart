import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Model untuk Auth State
class AuthState {
  final User? firebaseUser;
  final bool isLoading;
  final String? error;
  final String? authMethod; // 'email', 'google', 'facebook'
  final List<String> linkedProviders; // Provider yang sudah di-link (untuk account linking)

  AuthState({
    this.firebaseUser,
    this.isLoading = false,
    this.error,
    this.authMethod,
    this.linkedProviders = const [],
  });

  bool get isAuthenticated => firebaseUser != null || authMethod == 'guest_linux';

  AuthState copyWith({
    User? firebaseUser,
    bool? isLoading,
    String? error,
    String? authMethod,
    List<String>? linkedProviders,
  }) {
    return AuthState(
      firebaseUser: firebaseUser ?? this.firebaseUser,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      authMethod: authMethod ?? this.authMethod,
      linkedProviders: linkedProviders ?? this.linkedProviders,
    );
  }
}

/// AuthNotifier menggunakan Riverpod untuk manage auth state
class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuth? _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthNotifier(this._firebaseAuth, this._googleSignIn)
      : super(AuthState());

  /// Cek auth state saat app startup
  Future<void> checkAuthState() async {
    // [LINUX BYPASS] Mock Auth for Linux
    try {
        if (!kIsWeb && defaultTargetPlatform == TargetPlatform.linux) {
            // Auto-login as Guest on Linux because Firebase is not configured
            state = state.copyWith(
                firebaseUser: null, // No real user
                isLoading: false,
                authMethod: 'guest_linux',
            );
            return;
        }
    } catch (e) {
        debugPrint('Linux platform check error: $e');
    }

    try {
        final user = _firebaseAuth?.currentUser;
        if (user != null) {
        // Get linked providers
        final providerData = user.providerData;
        final linkedProviders = providerData.map((p) => p.providerId).toList();

        state = state.copyWith(
            firebaseUser: user,
            linkedProviders: linkedProviders,
        );
        }
    } catch(e) {
         debugPrint('FirebaseAuth check error: $e');
    }
  }

  /// Register dengan Email & Password
  Future<void> registerWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      if (_firebaseAuth == null) throw Exception('Auth not supported on Linux');
      final userCredential = await _firebaseAuth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      state = state.copyWith(
        isLoading: false,
        firebaseUser: userCredential.user,
        authMethod: 'email',
      );
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message ?? 'Registration failed',
      );
      rethrow;
    }
  }

  /// Login dengan Email & Password
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      if (_firebaseAuth == null) throw Exception('Auth not supported on Linux');
      final userCredential = await _firebaseAuth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final providerData = userCredential.user?.providerData;
      final linkedProviders = providerData?.map((p) => p.providerId).toList() ?? [];

      state = state.copyWith(
        isLoading: false,
        firebaseUser: userCredential.user,
        authMethod: 'email',
        linkedProviders: linkedProviders,
      );
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message ?? 'Login failed',
      );
      rethrow;
    }
  }

  /// Sign In dengan Google
  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Trigger Google Sign-In flow
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled
        state = state.copyWith(isLoading: false, error: 'Sign-in cancelled');
        return;
      }

      // Get Google authentication
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in ke Firebase dengan Google credential
      if (_firebaseAuth == null) throw Exception('Auth not supported on Linux');
      final userCredential = await _firebaseAuth!.signInWithCredential(credential);

      final providerData = userCredential.user?.providerData;
      final linkedProviders = providerData?.map((p) => p.providerId).toList() ?? [];

      state = state.copyWith(
        isLoading: false,
        firebaseUser: userCredential.user,
        authMethod: 'google',
        linkedProviders: linkedProviders,
      );
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message ?? 'Google sign-in failed',
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Google sign-in error: $e',
      );
      rethrow;
    }
  }

  /// Link Google Account ke existing email/password user
  Future<void> linkGoogleAccount() async {
    if (state.firebaseUser == null) {
      state = state.copyWith(error: 'No user logged in');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        state = state.copyWith(isLoading: false, error: 'Google sign-in cancelled');
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Link ke existing account
      await state.firebaseUser!.linkWithCredential(credential);

      // Refresh linked providers
      final updatedUser = _firebaseAuth?.currentUser;
      final providerData = updatedUser?.providerData;
      final linkedProviders = providerData?.map((p) => p.providerId).toList() ?? [];

      state = state.copyWith(
        isLoading: false,
        firebaseUser: updatedUser,
        linkedProviders: linkedProviders,
      );
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message ?? 'Account linking failed',
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Account linking error: $e',
      );
      rethrow;
    }
  }

  /// Unlink Google Account
  Future<void> unlinkGoogleAccount() async {
    if (state.firebaseUser == null) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      await state.firebaseUser!.unlink('google.com');

      final updatedUser = _firebaseAuth?.currentUser;
      final providerData = updatedUser?.providerData;
      final linkedProviders = providerData?.map((p) => p.providerId).toList() ?? [];

      state = state.copyWith(
        isLoading: false,
        firebaseUser: updatedUser,
        linkedProviders: linkedProviders,
      );
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message ?? 'Unlinking failed',
      );
      rethrow;
    }
  }

  /// Logout
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _firebaseAuth?.signOut();
      await _googleSignIn.signOut();

      state = AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Logout error: $e',
      );
      rethrow;
    }
  }
}
