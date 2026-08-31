import 'package:forge_dance/features/authentication/ui/register_screen.dart';
import 'package:forge_dance/features/authentication/ui/sign_in_screen.dart';
import 'package:widgetbook/widgetbook.dart';

List<WidgetbookNode> buildScreenStories() {
  return [
    WidgetbookFolder(
      name: 'Authentication',
      children: [
        WidgetbookComponent(
          name: 'Register',
          useCases: [
            WidgetbookUseCase(
              name: 'Default',
              builder: (_) => const RegisterScreen(),
            ),
          ],
        ),
        WidgetbookComponent(
          name: 'Sign in',
          useCases: [
            WidgetbookUseCase(
              name: 'Default',
              builder: (_) => const SignInScreen(),
            ),
          ],
        ),
      ],
    ),
  ];
}
