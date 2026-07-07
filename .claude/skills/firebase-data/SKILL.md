---
name: firebase-data
description: Work with Firebase Auth, Cloud Firestore, and local persistence in Forge Dance — repositories, nullable Firebase providers, firestore.rules, and the local-first SharedPreferences cache. Use when adding data storage, new Firestore collections or fields, auth flows, security rules, or fixing sync/persistence/offline issues.
---

# Firebase & Data Layer

Firebase project: `forge-dance-1bcc7` (Auth email/password + Cloud Firestore). Chosen for MVP speed — **do not add another backend-as-a-service dependency**.

## Golden rule

Firebase SDKs (`FirebaseAuth`, `FirebaseFirestore`, …) are called ONLY inside repository classes. Widgets and view models never import Firebase packages. Widgets → view models → repositories → Firebase.

## The nullable-provider pattern

`lib/features/firebase/repository/firebase_providers.dart` gates everything on whether Firebase initialized (`Firebase.apps.isNotEmpty`):

```dart
@Riverpod(keepAlive: true)
firebase_auth.FirebaseAuth? firebaseAuth(Ref ref) {
  if (!ref.watch(isFirebaseConfiguredProvider)) return null;
  return firebase_auth.FirebaseAuth.instance;
}
```

Firebase is **null on Linux** (FlutterFire generated no Linux options; `main.dart` catches `UnsupportedError`) and in unconfigured environments. Consequences:

- Repositories take `FirebaseAuth?` / `FirebaseFirestore?` constructor params and expose `bool get isFirebaseConfigured`.
- Methods either no-op gracefully (`_auth?.signOut()`), fall back to local data, or throw a domain exception via an assert-style guard (see `AuthenticationRepository._assertFirebaseConfigured`).
- This same nullability is what makes test fakes trivial (`FakeXRepository(...) : super(auth: null, firestore: null)`).

## Firestore schema & conventions

Current schema — all owner-only, validated on write:

```
users/{userId}:                      id, email, name, job, avatar, diamond, createdAt, updatedAt,
                                     xp, streakCount, lastActivityDate
users/{userId}/progress/{lessonId}:  lessonId, status, progress, updatedAt
users/{userId}/sessions/{date}_{workoutId}: workoutId, date, completedAt
```

Reference implementations:

- `ProfileRepository` owns `users/{userId}` profile persistence. The stats
  fields are denormalized mirrors written by `StatsCoordinator`, not the source
  of truth for XP.
- `ProgressRepository` owns `users/{userId}/progress/{lessonId}`.
- `SessionRepository` owns `users/{userId}/sessions/{date}_{workoutId}`. The
  deterministic session doc id makes completing the same workout on the same day
  idempotent and caps workout XP at one award per workout per day.

**Typed references (`withConverter`) are mandatory for new Firestore access.** One converter per collection, defined inside the repository — never pass raw maps around:

```dart
CollectionReference<LessonProgress>? _progressRef() {
  final user = _auth?.currentUser;
  final firestore = _firestore;
  if (firestore == null || user == null) return null;

  return firestore
      .collection('users').doc(user.uid).collection('progress')
      .withConverter<LessonProgress>(
        fromFirestore: (snapshot, _) =>
            LessonProgress.fromJson(_normalizeFirestoreJson(snapshot.data()!)),
        toFirestore: (progress, _) => _firestorePayload(progress),
      );
}
```

Conventions (reference implementations: `ProgressRepository`, `SessionRepository`, `ProfileRepository`, `AuthenticationRepository`):

- Writes use `SetOptions(merge: true)`; set `updatedAt: FieldValue.serverTimestamp()` inside the `toFirestore` payload, `createdAt` only on first create.
- Reads normalize Firestore types before `fromJson`: `Timestamp` → **ISO-8601 string** (json_serializable parses strings for `DateTime` fields) — see `_normalizeFirestoreJson`.
- Map `FirebaseAuthException` codes to human-readable messages and rethrow as a domain exception (`AuthenticationException`) — view models surface `error.toString()`.

