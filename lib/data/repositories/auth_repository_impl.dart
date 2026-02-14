
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/settings_local_data_source.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final SettingsLocalDataSource _settingsDataSource;
  final SharedPreferences _prefs;

  static const String _isAnonymousKey = 'is_anonymous_login';
  // Coin balance could be stored here or in a separate SecureStorage for better security if it involves real value.
  // For now, simple prefs is fine as per blueprint constraints (focus on chat privacy).

  AuthRepositoryImpl(this._settingsDataSource, this._prefs);

  @override
  Future<UserProfile?> getUserProfile() async {
    final theme = await _settingsDataSource.getLastThemeMode() ?? 'light';
    final isAnon = _prefs.getBool(_isAnonymousKey) ?? true; // Default to true (safe)
    
    // In a real app, ID would come from Firebase Auth
    // Here we simulate an anonymous ID or fetch from prefs if we stored one.
    const fakeId = 'anon_user'; 

    return UserProfile(
      id: fakeId,
      isAnonymous: isAnon,
      preferredTheme: theme,
      coinBalance: 0, // Placeholder
    );
  }

  @override
  Future<void> signInAnonymously() async {
    await _prefs.setBool(_isAnonymousKey, true);
  }

  @override
  Future<void> signOut() async {
    // In valid auth, this would sign out from Firebase.
    // Here we just clear the anon flag or reset state.
    await _prefs.remove(_isAnonymousKey);
  }

  @override
  Future<void> updateTheme(String themeMode) async {
    await _settingsDataSource.cacheThemeMode(themeMode);
  }
}
