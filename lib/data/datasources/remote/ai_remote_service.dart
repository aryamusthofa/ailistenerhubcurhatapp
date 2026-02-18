import 'package:flutter/foundation.dart';
import '../../../core/config/ai_config.dart';
import 'ai_provider.dart';

class AnalysisResult {
  final String response;
  final String modelName;

  AnalysisResult(this.response, this.modelName);
}

class AIRemoteService {
  late final List<AIProvider> _providers;
  bool _isInitialized = false;

  AIRemoteService() {
    _initializeProviders();
  }

  void _initializeProviders() {
    _providers = [];

    // 1. Setup Gemini with Key Rotation
    final geminiKeys = ModelConfig.getGeminiKeys();
    if (geminiKeys.isNotEmpty) {
      _providers.add(GeminiProvider(apiKeys: geminiKeys));
    }

    // 2. Setup Groq (Fallback)
    final groqKeys = ModelConfig.getGroqKeys();
    if (groqKeys.isNotEmpty) {
      _providers.add(GroqProvider(apiKeys: groqKeys));
    }

    // 3. Setup SambaNova (Free Fallback)
    final sambaKeys = ModelConfig.getSambaNovaKeys();
    if (sambaKeys.isNotEmpty) {
      _providers.add(SambaNovaProvider(apiKeys: sambaKeys));
    }

    // 4. Setup Together AI (Free Fallback)
    final togetherKeys = ModelConfig.getTogetherAIKeys();
    if (togetherKeys.isNotEmpty) {
      _providers.add(TogetherAIProvider(apiKeys: togetherKeys));
    }

    // 5. Setup HuggingFace (Free Fallback - Multi-Key)
    final huggingFaceKeys = ModelConfig.getHuggingFaceKeys();
    if (huggingFaceKeys.isNotEmpty) {
       _providers.add(HuggingFaceProvider(apiKeys: huggingFaceKeys));
    }

    // 6. Setup OpenAI (Paid/Scavenged Fallback - Last Resort - Multi-Key)
    final openAIKeys = ModelConfig.getOpenAIKeys();
    if (openAIKeys.isNotEmpty) {
      _providers.add(OpenAIProvider(apiKeys: openAIKeys));
    }

    _isInitialized = _providers.isNotEmpty;
  }

  /// Generates a response using authorized providers in order.
  /// Returns a tuple-like object [AnalysisResult] containing response and model name.
  Future<AnalysisResult> generateResponse(String message) async {
    if (!_isInitialized) {
      // Try initializing again (maybe .env loaded late)
      _initializeProviders();
      if (!_isInitialized) {
        return AnalysisResult(
          "System Error: No valid API keys found in .env. Please configure GEMINI_KEYS or GROQ_API_KEY.",
          "System",
        );
      }
    }

    List<String> errors = [];

    for (final provider in _providers) {
      try {
        final response = await provider.generateResponse(message);
        return AnalysisResult(response, provider.providerName);
      } catch (e) {
        debugPrint('Provider ${provider.providerName} failed: $e');
        errors.add("${provider.providerName}: ${e.toString()}");
        // Continue to next provider
      }
    }

    // If all providers failed
    return AnalysisResult(
      "Maaf, semua sistem AI saya sedang sibuk atau bermasalah.\n\nDetail Error:\n${errors.join('\n')}",
      "System Error",
    );
  }
}
