import 'dart:convert';
import 'dart:typed_data';

const maxMediaBytes = 20 * 1024 * 1024;
const maxMediaLibraryBytes = 100 * 1024 * 1024;

/// Private, user-supplied video. A source name is attribution, not verification.
class LocalMedia {
  const LocalMedia({
    required this.id,
    required this.title,
    required this.mimeType,
    required this.importedAt,
    required this.byteLength,
  });
  final String id;
  final String title;
  final String mimeType;
  final DateTime importedAt;
  final int byteLength;

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'mimeType': mimeType,
    'importedAt': importedAt.toIso8601String(),
    'byteLength': byteLength,
  };

  factory LocalMedia.fromJson(Map<String, Object?> json) {
    final id = json['id'];
    final title = json['title'];
    final type = json['mimeType'];
    final size = json['byteLength'];
    final date = json['importedAt'];
    if (id is! String ||
        !RegExp(r'^[a-zA-Z0-9_-]{1,100}$').hasMatch(id) ||
        title is! String ||
        title.trim().isEmpty ||
        title.length > 240 ||
        type is! String ||
        !const ['video/mp4', 'video/webm', 'video/quicktime'].contains(type) ||
        size is! int ||
        size <= 0 ||
        size > maxMediaBytes ||
        date is! String ||
        DateTime.tryParse(date) == null) {
      throw const FormatException('Invalid media metadata');
    }
    return LocalMedia(
      id: id,
      title: title,
      mimeType: type,
      importedAt: DateTime.parse(date),
      byteLength: size,
    );
  }
}

/// Checks container signatures before a decoder checks the actual video track.
String detectVideoType(Uint8List bytes) {
  if (bytes.length >= 12 &&
      ascii.decode(bytes.sublist(4, 8), allowInvalid: true) == 'ftyp') {
    return ascii.decode(bytes.sublist(8, 12), allowInvalid: true) == 'qt  '
        ? 'video/quicktime'
        : 'video/mp4';
  }
  if (bytes.length >= 4 &&
      bytes[0] == 0x1a &&
      bytes[1] == 0x45 &&
      bytes[2] == 0xdf &&
      bytes[3] == 0xa3) {
    return 'video/webm';
  }
  throw const FormatException('Unsupported video container');
}

/// Pure, complete validation used before a portable restore makes any writes.
List<Map<String, Object?>> validateMediaBackup(List<Object?> values) {
  var total = 0;
  final ids = <String>{};
  if (values.length > 500) throw const FormatException('Too many media items');
  return values
      .map((value) {
        if (value is! Map) throw const FormatException('Invalid media item');
        final json = Map<String, Object?>.from(value);
        final item = LocalMedia.fromJson(json);
        final encoded = json['bytes'];
        if (encoded is! String ||
            encoded.length > ((maxMediaBytes + 2) ~/ 3) * 4 ||
            !ids.add(item.id)) {
          throw const FormatException('Invalid media bytes or duplicate ID');
        }
        final bytes = base64Decode(encoded);
        if (bytes.length != item.byteLength ||
            detectVideoType(bytes) != item.mimeType) {
          throw const FormatException('Media bytes do not match metadata');
        }
        total += bytes.length;
        if (total > maxMediaLibraryBytes) {
          throw const FormatException('Media library exceeds 100 MiB');
        }
        return {...item.toJson(), 'bytes': encoded};
      })
      .toList(growable: false);
}
