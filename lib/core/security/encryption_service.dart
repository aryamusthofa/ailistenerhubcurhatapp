
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EncryptionService {
  final FlutterSecureStorage _secureStorage;
  static const String _keyName = 'ai_curhat_hive_key';

  EncryptionService(this._secureStorage);

  Future<Uint8List> getEncryptionKey() async {
    // 1. Check if key exists
    final containsEncryptionKey = await _secureStorage.containsKey(key: _keyName);
    
    if (!containsEncryptionKey) {
      // 2. Generate new key
      final key = Hive.generateSecureKey();
      // 3. Store it securely
      await _secureStorage.write(key: _keyName, value: base64UrlEncode(key));
      return Uint8List.fromList(key);
    } else {
      // 4. Retrieve existing key
      final keyBase64 = await _secureStorage.read(key: _keyName);
      return base64Url.decode(keyBase64!);
    }
  }

  Future<void> deleteKey() async {
    await _secureStorage.delete(key: _keyName);
  }
}
