part of 'feature_surface_contract_test.dart';

// Kept in the central inventory above; these are real destinations, not mocks.
final _personalImmersiveScreens = <String, Widget Function()>{
  'Local profile': () => const ProfilePage(),
  'Settings destinations': () => const SettingsPage(),
  'Account information': () => const AccountInfoScreen(
    originalProfile: Profile(name: 'Alex', email: 'local@example.test'),
  ),
  'Local onboarding': () => const OnboardingScreen(),
  'Profile readiness': () => const SplashScreen(),
};

class _PersonalProfileRepository extends ProfileRepository {
  _PersonalProfileRepository({this.fail = false});
  bool fail;
  bool failRead = false;
  Completer<void>? hold;
  int writes = 0;
  Profile profile = const Profile(name: 'Alex');

  @override
  Future<Profile?> get() async {
    if (failRead) throw StateError('Profile unavailable');
    return profile;
  }

  @override
  Future<void> update(Profile value) async {
    writes++;
    await hold?.future;
    if (fail) throw StateError('Storage unavailable');
    profile = value;
  }
}

class _PersonalBackupRepository implements PortableBackupRepository {
  int restores = 0;
  bool fail = false;
  Completer<void>? hold;

  @override
  Future<String> exportJson() async => '{}';
  @override
  Future<void> saveBackup({required Rect shareOrigin}) async {}
  @override
  Future<Map<String, Object?>?> pickBackup() async => {'test': true};
  @override
  Future<void> restore(Map<String, Object?> input) async {
    restores++;
    await hold?.future;
    if (fail) throw StateError('Restore failed');
  }
}

void _expectAppearanceContrast(WidgetTester tester) {
  for (final label in [
    LocaleKeys.auto.tr(),
    LocaleKeys.lightMode.tr(),
    LocaleKeys.darkMode.tr(),
  ]) {
    final text = find.descendant(
      of: find.text(label),
      matching: find.byType(RichText),
    );
    if (text.evaluate().isEmpty) continue;
    final rendered = tester.widget<RichText>(text);
    final context = tester.element(text);
    final scheme = Theme.of(context).colorScheme;
    expect(
      _contrast(rendered.text.style!.color!, scheme.surface),
      greaterThanOrEqualTo(4.5),
    );
  }
}

