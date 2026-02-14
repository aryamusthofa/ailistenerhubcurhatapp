
import '../entities/chat_message.dart';

abstract class IChatRepository {
  Future<void> sendMessage(String message, String conversationId);
  Future<List<ChatMessage>> getChatHistory(String conversationId);
  Future<void> clearHistory(String conversationId);
  Stream<List<ChatMessage>> getChatStream(String conversationId);
}
