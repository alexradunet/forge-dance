import 'package:media_kit/media_kit.dart';

/// Call after WidgetsFlutterBinding.ensureInitialized and before runApp.
void initializeLocalMedia() => MediaKit.ensureInitialized();
