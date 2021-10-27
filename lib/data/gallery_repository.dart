import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class GalleryRepository {
  final _galleryKey = 'GALLERY';

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  Future<List<File>> getGalleryImages() async {
    final pref = await _prefs;
    final galleryPaths = pref.getStringList(_galleryKey) ?? <String>[];
    final galleryImages = galleryPaths.map((e) => File(e)).toList();
    final filteredImages = <File>[];
    for (final item in galleryImages) {
      final file = File(item.path);
      if (await file.exists()) filteredImages.add(file);
    }
    return filteredImages;
  }

  Future<void> saveGalleryImage(File file) async {
    final pref = await _prefs;
    final galleryPaths = pref.getStringList(_galleryKey) ?? <String>[];
    if (!galleryPaths.contains(file.path)) galleryPaths.insert(0, file.path);
    pref.setStringList(_galleryKey, galleryPaths);
  }

  Future<void> deleteGalleryImage(File file) async {
    final pref = await _prefs;
    final galleryPaths = pref.getStringList(_galleryKey) ?? <String>[];
    if (!galleryPaths.contains(file.path)) galleryPaths.remove(file.path);
    pref.setStringList(_galleryKey, galleryPaths);
  }
}
