import 'dart:io';

import 'package:fix_it/util/asset_util.dart';
import 'package:fix_it/util/styles.dart';
import 'package:flutter/material.dart';

class GalleryImage extends StatelessWidget {
  final dynamic image;
  final double size;
  final ValueChanged<dynamic> onClick;
  final ValueChanged<dynamic> onLongPress;
  final bool inPlay;

  const GalleryImage(
      {Key? key,
      required this.image,
      required this.size,
      required this.onClick,
      required this.inPlay,
      required this.onLongPress})
      : assert(image is String || image is File),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick.call(image),
      onLongPress: () => onLongPress.call(image),
      customBorder: CircleBorder(),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
            border: inPlay ? Border.all(color: primary, width: 2) : null,
            borderRadius: BorderRadius.circular(10),
            color: black,
            image: DecorationImage(
                image: assetProvider(image), fit: BoxFit.cover)),
      ),
    );
  }
}
