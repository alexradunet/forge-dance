import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import '../../../features/profile/model/profile.dart';

part 'profile_repository.g.dart';

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) {
  return const ProfileRepository();
}

class ProfileRepository {
  const ProfileRepository();

  Future<Profile?> get() async {
    final prefs = await SharedPreferences.getInstance();
    final profileStr = prefs.getString(Constants.profileKey);
    if (profileStr == null) return null;

    return Profile.fromJson(jsonDecode(profileStr));
  }

  Future<void> update(Profile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.profileKey, jsonEncode(profile.toJson()));
  }
}
