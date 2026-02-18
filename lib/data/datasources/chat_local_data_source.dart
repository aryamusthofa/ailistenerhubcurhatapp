import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message_model.dart';

abstract class ChatLocalDataSource {
  Future<void> cacheChatHistory(List<ChatMessageModel> chatHistory);
  Future<List<ChatMessageModel>> getLastChatHistory();
  Future<void> clearChatHistory();
}

const cachedChatHistory = 'CACHED_CHAT_HISTORY';

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final SharedPreferences sharedPreferences;

  ChatLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheChatHistory(List<ChatMessageModel> chatHistory) {
    List<Map<String, dynamic>> jsonList = chatHistory.map((e) => e.toJson()).toList();
    final jsonString = json.encode(jsonList);
    final encodedString = base64Encode(utf8.encode(jsonString));
    return sharedPreferences.setString(cachedChatHistory, encodedString);
  }

  @override
  Future<List<ChatMessageModel>> getLastChatHistory() async {
    final encodedString = sharedPreferences.getString(cachedChatHistory);
    if (encodedString != null) {
      try {
        final jsonString = utf8.decode(base64Decode(encodedString));
        List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((e) => ChatMessageModel.fromJson(e)).toList();
      } catch (e) {
        // Fallback for migration if plain text exists or error
        return [];
      }
    } else {
      return [];
    }
  }

  @override
  Future<void> clearChatHistory() {
    return sharedPreferences.remove(cachedChatHistory);
  }
}
