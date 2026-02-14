
import 'dart:async';
import 'package:uuid/uuid.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/i_chat_repository.dart';
import '../datasources/local/hive_service.dart';
import '../datasources/remote/ai_remote_service.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements IChatRepository {
  final HiveService _hiveService;
  final AIRemoteService _remoteService;
  final _uuid = const Uuid();

  ChatRepositoryImpl(this._hiveService, this._remoteService);

  @override
  Stream<List<ChatMessage>> getChatStream(String conversationId) {
    // Watch the box for changes
    return _hiveService.chatBox.watch().map((event) {
      final models = _hiveService.chatBox.values
          .where((m) => m.conversationId == conversationId)
          .toList();
      models.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<List<ChatMessage>> getChatHistory(String conversationId) async {
    final models = _hiveService.chatBox.values
        .where((m) => m.conversationId == conversationId)
        .toList();
    models.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> sendMessage(String message, String conversationId) async {
    // 1. Create User Message
    final userMsg = ChatMessageModel(
      id: _uuid.v4(),
      content: message,
      isUser: true,
      timestamp: DateTime.now(),
      isEncrypted: true,
      conversationId: conversationId,
    );

    // 2. Save User Message Locally (Encrypted via Hive)
    await _hiveService.chatBox.put(userMsg.id, userMsg);

    try {
      // 3. Send to AI (Ephemeral)
      final result = await _remoteService.generateResponse(message);

      // 4. Create AI Message
      final aiMsg = ChatMessageModel(
        id: _uuid.v4(),
        content: result.response,
        isUser: false,
        timestamp: DateTime.now(),
        isEncrypted: true,
        conversationId: conversationId,
        modelUsed: result.modelName,
      );

      // 5. Save AI Message Locally
      await _hiveService.chatBox.put(aiMsg.id, aiMsg);

    } catch (e) {
      // Handle error (e.g. save error message)
      final errorMsg = ChatMessageModel(
        id: _uuid.v4(),
        content: "Error: Could not reach AI. Please try again.",
        isUser: false,
        timestamp: DateTime.now(),
        isEncrypted: true,
        conversationId: conversationId,
      );
      await _hiveService.chatBox.put(errorMsg.id, errorMsg);
    }
  }

  @override
  Future<void> clearHistory(String conversationId) async {
     final keysToDelete = _hiveService.chatBox.values
        .where((m) => m.conversationId == conversationId)
        .map((m) => m.id) // Using ID as key based on logic: put(userMsg.id, userMsg)
        .toList();
        
    await _hiveService.chatBox.deleteAll(keysToDelete);
  }
}
