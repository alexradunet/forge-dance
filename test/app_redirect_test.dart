import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/features/profile/model/profile.dart';
import 'package:forge_dance/features/profile/ui/state/profile_state.dart';
import 'package:forge_dance/routing/app_redirect.dart';
import 'package:forge_dance/routing/routes.dart';

AsyncValue<ProfileState> resolved({Profile? profile}) {
  return AsyncData(ProfileState(profile: profile));
}

String? redirect(String location, AsyncValue<ProfileState> profileState) {
  return computeRedirect(matchedLocation: location, profileState: profileState);
}

void main() {
  group('computeRedirect — local profile resolving', () {
    const loading = AsyncValue<ProfileState>.loading();

    test('holds splash while loading', () {
      expect(redirect(Routes.splash, loading), isNull);
    });

    test('parks guarded routes on splash while loading', () {
      expect(redirect(Routes.main, loading), Routes.splash);
      expect(redirect(Routes.settings, loading), Routes.splash);
    });
  });

  group('computeRedirect — offline setup', () {
    test('sends fresh devices to onboarding', () {
      final fresh = resolved();
      expect(redirect(Routes.splash, fresh), Routes.onboarding);
      expect(redirect(Routes.main, fresh), Routes.onboarding);
      expect(redirect(Routes.onboarding, fresh), isNull);
    });

    test('opens the app when local profile setup is complete', () {
      final ready = resolved(profile: const Profile(name: 'Offline Dancer'));
      expect(redirect(Routes.splash, ready), Routes.main);
      expect(redirect(Routes.onboarding, ready), Routes.main);
      expect(redirect(Routes.home, ready), isNull);
      expect(redirect(Routes.settings, ready), isNull);
    });
  });
}
