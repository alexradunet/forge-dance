import 'dart:convert';

import '../repository/method_catalog.dart';

enum ForgeCategory {
  rhythm,
  bodyControl,
  footwork,
  coordination,
  retention,
  creativity,
  mobility,
  capacity,
}

extension ForgeCategoryDescription on ForgeCategory {
  bool get isCore => index < 6;
  String get label => switch (this) {
    ForgeCategory.rhythm => 'Rhythm',
    ForgeCategory.bodyControl => 'Body control',
    ForgeCategory.footwork => 'Footwork',
    ForgeCategory.coordination => 'Coordination',
    ForgeCategory.retention => 'Retention',
    ForgeCategory.creativity => 'Creativity',
    ForgeCategory.mobility => 'Mobility',
    ForgeCategory.capacity => 'Capacity',
  };
}

class AssessmentCriterion {
  const AssessmentCriterion({required this.id, required this.text});
  final String id;
  final String text;
}

class MethodAssessment {
  const MethodAssessment({
    required this.id,
    required this.category,
    required this.level,
    required this.title,
    required this.instructions,
    required this.criteria,
    required this.adaptation,
    required this.linkedLessonId,
    this.rubricVersion = 1,
  });
  final String id;
  final ForgeCategory? category;
  final int level;
  final String title;
  final String instructions;
  final List<AssessmentCriterion> criteria;
  final String adaptation;
  final String linkedLessonId;
  final int rubricVersion;
  bool get requiresNotes =>
      category == null || (category == ForgeCategory.retention && level >= 6);

  bool isPassedBy(AssessmentAttempt attempt) =>
      attempt.assessmentId == id &&
      attempt.rubricVersion == rubricVersion &&
      attempt.metCriteriaIds.length == criteria.length &&
      (!requiresNotes || attempt.notes.trim().isNotEmpty) &&
      criteria.every(
        (criterion) => attempt.metCriteriaIds.contains(criterion.id),
      );
}

class MethodBelt {
  const MethodBelt({
    required this.index,
    required this.name,
    required this.description,
  });
  final int index;
  final String name;
  final String description;
  int get requiredLevel => index;
  String? get integratedAssessmentId =>
      index == 0 ? null : 'integrated-$index-v1';
}

class AssessmentAttempt {
  AssessmentAttempt({
    required this.id,
    required this.assessmentId,
    required this.performedAt,
    required List<String> metCriteriaIds,
    this.notes = '',
    this.evidenceId,
    this.rubricVersion = 1,
  }) : metCriteriaIds = List.unmodifiable(metCriteriaIds);

  final String id;
  final String assessmentId;
  final DateTime performedAt;
  final List<String> metCriteriaIds;
  final String notes;
  final String? evidenceId;
  final int rubricVersion;
  MethodAssessment get assessment => assessmentById(assessmentId);
  bool get passed => assessment.isPassedBy(this);

  Map<String, Object?> toJson() => {
    'id': id,
    'assessmentId': assessmentId,
    'performedAt': performedAt.toUtc().toIso8601String(),
    'metCriteriaIds': metCriteriaIds,
    'notes': notes,
    'evidenceId': evidenceId,
    'rubricVersion': rubricVersion,
  };

  factory AssessmentAttempt.fromJson(Map<String, Object?> json) {
    final attempt = AssessmentAttempt(
      id: _string(json, 'id'),
      assessmentId: _string(json, 'assessmentId'),
      performedAt: DateTime.parse(_string(json, 'performedAt')),
      metCriteriaIds: _strings(json['metCriteriaIds']),
      notes: _string(json, 'notes', allowEmpty: true),
      evidenceId: json['evidenceId'] == null
          ? null
          : _string(json, 'evidenceId'),
      rubricVersion: _integer(json, 'rubricVersion'),
    );
    validateAssessmentAttempt(attempt);
    return attempt;
  }
}

