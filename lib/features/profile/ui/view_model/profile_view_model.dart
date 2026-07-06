import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../constants/constants.dart';
import '../../../../extensions/build_context_extension.dart';
import '../../../../extensions/string_extension.dart';
import '../../model/profile.dart';
import '../../repository/profile_repository.dart';
import '../../ui/state/profile_state.dart';

part 'profile_view_model.g.dart';

@Riverpod(keepAlive: true)
class ProfileViewModel extends _$ProfileViewModel {
  late ProfileRepository _repository;

  @override
  FutureOr<ProfileState> build() async {
    _repository = ref.read(profileRepositoryProvider);
    final profile = await _repository.get();
    return ProfileState(profile: profile);
  }

  Future<void> updateProfile({
    String? id,
    String? email,
    String? name,
    String? avatar,
    int? diamond,
    int? xp,
    int? streakCount,
    String? lastActivityDate,
  }) async {
    final previousProfile = state.value?.profile;
    state = const AsyncValue.loading();
    try {
      final currentProfile = previousProfile ?? await _repository.get();
      final newAvatarPath = await saveImage(avatar);

      final updatedProfile = currentProfile?.copyWith(
            id: id ?? currentProfile.id,
            email: email ?? currentProfile.email,
            name: name ?? currentProfile.name,
            avatar: newAvatarPath ?? currentProfile.avatar,
            diamond: diamond ?? currentProfile.diamond,
            xp: xp ?? currentProfile.xp,
            streakCount: streakCount ?? currentProfile.streakCount,
            lastActivityDate:
                lastActivityDate ?? currentProfile.lastActivityDate,
          ) ??
          Profile(
            id: id,
            email: email,
            name: name,
            avatar: newAvatarPath,
            diamond: diamond,
            xp: xp,
            streakCount: streakCount,
            lastActivityDate: lastActivityDate,
          );
      debugPrint(
          '${Constants.tag} [ProfileViewModel.updateProfile] $updatedProfile');

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

  void clearProfile() {
    state = AsyncData(ProfileState(profile: null));
  }

  Future<String?> selectImage(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      return image?.path;
    } catch (error) {
      if (context.mounted) {
        context.showErrorSnackBar(error.toString());
      }
      return null;
    }
  }

  Future<String?> saveImage(String? image) async {
    if (image == null || image.isUrl) return image;
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final extension = path.extension(image);
      final File newFile = File('${directory.path}/$fileName$extension');

      final File originalFile = File(image);
      await originalFile.copy(newFile.path);

      return newFile.path;
    } catch (error) {
      return null;
    }
  }
}
