import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/conversation_model.dart';

abstract class ConversationLocalDataSource {
  Future<List<ConversationModel>> getConversations();
  Future<void> saveConversation(ConversationModel conversation);
  Future<void> deleteConversation(String id);
  Future<void> clearAll();
}

const cachedConversationsKey = 'CACHED_CONVERSATIONS_LIST';

class ConversationLocalDataSourceImpl implements ConversationLocalDataSource {
  final SharedPreferences sharedPreferences;

  ConversationLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ConversationModel>> getConversations() async {
    final jsonString = sharedPreferences.getString(cachedConversationsKey);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((e) => ConversationModel.fromJson(e)).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  @override
  Future<void> saveConversation(ConversationModel conversation) async {
    final conversations = await getConversations();
    final index = conversations.indexWhere((element) => element.id == conversation.id);
    
    if (index != -1) {
      conversations[index] = conversation;
    } else {
      conversations.insert(0, conversation); // Add new to top
    }
    
    _saveListToPrefs(conversations);
  }

  @override
  Future<void> deleteConversation(String id) async {
    final conversations = await getConversations();
    conversations.removeWhere((element) => element.id == id);
    _saveListToPrefs(conversations);
  }

  @override
  Future<void> clearAll() async {
    await sharedPreferences.remove(cachedConversationsKey);
  }

  Future<void> _saveListToPrefs(List<ConversationModel> conversations) async {
    final jsonList = conversations.map((e) => e.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await sharedPreferences.setString(cachedConversationsKey, jsonString);
  }
}
