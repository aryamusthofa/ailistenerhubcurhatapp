import '../../domain/entities/conversation.dart';

class ConversationModel extends Conversation {
  const ConversationModel({
    required super.id,
    required super.title,
    required super.lastMessage,
    required super.lastMessageTimestamp,
    required super.moodVibe,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      lastMessage: json['lastMessage'] as String,
      lastMessageTimestamp: DateTime.parse(json['lastMessageTimestamp'] as String),
      moodVibe: json['moodVibe'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lastMessage': lastMessage,
      'lastMessageTimestamp': lastMessageTimestamp.toIso8601String(),
      'moodVibe': moodVibe,
    };
  }

  factory ConversationModel.fromEntity(Conversation conversation) {
    return ConversationModel(
      id: conversation.id,
      title: conversation.title,
      lastMessage: conversation.lastMessage,
      lastMessageTimestamp: conversation.lastMessageTimestamp,
      moodVibe: conversation.moodVibe,
    );
  }
}
