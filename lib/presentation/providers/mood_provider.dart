import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_curhat_app/presentation/widgets/mood_selector.dart'; // Import VibeMode enum

class MoodNotifier extends StateNotifier<VibeMode> {
  MoodNotifier() : super(VibeMode.empathetic);

  void setMood(VibeMode mood) {
    state = mood;
  }
}

final moodProvider = StateNotifierProvider<MoodNotifier, VibeMode>((ref) {
  return MoodNotifier();
});
