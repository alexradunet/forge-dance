import 'package:freezed_annotation/freezed_annotation.dart';

import '../../model/auth_session.dart';

part 'authentication_state.freezed.dart';
part 'authentication_state.g.dart';

@freezed
abstract class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState({
    AuthSession? authSession,
    @Default(false) bool isRegisterSuccessfully,
    @Default(false) bool isSignInSuccessfully,
  }) = _AuthenticationState;

  factory AuthenticationState.fromJson(Map<String, Object?> json) =>
      _$AuthenticationStateFromJson(json);
}
