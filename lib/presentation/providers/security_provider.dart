
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/security/encryption_service.dart';
import '../../core/security/screen_shield.dart';
import '../../data/datasources/local/hive_service.dart';
import '../../data/datasources/settings_local_data_source.dart';
import 'di_providers.dart';

class SecurityState {
  final bool isBiometricEnabled;
  final bool isScreenShieldEnabled;

  const SecurityState({
    this.isBiometricEnabled = false,
    this.isScreenShieldEnabled = true, // Default to true
  });

  SecurityState copyWith({
    bool? isBiometricEnabled,
    bool? isScreenShieldEnabled,
  }) {
    return SecurityState(
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isScreenShieldEnabled: isScreenShieldEnabled ?? this.isScreenShieldEnabled,
    );
  }
}

class SecurityNotifier extends StateNotifier<SecurityState> {
  final SettingsLocalDataSource _dataSource;
  final EncryptionService _encryptionService;
  final HiveService _hiveService;

  static const _biometricKey = 'biometric_enabled';
  static const _shieldKey = 'screen_shield_enabled';

  SecurityNotifier(this._dataSource, this._encryptionService, this._hiveService) : super(const SecurityState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final bio = _dataSource.getBool(_biometricKey) ?? false;
    final shield = _dataSource.getBool(_shieldKey) ?? true;
    
    state = SecurityState(
      isBiometricEnabled: bio,
      isScreenShieldEnabled: shield,
    );

    if (shield) {
      ScreenShield.enable();
    } else {
      ScreenShield.disable();
    }
  }

  Future<void> toggleBiometric(bool value) async {
    state = state.copyWith(isBiometricEnabled: value);
    await _dataSource.setBool(_biometricKey, value);
  }

  Future<void> toggleScreenShield(bool value) async {
    state = state.copyWith(isScreenShieldEnabled: value);
    await _dataSource.setBool(_shieldKey, value);
    
    if (value) {
      await ScreenShield.enable();
    } else {
      await ScreenShield.disable();
    }
  }
  
  Future<void> wipeData() async {
    // 1. Delete Encryption Key (Critical)
    await _encryptionService.deleteKey();

    // 2. Delete Hive Boxes (Data)
    await _hiveService.deleteAllData();

    // 3. Clear Prefs (Settings)
    // We might want to keep some settings or just nuke everything.
    // For "Panic", we nuke everything relevant to user identity/history.
    
    // Reset State
    state = const SecurityState();
    
    // Ideally, catch-all errors here
  }
}

final securityProvider = StateNotifierProvider<SecurityNotifier, SecurityState>((ref) {
  final dataSource = ref.watch(settingsLocalDataSourceProvider);
  final encryptionService = ref.watch(encryptionServiceProvider);
  final hiveService = ref.watch(hiveServiceProvider);
  return SecurityNotifier(dataSource, encryptionService, hiveService);
});
