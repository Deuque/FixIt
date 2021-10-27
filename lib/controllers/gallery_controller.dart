import 'dart:io';

import 'package:fix_it/data/gallery_repository.dart';
import 'package:fix_it/util/asset_util.dart';
import 'package:flutter/cupertino.dart';

class GalleryController extends ChangeNotifier{
  final GalleryRepository repository;
  bool _isExpanded = true;

  GalleryController(this.repository){
    loadGalleryImages();
  }
  bool get isExpanded => _isExpanded;
  ValueNotifier<List<dynamic>> _galleryImages = ValueNotifier([]);
  ValueNotifier<List<dynamic>> get galleryImages => _galleryImages;

  ValueNotifier<dynamic> _imageInPlay = ValueNotifier(null);
  ValueNotifier<dynamic> get imageInPlay => _imageInPlay;


  void toggleExpanded(){
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  void loadGalleryImages()async{
    final images = await repository.getGalleryImages();
    _galleryImages.value = [...images,tempPuzzleImage];
  }

  void saveGalleryImage(File file)async{
    repository.saveGalleryImage(file);
    _galleryImages.value = [file, ...galleryImages.value];
  }

  void setImageInPlay(dynamic image){
    assert(image is String || image is File);
    _imageInPlay.value = image;
  }




}