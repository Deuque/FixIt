
import 'dart:core' as c;
import 'dart:io';

import 'package:flutter/material.dart';

const c.String imgAssetPath = 'assets/images';
const c.String homeIcon= '$imgAssetPath/home.png';
const c.String crownIcon = '$imgAssetPath/crown.png';
const c.String shareIcon = '$imgAssetPath/share.png';
const c.String downArrowIcon = '$imgAssetPath/arrow.png';
const c.String newImageIcon = '$imgAssetPath/new_image.png';
const c.String dottedLineIcon = '$imgAssetPath/dotted_line.png';
const c.String tempPuzzleImage = '$imgAssetPath/temp_image.jpeg';
const c.String emptyPuzzleIcon = '$imgAssetPath/puzzle.png';

ImageProvider assetProvider(image){
  final ImageProvider imageObject;
  if (image is c.String)
    imageObject = AssetImage(image);
  else
    imageObject = FileImage(image as File);
  return imageObject;
}
