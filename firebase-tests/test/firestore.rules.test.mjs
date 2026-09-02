import assert from 'node:assert/strict';
import { after, before, beforeEach, describe, it } from 'node:test';

import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import { doc, getDoc, setDoc } from 'firebase/firestore';

const projectId = 'demo-forge-dance';
let testEnvironment;

before(async () => {
  testEnvironment = await initializeTestEnvironment({ projectId });
});

beforeEach(async () => {
  await testEnvironment.clearFirestore();
});

after(async () => {
  await testEnvironment.cleanup();
});

function userDocument(database, userId) {
  return doc(database, 'users', userId);
}

function profile(userId, overrides = {}) {
  return {
    id: userId,
    email: `${userId}@example.com`,
    name: 'Forge Dancer',
    xp: 0,
    streakCount: 0,
    ...overrides,
  };
}

describe('user profiles', () => {
  it('allows owners to create and read their profile', async () => {
    const ownerDb = testEnvironment.authenticatedContext('dancer-1').firestore();
    const reference = userDocument(ownerDb, 'dancer-1');

    await assertSucceeds(setDoc(reference, profile('dancer-1')));
    const snapshot = await assertSucceeds(getDoc(reference));

    assert.equal(snapshot.data().id, 'dancer-1');
  });

  it('denies unauthenticated and non-owner reads', async () => {
    await testEnvironment.withSecurityRulesDisabled(async (context) => {
      await setDoc(
        userDocument(context.firestore(), 'dancer-1'),
        profile('dancer-1'),
      );
    });

    const guestDb = testEnvironment.unauthenticatedContext().firestore();
    const otherDb = testEnvironment.authenticatedContext('dancer-2').firestore();

    await assertFails(getDoc(userDocument(guestDb, 'dancer-1')));
    await assertFails(getDoc(userDocument(otherDb, 'dancer-1')));
  });

  it('rejects mismatched ids and invalid stats', async () => {
    const ownerDb = testEnvironment.authenticatedContext('dancer-1').firestore();
    const reference = userDocument(ownerDb, 'dancer-1');

    await assertFails(setDoc(reference, profile('dancer-2')));
    await assertFails(setDoc(reference, profile('dancer-1', { xp: -1 })));
    await assertFails(
      setDoc(reference, profile('dancer-1', { streakCount: 'twelve' })),
    );
  });
});

describe('lesson progress', () => {
  it('allows valid owner progress and rejects invalid identity or status', async () => {
    const ownerDb = testEnvironment.authenticatedContext('dancer-1').firestore();
    const reference = doc(ownerDb, 'users/dancer-1/progress/lesson-1');

    await assertSucceeds(
      setDoc(reference, {
        lessonId: 'lesson-1',
        status: 'inProgress',
        progress: 0.5,
        awardedXp: 0,
      }),
    );
    await assertFails(
      setDoc(reference, { lessonId: 'lesson-2', status: 'completed' }),
    );
    await assertFails(
      setDoc(reference, { lessonId: 'lesson-1', status: 'unknown' }),
    );
  });

  it('denies non-owner progress access', async () => {
    const otherDb = testEnvironment.authenticatedContext('dancer-2').firestore();
    const reference = doc(otherDb, 'users/dancer-1/progress/lesson-1');

    await assertFails(getDoc(reference));
    await assertFails(
      setDoc(reference, { lessonId: 'lesson-1', status: 'notStarted' }),
    );
  });
});

describe('workout sessions', () => {
  it('requires the deterministic date and workout document id', async () => {
    const ownerDb = testEnvironment.authenticatedContext('dancer-1').firestore();
    const validReference = doc(
      ownerDb,
      'users/dancer-1/sessions/2026-09-01_workout-1',
    );
    const invalidReference = doc(
      ownerDb,
      'users/dancer-1/sessions/arbitrary-id',
    );
    const session = {
      workoutId: 'workout-1',
      date: '2026-09-01',
      awardedXp: 100,
    };

    await assertSucceeds(setDoc(validReference, session));
    await assertFails(setDoc(invalidReference, session));
  });
});
