import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/routing/routes.dart';

void main() {
  test('typed destinations own nested route identity', () {
    expect(
      const ModuleDestination('body-control').location,
      '/main/module/body-control',
    );
    expect(
      const LessonDestination('body-control', 'isolation').location,
      '/main/module/body-control/lesson/isolation',
    );
  });

  test('main tab classification keeps module flows on Learn', () {
    expect(
      MainTabDestination.fromLocation(Routes.library),
      MainTabDestination.library,
    );
    expect(
      MainTabDestination.fromLocation('/main/module/body-control'),
      MainTabDestination.explore,
    );
    expect(
      MainTabDestination.fromLocation('/main/module/body-control/lesson/a'),
      MainTabDestination.explore,
    );
    expect(
      MainTabDestination.fromLocation('/main/library-extra'),
      MainTabDestination.home,
    );
  });
}
