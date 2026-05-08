import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../authentication/model/auth_session.dart';
import '../../authentication/ui/view_model/authentication_view_model.dart';
import '../../profile/ui/view_model/profile_view_model.dart';

part 'session_coordinator.g.dart';

@Riverpod(keepAlive: true)
SessionCoordinator sessionCoordinator(Ref ref) => SessionCoordinator(ref);

class SessionCoordinator {
  const SessionCoordinator(this._ref);

  final Ref _ref;

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _ref
        .read(authenticationViewModelProvider.notifier)
        .registerWithEmailAndPassword(
          email: email,
          password: password,
        );
    await _syncCurrentAuthProfile();
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _ref
        .read(authenticationViewModelProvider.notifier)
        .signInWithEmailAndPassword(
          email: email,
          password: password,
        );
    await _syncCurrentAuthProfile();
  }

  Future<void> signOut() async {
    await _ref.read(authenticationViewModelProvider.notifier).signOut();
    _ref.read(profileViewModelProvider.notifier).clearProfile();
  }

  Future<void> syncProfileFromAuthUser(AuthUser user) async {
    final metaData = user.metadata;
    await _ref.read(profileViewModelProvider.notifier).updateProfile(
          id: user.id,
          email: user.email,
          name: metaData?['full_name'] as String?,
          avatar: metaData?['avatar_url'] as String?,
        );
  }

  Future<void> _syncCurrentAuthProfile() async {
    final authState = _ref.read(authenticationViewModelProvider).valueOrNull;
    final user = authState?.authSession?.user;
    if (user == null) return;

    await syncProfileFromAuthUser(user);
  }
}
