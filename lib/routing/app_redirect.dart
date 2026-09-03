import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/profile/ui/state/profile_state.dart';
import 'routes.dart';

const Set<String> _setupLocations = {
  Routes.splash,
  Routes.onboarding,
};

/// Centralized offline navigation guard.
///
/// There is no registration or login flow. First launch goes to local profile
/// setup, and after a dancer has a name the app opens directly to the main
/// shell. Profile/settings pages remain available offline.
String? computeRedirect({
  required String matchedLocation,
  required AsyncValue<ProfileState> profileState,
}) {
  final state = profileState.value;

  if (state == null) {
    if (profileState.isLoading) {
      return matchedLocation == Routes.splash ? null : Routes.splash;
    }
    return _setupLocations.contains(matchedLocation) ? null : Routes.onboarding;
  }

  final hasCompletedLocalSetup =
      state.profile?.name?.trim().isNotEmpty ?? false;

  if (hasCompletedLocalSetup) {
    return _setupLocations.contains(matchedLocation) ? Routes.main : null;
  }

  return matchedLocation == Routes.onboarding ? null : Routes.onboarding;
}
