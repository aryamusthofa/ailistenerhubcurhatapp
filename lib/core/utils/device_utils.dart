
import 'dart:io';
import 'package:flutter/foundation.dart';

class DeviceUtils {
  static bool get isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

  static bool get isMobile =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  static bool get isWeb => kIsWeb;

  // Placeholder for Low Power Mode check
  // In a real app, use battery_plus or power management plugins
  static Future<bool> isLowPowerMode() async {
    // TODO: Implement actual check
    return false;
  }
}
