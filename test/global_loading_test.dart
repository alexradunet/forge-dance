import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:forge_dance/utils/global_loading.dart';

void main() {
  testWidgets('loading overlay exposes a valid route-scoped semantics node', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    late BuildContext overlayContext;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.light,
        home: Builder(
          builder: (context) {
            overlayContext = context;
            return const Scaffold(body: SizedBox.expand());
          },
        ),
      ),
    );

    Global.showLoading(overlayContext);
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(FgSpinner), findsOneWidget);

    Global.hideLoading();
    await tester.pump();
    semantics.dispose();
  });
}
