import 'package:flutter/cupertino.dart';

class SizeUtil{
  SizeUtil._();
  static late double sHeight;
  static late double sWidth;

  static void init(BuildContext context){
    final size = MediaQuery.of(context).size;
    sHeight = size.height;
    sWidth = size.width;
  }

}

