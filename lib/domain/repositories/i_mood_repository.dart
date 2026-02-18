
import '../entities/mood_entry.dart';

abstract class IMoodRepository {
  Future<void> logMood(MoodEntry entry);
  Future<List<MoodEntry>> getMoodHistory();
  Future<void> deleteMood(String id);
}
