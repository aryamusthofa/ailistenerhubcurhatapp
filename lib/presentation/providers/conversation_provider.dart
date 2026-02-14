import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/i_conversation_repository.dart';
import 'di_providers.dart';

// State for the list of conversations
class ConversationListState {
  final bool isLoading;
  final List<Conversation> conversations;
  final String? error;

  const ConversationListState({
    this.isLoading = false,
    this.conversations = const [],
    this.error,
  });

  ConversationListState copyWith({
    bool? isLoading,
    List<Conversation>? conversations,
    String? error,
  }) {
    return ConversationListState(
      isLoading: isLoading ?? this.isLoading,
      conversations: conversations ?? this.conversations,
      error: error,
    );
  }
}

class ConversationNotifier extends StateNotifier<ConversationListState> {
  final IConversationRepository _repository;
  final _uuid = const Uuid();

  ConversationNotifier(this._repository) : super(const ConversationListState()) {
    loadConversations();
  }

  Future<void> loadConversations() async {
    state = state.copyWith(isLoading: true);
    try {
      final conversations = await _repository.getConversations();
      state = state.copyWith(isLoading: false, conversations: conversations);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<String> createNewConversation({String title = 'New Chat', String moodVibe = 'listener'}) async {
    final newConversation = Conversation(
      id: _uuid.v4(),
      title: title,
      lastMessage: 'Started a new session',
      lastMessageTimestamp: DateTime.now(),
      moodVibe: moodVibe,
    );
    await _repository.saveConversation(newConversation);
    await loadConversations();
    return newConversation.id;
  }

  Future<void> deleteConversation(String id) async {
    await _repository.deleteConversation(id);
    await loadConversations();
  }
  
  // Update last message of a conversation
  Future<void> updateLastMessage(String conversationId, String message, {String? title}) async {
    // Find existing conversation to keep vibe and other data
    final existingIndex = state.conversations.indexWhere((c) => c.id == conversationId);
    if (existingIndex == -1) return;
    
    final existing = state.conversations[existingIndex];
    final updated = Conversation(
      id: existing.id,
      title: title ?? existing.title, // Update title if provided (e.g. first message)
      lastMessage: message,
      lastMessageTimestamp: DateTime.now(),
      moodVibe: existing.moodVibe,
    );
    
    await _repository.saveConversation(updated);
    await loadConversations();
  }
}

final conversationProvider = StateNotifierProvider<ConversationNotifier, ConversationListState>((ref) {
  final repository = ref.watch(conversationRepositoryProvider);
  return ConversationNotifier(repository);
});
