import '../../domain/entities/conversation.dart';
import '../../domain/repositories/i_conversation_repository.dart';
import '../../data/datasources/conversation_local_data_source.dart';
import '../models/conversation_model.dart';

class ConversationRepositoryImpl implements IConversationRepository {
  final ConversationLocalDataSource _localDataSource;

  ConversationRepositoryImpl(this._localDataSource);

  @override
  Future<List<Conversation>> getConversations() async {
    final models = await _localDataSource.getConversations();
    // Sort by timestamp desc
    models.sort((a, b) => b.lastMessageTimestamp.compareTo(a.lastMessageTimestamp));
    return models;
  }

  @override
  Future<void> saveConversation(Conversation conversation) async {
    final model = ConversationModel.fromEntity(conversation);
    await _localDataSource.saveConversation(model);
  }

  @override
  Future<void> deleteConversation(String id) async {
    await _localDataSource.deleteConversation(id);
  }
}
