import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final String content;
  final bool isUser; // true if sender is User, false if AI
  final DateTime timestamp;
  final bool isEncrypted;
  final String? conversationId;
  final String? modelUsed;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    required this.isEncrypted,
    this.conversationId,
    this.modelUsed,
  });

  @override
  List<Object?> get props => [id, content, isUser, timestamp, isEncrypted, conversationId, modelUsed];
}
