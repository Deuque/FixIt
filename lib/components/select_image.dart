import 'dart:io';

import 'package:fix_it/util/asset_util.dart';
import 'package:fix_it/util/styles.dart';
import 'package:flutter/material.dart';

class SelectImage extends StatelessWidget {
  final double size;
  final ValueChanged<File> onImageGotten;

  const SelectImage({Key? key, required this.size, required this.onImageGotten})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          dottedLineIcon,
          height: size,
          color: white.withOpacity(.3),
        ),
        Positioned.fill(
          child: Center(
            child: Image.asset(
              newImageIcon,
              height: size/3,
              color: white.withOpacity(.3),
            ),
          ),
        ),
      ],
    );
  }
}
