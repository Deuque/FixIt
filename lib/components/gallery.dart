import 'dart:io';

import 'package:fix_it/components/dialogs/confirm_image_selection.dart';
import 'package:fix_it/components/gallery_image.dart';
import 'package:fix_it/components/icon_button.dart';
import 'package:fix_it/components/select_image.dart';
import 'package:fix_it/controllers/gallery_controller.dart';
import 'package:fix_it/locator.dart';
import 'package:fix_it/util/asset_util.dart';
import 'package:fix_it/util/styles.dart';
import 'package:flutter/material.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> with SingleTickerProviderStateMixin {
  late final AnimationController _toggleController = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  late final curvedAnimation = CurvedAnimation(
    parent: _toggleController,
    curve: Curves.decelerate,
  );
  late final Animation<double> _toggleAnimation =
      Tween<double>(begin: 0, end: .5).animate(curvedAnimation);
  late final Animation<double> _gallerySizeAnimation =
      Tween<double>(begin: 1, end: 0).animate(curvedAnimation);

  final GalleryController _galleryController = locator<GalleryController>();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _galleryController,
        builder: (context, child) {
          _galleryController.isExpanded
              ? _toggleController.reverse()
              : _toggleController.forward();

          return Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: black.withOpacity(.2), width: 6))),
            padding:
                EdgeInsets.symmetric(vertical: 15, horizontal: defHorPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Gallery',
                      style: TextStyle(color: white, fontSize: 16),
                    ),
                    RotationTransition(
                        turns: _toggleAnimation,
                        child: MIcon(
                            imgName: downArrowIcon,
                            onTap: () {
                              _galleryController.toggleExpanded();
                            },
                            size: 14))
                  ],
                ),
                SizeTransition(
                  sizeFactor: _gallerySizeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: _galleryRow(),
                  ),
                )
              ],
            ),
          );
        });
  }

  void _showConfirmImageDialog(dynamic image) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          child:

          ConfirmImageDialog(
            onCancel: () {
              Navigator.pop(context);
            },
            onPlay: () {
              Navigator.pop(context);
              _galleryController.setImageInPlay(image);
            },
            assetOrFile: image,
          ),
        ));
  }

  Widget _galleryRow() => Row(
        children: [
          SelectImage(
              size: 80,
              onImageGotten: (image) {
                _galleryController.saveGalleryImage(image);
              }),
          SizedBox(
            width: 15,
          ),
          ValueListenableBuilder<List<dynamic>>(
              valueListenable: _galleryController.galleryImages,
              builder: (context, images, child) {
                return Expanded(
                    child: SizedBox(
                  height: 80,
                  child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, i) {
                        final image = images[i];
                        final identifier =
                            image is String ? image : (image as File).path;

                        return ValueListenableBuilder(
                            valueListenable: _galleryController.imageInPlay,
                            builder: (_, value, child) {
                              final inPlayIdentifier = value == null
                                  ? null
                                  : value is String
                                      ? value
                                      : (value as File).path;
                              return GalleryImage(
                                  image: image,
                                  size: 80,
                                  onClick: (image) {
                                    _showConfirmImageDialog(image);
                                  },
                                  inPlay: identifier == inPlayIdentifier);
                            });
                      },
                      separatorBuilder: (_, i) => SizedBox(
                            width: 15,
                          ),
                      itemCount: images.length),
                ));
              }),
        ],
      );
}
