import '../entities/conversation.dart';

abstract class IConversationRepository {
  Future<List<Conversation>> getConversations();
  Future<void> saveConversation(Conversation conversation);
  Future<void> deleteConversation(String id);
}
