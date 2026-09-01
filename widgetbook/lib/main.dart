import 'package:widgetbook/widgetbook.dart';

import 'widgetbook.config.dart';
import 'forge_preview_app.dart';

Future<void> main() async {
  await initializeForgePreview();
  runWidgetbook(config);
}
