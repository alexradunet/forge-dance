import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:forge_dance/features/learn/repository/lesson_catalog.dart';
import 'package:forge_dance/features/learn/ui/module_view_screen.dart';
import 'package:forge_dance/features/learn/ui/view_model/learn_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('overview starts available lessons but not locked programs', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    // The timeline uses NetworkImage; widget-test HTTP returns 400.
    final reportError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.exception is NetworkImageLoadException) return;
      reportError?.call(details);
    };
    addTearDown(() => FlutterError.onError = reportError);
    String? opened;
    final moduleId = ValueNotifier<String?>(null);
    addTearDown(moduleId.dispose);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppThemes.dark,
          home: ValueListenableBuilder<String?>(
            valueListenable: moduleId,
            builder: (context, id, _) => ModuleViewScreen(
              moduleId: id,
              onBack: () {},
              onLessonNavigate: (id) => opened = id,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    final start = find.widgetWithText(FgButton, 'startLesson');
    await tester.ensureVisible(start);
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(start);
    await tester.pump(const Duration(seconds: 1));
    expect(opened, readyBody.lessons.first.id);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(ModuleViewScreen)),
    );
    // Route identity wins over a stale session-global module selection.
    expect(
      container.read(learnViewModelProvider).value?.activeModuleId,
      readyBody.id,
    );
    moduleId.value = hipHopFoundations.id;
    await tester.pump(const Duration(seconds: 1));
    expect(find.widgetWithText(FgButton, 'startLesson'), findsNothing);
    expect(find.widgetWithText(FgButton, 'continueText'), findsNothing);
    expect(find.text('requiresLesson'), findsOneWidget);
    expect(find.byType(LessonPathTimeline), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
