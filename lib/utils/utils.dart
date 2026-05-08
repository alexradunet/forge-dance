import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';

import '../generated/locale_keys.g.dart';

class Utils {
  Utils._();

  static Future<bool> haveConnection() async {
    final connectivityResults = await Connectivity().checkConnectivity();
    return !connectivityResults.contains(ConnectivityResult.none);
  }

  static String getErrorMessage(Object? error) {
    if (error == null) return LocaleKeys.unexpectedErrorOccurred.tr();

    final message = error.toString().replaceFirst('Exception: ', '').trim();
    if (message.isEmpty) return LocaleKeys.unexpectedErrorOccurred.tr();

    return message;
  }

  static DateTime today() {
    final today = DateTime.now();
    return DateTime(today.year, today.month, today.day);
  }
}
