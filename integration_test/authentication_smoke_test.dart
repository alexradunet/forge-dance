import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/features/firebase/repository/firebase_bootstrap.dart';
import 'package:forge_dance/features/authentication/ui/sign_in_screen.dart';
import 'package:forge_dance/features/home/presentation/pages/home_page.dart';
import 'package:forge_dance/features/profile/presentation/pages/profile_page.dart';
import 'package:forge_dance/features/settings/presentation/pages/settings_page.dart';
import 'package:integration_test/integration_test.dart';

import 'package:forge_dance/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('a returning dancer signs in with their persisted profile', (
    tester,
  ) async {
    expect(
      useFirebaseEmulator,
      isTrue,
      reason: 'Integration tests must never use production Firebase.',
    );
    app.main();

    const emailField = ValueKey('registration.email');
    const passwordField = ValueKey('registration.password');
    const registerButton = ValueKey('registration.submit');
    const nameField = ValueKey('onboarding.name');
    const continueButton = ValueKey('onboarding.continue');
    const signInEmailField = ValueKey('sign-in.email');
    const signInPasswordField = ValueKey('sign-in.password');
    const signInButton = ValueKey('sign-in.submit');

    await _pumpUntilVisible(tester, find.byKey(emailField));
    _expectNoFlutterExceptions(tester, stage: 'opening registration');

    await tester.enterText(
      find.descendant(
        of: find.byKey(emailField),
        matching: find.byType(EditableText),
      ),
      'integration.dancer@example.com',
    );
    await tester.enterText(
      find.descendant(
        of: find.byKey(passwordField),
        matching: find.byType(EditableText),
      ),
      'forge-dance-test-password',
    );
    await tester.pump();
    await tester.tap(find.byKey(registerButton));

    await _pumpUntilVisible(tester, find.byKey(nameField));
    _expectNoFlutterExceptions(tester, stage: 'registering the dancer');
    await tester.enterText(
      find.descendant(
        of: find.byKey(nameField),
        matching: find.byType(EditableText),
      ),
      'Forge Tester',
    );
    await tester.pump();
    await tester.tap(find.byKey(continueButton));

    await _pumpUntilVisible(tester, find.byType(HomePage));
    await _pumpUntilVisible(tester, find.text('FORGE_TESTER'));
    _expectNoFlutterExceptions(tester, stage: 'opening Home');

    await tester.tap(find.text('Profile'));
    await _pumpUntilVisible(tester, find.byType(ProfilePage));
    await tester.tap(find.byIcon(Icons.settings_rounded));
    await _pumpUntilVisible(tester, find.byType(SettingsPage));
    await tester.ensureVisible(find.text('Log out').first);
    await tester.tap(find.text('Log out').first);
    await _pumpUntilVisible(tester, find.byType(AlertDialog));
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Log out'),
      ),
    );

    await _pumpUntilVisible(tester, find.byType(SignInScreen));
    _expectNoFlutterExceptions(tester, stage: 'signing out');

    expect(find.byKey(signInEmailField), findsOneWidget);
    expect(find.byKey(signInPasswordField), findsOneWidget);
    expect(find.byKey(signInButton), findsOneWidget);
    await tester.enterText(
      find.descendant(
        of: find.byKey(signInEmailField),
        matching: find.byType(EditableText),
      ),
      'integration.dancer@example.com',
    );
    await tester.enterText(
      find.descendant(
        of: find.byKey(signInPasswordField),
        matching: find.byType(EditableText),
      ),
      'forge-dance-test-password',
    );
    await tester.pump();
    await tester.tap(find.byKey(signInButton));

    await _pumpUntilVisible(tester, find.byType(HomePage));
    await _pumpUntilVisible(tester, find.text('FORGE_TESTER'));
    _expectNoFlutterExceptions(tester, stage: 'returning to Home');
  });
}

void _expectNoFlutterExceptions(WidgetTester tester, {required String stage}) {
  final exceptions = <Object>[];
  Object? exception;
  while ((exception = tester.takeException()) != null) {
    exceptions.add(exception!);
  }

  expect(exceptions, isEmpty, reason: stage);
}

Future<void> _pumpUntilVisible(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (finder.evaluate().isEmpty && DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 100));
  }

  final visibleText = find
      .byType(Text)
      .evaluate()
      .map((element) => (element.widget as Text).data)
      .whereType<String>()
      .toList();
  expect(
    finder,
    findsOneWidget,
    reason: 'Visible text at timeout: $visibleText',
  );
}
