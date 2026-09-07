import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/features/practice/model/practice.dart';
import 'package:forge_dance/features/practice/repository/practice_repository.dart';
import 'package:forge_dance/features/programmes/repository/programme_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('plugins.flutter.io/shared_preferences');
  final durable = <String, Object>{};
  var rejectNext = false;

  setUp(() {
    SharedPreferences.resetStatic();
    durable.clear();
    rejectNext = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'getAll') return Map<String, Object>.from(durable);
          final args = Map<String, Object?>.from(call.arguments as Map);
          final key = args['key'] as String;
          if (call.method == 'setString') {
            if (rejectNext) {
              rejectNext = false;
              return false;
            }
            durable[key] = args['value']!;
            return true;
          }
          if (call.method == 'remove') {
            durable.remove(key);
            return true;
          }
          throw StateError('Unexpected preference operation ${call.method}');
        });
  });

  tearDown(() {
    SharedPreferences.resetStatic();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('a rejected platform practice write cannot become a phantom successful retry', () async {
    final repository = PracticeRepository();
    final record = PracticeRecord(
      id: 'practice-recovery',
      blockId: 'pulse',
      title: 'Pulse',
      lessonId: 'common-time-weight-find-pulse',
      level: 1,
      performedAt: DateTime(2025, 1, 1),
      durationSeconds: 30,
      bpm: 60,
      attempts: 2,
      difficulty: 3,
      notes: '',
    );
    rejectNext = true;
    await expectLater(repository.record(record), throwsStateError);
    expect(await PracticeRepository().getAll(), isEmpty);
    await repository.record(record);
    await (await SharedPreferences.getInstance()).reload();
    expect((await PracticeRepository().getAll()).single.id, record.id);
  });

  test('rejected enrolment is absent until a durable retry succeeds', () async {
    final repository = ProgrammeRepository();
    rejectNext = true;
    await expectLater(repository.enrol('find-the-beat'), throwsStateError);
    expect(await ProgrammeRepository().getEnrolledIds(), isEmpty);
    await repository.enrol('find-the-beat');
    await (await SharedPreferences.getInstance()).reload();
    expect(await ProgrammeRepository().getEnrolledIds(), {'find-the-beat'});
  });
}
