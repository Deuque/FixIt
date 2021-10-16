import 'package:flutter/cupertino.dart';

class GalleryController extends ChangeNotifier{
  bool _isExpanded = true;
  bool get isExpanded => _isExpanded;

  void toggleExpanded(){
    _isExpanded = !_isExpanded;
    notifyListeners();
  }


}