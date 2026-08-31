import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final deviceAvatarRepositoryProvider = Provider<DeviceAvatarRepository>(
  (_) => DeviceAvatarRepository(
    picker: GalleryAvatarPicker(),
    storage: LocalAvatarStorage(),
  ),
);

abstract interface class AvatarPicker {
  Future<String?> select();
}

class GalleryAvatarPicker implements AvatarPicker {
  GalleryAvatarPicker({ImagePicker? picker})
      : _picker = picker ?? ImagePicker();
  final ImagePicker _picker;

  @override
  Future<String?> select() async =>
      (await _picker.pickImage(source: ImageSource.gallery))?.path;
}

abstract interface class AvatarStorage {
  Future<String?> load(String identity);
  Future<String> save(String identity, String sourcePath);
}

class LocalAvatarStorage implements AvatarStorage {
  @override
  Future<String?> load(String identity) async {
    final value =
        (await SharedPreferences.getInstance()).getString(_key(identity));
    return value != null && File(value).existsSync() ? value : null;
  }

  @override
  Future<String> save(String identity, String sourcePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final target = File(
      '${directory.path}/avatar-$identity-${DateTime.now().millisecondsSinceEpoch}${path.extension(sourcePath)}',
    );
    await File(sourcePath).copy(target.path);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(identity), target.path);
    return target.path;
  }

  String _key(String identity) => 'device_avatar:$identity';
}

/// Device-only avatar module. Profile never persists these local paths.
class DeviceAvatarRepository {
  const DeviceAvatarRepository({
    required AvatarPicker picker,
    required AvatarStorage storage,
  })  : _picker = picker,
        _storage = storage;

  final AvatarPicker _picker;
  final AvatarStorage _storage;

  Future<String?> load(String identity) => _storage.load(identity);

  Future<String?> selectAndSave(String identity) async {
    final selected = await _picker.select();
    if (selected == null) return null;
    return _storage.save(identity, selected);
  }
}
