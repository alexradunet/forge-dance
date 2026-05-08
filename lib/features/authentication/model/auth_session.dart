import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_session.freezed.dart';
part 'auth_session.g.dart';

@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    required AuthUser user,
  }) = _AuthSession;

  factory AuthSession.fromJson(Map<String, Object?> json) =>
      _$AuthSessionFromJson(json);
}

@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    String? email,
    Map<String, dynamic>? metadata,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, Object?> json) =>
      _$AuthUserFromJson(json);
}
