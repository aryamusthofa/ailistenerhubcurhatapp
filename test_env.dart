import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  
  print("=== Testing .env Configuration ===\n");
  
  // Test Gemini Keys
  final geminiKeys = dotenv.env['GEMINI_KEYS']?.split(',') ?? [];
  print("✓ GEMINI_KEYS loaded: ${geminiKeys.length} keys");
  
  // Test Groq Keys
  final groqKeys = dotenv.env['GROQ_KEYS']?.split(',') ?? [];
  print("✓ GROQ_KEYS loaded: ${groqKeys.length} keys");
  
  // Test SambaNova Keys
  final sambaKeys = dotenv.env['SAMBANOVA_KEYS']?.split(',') ?? [];
  print("✓ SAMBANOVA_KEYS loaded: ${sambaKeys.length} keys");
  
  // Test Together AI Keys
  final togetherKeys = dotenv.env['TOGETHER_KEYS']?.split(',') ?? [];
  print("✓ TOGETHER_KEYS loaded: ${togetherKeys.length} keys");
  
  // Test HuggingFace Keys
  final hfKeys = dotenv.env['HUGGINGFACE_KEYS']?.split(',') ?? [];
  print("✓ HUGGINGFACE_KEYS loaded: ${hfKeys.length} keys");
  
  // Test OpenAI Keys
  final openaiKeys = dotenv.env['OPENAI_KEYS']?.split(',') ?? [];
  print("✓ OPENAI_KEYS loaded: ${openaiKeys.length} keys");
  
  // Test Encryption Key
  final encryptionKey = dotenv.env['ENCRYPTION_KEY'] ?? '';
  print("✓ ENCRYPTION_KEY loaded: ${encryptionKey.length} characters\n");
  
  // Summary
  int totalKeys = geminiKeys.length + groqKeys.length + sambaKeys.length + 
                  togetherKeys.length + hfKeys.length + openaiKeys.length;
  print("=== SUMMARY ===");
  print("Total API Keys: $totalKeys");
  print("Status: ${totalKeys > 0 ? '✅ READY TO RUN' : '❌ MISSING API KEYS'}");
}
