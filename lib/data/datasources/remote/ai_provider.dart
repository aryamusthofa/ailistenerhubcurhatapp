import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class AIProvider {
  String get providerName;
  Future<String> generateResponse(String prompt);
}

class GeminiProvider implements AIProvider {
  final List<String> apiKeys;
  final String modelName;
  int _currentKeyIndex = 0;

  GeminiProvider({
    required this.apiKeys,
    this.modelName = 'gemini-pro',
  });

  @override
  String get providerName => 'Gemini Pro';

  @override
  Future<String> generateResponse(String prompt) async {
    if (apiKeys.isEmpty) {
      throw Exception('No Gemini API keys provided.');
    }

    Exception? lastError;
    
    for (int i = 0; i < apiKeys.length; i++) {
      final keyIndex = (_currentKeyIndex + i) % apiKeys.length;
      final apiKey = apiKeys[keyIndex];
      
      try {
        final model = GenerativeModel(
          model: modelName,
          apiKey: apiKey,
        );
        
        final content = [Content.text(prompt)];
        final response = await model.generateContent(content);
        
        if (response.text != null) {
          _currentKeyIndex = (_currentKeyIndex + 1) % apiKeys.length;
          return response.text!;
        }
      } catch (e) {
        lastError = Exception(e.toString());
        continue;
      }
    }

    throw lastError ?? Exception('All Gemini keys failed.');
  }
}

class GroqProvider implements AIProvider {
  final List<String> apiKeys;
  final String modelName;
  int _currentKeyIndex = 0;

  GroqProvider({
    required this.apiKeys,
    this.modelName = 'llama3-8b-8192',
  });

  @override
  String get providerName => 'Groq (Llama 3)';

  @override
  Future<String> generateResponse(String prompt) async {
    if (apiKeys.isEmpty) {
      throw Exception('No Groq API keys provided.');
    }

    Exception? lastError;
    
    for (int i = 0; i < apiKeys.length; i++) {
      final keyIndex = (_currentKeyIndex + i) % apiKeys.length;
      final apiKey = apiKeys[keyIndex];
      
      final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');
      
      try {
        final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'messages': [
              {'role': 'user', 'content': prompt}
            ],
            'model': modelName,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          _currentKeyIndex = (_currentKeyIndex + 1) % apiKeys.length; // Rotate on success
          return data['choices'][0]['message']['content'];
        } else {
          // If rate limit (429) or other errors, try next key
          throw Exception('Groq API Error: ${response.statusCode} - ${response.body}');
        }
      } catch (e) {
        lastError = Exception('Key $keyIndex failed: $e');
        continue;
      }
    }

    throw lastError ?? Exception('All Groq keys failed.');
  }
}

class OpenAIProvider implements AIProvider {
  final List<String> apiKeys;
  final String modelName;
  int _currentKeyIndex = 0;

  OpenAIProvider({
    required this.apiKeys,
    this.modelName = 'gpt-4o-mini',
  });

  @override
  String get providerName => '🧠 OpenAI ($modelName)';

  @override
  Future<String> generateResponse(String prompt) async {
    if (apiKeys.isEmpty) throw Exception('No OpenAI API keys provided.');

    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    Exception? lastError;

    for (int i = 0; i < apiKeys.length; i++) {
        final keyIndex = (_currentKeyIndex + i) % apiKeys.length;
        final apiKey = apiKeys[keyIndex];

        try {
          final response = await http.post(
            url,
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'messages': [
                {'role': 'user', 'content': prompt}
              ],
              'model': modelName,
            }),
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            _currentKeyIndex = (_currentKeyIndex + 1) % apiKeys.length; // Rotate on success
            return data['choices'][0]['message']['content'];
          } else {
            throw Exception('OpenAI API Error: ${response.statusCode} - ${response.body}');
          }
        } catch (e) {
          lastError = Exception('Key $keyIndex failed: $e');
          continue;
        }
    }
    throw lastError ?? Exception('All OpenAI keys failed.');
  }
}

class HuggingFaceProvider implements AIProvider {
  final List<String> apiKeys;
  final String modelName;
  int _currentKeyIndex = 0;

  HuggingFaceProvider({
    required this.apiKeys,
    this.modelName = 'mistralai/Mistral-7B-Instruct-v0.3',
  });

