import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/features/authentication/ui/state/authentication_state.dart';
import 'package:forge_dance/routing/app_redirect.dart';
import 'package:forge_dance/routing/routes.dart';

void main() {
  AsyncValue<AuthenticationState> resolved({
    bool isLoggedIn = false,
    bool hasExistingAccount = false,
    bool isFirebaseConfigured = true,
  }) {
    return AsyncData(
      AuthenticationState(
        isLoggedIn: isLoggedIn,
        hasExistingAccount: hasExistingAccount,
        isFirebaseConfigured: isFirebaseConfigured,
      ),
    );
  }

  String? redirect(String location, AsyncValue<AuthenticationState> auth) {
    return computeRedirect(matchedLocation: location, auth: auth);
  }

  group('computeRedirect — auth resolving', () {
    const loading = AsyncLoading<AuthenticationState>();

    test('holds splash while loading', () {
      expect(redirect(Routes.splash, loading), isNull);
    });

    test('parks guarded routes on splash while loading', () {
      expect(redirect(Routes.main, loading), Routes.splash);
      expect(redirect(Routes.settings, loading), Routes.splash);
    });

    test('fails towards login on auth error', () {
      final error = AsyncError<AuthenticationState>(
        Exception('prefs unavailable'),
        StackTrace.current,
      );
      expect(redirect(Routes.main, error), Routes.login);
      expect(redirect(Routes.login, error), isNull);
    });
  });

  group('computeRedirect — Firebase not configured (local dev mode)', () {
    final guest = resolved(isFirebaseConfigured: false);

    test('skips the auth flow entirely', () {
      expect(redirect(Routes.splash, guest), Routes.main);
      expect(redirect(Routes.login, guest), Routes.main);
      expect(redirect(Routes.register, guest), Routes.main);
    });

    test('allows the rest of the app', () {
      expect(redirect(Routes.main, guest), isNull);
      expect(redirect(Routes.settings, guest), isNull);
    });
  });

  group('computeRedirect — signed in', () {
    final signedIn = resolved(isLoggedIn: true, hasExistingAccount: true);

    test('leaves splash and login for main', () {
      expect(redirect(Routes.splash, signedIn), Routes.main);
      expect(redirect(Routes.login, signedIn), Routes.main);
    });

    test('register hands off to onboarding (post-registration flow)', () {
      expect(redirect(Routes.register, signedIn), Routes.onboarding);
    });

    test('allows guarded routes', () {
      expect(redirect(Routes.main, signedIn), isNull);
      expect(redirect(Routes.onboarding, signedIn), isNull);
      expect(redirect(Routes.settings, signedIn), isNull);
    });
  });

  group('computeRedirect — signed out', () {
    test('guarded routes go to login when an account exists', () {
      final auth = resolved(hasExistingAccount: true);
      expect(redirect(Routes.main, auth), Routes.login);
      expect(redirect(Routes.splash, auth), Routes.login);
      expect(redirect(Routes.settings, auth), Routes.login);
    });

    test('guarded routes go to register on a fresh device', () {
      final auth = resolved(hasExistingAccount: false);
      expect(redirect(Routes.main, auth), Routes.register);
      expect(redirect(Routes.splash, auth), Routes.register);
    });

    test('login and register are freely reachable', () {
      final auth = resolved(hasExistingAccount: true);
      expect(redirect(Routes.login, auth), isNull);
      expect(redirect(Routes.register, auth), isNull);
    });
  });
}
