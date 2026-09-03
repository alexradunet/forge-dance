import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../constants/constants.dart';
import '../../model/profile.dart';
import '../../repository/profile_repository.dart';
import '../../ui/state/profile_state.dart';

part 'profile_view_model.g.dart';

@Riverpod(keepAlive: true)
class ProfileViewModel extends _$ProfileViewModel {
  late ProfileRepository _repository;
  Future<void> _updateTail = Future<void>.value();

  @override
  FutureOr<ProfileState> build() async {
    _repository = ref.read(profileRepositoryProvider);
    final profile = await _repository.get();
    return ProfileState(profile: profile);
  }

  Future<void> editProfile({String? name, String? job}) => _enqueueUpdate(
    (profile) =>
        profile.copyWith(name: name ?? profile.name, job: job ?? profile.job),
  );

  Future<void> syncLocalIdentity({
    String? id,
    String? email,
    String? name,
    String? avatar,
  }) => _enqueueUpdate(
    (profile) => profile.copyWith(
      id: id ?? profile.id,
      email: email ?? profile.email,
      name: profile.name ?? name,
      avatar: avatar ?? profile.avatar,
    ),
  );

  Future<void> _enqueueUpdate(Profile Function(Profile profile) change) {
    final update = _updateTail.then((_) => _update(change));
    _updateTail = update;
    return update;
  }

  Future<void> _update(Profile Function(Profile profile) change) async {
    final previousProfile = state.value?.profile;
    state = const AsyncValue.loading();
    try {
      final currentProfile =
          previousProfile ?? await _repository.get() ?? const Profile();
      final updatedProfile = change(currentProfile);
      debugPrint('${Constants.tag} [ProfileViewModel._update] $updatedProfile');

      await _repository.update(updatedProfile);
      state = AsyncData(ProfileState(profile: updatedProfile));
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> refreshProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _repository.get();
      state = AsyncData(ProfileState(profile: profile));
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> clearProfile() async {
    await _repository.clear();
    state = const AsyncData(ProfileState(profile: null));
  }
}
