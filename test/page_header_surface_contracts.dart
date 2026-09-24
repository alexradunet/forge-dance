part of 'feature_surface_contract_test.dart';

void _pageHeaderSurfaceContracts() {
  final pages = <String, ({Widget page, bool back})>{
    'Home': (page: const HomePage(), back: false),
    'Learn': (page: const ExplorePage(), back: false),
    'Vocabulary': (page: const VocabularyPage(), back: false),
    'Programmes': (page: const ProgrammesPage(), back: true),
    'Profile': (page: const ProfilePage(), back: false),
    'Practice': (page: const PracticePage(), back: false),
    'Settings': (page: const SettingsPage(), back: true),
    'Movement reference': (
      page: VocabularyEntryPage(
        entry: const VocabularyRepository().byId('bounce')!,
        onBack: () {},
      ),
      back: true,
    ),
  };
  for (final width in [320.0, 1200.0]) {
    for (final entry in pages.entries) {
      testWidgets(
        '${entry.key} uses the shared page header at $width with large text',
        (tester) async {
          await tester.binding.setSurfaceSize(Size(width, 1000));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          await _pumpFeature(tester, entry.value.page, textScale: 2);
          final header = find.byType(AppHeader);
          expect(header, findsOneWidget);
          final widget = tester.widget<AppHeader>(header);
          expect(widget.compact, isFalse);
          final title = find.descendant(
            of: header,
            matching: find.text(widget.title.toUpperCase()),
          );
          final text = tester.widget<Text>(title);
          expect(text.style!.fontFamily, AppTypography.h2.fontFamily);
          expect(text.style!.fontSize, AppTypography.h2.fontSize);
          expect(text.maxLines, isNull);
          expect(text.overflow, isNull);
          expect(title.hitTestable(), findsOneWidget);
          expect(
            find.descendant(of: header, matching: find.byType(BackButton)),
            entry.value.back ? findsOneWidget : findsNothing,
          );
          final row = find
              .descendant(of: header, matching: find.byType(Row))
              .first;
          final contentWidth = math.min(width, AppSizes.readingContentMax);
          expect(
            tester.getTopLeft(row).dx,
            (width - contentWidth) / 2 + AppSpacing.xxl,
          );
          expect(tester.getSize(row).width, contentWidth - 2 * AppSpacing.xxl);
          _expectDarkScreen(tester, entry.value.page);
          if (entry.value.page is ExplorePage) {
            expect(
              find.text(LocaleKeys.cypherLearnHeadline.tr()),
              findsOneWidget,
            );
            expect(
              find.text(LocaleKeys.cypherLearnSubtitle.tr()),
              findsOneWidget,
            );
          }
          if (entry.value.page is VocabularyPage) {
            expect(
              find.text(LocaleKeys.vocabularyHeadline.tr()),
              findsOneWidget,
            );
            expect(
              find.text(LocaleKeys.vocabularySubtitle.tr()),
              findsOneWidget,
            );
          }
          if (entry.value.page is ProfilePage) {
            expect(
              find.descendant(of: header, matching: find.byType(FgIconButton)),
              findsOneWidget,
            );
          }
        },
      );
    }
  }
}
