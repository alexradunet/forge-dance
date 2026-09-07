import 'package:flutter/foundation.dart';

import '../../method/model/forge_method.dart';

enum VocabularyKind { move, concept }

/// Reference content is independent of lesson completion and always browsable.
@immutable
class VocabularyEntry {
  const VocabularyEntry({
    required this.id,
    required this.name,
    required this.kind,
    required this.style,
    required this.definition,
    required this.cue,
    required this.commonMistake,
    required this.practice,
    required this.moduleId,
    required this.lessonId,
    required this.context,
    required this.easierPractice,
    required this.harderPractice,
    required this.category,
    this.aliases = const [],
    this.relatedIds = const [],
  });

  final String id;
  final String name;
  final VocabularyKind kind;
  final String style;
  final String definition;
  final String cue;
  final String commonMistake;
  final String practice;
  final String moduleId;
  final String lessonId;
  final String context;
  final String easierPractice;
  final String harderPractice;
  final ForgeCategory category;
  final List<String> aliases;
  final List<String> relatedIds;
}
