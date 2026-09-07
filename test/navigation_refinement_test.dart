import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:forge_dance/features/main/presentation/pages/main_screen.dart';
import 'package:forge_dance/routing/routes.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets(
    'workout preview keeps tabs; session hides them; Back restores them',
    (tester) async {
      final router = GoRouter(
        initialLocation: Routes.workout,
        routes: [
          ShellRoute(
            builder: (context, state, child) =>
                MainScreen(location: state.uri.path, child: child),
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (_, _) => const Text('Home content'),
              ),
              GoRoute(
                path: Routes.workout,
                builder: (context, _) => TextButton(
                  onPressed: () => context.push(Routes.workoutSession),
                  child: const Text('Start session'),
                ),
                routes: [
                  GoRoute(
                    path: 'session',
                    builder: (_, _) => const Text('Active session'),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        MaterialApp.router(theme: AppThemes.dark, routerConfig: router),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AppBottomNav), findsOneWidget);

      await tester.tap(find.text('Start session'));
      await tester.pumpAndSettle();
      expect(find.text('Active session'), findsOneWidget);
      expect(find.byType(AppBottomNav), findsNothing);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Start session'), findsOneWidget);
      expect(find.byType(AppBottomNav), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Home content'), findsOneWidget);
    },
  );

  testWidgets('menu trigger uses immersive foreground even in light theme', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.light,
        home: Scaffold(
          body: FgBackground(
            child: FgMenuButton<int>(
              icon: Icons.grid_view_rounded,
              semanticLabel: 'Grid columns',
              items: const [FgMenuItem(value: 2, label: 'Two columns')],
              onSelected: (_) {},
            ),
          ),
        ),
      ),
    );
    final icon = tester.widget<Icon>(find.byIcon(Icons.grid_view_rounded));
    final context = tester.element(find.byType(FgMenuButton<int>));
    expect(icon.color, Theme.of(context).forgeColors.onImmersive);
    await tester.tap(find.byType(FgMenuButton<int>));
    await tester.pumpAndSettle();
    expect(find.text('Two columns'), findsOneWidget);
  });
}
