import '../../learn/model/lesson_progress.dart';
import '../../method/model/forge_method.dart';
import '../../practice/model/practice.dart';
import 'vocabulary_entry.dart';

/// Studying, practising and self-assessed capability are distinct facts.
class VocabularyLearning {
  VocabularyLearning({
    required VocabularyEntry entry,
    required Map<String, LessonProgress> lessons,
    required MethodProgress method,
    required List<PracticeRecord> practice,
  }) : studied = lessons[entry.lessonId]?.status == LessonStatus.completed,
       categoryLevel = method.levelFor(entry.category),
       categoryAttempts = List.unmodifiable(
         method.attempts
             .where((attempt) => attempt.assessment.category == entry.category)
             .toList()
           ..sort((a, b) => b.performedAt.compareTo(a.performedAt)),
       ),
       practiceHistory = List.unmodifiable(
         practice.where((record) => record.vocabularyId == entry.id).toList()
           ..sort((a, b) => b.performedAt.compareTo(a.performedAt)),
       );

  final bool studied;
  final int categoryLevel;
  final List<AssessmentAttempt> categoryAttempts;
  final List<PracticeRecord> practiceHistory;
}