void _personalSurfaceContracts() {
  for (final width in [320.0, 1040.0]) {
    testWidgets(
      'Profile readiness never substitutes fabricated metrics at $width',
      (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final pending = Completer<UserStats>();
        const page = ProfilePage();
        await _pumpFeature(
          tester,
          page,
          textScale: 2,
          statsResult: pending.future,
        );
        expect(find.byType(FgSpinner), findsOneWidget);
        expect(find.byType(FgProgressSection), findsNothing);
        _expectDarkScreen(tester, page);
        await tester.runAsync(() async {
          pending.complete(const UserStats());
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pumpAndSettle();
        expect(find.byType(FgProgressSection), findsOneWidget);
      },
    );

    testWidgets('Profile failure retains honest status and reloads at $width', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(Size(width, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final repository = _PersonalProfileRepository();
      const page = ProfilePage();
      await _pumpFeature(
        tester,
        page,
        textScale: 2,
        profileRepository: repository,
      );
      final container = ProviderScope.containerOf(
        tester.element(find.byType(ProfilePage)),
      );
      repository.failRead = true;
      await tester.runAsync(() async {
        container.invalidate(profileViewModelProvider);
        try {
          await container.read(profileViewModelProvider.future);
        } catch (_) {}
        await Future<void>.delayed(Duration.zero);
      });
      await tester.pumpAndSettle();
      expect(
        find.text(LocaleKeys.unexpectedErrorOccurred.tr()),
        findsOneWidget,
      );
      expect(find.byType(FgProgressSection), findsNothing);
      _expectDarkScreen(tester, page);
      repository.failRead = false;
      await tester.runAsync(() async {
        await tester.tap(find.text(LocaleKeys.practiceRetry.tr()));
        await Future.wait([
          container.read(profileViewModelProvider.future),
          container.read(methodViewModelProvider.future),
          container.read(userStatsProvider.future),
        ]);
      });
      await tester.pumpAndSettle();
      expect(find.byType(FgProgressSection), findsOneWidget);
      _expectDarkScreen(tester, page);
    });
  }

  for (final width in [320.0, 1040.0]) {
    for (final entry in {
      ..._personalImmersiveScreens,
      'Backup reading surface': () => const DataTransferPage(),
      'Belt requirements': () => const LevelProgressionPage(),
    }.entries) {
      testWidgets('${entry.key} reflows at $width with doubled text', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final page = entry.value();
        await _pumpFeature(tester, page, textScale: 2);
        _expectDarkScreen(tester, page);
        if (page is DataTransferPage || page is LevelProgressionPage) {
          final label = page is DataTransferPage
              ? LocaleKeys.detailsBackup.tr()
              : LocaleKeys.detailsAboutMethod.tr();
          await _show(tester, find.text(label));
          await tester.tap(find.text(label));
          await tester.pumpAndSettle();
          final fullCopy = page is DataTransferPage
              ? LocaleKeys.forgeTransferDescription.tr()
              : LocaleKeys.forgeCriteriaProvisional.tr();
          await _show(tester, find.text(fullCopy));
          expect(find.text(fullCopy), findsOneWidget);
        } else if (page is OnboardingScreen || page is AccountInfoScreen) {
          final input = find.byType(TextField);
          await _show(tester, input);
          await tester.enterText(input, 'Dancer with a long local name');
          // A phone keyboard must not strand the primary action below a fixed Column.
          tester.view.viewInsets = const FakeViewPadding(bottom: 280);
          addTearDown(tester.view.resetViewInsets);
          await tester.pumpAndSettle();
          final action = page is OnboardingScreen
              ? find.byKey(const ValueKey('onboarding.continue'))
              : find.widgetWithText(FgButton, LocaleKeys.confirm.tr());
          await _show(tester, action);
          expect(action.hitTestable(), findsOneWidget);
        } else if (page is SettingsPage) {
          await _show(tester, find.text(LocaleKeys.rateUs.tr()));
          expect(
            find.text(LocaleKeys.rateUs.tr()).hitTestable(),
            findsOneWidget,
          );
        } else if (page is ProfilePage) {
          await _show(
            tester,
            find.byWidgetPredicate((w) => w is LevelItem && w.level.id == 8),
          );
          expect(find.byType(LevelItem), findsNWidgets(8));
        }
        _expectDarkScreen(tester, page);
      });
    }

    testWidgets(
      'Appearance is coherent and only writes on selection at $width',
      (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await _pumpFeature(tester, const AppearancesScreen(), textScale: 2);
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.containsKey(Constants.themeModeKey), isFalse);
        final scaffold = find.byType(Scaffold);
        expect(Theme.of(tester.element(scaffold)).brightness, Brightness.light);
        for (final mode in [
          LocaleKeys.darkMode.tr(),
          LocaleKeys.lightMode.tr(),
          LocaleKeys.auto.tr(),
        ]) {
          final target = find.text(mode);
          await _show(
            tester,
            target,
            delta: mode == LocaleKeys.auto.tr() ? -250 : 250,
          );
          await tester.tap(target);
          await tester.pumpAndSettle();
          _expectAppearanceContrast(tester);
        }
        expect(prefs.getString(Constants.themeModeKey), ThemeMode.system.name);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('Profile opens the actual selected belt sheet at $width', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(Size(width, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      const page = ProfilePage();
      await _pumpFeature(
        tester,
        page,
        textScale: 2,
        profileRepository: _PersonalProfileRepository(),
      );
      final avatar = tester.widget<FgAvatar>(find.byType(FgAvatar).first);
      expect(avatar.initials, 'A');
      expect(avatar.semanticLabel, 'Alex');
      final belt = find.byWidgetPredicate(
        (w) => w is LevelItem && w.level.id == 2,
      );
      await _show(tester, belt);
      await tester.tap(belt);
      await tester.pumpAndSettle();
      final sheet = tester.widget<LevelProgressionPage>(
        find.byType(LevelProgressionPage),
      );
      expect(sheet.initialLevelIndex, 1);
      await _show(tester, find.byKey(const ValueKey('belt-2')));
      final details = tester.widget<FgDetails>(
        find.byKey(const ValueKey('belt-2')),
      );
      expect(details.initiallyExpanded, isTrue);
      _expectDarkScreen(tester, sheet);
      await _show(
        tester,
        find.text(LocaleKeys.detailsAboutMethod.tr()),
        delta: -250,
      );
      await tester.tap(find.text(LocaleKeys.detailsAboutMethod.tr()));
      await tester.pumpAndSettle();
      expect(
        find.text(LocaleKeys.forgeCriteriaProvisional.tr()),
        findsOneWidget,
      );
      _expectDarkScreen(tester, sheet);
    });
  }

  for (final width in [320.0, 1040.0]) {
    testWidgets(
      'Backup root cancel/confirm, error and busy back guard at $width',
      (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final repository = _PersonalBackupRepository();
        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, _) => Scaffold(
                body: TextButton(
                  onPressed: () => context.push('/backup'),
                  child: const Text('Open backup'),
                ),
              ),
            ),
            GoRoute(
              path: '/backup',
              builder: (_, _) => const DataTransferPage(),
            ),
          ],
        );
        addTearDown(router.dispose);
        await _pumpFeature(
          tester,
          const SizedBox(),
          router: router,
          backupRepository: repository,
          textScale: 2,
        );
        await tester.tap(find.text('Open backup'));
        await tester.pumpAndSettle();
        final import = find.widgetWithText(
          FgButton,
          LocaleKeys.forgeImportData.tr(),
        );
        await _show(tester, import);
        await tester.tap(import);
        await tester.pumpAndSettle();
        final dialog = find.byType(AlertDialog);
        expect(dialog, findsOneWidget);
        expect(find.text(LocaleKeys.forgeRestoreWarning.tr()), findsOneWidget);
        _expectDarkModal(tester, dialog);
        await tester.tap(find.widgetWithText(FgButton, LocaleKeys.cancel.tr()));
        await tester.pumpAndSettle();
        expect(repository.restores, 0);
        await tester.tap(import);
        await tester.pumpAndSettle();
        repository.hold = Completer<void>();
        repository.fail = true;
        await tester.tap(
          find.widgetWithText(FgButton, LocaleKeys.forgeRestoreAction.tr()),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        expect(tester.widget<FgButton>(import).onPressed, isNull);
        final pageContext = tester.element(find.byType(DataTransferPage));
        await Navigator.of(pageContext).maybePop();
        await tester.pump();
        expect(find.byType(DataTransferPage), findsOneWidget);
        repository.hold!.complete();
        await tester.pumpAndSettle();
        expect(repository.restores, 1);
        final error = find.textContaining('Restore failed');
        await _show(tester, error);
        expect(error, findsOneWidget);
        expect(tester.widget<FgButton>(import).onPressed, isNotNull);
        repository.hold = null;
        repository.fail = false;
        await _show(tester, import, delta: -250);
        await tester.tap(import);
        await tester.pumpAndSettle();
        await tester.tap(
          find.widgetWithText(FgButton, LocaleKeys.forgeRestoreAction.tr()),
        );
        await tester.pumpAndSettle();
        await _show(tester, find.text(LocaleKeys.forgeTransferSuccess.tr()));
        expect(repository.restores, 2);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'Onboarding retains failed input, retries and guards duplicate keyboard saves',
    (tester) async {
      final repository = _PersonalProfileRepository(fail: true);
      final router = GoRouter(
        initialLocation: '/setup',
        routes: [
          GoRoute(path: '/setup', builder: (_, _) => const OnboardingScreen()),
          GoRoute(
            path: Routes.main,
            builder: (_, _) => const Scaffold(body: Text('Saved destination')),
          ),
        ],
      );
      addTearDown(router.dispose);
      await _pumpFeature(
        tester,
        const OnboardingScreen(),
        router: router,
        profileRepository: repository,
      );
      final button = find.byKey(const ValueKey('onboarding.continue'));
      expect(tester.widget<FgButton>(button).onPressed, isNull);
      await tester.enterText(find.byType(TextField), '  ');
      expect(tester.widget<FgButton>(button).onPressed, isNull);
      await tester.enterText(find.byType(TextField), '  New dancer  ');
      await tester.runAsync(
        () => tester.testTextInput.receiveAction(TextInputAction.done),
      );
      await tester.pumpAndSettle();
      expect(find.text('Saved destination'), findsNothing);
      expect(find.text(LocaleKeys.failedToSaveProfile.tr()), findsWidgets);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        '  New dancer  ',
      );
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(find.text(LocaleKeys.failedToSaveProfile.tr()), findsOneWidget);
      await _show(tester, button);
      repository.fail = false;
      repository.hold = Completer<void>();
      await tester.runAsync(() async {
        await tester.tap(button);
        await Future<void>.delayed(Duration.zero);
      });
      await tester.pump();
      expect(tester.widget<FgButton>(button).isLoading, isTrue);
      final input = tester.widget<FgInput>(find.byType(FgInput));
      input.onSubmitted?.call('duplicate');
      await tester.pump();
      expect(repository.writes, 2);
      await tester.runAsync(() async {
        repository.hold!.complete();
        await Future<void>.delayed(Duration.zero);
      });
      await tester.pumpAndSettle();
      expect(repository.profile.name, 'New dancer');
      expect(find.text('Saved destination'), findsOneWidget);
    },
  );

  testWidgets(
    'Account validates dirty name and retains failed save before retry',
    (tester) async {
      final repository = _PersonalProfileRepository(fail: true);
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, _) => Scaffold(
              body: TextButton(
                onPressed: () => context.push('/account'),
                child: const Text('Open account'),
              ),
            ),
          ),
          GoRoute(
            path: '/account',
            builder: (_, _) =>
                const AccountInfoScreen(originalProfile: Profile(name: 'Alex')),
          ),
        ],
      );
      addTearDown(router.dispose);
      await _pumpFeature(
        tester,
        const SizedBox(),
        router: router,
        profileRepository: repository,
      );
      await tester.tap(find.text('Open account'));
      await tester.pumpAndSettle();
      final confirm = find.widgetWithText(FgButton, LocaleKeys.confirm.tr());
      expect(tester.widget<FgButton>(confirm).onPressed, isNull);
      await tester.enterText(find.byType(TextField), '  ');
      await tester.pumpAndSettle();
      expect(find.text(LocaleKeys.personalNameRequired.tr()), findsOneWidget);
      expect(tester.widget<FgButton>(confirm).onPressed, isNull);
      await tester.enterText(find.byType(TextField), 'Updated dancer');
      await tester.runAsync(
        () => tester.testTextInput.receiveAction(TextInputAction.done),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AccountInfoScreen), findsOneWidget);
      expect(find.text(LocaleKeys.unexpectedErrorOccurred.tr()), findsWidgets);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'Updated dancer',
      );
      repository.fail = false;
      await tester.runAsync(() async {
        await tester.tap(confirm);
        await Future<void>.delayed(Duration.zero);
      });
      await tester.pumpAndSettle();
      expect(repository.writes, 2);
      expect(repository.profile.name, 'Updated dancer');
      expect(find.text('Open account'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
