import 'package:hive/hive.dart';
import '../../domain/entities/conversation.dart';

part 'conversation_model.g.dart';

@HiveType(typeId: 2)
class ConversationModel extends Conversation {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String lastMessage;
  @HiveField(3)
  final DateTime lastMessageTimestamp;
  @HiveField(4)
  final String moodVibe;

  const ConversationModel({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.moodVibe,
  }) : super(
          id: id,
          title: title,
          lastMessage: lastMessage,
          lastMessageTimestamp: lastMessageTimestamp,
          moodVibe: moodVibe,
        );

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
