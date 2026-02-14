import 'package:equatable/equatable.dart';

class Conversation extends Equatable {
  final String id;
  final String title;
  final String lastMessage;
  final DateTime lastMessageTimestamp;
  final String moodVibe;

  const Conversation({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.moodVibe,
  });

  @override
  List<Object?> get props => [id, title, lastMessage, lastMessageTimestamp, moodVibe];
}
