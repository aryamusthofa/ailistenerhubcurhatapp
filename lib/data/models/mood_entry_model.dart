
import 'package:hive/hive.dart';
import '../../domain/entities/mood_entry.dart';

part 'mood_entry_model.g.dart';

@HiveType(typeId: 1)
class MoodEntryModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime timestamp;
  @HiveField(2)
  final String moodTypeString; // Storing enum as string for simplicity/robustness
  @HiveField(3)
  final String? note;

  MoodEntryModel({
    required this.id,
    required this.timestamp,
    required this.moodTypeString,
    this.note,
  });

  MoodType get moodType => _parseMood(moodTypeString);

  static MoodType _parseMood(String mood) {
    return MoodType.values.firstWhere(
      (e) => e.toString() == mood,
      orElse: () => MoodType.neutral,
    );
  }

  factory MoodEntryModel.fromEntity(MoodEntry entity) {
    return MoodEntryModel(
      id: entity.id,
      timestamp: entity.timestamp,
      moodTypeString: entity.moodType.toString(),
      note: entity.note,
    );
  }

  MoodEntry toEntity() {
    return MoodEntry(
      id: id,
      timestamp: timestamp,
      moodType: moodType,
      note: note,
    );
  }
}
