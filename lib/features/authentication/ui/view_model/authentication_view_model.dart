import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../constants/constants.dart';
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
    final currentSession = await _repository.currentSession();
    final isLoggedIn = currentSession != null ||
        (!_repository.isFirebaseConfigured && await _repository.isLogin());
    return AuthenticationState(
      authSession: currentSession,
      isLoggedIn: isLoggedIn,
      hasExistingAccount: await _repository.isExistAccount(),
      isFirebaseConfigured: _repository.isFirebaseConfigured,
    );
  }

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(
      () => _repository.registerWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
    await _handleResult(result, isRegister: true);
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(
      () => _repository.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
    await _handleResult(result, isRegister: false);
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(_repository.signOut);

    if (result is AsyncError) {
      final stackTrace = result.stackTrace;
      state = AsyncError(result.error, stackTrace);
      Error.throwWithStackTrace(result.error, stackTrace);
    }

    state = const AsyncData(AuthenticationState());
  }

  Future<void> _handleResult(
    AsyncValue<AuthSession> result, {
    required bool isRegister,
  }) async {
    debugPrint(
      '${Constants.tag} [AuthenticationViewModel._handleResult] result: $result',
    );

    if (result is AsyncError) {
      state = AsyncError(result.error.toString(), StackTrace.current);
      return;
    }

    final authSession = result.value;
    if (authSession == null) {
      state = AsyncError(
        LocaleKeys.unexpectedErrorOccurred.tr(),
        StackTrace.current,
      );
      return;
    }

    await _repository.setIsLogin(true);

    state = AsyncData(
      AuthenticationState(
        authSession: authSession,
        isLoggedIn: true,
        hasExistingAccount: true,
        isFirebaseConfigured: _repository.isFirebaseConfigured,
        isRegisterSuccessfully: isRegister,
        isSignInSuccessfully: true,
      ),
    );
  }
}
