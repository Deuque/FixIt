import 'package:flutter/cupertino.dart';

class SizeUtil{
  SizeUtil._();
  static late final double sHeight;
  static late final double sWidth;

  static void init(BuildContext context){
    final size = MediaQuery.of(context).size;
    sHeight = size.height;
    sWidth = size.width;
  }

}

