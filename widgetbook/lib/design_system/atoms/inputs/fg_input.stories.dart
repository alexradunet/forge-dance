import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/atoms/inputs/fg_input.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/story_setup.dart';

part 'fg_input.stories.g.dart';

const meta = Meta(FgInput.new);

final $Playground = _Story(
  name: 'Playground',
  setup: scenarioSemanticsBoundary,
  args: _Args(
    label: NullableStringArg('Email address'),
    placeholder: NullableStringArg('dancer@example.com'),
    helperText: NullableStringArg('We never share your email.'),
    prefixIcon: Arg.fixed(Icons.email_outlined),
    onChanged: Arg.fixed((_) {}),
  ),
  scenarios: [
    _Scenario(
      name: 'Default',
      args: _Args.fixed(
        label: 'Email address',
        placeholder: 'dancer@example.com',
        prefixIcon: Icons.email_outlined,
        onChanged: _ignoreText,
      ),
    ),
    _Scenario(
      name: 'Error',
      excludeFromTests: true,
      args: _Args.fixed(
        label: 'Email address',
        errorText: 'Enter a valid email address.',
        prefixIcon: Icons.error_outline_rounded,
        onChanged: _ignoreText,
      ),
    ),
    _Scenario(
      name: 'Disabled',
      excludeFromTests: true,
      args: _Args.fixed(
        label: 'Email address',
        placeholder: 'dancer@example.com',
        isEnabled: false,
      ),
    ),
    _Scenario(
      name: 'Loading',
      excludeFromTests: true,
      args: _Args.fixed(
        label: 'Email address',
        isLoading: true,
        loadingSemanticsLabel: 'Checking email address',
      ),
    ),
  ],
);

void _ignoreText(String value) {}
