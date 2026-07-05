import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/authentication/ui/state/authentication_state.dart';
import 'routes.dart';

/// Routes that belong to the pre-auth flow.
const Set<String> _authLocations = {
  Routes.splash,
  Routes.login,
  Routes.register,
};

/// Centralized navigation guard — the ONLY place that decides where a user
/// may be based on auth state. Pure function so it is trivially unit-tested.
///
/// Rules, in order:
/// 1. Firebase not configured (e.g. Linux desktop) → local dev mode: skip
///    auth entirely and land on main.
/// 2. Auth state still resolving → hold pre-auth screens, park everything
///    else on splash until resolved.
/// 3. Signed in → keep out of splash/login (→ main); register redirects to
///    onboarding (post-registration flow).
/// 4. Signed out → login/register are allowed; everything else goes to
///    login (or register when no account ever existed on this device).
String? computeRedirect({
  required String matchedLocation,
  required AsyncValue<AuthenticationState> auth,
}) {
  final state = auth.valueOrNull;

  if (state == null) {
    if (auth.isLoading) {
      return matchedLocation == Routes.splash ? null : Routes.splash;
    }
    // Auth state errored (rare: prefs failure). Fail towards login.
    return _authLocations.contains(matchedLocation) ? null : Routes.login;
  }

  if (!state.isFirebaseConfigured) {
    return _authLocations.contains(matchedLocation) ? Routes.main : null;
  }

  if (state.isLoggedIn) {
    if (matchedLocation == Routes.register) return Routes.onboarding;
    if (matchedLocation == Routes.splash || matchedLocation == Routes.login) {
      return Routes.main;
    }
    return null;
  }

  // Signed out.
  if (matchedLocation == Routes.login || matchedLocation == Routes.register) {
    return null;
  }
  return state.hasExistingAccount ? Routes.login : Routes.register;
}