  @override
  String get providerName => '🤗 HuggingFace (Mistral)';

  @override
  Future<String> generateResponse(String prompt) async {
    if (apiKeys.isEmpty) throw Exception('No HuggingFace API keys provided.');

    final url = Uri.parse('https://api-inference.huggingface.co/models/$modelName');
    Exception? lastError;

    for (int i = 0; i < apiKeys.length; i++) {
        final keyIndex = (_currentKeyIndex + i) % apiKeys.length;
        final apiKey = apiKeys[keyIndex];

        try {
          final response = await http.post(
            url,
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'inputs': prompt,
              'parameters': {
                'max_new_tokens': 1024,
                'return_full_text': false,
              },
            }),
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            _currentKeyIndex = (_currentKeyIndex + 1) % apiKeys.length; // Rotate on success
            
            if (data is List && data.isNotEmpty) {
              return data[0]['generated_text'] ?? 'No text generated';
            } else if (data is Map && data.containsKey('generated_text')) {
              return data['generated_text'];
            }
            return response.body; 
          } else {
             // If rate limit or other errors, try next key
            throw Exception('HuggingFace API Error: ${response.statusCode} - ${response.body}');
          }
        } catch (e) {
          lastError = Exception('Key $keyIndex failed: $e');
          continue;
        }
    }
    throw lastError ?? Exception('All HuggingFace keys failed.');
  }
}

class SambaNovaProvider implements AIProvider {
  final List<String> apiKeys;
  final String modelName;
  int _currentKeyIndex = 0;

  SambaNovaProvider({
    required this.apiKeys,
    this.modelName = 'Meta-Llama-3.1-70B-Instruct',
  });

  @override
  String get providerName => '⚡ SambaNova (Llama 3.1)';

  @override
  Future<String> generateResponse(String prompt) async {
    if (apiKeys.isEmpty) throw Exception('No SambaNova API keys provided.');

    final url = Uri.parse('https://api.sambanova.ai/v1/chat/completions');
    Exception? lastError;

    for (int i = 0; i < apiKeys.length; i++) {
        final keyIndex = (_currentKeyIndex + i) % apiKeys.length;
        final apiKey = apiKeys[keyIndex];

        try {
          final response = await http.post(
            url,
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'messages': [
                {'role': 'system', 'content': 'You are a helpful AI assistant.'},
                {'role': 'user', 'content': prompt}
              ],
              'model': modelName,
            }),
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            _currentKeyIndex = (_currentKeyIndex + 1) % apiKeys.length;
            return data['choices'][0]['message']['content'];
          } else {
             throw Exception('SambaNova API Error: ${response.statusCode} - ${response.body}');
          }
        } catch (e) {
          lastError = Exception('Key $keyIndex failed: $e');
          continue;
        }
    }
    throw lastError ?? Exception('All SambaNova keys failed.');
  }
}

class TogetherAIProvider implements AIProvider {
  final List<String> apiKeys;
  final String modelName;
  int _currentKeyIndex = 0;

  TogetherAIProvider({
    required this.apiKeys,
    this.modelName = 'meta-llama/Llama-3.3-70B-Instruct-Turbo',
  });

  @override
  String get providerName => '🤝 Together AI (Llama 3.3)';

  @override
  Future<String> generateResponse(String prompt) async {
    if (apiKeys.isEmpty) throw Exception('No Together AI keys provided.');

    final url = Uri.parse('https://api.together.xyz/v1/chat/completions');
    Exception? lastError;

    for (int i = 0; i < apiKeys.length; i++) {
        final keyIndex = (_currentKeyIndex + i) % apiKeys.length;
        final apiKey = apiKeys[keyIndex];

        try {
          final response = await http.post(
            url,
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'messages': [
                {'role': 'system', 'content': 'You are a helpful AI assistant.'},
                {'role': 'user', 'content': prompt}
              ],
              'model': modelName,
            }),
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            _currentKeyIndex = (_currentKeyIndex + 1) % apiKeys.length;
            return data['choices'][0]['message']['content'];
          } else {
             throw Exception('Together AI Error: ${response.statusCode} - ${response.body}');
          }
        } catch (e) {
          lastError = Exception('Key $keyIndex failed: $e');
          continue;
        }
    }
    throw lastError ?? Exception('All Together AI keys failed.');
  }
}
