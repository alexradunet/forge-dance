import '../model/lesson.dart';

/// Static lesson content. Content ships with the app on purpose — only user
/// progress is persisted to Firestore. If content ever needs to change
/// independently of app releases, revisit this decision (documented in the
/// best-practices research report).
const Module hipHopFoundations = Module(
  id: 'hip-hop-foundations',
  title: 'Hip Hop Foundations',
  subtitle: 'Module 1 • Path',
  lessons: [
    Lesson(
      id: 'history-of-hip-hop',
      title: 'History of Hip Hop',
      type: LessonType.theory,
      duration: '5 min',
    ),
    Lesson(
      id: 'groove-basics',
      title: 'Groove Basics',
      type: LessonType.movement,
      duration: '15 min',
      steps: [
        'FIND THE BEAT',
        'BOUNCE TECHNIQUE',
        'ARM SWING',
        'FULL GROOVE',
      ],
    ),
    Lesson(
      id: 'bounce-and-rock',
      title: 'Bounce & Rock',
      type: LessonType.drill,
      duration: '10 min',
    ),
    Lesson(
      id: 'freestyle-session',
      title: 'Freestyle Session',
      type: LessonType.experiment,
      duration: '20 min',
    ),
    Lesson(
      id: 'boss-showcase',
      title: 'Boss Showcase',
      type: LessonType.boss,
    ),
  ],
);
