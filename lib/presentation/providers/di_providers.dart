
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/security/encryption_service.dart';
import '../../data/datasources/local/hive_service.dart';
import '../../data/datasources/remote/ai_remote_service.dart';
import '../../data/datasources/settings_local_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../data/repositories/mood_repository_impl.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/repositories/i_conversation_repository.dart';
import '../../domain/repositories/i_chat_repository.dart';
import '../../domain/repositories/i_mood_repository.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../data/datasources/conversation_local_data_source.dart';
import '../../data/repositories/conversation_repository_impl.dart';

// --- Core & External ---
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
});

// --- Services ---
final encryptionServiceProvider = Provider<EncryptionService>((ref) {
  return EncryptionService(ref.watch(secureStorageProvider));
});

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService(ref.watch(encryptionServiceProvider));
});

final aiRemoteServiceProvider = Provider<AIRemoteService>((ref) {
  return AIRemoteService();
});

final settingsLocalDataSourceProvider = Provider<SettingsLocalDataSource>((ref) {
  return SettingsLocalDataSourceImpl(
    sharedPreferences: ref.watch(sharedPreferencesProvider)
  );
});

// --- Repositories ---
final chatRepositoryProvider = Provider<IChatRepository>((ref) {
  return ChatRepositoryImpl(
    ref.watch(hiveServiceProvider),
    ref.watch(aiRemoteServiceProvider),
  );
});

final moodRepositoryProvider = Provider<IMoodRepository>((ref) {
  return MoodRepositoryImpl(ref.watch(hiveServiceProvider));
});

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(settingsLocalDataSourceProvider),
    ref.watch(sharedPreferencesProvider),
  );
});

final conversationLocalDataSourceProvider = Provider<ConversationLocalDataSource>((ref) {
  return ConversationLocalDataSourceImpl(
    sharedPreferences: ref.watch(sharedPreferencesProvider),
  );
});

final conversationRepositoryProvider = Provider<IConversationRepository>((ref) {
  return ConversationRepositoryImpl(
    ref.watch(conversationLocalDataSourceProvider),
  );
});

// --- Use Cases ---
final sendMessageUseCaseProvider = Provider<SendMessageUseCase>((ref) {
  return SendMessageUseCase(ref.watch(chatRepositoryProvider));
});
