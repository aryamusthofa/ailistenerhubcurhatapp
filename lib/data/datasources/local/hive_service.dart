
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ai_curhat_app/core/security/encryption_service.dart';
import 'package:ai_curhat_app/core/utils/box_names.dart';
import 'package:ai_curhat_app/data/models/chat_message_model.dart';
import 'package:ai_curhat_app/data/models/mood_entry_model.dart';

class HiveService {
  final EncryptionService _encryptionService;
  bool _isInitialized = false;

  HiveService(this._encryptionService);

  Future<void> init() async {
    if (_isInitialized) return;

    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(ChatMessageModelAdapter());
    Hive.registerAdapter(MoodEntryModelAdapter());

    // Get Encryption Key
    final encryptionKey = await _encryptionService.getEncryptionKey();

    // Open Boxes with Encryption
    await Hive.openBox<ChatMessageModel>(
      BoxNames.chatBox,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );

    await Hive.openBox<MoodEntryModel>(
      BoxNames.moodBox,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );

    _isInitialized = true;
  }

  Box<ChatMessageModel> get chatBox => Hive.box<ChatMessageModel>(BoxNames.chatBox);
  Box<MoodEntryModel> get moodBox => Hive.box<MoodEntryModel>(BoxNames.moodBox);

  Future<void> deleteAllData() async {
    await Hive.deleteBoxFromDisk(BoxNames.chatBox);
    await Hive.deleteBoxFromDisk(BoxNames.moodBox);
    // Optionally delete other boxes if any
  }
}
