import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/routing/routes.dart';

void main() {
  test('typed destinations own nested route identity', () {
    expect(const ModuleDestination('body-control').location,
        '/main/module/body-control');
    expect(
      const LessonDestination('body-control', 'isolation').location,
      '/main/module/body-control/lesson/isolation',
    );
  });

  test('main tab classification keeps nested flows on Home', () {
    expect(MainTabDestination.fromLocation(Routes.library),
        MainTabDestination.library);
    expect(MainTabDestination.fromLocation('/main/module/body-control'),
        MainTabDestination.home);
  });
}
