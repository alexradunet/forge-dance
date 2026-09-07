import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:media_kit/media_kit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast.dart';

import '../model/local_media.dart';
import 'media_database_native.dart'
    if (dart.library.js_interop) 'media_database_web.dart';

part 'media_repository.g.dart';

@Riverpod(keepAlive: true)
MediaRepository mediaRepository(Ref ref) => MediaRepository();

class MediaImportException implements Exception {
  const MediaImportException(this.reason);
  final String reason;
  @override
  String toString() => reason;
}

/// Video bytes live in an app-private transactional database, never a picker URL.
/// On web this is IndexedDB; clearing site data removes them. Export for backup.
class MediaRepository {
  MediaRepository({Future<Database>? database})
    : _database = database ?? openMediaDatabase();
  final Future<Database> _database;
  final _store = stringMapStoreFactory.store('videos');

  Future<List<LocalMedia>> getAll() async {
    final records = await _store.find(await _database);
    return records.map((record) => LocalMedia.fromJson(record.value)).toList()
      ..sort((a, b) => b.importedAt.compareTo(a.importedAt));
  }

  Future<LocalMedia?> get(String id) async {
    final json = await _store.record(id).get(await _database);
    return json == null ? null : LocalMedia.fromJson(json);
  }

  Future<Uint8List> readBytes(String id) async {
    final json = await _store.record(id).get(await _database);
    if (json == null) throw const MediaImportException('missing');
    return base64Decode(json['bytes'] as String);
  }

  /// A cancelled OS picker returns null, and never creates an empty record.
  Future<LocalMedia?> pickAndImportVideo() async {
    final file = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(
          label: 'Video',
          extensions: ['mp4', 'm4v', 'mov', 'webm'],
          mimeTypes: ['video/mp4', 'video/quicktime', 'video/webm'],
          uniformTypeIdentifiers: ['public.movie'],
        ),
      ],
    );
    if (file == null) return null;
    final length = await file.length();
    if (length <= 0 || length > maxMediaBytes) {
      throw const MediaImportException('size');
    }
    return importVideo(title: file.name, bytes: await file.readAsBytes());
  }

  Future<LocalMedia> importVideo({
    required String title,
    required Uint8List bytes,
  }) async {
    if (bytes.isEmpty || bytes.length > maxMediaBytes) {
      throw const MediaImportException('size');
    }
    String type;
    try {
      type = detectVideoType(bytes);
    } on FormatException {
      throw const MediaImportException('unsupported');
    }
    await _checkPlayable(bytes, type);
    final random = Random.secure();
    final id = List.generate(
      16,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
    final name = title.trim();
    if (name.isEmpty || name.length > 240) {
      throw const MediaImportException('name');
    }
    final item = LocalMedia(
      id: id,
      title: name,
      mimeType: type,
      importedAt: DateTime.now(),
      byteLength: bytes.length,
    );
    final encoded = base64Encode(bytes);
    final db = await _database;
    await db.transaction((transaction) async {
      final records = await _store.find(transaction);
      final total = records.fold<int>(
        0,
        (sum, record) => sum + (record.value['byteLength'] as int),
      );
      if (total + bytes.length > maxMediaLibraryBytes ||
          records.length >= 500) {
        throw const MediaImportException('quota');
      }
      await _store.record(id).put(transaction, {
        ...item.toJson(),
        'bytes': encoded,
      });
    });
    return item;
  }

  Future<void> _checkPlayable(Uint8List bytes, String type) async {
    final media = await Media.memory(bytes, type: type);
    final player = Player();
    final ready = Completer<void>();
    final errors = player.stream.error.listen((_) {
      if (!ready.isCompleted) {
        ready.completeError(const MediaImportException('unsupported'));
      }
    });
    final widths = player.stream.width.listen((width) {
      if (width != null && width > 0 && !ready.isCompleted) ready.complete();
    });
    try {
      await Future.wait<void>([player.open(media, play: false), ready.future])
          .timeout(const Duration(seconds: 15));
    } on Object {
      throw const MediaImportException('unsupported');
    } finally {
      if (!ready.isCompleted) ready.complete();
      await errors.cancel();
      await widths.cancel();
      await player.dispose();
    }
  }

  Future<void> delete(String id) async {
    await _store.record(id).delete(await _database);
  }

  /// Includes original bytes; also usable as a rollback snapshot by Settings.
  Future<List<Map<String, Object?>>> exportJson() async =>
      (await _store.find(await _database))
          .map((record) => Map<String, Object?>.from(record.value))
          .toList();

  static List<Map<String, Object?>> validateJson(List<Object?> json) =>
      validateMediaBackup(json);

  /// Atomic replacement, including bytes. No writes occur if validation fails.
  Future<void> replaceFromJson(List<Object?> json) async {
    final validated = validateJson(json);
    final db = await _database;
    await db.transaction((transaction) async {
      await _store.delete(transaction);
      for (final item in validated) {
        await _store.record(item['id'] as String).put(transaction, item);
      }
    });
  }
}
