import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/mood_entry.dart';
import '../../domain/entities/ai_vibe.dart';
import 'di_providers.dart';

final vibeProvider = StateProvider<AiVibe>((ref) => AiVibe.empathetic);

final moodHistoryProvider = FutureProvider<List<MoodEntry>>((ref) async {
  final repository = ref.watch(moodRepositoryProvider);
  return repository.getMoodHistory();
});
