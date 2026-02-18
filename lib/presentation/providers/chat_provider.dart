
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/send_message_usecase.dart';
import 'di_providers.dart';
import 'conversation_provider.dart';

// State
class ChatState {
  final bool isLoading;
  final bool isSending;
  final String? errorMessage;

  const ChatState({
    this.isLoading = false,
    this.isSending = false,
    this.errorMessage,
  });

  ChatState copyWith({
    bool? isLoading,
    bool? isSending,
    String? errorMessage,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      errorMessage: errorMessage,
    );
  }
}

// Notifier
class ChatNotifier extends StateNotifier<ChatState> {
  final SendMessageUseCase _sendMessageUseCase;
  final Ref _ref;

  ChatNotifier(this._sendMessageUseCase, this._ref) : super(const ChatState());

  Future<void> sendMessage(String text, String conversationId) async {
    if (state.isSending) return;

    state = state.copyWith(isSending: true, errorMessage: null);

    try {
      await _sendMessageUseCase(text, conversationId);
      
      // Update metadata (last message)
      // We use 'read' here to avoid listening
      _ref.read(conversationProvider.notifier).updateLastMessage(conversationId, text);
      
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    } finally {
      state = state.copyWith(isSending: false);
    }
  }
}

// Providers
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final sendMessageUseCase = ref.watch(sendMessageUseCaseProvider);
  return ChatNotifier(sendMessageUseCase, ref);
});

final chatHistoryProvider = StreamProvider.family<List<ChatMessage>, String>((ref, conversationId) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getChatStream(conversationId);
});
