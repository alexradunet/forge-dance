import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

class ReducedMotionMode extends Mode<bool> {
  ReducedMotionMode(bool value) : super(value, ReducedMotionAddon(value));

  @override
  String get formattedValue => value ? 'Enabled' : 'Disabled';
}

class ReducedMotionAddon extends Addon<bool> with SingleFieldOnly {
  ReducedMotionAddon([bool enabled = false])
    : super(name: 'Reduced Motion', initialValue: enabled);

  @override
  Field<bool> get field =>
      BooleanField(name: 'enabled', initialValue: initialValue);

  @override
  Widget apply(BuildContext context, Widget child, bool setting) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: setting),
      child: child,
    );
  }
}