## Local-first persistence

`ProfileRepository` is the reference: SharedPreferences is the cache/fallback, Firestore is the source of truth when signed in.

- `get()`: read local + remote, prefer remote, merge local-only fields back in.
- `update()`: write local first, then Firestore if configured + signed in.
- Local file paths (e.g. picked avatar images, saved under app documents by `ProfileViewModel.saveImage`) are **never synced to Firestore** — only URLs are.
- SharedPreferences keys live in `Constants` (`profileKey`, `isExistAccountKey`, `themeModeKey`). Add new keys there, never inline.

## Security rules (`firestore.rules`)

Rules are v2, owner-only, and **validate writes** — they don't just gate access. Current invariants: `users/{userId}.id` must equal the auth uid; optional stats fields (`xp`, `streakCount`, `lastActivityDate`) must pass `validStats()`; `progress/{lessonId}.lessonId` must equal the doc id and `status` must be a whitelisted `LessonStatus` name (keep the whitelist in sync with the enum); `sessions/{date}_{workoutId}` must mirror its `date` and `workoutId` fields in the doc id. When adding a collection:

1. Add an explicit `match` block (subcollections inherit NOTHING — everything unmatched is default-deny).
2. Validate `request.resource.data` on create/update: ownership fields match `request.auth.uid`, ids mirror the doc path, enum fields whitelisted. Put validation on `create, update` only — `delete` has no `request.resource`.
3. Reuse the `signedIn()` / `ownsUserDocument()` helper style.
4. Deploy: `firebase deploy --only firestore:rules` (config wired in `firebase.json`). Composite indexes go in `firestore.indexes.json`.
5. Remember: rules are not filters — queries must be shaped so they can only return permitted docs.

Rules are NOT applied automatically — an undeployed rules change is the usual cause of `permission-denied` errors.

## Local development: Firebase Emulator Suite

Never exercise auth/Firestore behavior against production. Instead:

```bash
firebase emulators:start        # auth :9099, firestore :8080, UI enabled (firebase.json)
flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

The flag is read in `lib/features/firebase/repository/firebase_bootstrap.dart`, which points `FirebaseAuth` and `FirebaseFirestore` at localhost right after `Firebase.initializeApp`. Unit tests do NOT need the emulator — fakes cover the logic layer.

## Auth/session flows

**Auth state is a stream.** `authStateChangesProvider` (keepAlive, in `authentication_repository.dart`) wraps `FirebaseAuth.authStateChanges()` and is the single source of truth — it emits `null` immediately when Firebase is unconfigured. `AuthenticationViewModel` derives its state by watching it; never store a parallel logged-in flag.

Navigation reacts automatically: the router's `refreshListenable` re-runs `computeRedirect` (`lib/routing/app_redirect.dart`) on every emission. Sign-out anywhere lands the user on login with zero imperative navigation.

Cross-feature auth flows go through `SessionCoordinator` (`features/session/application/`): register/sign-in delegates to `AuthenticationViewModel`, then syncs `ProfileViewModel`; sign-out clears the profile. Extend the coordinator for new session-wide behavior — don't chain view models from widgets.

Gamification writes go through `StatsCoordinator` (`features/stats/application/`): after a lesson or workout is completed, it derives XP from `LearnViewModel` progress plus `WorkoutViewModel` sessions, computes streak transitions with `stats_rules.dart`, and updates the profile document. New training flows should call that coordinator after their own persistence succeeds and should treat stat sync as best-effort.

## Environment setup (for humans/CI running against real Firebase)

- `flutterfire configure --project=forge-dance-1bcc7` regenerates `lib/firebase_options.dart` + platform configs.
- Firebase Console prerequisites: **Authentication → Email/Password enabled** and a **Firestore database** created.
- Without these, the app still runs — auth-dependent features degrade per the nullable pattern.
