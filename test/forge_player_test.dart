import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/features/media/model/local_media.dart';
import 'package:forge_dance/features/media/repository/media_repository.dart';
import 'package:forge_dance/features/practice_player/model/practice_clock.dart';
import 'package:sembast/sembast_memory.dart';

class _ManualStopwatch implements Stopwatch {
  int micros = 0;
  bool active = false;
  void advance(Duration elapsed) {
    if (active) micros += elapsed.inMicroseconds;
  }

  @override
  int get elapsedMicroseconds => micros;
  @override
  int get elapsedMilliseconds => micros ~/ 1000;
  @override
  int get elapsedTicks => micros;
  @override
  int get frequency => 1000000;
  @override
  Duration get elapsed => Duration(microseconds: micros);
  @override
  bool get isRunning => active;
  @override
  void start() => active = true;
  @override
  void stop() => active = false;
  @override
  void reset() => micros = 0;
}

void main() {
  test(
    'count-in and every pause are excluded from measured active practice',
    () {
      final time = _ManualStopwatch();
      final clock = PracticeClock(bpm: 60, stopwatch: time);
      addTearDown(clock.dispose);
      clock.start();
      time.advance(const Duration(seconds: 3));
      expect(clock.countIn, 1);
      expect(clock.activeDuration, Duration.zero);
      time.advance(const Duration(seconds: 6));
      expect(clock.activeDuration, const Duration(seconds: 5));
      clock.pause();
      time.advance(const Duration(hours: 1));
      expect(clock.activeDuration, const Duration(seconds: 5));
      clock.start();
      time.advance(const Duration(seconds: 6));
      expect(clock.activeDuration, const Duration(seconds: 7));
      clock.pause();
      expect(clock.activeDuration, const Duration(seconds: 7));
    },
  );

  test('tempo changes preserve actual duration and selected phrase wraps', () {
    final time = _ManualStopwatch();
    final clock = PracticeClock(bpm: 60, stopwatch: time);
    addTearDown(clock.dispose);
    clock.setPhrase(3, 5);
    clock.start();
    time.advance(const Duration(seconds: 7));
    expect(clock.beat, 3);
    expect(clock.activeDuration, const Duration(seconds: 3));
    clock.setTempo(120);
    expect(clock.running, false);
    clock.start();
    time.advance(const Duration(milliseconds: 3500));
    expect(clock.beat, 3);
    expect(clock.activeDuration, const Duration(milliseconds: 4500));
    expect(clock.attempts, 2);
    clock.setPhrase(1, 1);
    expect(clock.attempts, 2);
  });

  test('synthesized pulse spacing matches selected tempo with silent gaps', () {
    final wav = makeMetronomeWav(120);
    final data = ByteData.sublistView(wav);
    expect(ascii.decode(wav.sublist(0, 4)), 'RIFF');
    expect(data.getUint32(40, Endian.little) / 2 / 22050, 4);
    expect(data.getInt16(44 + 100 * 2, Endian.little), isNot(0));
    expect(data.getInt16(44 + 1000 * 2, Endian.little), 0);
    expect(data.getInt16(44 + (11025 + 100) * 2, Endian.little), isNot(0));
  });

  test(
    'bad portable media restores leave the existing evidence intact',
    () async {
      final db = await databaseFactoryMemory.openDatabase('media_restore');
      addTearDown(db.close);
      final repository = MediaRepository(database: Future.value(db));
      final bytes = Uint8List.fromList([
        0,
        0,
        0,
        16,
        ...ascii.encode('ftypisom'),
        0,
        0,
        0,
        0,
      ]);
      final backup = <Object?>[
        {
          'id': 'evidence1',
          'title': 'My step touch.mp4',
          'mimeType': 'video/mp4',
          'importedAt': '2026-09-01T10:00:00.000',
          'byteLength': bytes.length,
          'bytes': base64Encode(bytes),
        },
      ];
      await repository.replaceFromJson(backup);
      await expectLater(
        repository.replaceFromJson([...backup, ...backup]),
        throwsFormatException,
      );
      final reopened = MediaRepository(database: Future.value(db));
      expect(await reopened.readBytes('evidence1'), orderedEquals(bytes));
      expect((await reopened.getAll()).single.id, 'evidence1');
      expect(await reopened.exportJson(), backup);
      expect(
        () => validateMediaBackup([
          {
            ...(backup.single! as Map<String, Object?>),
            'byteLength': maxMediaBytes + 1,
          },
        ]),
        throwsFormatException,
      );
    },
  );
}
