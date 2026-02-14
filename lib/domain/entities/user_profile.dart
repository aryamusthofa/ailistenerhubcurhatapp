import 'ai_vibe.dart';

class UserProfile {
  final String id;
  final bool isAnonymous;
  final String preferredTheme; // 'light', 'dark', 'calming'
  final int coinBalance; // For gamification later
  final bool isPremium;
  final AiVibe preferredVibe;

  const UserProfile({
    required this.id,
    this.isAnonymous = true,
    this.preferredTheme = 'light',
    this.coinBalance = 0,
    this.isPremium = false,
    this.preferredVibe = AiVibe.empathetic,
  });

  // CopyWith for immutability updates
  UserProfile copyWith({
    String? id,
    bool? isAnonymous,
    String? preferredTheme,
    int? coinBalance,
    bool? isPremium,
    AiVibe? preferredVibe,
  }) {
    return UserProfile(
      id: id ?? this.id,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      preferredTheme: preferredTheme ?? this.preferredTheme,
      coinBalance: coinBalance ?? this.coinBalance,
      isPremium: isPremium ?? this.isPremium,
      preferredVibe: preferredVibe ?? this.preferredVibe,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          isAnonymous == other.isAnonymous &&
          preferredTheme == other.preferredTheme &&
          coinBalance == other.coinBalance &&
          isPremium == other.isPremium &&
          preferredVibe == other.preferredVibe;

  @override
  int get hashCode =>
      id.hashCode ^
      isAnonymous.hashCode ^
      preferredTheme.hashCode ^
      coinBalance.hashCode ^
      isPremium.hashCode ^
      preferredVibe.hashCode;
}
