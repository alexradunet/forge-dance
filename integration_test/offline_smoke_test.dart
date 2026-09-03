import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:forge_dance/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('offline first-run setup reaches the app shell', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    final nameField = find.byKey(const ValueKey('onboarding.name'));
    expect(nameField, findsOneWidget);

    await tester.enterText(nameField, 'Offline Dancer');
    await tester.tap(find.byKey(const ValueKey('onboarding.continue')));
    await tester.pumpAndSettle();

    expect(find.text('Offline Dancer'), findsWidgets);
  });
}