class BeltAward {
  BeltAward({
    required this.index,
    required this.awardedAt,
    required List<String> evidenceIds,
  }) : evidenceIds = List.unmodifiable(evidenceIds);
  final int index;
  final DateTime awardedAt;

  /// IDs of the six category attempts and integrated attempt, not video IDs.
  /// Optional private video references live on those immutable attempts.
  final List<String> evidenceIds;
  Map<String, Object?> toJson() => {
    'index': index,
    'awardedAt': awardedAt.toUtc().toIso8601String(),
    'evidenceIds': evidenceIds,
  };

  factory BeltAward.fromJson(Map<String, Object?> json) => BeltAward(
    index: _integer(json, 'index'),
    awardedAt: DateTime.parse(_string(json, 'awardedAt')),
    evidenceIds: _strings(json['evidenceIds']),
  );
}

/// Self-assessed FORGE capability, not a global dance rank or an XP level.
/// A failed retest caps current capability below the tested level; it cannot
/// erase an earlier award. Higher passes subsume lower category requirements.
class MethodProgress {
  factory MethodProgress({
    List<AssessmentAttempt> attempts = const [],
    List<BeltAward>? awards,
  }) {
    final evaluated = _evaluate(attempts);
    if (awards != null &&
        jsonEncode(awards.map((award) => award.toJson()).toList()) !=
            jsonEncode(
              evaluated.awards.map((award) => award.toJson()).toList(),
            )) {
      throw const FormatException(
        'Belt awards do not match assessment evidence.',
      );
    }
    return evaluated;
  }

  MethodProgress._(
    this.attempts,
    this.awards,
    this._levels,
    this._integratedLevel,
  );
  final List<AssessmentAttempt> attempts;
  final List<BeltAward> awards;
  final Map<ForgeCategory, int> _levels;
  final int _integratedLevel;
  int levelFor(ForgeCategory category) => _levels[category] ?? 0;
  int get earnedBeltIndex => awards.isEmpty ? 0 : awards.last.index;
  bool meetsIntegratedLevel(int level) => _integratedLevel >= level;
  List<({String description, bool isMet})> requirementsForBelt(int index) {
    if (index < 0 || index > 7) throw RangeError.range(index, 0, 7);
    if (index == 0) {
      return [(description: forgeBelts.first.description, isMet: true)];
    }
    return [
      for (final category in ForgeCategory.values.where(
        (category) => category.isCore,
      ))
        (
          description: '${category.label}: level $index or above',
          isMet: levelFor(category) >= index,
        ),
      (
        description:
            '${assessmentById('integrated-$index-v1').title}: level $index integrated assessment or above',
        isMet: meetsIntegratedLevel(index),
      ),
    ];
  }

  double get nextBeltProgress {
    if (earnedBeltIndex == 7) return 1;
    final target = earnedBeltIndex + 1;
    final met = ForgeCategory.values
        .where((category) => category.isCore && levelFor(category) >= target)
        .length;
    return (met + (meetsIntegratedLevel(target) ? 1 : 0)) / 7;
  }

  Map<String, Object?> toJson() => {
    'schemaVersion': 1,
    'attempts': attempts.map((attempt) => attempt.toJson()).toList(),
    'awards': awards.map((award) => award.toJson()).toList(),
  };

  factory MethodProgress.fromJson(Map<String, Object?> json) {
    if (json['schemaVersion'] != 1 ||
        json['attempts'] is! List ||
        json['awards'] is! List) {
      throw const FormatException('Unsupported method progress format.');
    }
    return MethodProgress(
      attempts: (json['attempts'] as List)
          .map((value) => AssessmentAttempt.fromJson(_object(value)))
          .toList(),
      awards: (json['awards'] as List)
          .map((value) => BeltAward.fromJson(_object(value)))
          .toList(),
    );
  }
}

MethodAssessment assessmentById(String id) => forgeAssessments.firstWhere(
  (assessment) => assessment.id == id,
  orElse: () => throw FormatException('Unknown assessment: $id'),
);

