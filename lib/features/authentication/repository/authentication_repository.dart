import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/constants/constants.dart';
import '/generated/locale_keys.g.dart';
import '../model/auth_session.dart';

part 'authentication_repository.g.dart';

@riverpod
AuthenticationRepository authenticationRepository(Ref ref) {
  return AuthenticationRepository();
}

class AuthenticationRepository {
  const AuthenticationRepository();

  Future<void> signInWithMagicLink(String email) async {
    // Local-only placeholder. Replace behind this repository when auth is chosen.
    if (email.trim().isEmpty) {
      throw Exception(LocaleKeys.unexpectedErrorOccurred.tr());
    }
  }

  Future<AuthSession> verifyOtp({
    required String email,
    required String token,
    required bool isRegister,
  }) async {
    // Local-only placeholder. Do not add backend-specific code here.
    if (token.trim().isEmpty) {
      throw Exception(LocaleKeys.unexpectedErrorOccurred.tr());
    }
    return _localSession(email: email);
  }

  Future<void> signOut() async {
    await setIsLogin(false);
  }

  Future<bool> isLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(Constants.isLoginKey) ?? false;
  }

  Future<void> setIsLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Constants.isLoginKey, value);
  }

  Future<bool> isExistAccount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(Constants.isExistAccountKey) ?? false;
  }

  Future<void> setIsExistAccount(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Constants.isExistAccountKey, value);
  }

  AuthSession _localSession({required String email}) {
    return AuthSession(
      user: AuthUser(
        id: email.trim().toLowerCase(),
        email: email,
      ),
    );
  }
}
