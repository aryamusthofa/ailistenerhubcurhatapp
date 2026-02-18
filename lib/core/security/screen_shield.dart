
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class ScreenShield {
  static Future<void> enable() async {
    try {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    } catch (e) {
      // Handle error or ignore on platforms where not supported
    }
  }

  static Future<void> disable() async {
    try {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    } catch (e) {
      // Handle error
    }
  }
}
