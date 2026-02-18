enum MoodType {
  happy,
  sad,
  angry,
  anxious,
  neutral,
}

class MoodEntry {
  final String id;
  final DateTime timestamp;
  final MoodType moodType;
  final String? note;

  const MoodEntry({
    required this.id,
    required this.timestamp,
    required this.moodType,
    this.note,
  });

  // Equatable-like behavior for value comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MoodEntry &&
      other.id == id &&
      other.timestamp == timestamp &&
      other.moodType == moodType &&
      other.note == note;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      timestamp.hashCode ^
      moodType.hashCode ^
      note.hashCode;
  }
}
