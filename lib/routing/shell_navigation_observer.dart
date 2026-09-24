import 'package:flutter/widgets.dart';

/// Tab replacement must respect PopScope on shell pages and imperative children.
/// A read-only detail may be popped; the shell's own back-to-Home policy is not
/// part of this navigator and must not block tab selection.
class ShellNavigationObserver extends NavigatorObserver {
  final List<Route<dynamic>> _routes = [];

  bool get canChangeTab => _routes.every(
    (route) => route.popDisposition != RoutePopDisposition.doNotPop,
  );

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routes.add(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routes.remove(route);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routes.remove(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final index = oldRoute == null ? -1 : _routes.indexOf(oldRoute);
    if (index >= 0) {
      if (newRoute == null) {
        _routes.removeAt(index);
      } else {
        _routes[index] = newRoute;
      }
    }
  }
}
