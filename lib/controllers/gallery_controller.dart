import 'dart:io';

import 'package:fix_it/data/gallery_repository.dart';
import 'package:fix_it/util/asset_util.dart';
import 'package:fix_it/util/screen_size_util.dart';
import 'package:flutter/cupertino.dart';

class GalleryController extends ChangeNotifier {
  final GalleryRepository repository;
  bool _isExpanded = true;

  GalleryController(this.repository) {
    loadGalleryImages();
  }

  bool get isExpanded => _isExpanded;
  ValueNotifier<List<dynamic>> _galleryImages = ValueNotifier([]);

  ValueNotifier<List<dynamic>> get galleryImages => _galleryImages;

  ValueNotifier<dynamic> _imageInPlay = ValueNotifier(null);

  ValueNotifier<dynamic> get imageInPlay => _imageInPlay;

  double get _imageSize => SizeUtil.sHeight * .1;

  double get imageSize => _imageSize;

  void toggleExpanded() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  void loadGalleryImages() async {
    final images = await repository.getGalleryImages();
    _galleryImages.value = [...images, tempPuzzleImage];
  }

  void saveGalleryImage(File file) async {
    repository.saveGalleryImage(file);
    _galleryImages.value = [file, ...galleryImages.value];
  }

  void deleteGalleryImage(File file) async {
    repository.deleteGalleryImage(file);
    _galleryImages.value = galleryImages.value
        .where((element) =>
            element is String ? true : (element as File).path != file.path)
        .toList();
  }

  void setImageInPlay(dynamic image) {
    assert(image is String || image is File);
    _imageInPlay.value = image;
  }
}
