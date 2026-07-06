import '../model/workout.dart';

/// Static workout content (same philosophy as lesson_catalog.dart): content
/// ships with the app, only session completions are persisted. XP values
/// feed the stats system — keep them modest relative to lesson XP so the
/// belt ladder stays lesson-driven (see CLAUDE.md, Gamification rules).
const List<Workout> allWorkouts = [
  Workout(
    id: 'body-control',
    title: 'Body Control',
    description:
        'Master your movement with this fundamental sequence designed to improve awareness and stability.',
    style: 'Modern',
    difficulty: 'Intermediate',
    imageUrl:
        'https://images.unsplash.com/photo-1599058945522-28d584b6f0ff?q=80&w=2069&auto=format&fit=crop',
    xp: 40,
    estimatedMinutes: 25,
    exercises: [
      WorkoutExercise(name: 'Top Rock Basic', seconds: 45),
      WorkoutExercise(name: 'Indian Step', seconds: 45),
      WorkoutExercise(name: '6-Step Drill', seconds: 60),
      WorkoutExercise(name: 'Baby Freeze Hold', seconds: 30),
    ],
  ),
  Workout(
    id: 'groove-cardio',
    title: 'Groove Cardio',
    description:
        'Keep the bounce alive: a continuous groove circuit that builds rhythm endurance.',
    style: 'Hip Hop',
    difficulty: 'Beginner',
    imageUrl:
        'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800&auto=format&fit=crop&q=80',
    xp: 40,
    estimatedMinutes: 20,
    exercises: [
      WorkoutExercise(name: 'Bounce Warm-Up', seconds: 45),
      WorkoutExercise(name: 'Two-Step Flow', seconds: 60),
      WorkoutExercise(name: 'Arm Wave Circuit', seconds: 45),
      WorkoutExercise(name: 'Freestyle Burnout', seconds: 60),
    ],
  ),
  Workout(
    id: 'power-foundations',
    title: 'Power Foundations',
    description:
        'Explosive strength for breaking: condition the body that powers your downrock.',
    style: 'Breaking',
    difficulty: 'Advanced',
    imageUrl:
        'https://images.unsplash.com/photo-1535525153412-5a42439a210d?w=800&q=80',
    xp: 50,
    estimatedMinutes: 30,
    exercises: [
      WorkoutExercise(name: 'Plank to Downrock', seconds: 45),
      WorkoutExercise(name: 'Six-Step Speed Run', seconds: 60),
      WorkoutExercise(name: 'Freeze Conditioning', seconds: 45),
      WorkoutExercise(name: 'Power Prep Jumps', seconds: 45),
    ],
  ),
  Workout(
    id: 'mobility-flow',
    title: 'Mobility Flow',
    description:
        'Open up hips, shoulders, and spine — the quiet work behind every smooth move.',
    style: 'Mobility',
    difficulty: 'Beginner',
    imageUrl:
        'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=400&auto=format&fit=crop&q=80',
    xp: 30,
    estimatedMinutes: 20,
    exercises: [
      WorkoutExercise(name: 'Hip Opener Flow', seconds: 60),
      WorkoutExercise(name: 'Shoulder Circles', seconds: 45),
      WorkoutExercise(name: 'Spine Waves', seconds: 60),
      WorkoutExercise(name: 'Deep Squat Hold', seconds: 45),
    ],
  ),
  Workout(
    id: 'footwork-blast',
    title: 'Footwork Blast',
    description:
        'Fast feet win battles: speed and precision drills for sharper steps.',
    style: 'Technique',
    difficulty: 'Intermediate',
    imageUrl:
        'https://images.unsplash.com/photo-1716996642138-e655f2a8dcd5?w=400&auto=format&fit=crop&q=80',
    xp: 40,
    estimatedMinutes: 25,
    exercises: [
      WorkoutExercise(name: 'Speed Ladder Steps', seconds: 45),
      WorkoutExercise(name: 'Kick-Ball-Change Reps', seconds: 45),
      WorkoutExercise(name: 'Crossover Drills', seconds: 60),
      WorkoutExercise(name: 'Footwork Freestyle', seconds: 60),
    ],
  ),
  Workout(
    id: 'isolation-lab',
    title: 'Isolation Lab',
    description:
        'Precision session: isolate chest, hips, and head until each moves on its own.',
    style: 'Popping',
    difficulty: 'Intermediate',
    imageUrl:
        'https://images.unsplash.com/photo-1547153760-18fc86324498?w=800&q=80',
    xp: 40,
    estimatedMinutes: 25,
    exercises: [
      WorkoutExercise(name: 'Chest Pops', seconds: 45),
      WorkoutExercise(name: 'Hip Isolations', seconds: 45),
      WorkoutExercise(name: 'Head Slides', seconds: 45),
      WorkoutExercise(name: 'Robot Sequence', seconds: 60),
    ],
  ),
  Workout(
    id: 'endurance-groove',
    title: 'Endurance Groove',
    description:
        'Outlast the cypher: long-form groove intervals that build stamina.',
    style: 'House',
    difficulty: 'Advanced',
    imageUrl:
        'https://images.unsplash.com/photo-1504609813442-a8924e83f76e?w=800&q=80',
    xp: 50,
    estimatedMinutes: 30,
    exercises: [
      WorkoutExercise(name: 'Continuous Groove', seconds: 90),
      WorkoutExercise(name: 'Interval Bounce', seconds: 60),
      WorkoutExercise(name: 'Level Changes', seconds: 60),
      WorkoutExercise(name: 'Cool-Down Flow', seconds: 45),
    ],
  ),
];

/// Deterministic workout-of-the-day: rotates through the catalog by
/// day-of-year, so every user sees the same WOD on the same date with no
/// backend involved.
Workout wodFor(DateTime date) {
  final startOfYear = DateTime(date.year);
  final dayOfYear = date.difference(startOfYear).inDays;
  return allWorkouts[dayOfYear % allWorkouts.length];
}
