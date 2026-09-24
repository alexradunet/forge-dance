import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:forge_dance/routing/main_navigation.dart';
import 'package:forge_dance/routing/routes.dart';
import 'package:go_router/go_router.dart';

void main() {
  for (final scale in [1.0, 2.0]) {
    testWidgets(
      'retains tab detail and form; reselect resets at scale $scale',
      (tester) async {
        final router = _router();
        addTearDown(router.dispose);
        await tester.pumpWidget(
          MaterialApp.router(
            theme: AppThemes.light,
            routerConfig: router,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.menu_book_outlined));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Open detail'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'Remember this');
        await tester.tap(find.byIcon(Icons.home_outlined));
        await tester.pumpAndSettle();
        expect(find.text('Home content'), findsOneWidget);
        await tester.tap(find.byIcon(Icons.menu_book_outlined));
        await tester.pumpAndSettle();
        expect(find.text('Remember this'), findsOneWidget);
        expect(
          GoRouterState.of(tester.element(find.byType(TextField))).uri.path,
          '${Routes.vocabulary}/detail',
        );
        await tester.tap(find.byIcon(Icons.menu_book_outlined));
        await tester.pumpAndSettle();
        expect(find.text('Open detail'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('guard prevents tab switch and reselect; Back pops detail', (
    tester,
  ) async {
    final router = _router(guarded: true);
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(theme: AppThemes.light, routerConfig: router),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.menu_book_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open detail'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    await tester.tap(find.byIcon(Icons.menu_book_outlined));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    await tester.tap(find.text('Allow leaving'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Open detail'), findsOneWidget);
  });

  testWidgets(
    'conditioning returns to caller; direct link falls back to Practice',
    (tester) async {
      final router = _router();
      addTearDown(router.dispose);
      await tester.pumpWidget(
        MaterialApp.router(theme: AppThemes.light, routerConfig: router),
      );
      await tester.pumpAndSettle();
      router.push(Routes.workout);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Close circuit'));
      await tester.pumpAndSettle();
      expect(find.text('Home content'), findsOneWidget);
      router.go(Routes.workout);
      await tester.pumpAndSettle();
      router.push(Routes.workoutSession);
      await tester.pumpAndSettle();
      expect(find.byType(AppBottomNav), findsNothing);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(AppBottomNav), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Practice content'), findsOneWidget);
    },
  );
}

GoRouter _router({bool guarded = false}) => GoRouter(
  initialLocation: Routes.home,
  routes: [
    mainNavigation([
      GoRoute(path: Routes.home, builder: (_, _) => const Text('Home content')),
      GoRoute(
        path: Routes.explore,
        builder: (_, _) => const Text('Learn content'),
      ),
      GoRoute(
        path: Routes.profile,
        builder: (_, _) => const Text('Profile content'),
      ),
      GoRoute(
        path: Routes.practice,
        builder: (_, _) => const Text('Practice content'),
      ),
      GoRoute(
        path: Routes.workout,
        builder: (context, _) => TextButton(
          onPressed: () => closeDetail(context, fallback: Routes.practice),
          child: const Text('Close circuit'),
        ),
        routes: [
          GoRoute(
            path: 'session',
            builder: (_, _) => const Text('Active circuit'),
          ),
        ],
      ),
      GoRoute(
        path: Routes.vocabulary,
        builder: (context, _) => TextButton(
          onPressed: () => context.push('${Routes.vocabulary}/detail'),
          child: const Text('Open detail'),
        ),
        routes: [
          GoRoute(
            path: 'detail',
            builder: (_, _) => _Detail(guarded: guarded),
          ),
        ],
      ),
    ]),
  ],
);

class _Detail extends StatefulWidget {
  const _Detail({required this.guarded});
  final bool guarded;
  @override
  State<_Detail> createState() => _DetailState();
}

class _DetailState extends State<_Detail> {
  late bool guarded = widget.guarded;
  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !guarded,
    child: Column(
      children: [
        const TextField(),
        TextButton(
          onPressed: () => setState(() => guarded = false),
          child: const Text('Allow leaving'),
        ),
      ],
    ),
  );
}
