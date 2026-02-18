
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/settings_local_data_source.dart';
import '../di_providers.dart';

enum AppThemeMode {
  light,
  dark,
  calming,
  cyberpunk,
  rgb,
  vintage,
  ocean,
  flower,
  electro,
}

class ThemeNotifier extends StateNotifier<AppThemeMode> {
  final SettingsLocalDataSource _dataSource;

  ThemeNotifier(this._dataSource) : super(AppThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final themeStr = await _dataSource.getLastThemeMode();
      if (themeStr != null) {
        state = AppThemeMode.values.firstWhere(
          (e) => e.toString() == themeStr,
          orElse: () => AppThemeMode.light,
        );
      }
    } catch (_) {
      // Default to light
    }
  }

  Future<void> setTheme(AppThemeMode mode) async {
    state = mode;
    await _dataSource.cacheThemeMode(mode.toString());
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  final dataSource = ref.watch(settingsLocalDataSourceProvider);
  return ThemeNotifier(dataSource);
});
