import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../constants/constants.dart';
import '../../../../features/profile/ui/view_model/profile_view_model.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../model/auth_session.dart';
import '../../repository/authentication_repository.dart';
import '../../ui/state/authentication_state.dart';

part 'authentication_view_model.g.dart';

@riverpod
class AuthenticationViewModel extends _$AuthenticationViewModel {
  late AuthenticationRepository _repository;

  @override
  FutureOr<AuthenticationState> build() async {
    _repository = ref.read(authenticationRepositoryProvider);
    return const AuthenticationState();
  }

  Future<void> signInWithMagicLink(String email) async {
    state = const AsyncValue.loading();
    final result =
        await AsyncValue.guard(() => _repository.signInWithMagicLink(email));

    if (result is AsyncError) {
      state = AsyncError(result.error.toString(), StackTrace.current);
      return;
    }

    state = const AsyncData(AuthenticationState());
  }

  Future<void> verifyOtp({
    required String email,
    required String token,
    required bool isRegister,
  }) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(
      () => _repository.verifyOtp(
        email: email,
        token: token,
        isRegister: isRegister,
      ),
    );
    handleResult(result);
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(_repository.signOut);

    if (result is AsyncError) {
      state = AsyncError(result.error.toString(), StackTrace.current);
      return;
    }

    state = const AsyncData(AuthenticationState());
  }

  void handleResult(AsyncValue<AuthSession> result) async {
    debugPrint(
        '${Constants.tag} [AuthenticationViewModel.handleResult] result: $result');
    if (result is AsyncError) {
      state = AsyncError(result.error.toString(), StackTrace.current);
      return;
    }

    final authSession = result.value;
    debugPrint(
        '${Constants.tag} [AuthenticationViewModel.handleResult] user: ${authSession?.user.toJson()}');
    if (authSession == null) {
      state = AsyncError(LocaleKeys.unexpectedErrorOccurred.tr(), StackTrace.current);
      return;
    }

    final isExistAccount = await _repository.isExistAccount();
    if (!isExistAccount) {
      await _repository.setIsExistAccount(true);
    }
    updateProfile(authSession.user);
    await _repository.setIsLogin(true);

    state = AsyncData(
      AuthenticationState(
        authSession: authSession,
        isRegisterSuccessfully: !isExistAccount,
        isSignInSuccessfully: true,
      ),
    );
  }

  Future<void> updateProfile(AuthUser user) async {
    final metaData = user.metadata;
    ref.read(profileViewModelProvider.notifier).updateProfile(
      email: user.email,
      name: metaData?['full_name'] as String?,
      avatar: metaData?['avatar_url'] as String?,
    );
  }
}
