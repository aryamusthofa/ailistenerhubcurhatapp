
import '../repositories/i_chat_repository.dart';

class SendMessageUseCase {
  final IChatRepository _repository;

  SendMessageUseCase(this._repository);

  Future<void> call(String message, String conversationId) async {
    if (message.trim().isEmpty) return;
    return _repository.sendMessage(message, conversationId);
  }
}
