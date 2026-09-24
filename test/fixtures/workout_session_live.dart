// Isolated live entry point. No repositories, production routes or stored records
// are used. Run with -t test/fixtures/workout_session_live.dart, then restore main.
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:forge_dance/features/practice/model/practice.dart';
import 'package:forge_dance/features/practice/ui/workout_session_page.dart';

import '../support/workout_session_fixture.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en')],
        fallbackLocale: const Locale('en'),
        startLocale: const Locale('en'),
        saveLocale: false,
        path: 'assets/translations',
        child: const _FixtureApp(),
      ),
    ),
  );
}

class _FixtureApp extends StatelessWidget {
  const _FixtureApp();
  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: AppThemes.light,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(
          (double.tryParse(Uri.base.queryParameters['scale'] ?? '') ?? 1).clamp(
            1,
            2,
          ),
        ),
      ),
      child: child!,
    ),
    locale: context.locale,
    localizationsDelegates: context.localizationDelegates,
    supportedLocales: context.supportedLocales,
    home: const _FixtureLauncher(),
  );
}

class _FixtureLauncher extends StatelessWidget {
  const _FixtureLauncher();
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: FgButton(
        text: 'Open isolated workout fixture',
        onPressed: () {
          final records = <String, PracticeRecord>{};
          var fail = true;
          final fixture = WorkoutTestFixture(
            save: (record) async {
              records[record.id] = record;
              if (fail) {
                fail = false;
                throw StateError(
                  'Isolated fixture: acknowledgement lost; Retry uses the same record',
                );
              }
            },
          );
          for (var i = 0; i < 2; i++) {
            fixture.session.index = i;
            fixture.completeTarget();
            final round = fixture.session.current;
            round.muted = true;
            round.notes = 'Retained fixture reflection ${i + 1}';
            round.difficulty = 6;
            round.clock.setPhrase(2, 6);
          }
          fixture.session.index = 0;
          Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (_) => WorkoutSessionPage(session: fixture.session),
            ),
          );
        },
      ),
    ),
  );
}
