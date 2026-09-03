import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import '../../../features/profile/model/profile.dart';

part 'profile_repository.g.dart';

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) => const ProfileRepository();

/// Local-only profile storage.
///
/// This is the app's profile persistence seam. Today it stores the current
/// device profile in SharedPreferences; a future sync/export adapter can reuse
/// this repository's JSON shape without leaking cloud details into widgets.
class ProfileRepository {
  const ProfileRepository();

  Future<Profile?> get() async {
    final prefs = await SharedPreferences.getInstance();
    final profileStr = prefs.getString(Constants.profileKey);
    if (profileStr == null) return null;

    return Profile.fromJson(jsonDecode(profileStr) as Map<String, Object?>);
  }

  Future<void> update(Profile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final localProfile = profile.copyWith(id: profile.id ?? Constants.localUserId);
    await prefs.setString(Constants.profileKey, jsonEncode(localProfile.toJson()));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(Constants.profileKey);
  }
}
