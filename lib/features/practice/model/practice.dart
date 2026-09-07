import 'dart:math';

import '../../method/model/forge_method.dart';

/// A cue-based drill, not a lesson completion or a demonstration of mastery.
class PracticeBlock {
  PracticeBlock({
    required this.id,
    required this.title,
    this.category,
    required this.level,
    required this.minutes,
    required this.bpm,
    required this.lessonId,
    required List<String> cues,
    required this.adaptation,
    this.vocabularyId,
  }) : cues = List.unmodifiable(cues);

  final String id;
  final String title;
  final ForgeCategory? category;
  final int level;
  final int minutes;
  final int bpm;
  final String lessonId;
  final List<String> cues;
  final String adaptation;
  final String? vocabularyId;
}

class PracticePlan {
  PracticePlan({required List<PracticeBlock> blocks})
    : blocks = List.unmodifiable(blocks);

  final List<PracticeBlock> blocks;
  int get minutes => blocks.fold(0, (total, block) => total + block.minutes);
}

enum PracticeSupport { standing, seated, supported }

class PracticePreferences {
  const PracticePreferences({
    this.minutes = 20,
    this.gentle = false,
    this.includeConditioning = false,
    this.support = PracticeSupport.standing,
  });

  final int minutes;
  final bool gentle;
  final bool includeConditioning;
  final PracticeSupport support;

  Map<String, Object?> toJson() => {
    'minutes': minutes,
    'gentle': gentle,
    'includeConditioning': includeConditioning,
    'support': support.name,
  };

  factory PracticePreferences.fromJson(Map<String, Object?> json) {
    final minutes = json['minutes'];
    final gentle = json['gentle'];
    final conditioning = json['includeConditioning'];
    final support = PracticeSupport.values
        .where((v) => v.name == json['support'])
        .firstOrNull;
    if (minutes is! int ||
        minutes < 10 ||
        minutes > 60 ||
        gentle is! bool ||
        conditioning is! bool ||
        support == null) {
      throw const FormatException('Invalid practice preferences.');
    }
    return PracticePreferences(
      minutes: minutes,
      gentle: gentle,
      includeConditioning: conditioning,
      support: support,
    );
  }
}

class PracticeRecord {
  const PracticeRecord({
    required this.id,
    required this.blockId,
    required this.title,
    required this.lessonId,
    this.vocabularyId,
    this.category,
    required this.level,
    required this.performedAt,
    required this.durationSeconds,
    required this.bpm,
    required this.attempts,
    required this.difficulty,
    this.notes = '',
    this.evidenceId,
  });

  final String id;
  final String blockId;
  final String title;
  final String lessonId;
  final String? vocabularyId;
  final ForgeCategory? category;
  final int level;
  final DateTime performedAt;
  final int durationSeconds;
  final int bpm;
  final int attempts;

  /// Self-reported perceived effort (RPE), never an assessment score.
  final int difficulty;
  final String notes;
  final String? evidenceId;

  static final Random _random = Random.secure();
  static String createId() => List.generate(
    16,
    (_) => _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ).join();

  void validate() {
    if ([id, blockId, title, lessonId].any((value) => value.trim().isEmpty) ||
        level < 1 ||
        level > 7 ||
        durationSeconds < 1 ||
        durationSeconds > 86400 ||
        bpm < 20 ||
        bpm > 300 ||
        attempts < 1 ||
        attempts > 10000 ||
        difficulty < 1 ||
        difficulty > 10 ||
        notes.length > 10000 ||
        (evidenceId != null && evidenceId!.trim().isEmpty) ||
        (vocabularyId != null && vocabularyId!.trim().isEmpty)) {
      throw const FormatException(
        'Invalid practice record. Check duration, tempo, attempts and effort.',
      );
    }
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'blockId': blockId,
    'title': title,
    'lessonId': lessonId,
    'vocabularyId': vocabularyId,
    'category': category?.name,
    'level': level,
    'performedAt': performedAt.toIso8601String(),
    'durationSeconds': durationSeconds,
    'bpm': bpm,
    'attempts': attempts,
    'difficulty': difficulty,
    'notes': notes,
    'evidenceId': evidenceId,
  };

  factory PracticeRecord.fromJson(Map<String, Object?> json) {
    final categoryName = json['category'];
    final category = ForgeCategory.values
        .where((v) => v.name == categoryName)
        .firstOrNull;
    if (categoryName != null && category == null) {
      throw const FormatException('Unknown practice category.');
    }
    try {
      final record = PracticeRecord(
        id: json['id'] as String,
        blockId: json['blockId'] as String,
        title: json['title'] as String,
        lessonId: json['lessonId'] as String,
        vocabularyId: json['vocabularyId'] as String?,
        category: category,
        level: json['level'] as int,
        performedAt: DateTime.parse(json['performedAt'] as String),
        durationSeconds: json['durationSeconds'] as int,
        bpm: json['bpm'] as int,
        attempts: json['attempts'] as int,
        difficulty: json['difficulty'] as int,
        notes: json['notes'] as String,
        evidenceId: json['evidenceId'] as String?,
      );
      record.validate();
      return record;
    } on TypeError {
      throw const FormatException('Malformed practice record.');
    }
  }

  PracticeRecord withReflection({
    required String notes,
    required int difficulty,
    required String? evidenceId,
  }) => PracticeRecord(
    id: id,
    blockId: blockId,
    title: title,
    lessonId: lessonId,
    vocabularyId: vocabularyId,
    category: category,
    level: level,
    performedAt: performedAt,
    durationSeconds: durationSeconds,
    bpm: bpm,
    attempts: attempts,
    difficulty: difficulty,
    notes: notes,
    evidenceId: evidenceId,
  );

  /// Only compare like-for-like drills. Effort is subjective, not a rank.
  bool isComparableTo(PracticeRecord other) =>
      blockId == other.blockId &&
      lessonId == other.lessonId &&
      vocabularyId == other.vocabularyId &&
      level == other.level &&
      bpm == other.bpm;
}
