import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalizationState {
  final String aboutMe;
  final String instruction;

  const PersonalizationState({
    this.aboutMe = '',
    this.instruction = '',
  });

  PersonalizationState copyWith({String? aboutMe, String? instruction}) {
    return PersonalizationState(
      aboutMe: aboutMe ?? this.aboutMe,
      instruction: instruction ?? this.instruction,
    );
  }
}

class PersonalizationNotifier extends StateNotifier<PersonalizationState> {
  static const _keyAboutMe = 'user_about_me';
  static const _keyInstruction = 'user_instruction';
  
  PersonalizationNotifier() : super(const PersonalizationState()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = PersonalizationState(
      aboutMe: prefs.getString(_keyAboutMe) ?? '',
      instruction: prefs.getString(_keyInstruction) ?? '',
    );
  }

  Future<void> updateAboutMe(String value) async {
    state = state.copyWith(aboutMe: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAboutMe, value);
  }

  Future<void> updateInstruction(String value) async {
    state = state.copyWith(instruction: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyInstruction, value);
  }
}

final personalizationProvider = 
    StateNotifierProvider<PersonalizationNotifier, PersonalizationState>((ref) {
  return PersonalizationNotifier();
});
