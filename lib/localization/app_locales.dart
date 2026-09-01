import 'package:flutter/widgets.dart';

/// Application locale registry.
///
/// English is the only shipped locale. Add future locales here and provide a
/// matching `assets/translations/<languageCode>.json` file.
abstract final class AppLocales {
  static const english = Locale('en');
  static const fallback = english;
  static const supported = <Locale>[english];
}
