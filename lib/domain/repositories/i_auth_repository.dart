
import '../entities/user_profile.dart';

abstract class IAuthRepository {
  Future<void> signInAnonymously();
  Future<void> signOut();
  Future<UserProfile?> getUserProfile();
  Future<void> updateTheme(String themeMode);
}
