import 'package:flutter_dotenv/flutter_dotenv.dart';

enum AIProviderType {
  gemini,
  groq,
  openAI,
}

class ModelConfig {
  final AIProviderType providerType;
  final String? apiKey;
  final String modelName;

  ModelConfig({
    required this.providerType,
    this.apiKey,
    required this.modelName,
  });

  /// Helper to get a list of Gemini keys from .env
  /// Expected format in .env: GEMINI_KEYS=key1,key2,key3
  static List<String> getGeminiKeys() {
    final keysString = dotenv.env['GEMINI_KEYS'] ?? dotenv.env['GEMINI_API_KEY'] ?? '';
    if (keysString.isEmpty) return [];
    
    return keysString.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  /// Helper to get Groq keys
  static List<String> getGroqKeys() {
    final keysString = dotenv.env['GROQ_KEYS'] ?? dotenv.env['GROQ_API_KEY'] ?? '';
    if (keysString.isEmpty) return [];
    
    return keysString.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  /// Helper to get OpenAI Keys (Multi-Key)
  static List<String> getOpenAIKeys() {
    final keysString = dotenv.env['OPENAI_KEYS'] ?? dotenv.env['OPENAI_API_KEY'] ?? '';
    if (keysString.isEmpty) return [];
    
    return keysString.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  /// Helper to get HuggingFace Keys (Multi-Key)
  static List<String> getHuggingFaceKeys() {
    final keysString = dotenv.env['HUGGINGFACE_KEYS'] ?? dotenv.env['HUGGINGFACE_API_KEY'] ?? '';
    if (keysString.isEmpty) return [];
    
    return keysString.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  /// Helper to get SambaNova Keys
  static List<String> getSambaNovaKeys() {
    final keysString = dotenv.env['SAMBANOVA_KEYS'] ?? '';
    if (keysString.isEmpty) return [];
    
    return keysString.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  /// Helper to get Together AI Keys
  static List<String> getTogetherAIKeys() {
    final keysString = dotenv.env['TOGETHER_KEYS'] ?? '';
    if (keysString.isEmpty) return [];
    
    return keysString.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }
}
