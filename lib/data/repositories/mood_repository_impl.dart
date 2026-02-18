
import '../../domain/entities/mood_entry.dart';
import '../../domain/repositories/i_mood_repository.dart';
import '../datasources/local/hive_service.dart';
import '../models/mood_entry_model.dart'; // Will use this once available

class MoodRepositoryImpl implements IMoodRepository {
  final HiveService _hiveService;

  MoodRepositoryImpl(this._hiveService);

  @override
  Future<void> deleteMood(String id) async {
    await _hiveService.moodBox.delete(id);
  }

  @override
  Future<List<MoodEntry>> getMoodHistory() async {
    final values = _hiveService.moodBox.values.toList();
    values.sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Newest first
    return values.map((entry) => entry.toEntity()).toList();
  }

  @override
  Future<void> logMood(MoodEntry entry) async {
    final model = MoodEntryModel.fromEntity(entry);
    await _hiveService.moodBox.put(model.id, model);
  }
}