void validateAssessmentAttempt(AssessmentAttempt attempt) {
  final assessment = attempt.assessment;
  final validIds = assessment.criteria.map((criterion) => criterion.id).toSet();
  if (attempt.id.trim().isEmpty ||
      attempt.rubricVersion != assessment.rubricVersion ||
      attempt.metCriteriaIds.toSet().length != attempt.metCriteriaIds.length ||
      !attempt.metCriteriaIds.every(validIds.contains) ||
      (attempt.evidenceId != null && attempt.evidenceId!.trim().isEmpty) ||
      attempt.performedAt.isAfter(
        DateTime.now().add(const Duration(minutes: 5)),
      )) {
    throw const FormatException(
      'Invalid assessment evidence or rubric version.',
    );
  }
}

MethodProgress _evaluate(List<AssessmentAttempt> attempts) {
  final levels = <ForgeCategory, int>{};
  final support = <ForgeCategory, AssessmentAttempt>{};
  final validPasses = <ForgeCategory, Map<int, AssessmentAttempt>>{};
  final integratedPasses = <int, AssessmentAttempt>{};
  final awards = <BeltAward>[];
  var integratedLevel = 0;
  AssessmentAttempt? integratedSupport;
  final ids = <String>{};
  DateTime? previous;
  for (final attempt in attempts) {
    validateAssessmentAttempt(attempt);
    if (!ids.add(attempt.id) ||
        (previous != null && attempt.performedAt.isBefore(previous))) {
      throw const FormatException(
        'Assessment attempts must be unique and chronological.',
      );
    }
    previous = attempt.performedAt;
    final assessment = attempt.assessment;
    final category = assessment.category;
    final passes = category == null
        ? integratedPasses
        : validPasses.putIfAbsent(category, () => {});
    if (attempt.passed) {
      passes[assessment.level] = attempt;
    } else {
      // Never resurrect proof invalidated by an earlier failed retest.
      passes.removeWhere((level, _) => level >= assessment.level);
    }
    AssessmentAttempt? strongest;
    for (final candidate in passes.values) {
      if (strongest == null ||
          candidate.assessment.level > strongest.assessment.level) {
        strongest = candidate;
      }
    }
    if (category == null) {
      integratedLevel = strongest?.assessment.level ?? 0;
      integratedSupport = strongest;
    } else {
      levels[category] = strongest?.assessment.level ?? 0;
      if (strongest == null) {
        support.remove(category);
      } else {
        support[category] = strongest;
      }
    }
    for (var index = awards.length + 1; index <= 7; index++) {
      if (integratedLevel < index ||
          ForgeCategory.values.any(
            (category) => category.isCore && (levels[category] ?? 0) < index,
          )) {
        break;
      }
      awards.add(
        BeltAward(
          index: index,
          awardedAt: attempt.performedAt,
          evidenceIds: [
            for (final category in ForgeCategory.values.where(
              (category) => category.isCore,
            ))
              support[category]!.id,
            integratedSupport!.id,
          ],
        ),
      );
    }
  }
  return MethodProgress._(
    List.unmodifiable(attempts),
    List.unmodifiable(awards),
    Map.unmodifiable(levels),
    integratedLevel,
  );
}

Map<String, Object?> _object(Object? value) {
  if (value is! Map<String, Object?>) {
    throw const FormatException('Expected an object.');
  }
  return value;
}

String _string(
  Map<String, Object?> json,
  String key, {
  bool allowEmpty = false,
}) {
  final value = json[key];
  if (value is! String || (!allowEmpty && value.trim().isEmpty)) {
    throw FormatException('Invalid $key.');
  }
  return value;
}

int _integer(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! int) throw FormatException('Invalid $key.');
  return value;
}

List<String> _strings(Object? value) {
  if (value is! List || value.any((item) => item is! String)) {
    throw const FormatException('Expected text list.');
  }
  return value.cast<String>();
}
