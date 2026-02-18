import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/i_auth_repository.dart';
import 'di_providers.dart';

class UserNotifier extends StateNotifier<AsyncValue<UserProfile>> {
  final IAuthRepository _authRepository;

  UserNotifier(this._authRepository) : super(const AsyncValue.loading()) {
    _signIn();
  }

  Future<void> _signIn() async {
    try {
      await _authRepository.signInAnonymously();
      final user = await _authRepository.getUserProfile();
      if (user != null) {
        state = AsyncValue.data(user);
      } else {
        state = AsyncValue.error('User profile not found', StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void upgradeToPremium() {
    state.whenData((user) {
      state = AsyncValue.data(
        user.copyWith(isPremium: true),
      );
    });
  }
}

final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<UserProfile>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return UserNotifier(authRepository);
});
