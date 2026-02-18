import '../models/chat_message_model.dart';

abstract class ChatRemoteDataSource {
  Future<ChatMessageModel> getAiResponse(List<ChatMessageModel> history, {String? vibe});
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  @override
  Future<ChatMessageModel> getAiResponse(List<ChatMessageModel> history, {String? vibe}) async {
    // MOCKING AI DELAY
    await Future.delayed(const Duration(seconds: 2));

    String content;
    
    // MOCKING EMPATHY RESPONSE based on Vibe
    switch (vibe) {
      case 'Logical':
        content = "Analisa situasi:\n1. Masalah teridentifikasi: Perasaan anda saat ini.\n2. Solusi potensial: Tarik napas, identifikasi pemicu, dan lakukan tindakan kecil yang produktif.";
        break;
      case 'Listener':
        content = "Hmm... Saya mendengarkan. Lanjut...";
        break;
      case 'Empathetic':
      default:
        content = "Saya mengerti perasaanmu. Ceritakan lebih banyak, saya di sini untuk mendengarkan tanpa menghakimi.";
    }

    // In real implementation, this would call Gemini/Grok API
    return ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: false,
      timestamp: DateTime.now(),
      isEncrypted: true,
    );
  }
}
