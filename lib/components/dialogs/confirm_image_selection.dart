import 'package:fix_it/components/dialogs/animated_dialog.dart';
import 'package:fix_it/components/puzzle_button.dart';
import 'package:fix_it/util/asset_util.dart';
import 'package:fix_it/util/screen_size_util.dart';
import 'package:fix_it/util/styles.dart';
import 'package:flutter/material.dart';

class ConfirmImageDialog extends StatelessWidget {
  final dynamic assetOrFile;
  final VoidCallback onCancel;
  final VoidCallback onPlay;

  const ConfirmImageDialog(
      {Key? key,
      required this.assetOrFile,
      required this.onCancel,
      required this.onPlay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topImageSize = SizeUtil.sWidth * .15;
    return AnimatedDialog(builder: (controller) {
      return Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: SizeUtil.sWidth * .07, vertical: topImageSize / 2),
            decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(defPuzzleRadius)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: (topImageSize / 2) + 30,
                ),
                Text(
                  'Do you want to play \nwith this Image?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: white, fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: (topImageSize / 2) + 25,
                ),
                Row(
                  children: [
                    Expanded(
                        child: PuzzleButton.left(
                      title: 'CANCEL',
                      enabled: true,
                      onPressed: () {
                        controller
                            .reverse()
                            .whenComplete(() => onCancel.call());
                      },
                    )),
                    SizedBox(
                      width: 2,
                    ),
                    Expanded(
                        child: PuzzleButton.right(
                      title: 'PLAY',
                      enabled: true,
                      onPressed: () {
                        controller
                            .reverse()
                            .whenComplete(() => onPlay.call());
                      },
                    )),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Material(
              shape: CircleBorder(),
              color: background,
              child: Container(
                height: topImageSize,
                width: topImageSize,
                margin: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: assetProvider(assetOrFile))),
              ),
            ),
          )
        ],
      );
    });
  }
}
