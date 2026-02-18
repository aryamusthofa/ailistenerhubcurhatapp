import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<void> cacheThemeMode(String themeMode);
  Future<String?> getLastThemeMode();
  Future<void> setBool(String key, bool value);
  bool? getBool(String key);
}

const cachedThemeMode = 'CACHED_THEME_MODE';

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheThemeMode(String themeMode) {
    return sharedPreferences.setString(cachedThemeMode, themeMode);
  }

  @override
  Future<String?> getLastThemeMode() async {
    return sharedPreferences.getString(cachedThemeMode);
  }

  @override
  Future<void> setBool(String key, bool value) {
    return sharedPreferences.setBool(key, value);
  }

  @override
  bool? getBool(String key) {
    return sharedPreferences.getBool(key);
  }
}

