import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// --- State ---
class AuthState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;
  // Tambahan untuk Guest Mode di Linux
  final bool isGuest; 

  const AuthState({
    this.user, 
    this.isLoading = false, 
    this.errorMessage,
    this.isGuest = false,
  });

  AuthState copyWith({
    User? user, 
    bool? isLoading, 
    String? errorMessage,
    bool? isGuest,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}

// --- Notifier ---
class AuthNotifier extends StateNotifier<AuthState> {
  FirebaseAuth? _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthNotifier() : super(const AuthState()) {
    _init();
  }

  Future<void> _init() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.linux) {
      debugPrint('AuthNotifier: Running on Linux (Dev Mode). Ready for Guest Login.');
      return;
    }

    try {
      _auth = FirebaseAuth.instance;
      _auth?.authStateChanges().listen((user) {
        state = state.copyWith(user: user, isLoading: false);
      });
    } catch (e) {
      debugPrint('AuthNotifier Init Error: $e');
    }
  }

  Future<void> signInWithGoogle() async {
    // Linux Guest Bypass
    if (_auth == null && defaultTargetPlatform == TargetPlatform.linux) {
      _loginAsGuest();
      return;
    }

    if (_auth == null) {
      state = state.copyWith(errorMessage: 'Login Google belum tersedia di platform ini.');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth!.signInWithCredential(credential);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    // Linux Guest Bypass
    if (_auth == null && defaultTargetPlatform == TargetPlatform.linux) {
      _loginAsGuest();
      return;
    }

    if (_auth == null) {
      state = state.copyWith(errorMessage: 'Login Email belum tersedia di platform ini.');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _auth!.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> registerWithEmail(String email, String password) async {
    // Linux Guest Bypass
    if (_auth == null && defaultTargetPlatform == TargetPlatform.linux) {
      _loginAsGuest();
      return;
    }

    if (_auth == null) {
      state = state.copyWith(errorMessage: 'Register belum tersedia di platform ini.');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _auth!.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // Mock Login untuk Linux Dev
  void _loginAsGuest() {
    state = state.copyWith(isLoading: true);
    // Simulasi delay jaringan
    Future.delayed(const Duration(seconds: 1), () {
      state = state.copyWith(
        isLoading: false,
        isGuest: true, // Flag guest active
        // Kita biarkan user null, tapi nanti di router kita cek flag isGuest juga
      );
    });
  }

  Future<void> signOut() async {
    if (_auth != null) {
      await _auth!.signOut();
    }
    await _googleSignIn.signOut();
    // Reset state sepenuhnya
    state = const AuthState();
  }
}

// --- Provider ---
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
