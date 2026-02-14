
import 'package:hive/hive.dart';
import '../../domain/entities/chat_message.dart';

part 'chat_message_model.g.dart';

@HiveType(typeId: 0)
class ChatMessageModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String content;
  @HiveField(2)
  final bool isUser;
  @HiveField(3)
  final DateTime timestamp;
  @HiveField(4)
  final bool isEncrypted;
  @HiveField(5)
  final String? conversationId;
  @HiveField(6)
  final String? modelUsed;

  const ChatMessageModel({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    required this.isEncrypted,
    this.conversationId,
    this.modelUsed,
  });

  // From Entity
  factory ChatMessageModel.fromEntity(ChatMessage entity) {
    return ChatMessageModel(
      id: entity.id,
      content: entity.content,
      isUser: entity.isUser,
      timestamp: entity.timestamp,
      isEncrypted: entity.isEncrypted,
      conversationId: entity.conversationId,
      modelUsed: entity.modelUsed,
    );
  }

  // Convert to Entity
  ChatMessage toEntity() {
    return ChatMessage(
      id: id,
      content: content,
      isUser: isUser,
      timestamp: timestamp,
      isEncrypted: isEncrypted,
      conversationId: conversationId,
      modelUsed: modelUsed,
    );
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      content: json['content'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isEncrypted: json['isEncrypted'] as bool? ?? true,
      conversationId: json['conversationId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'isEncrypted': isEncrypted,
      'conversationId': conversationId,
    };
  }
}
