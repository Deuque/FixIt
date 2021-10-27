import 'dart:io';

import 'package:fix_it/util/asset_util.dart';
import 'package:fix_it/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectImage extends StatelessWidget {
  final double size;
  final ValueChanged<File> onImageGotten;

  const SelectImage({Key? key, required this.size, required this.onImageGotten})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()async{
        final ImagePicker _picker = ImagePicker();
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        final imageFile = image?.path!=null ? File(image!.path) : null;
        if(imageFile!=null)
          onImageGotten.call(imageFile);
      },
      child: Stack(
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
      ),
    );
  }
}
