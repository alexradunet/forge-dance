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

Current schema — one collection:

```
users/{userId}: id, email, name, job, avatar, diamond, createdAt, updatedAt
```

Conventions from `AuthenticationRepository` / `ProfileRepository`:

- Writes use `SetOptions(merge: true)`; set `updatedAt: FieldValue.serverTimestamp()` on every write and `createdAt` only on first create.
- Build payloads field-by-field, skipping nulls — don't blindly `toJson()` the whole model.
- Reads normalize Firestore types before `fromJson`: convert `Timestamp` → `DateTime` (see `_normalizeFirestoreJson`).
- Map `FirebaseAuthException` codes to human-readable messages and rethrow as a domain exception (`AuthenticationException`) — view models surface `error.toString()`.

## Local-first persistence

`ProfileRepository` is the reference: SharedPreferences is the cache/fallback, Firestore is the source of truth when signed in.

- `get()`: read local + remote, prefer remote, merge local-only fields back in.
- `update()`: write local first, then Firestore if configured + signed in.
- Local file paths (e.g. picked avatar images, saved under app documents by `ProfileViewModel.saveImage`) are **never synced to Firestore** — only URLs are.
- SharedPreferences keys live in `Constants` (`profileKey`, `isLoginKey`, `isExistAccountKey`, `themeModeKey`). Add new keys there, never inline.

## Security rules (`firestore.rules`)

Current rules allow owner-only access to `users/{userId}` via `request.auth.uid == userId`. When adding a collection:

1. Add a `match` block with explicit `allow` conditions — default-deny everything else.
2. Reuse the `signedIn()` / ownership helper-function style.
3. Deploy: `firebase deploy --only firestore:rules` (config wired in `firebase.json`).
4. Composite indexes go in `firestore.indexes.json`.

Rules are NOT applied automatically — an undeployed rules change is the usual cause of `permission-denied` errors.

## Auth/session flows

Cross-feature auth flows go through `SessionCoordinator` (`features/session/application/`): register/sign-in delegates to `AuthenticationViewModel`, then syncs `ProfileViewModel`; sign-out clears the profile. Extend the coordinator for new session-wide behavior — don't chain view models from widgets.

Boot decision (splash): session or `isLogin` flag → `/main`; `isExistAccount` → `/login`; else `/register`.

## Environment setup (for humans/CI running against real Firebase)

- `flutterfire configure --project=forge-dance-1bcc7` regenerates `lib/firebase_options.dart` + platform configs.
- Firebase Console prerequisites: **Authentication → Email/Password enabled** and a **Firestore database** created.
- Without these, the app still runs — auth-dependent features degrade per the nullable pattern.
