import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/features/authentication/model/auth_session.dart';
import 'package:forge_dance/features/authentication/repository/authentication_repository.dart';
import 'package:forge_dance/features/authentication/ui/view_model/authentication_view_model.dart';

class FakeAuthenticationRepository extends AuthenticationRepository {
  FakeAuthenticationRepository({
    required this.authStream,
    this.configured = true,
    this.hasAccount = false,
  }) : super(auth: null, firestore: null);

  final Stream<AuthUser?> authStream;
  final bool configured;
  final bool hasAccount;
  final StreamController<AuthUser?> signOutEvents =
      StreamController<AuthUser?>.broadcast();
  bool signOutCalled = false;

  @override
  bool get isFirebaseConfigured => configured;

  @override
  Stream<AuthUser?> authStateChanges() => authStream;

  @override
  Future<bool> isExistAccount() async => hasAccount;

  @override
  Future<void> signOut() async {
    signOutCalled = true;
  }
}

const dancer = AuthUser(id: 'dancer-1', email: 'dancer@example.com');

ProviderContainer containerWith(FakeAuthenticationRepository repository) {
  final container = ProviderContainer(
    overrides: [
      authenticationRepositoryProvider.overrideWithValue(repository),
    ],
  );
  addTearDown(container.dispose);
  // Mirror production: the router keeps a permanent listener on the view
  // model, so it never auto-disposes between reads.
  container.listen(authenticationViewModelProvider, (_, __) {});
  return container;
}

void main() {
  group('AuthenticationViewModel', () {
    test('derives signed-in state from the auth stream', () async {
      final repository = FakeAuthenticationRepository(
        authStream: Stream.value(dancer),
        hasAccount: true,
      );
      final container = containerWith(repository);

      final state =
          await container.read(authenticationViewModelProvider.future);

      expect(state.isLoggedIn, isTrue);
      expect(state.authSession, const AuthSession(user: dancer));
      expect(state.hasExistingAccount, isTrue);
      expect(state.isFirebaseConfigured, isTrue);
    });

    test('derives signed-out state when the stream emits null', () async {
      final repository = FakeAuthenticationRepository(
        authStream: Stream.value(null),
      );
      final container = containerWith(repository);

      final state =
          await container.read(authenticationViewModelProvider.future);

      expect(state.isLoggedIn, isFalse);
      expect(state.authSession, isNull);
    });

    test('rebuilds to signed-out when the stream signs the user out',
        () async {
      final controller = StreamController<AuthUser?>();
      final repository = FakeAuthenticationRepository(
        authStream: controller.stream,
        hasAccount: true,
      );
      addTearDown(controller.close);
      final container = containerWith(repository);

      controller.add(dancer);
      final signedIn =
          await container.read(authenticationViewModelProvider.future);
      expect(signedIn.isLoggedIn, isTrue);

      controller.add(null);
      await _pumpUntil(
        () =>
            container
                .read(authenticationViewModelProvider)
                .valueOrNull
                ?.isLoggedIn ==
            false,
      );

      expect(
        container.read(authenticationViewModelProvider).value?.isLoggedIn,
        isFalse,
      );
    });

    test('signOut delegates to the repository', () async {
      final repository = FakeAuthenticationRepository(
        authStream: Stream.value(dancer),
        hasAccount: true,
      );
      final container = containerWith(repository);
      await container.read(authenticationViewModelProvider.future);

      await container
          .read(authenticationViewModelProvider.notifier)
          .signOut();

      expect(repository.signOutCalled, isTrue);
    });
  });

  group('AuthenticationRepository (unconfigured Firebase)', () {
    test('auth stream emits null immediately', () async {
      const repository = AuthenticationRepository(auth: null, firestore: null);

      expect(repository.isFirebaseConfigured, isFalse);
      expect(await repository.authStateChanges().first, isNull);
    });
  });
}

Future<void> _pumpUntil(bool Function() condition) async {
  for (var i = 0; i < 100 && !condition(); i++) {
    await Future<void>.delayed(Duration.zero);
  }
}
