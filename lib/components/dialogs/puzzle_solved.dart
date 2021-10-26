import 'package:fix_it/components/dialogs/animated_dialog.dart';
import 'package:fix_it/components/puzzle_button.dart';
import 'package:fix_it/util/screen_size_util.dart';
import 'package:fix_it/util/styles.dart';
import 'package:flutter/material.dart';

class PuzzleSolvedDialog extends StatelessWidget {
  final int moves;
  final VoidCallback onCancel;
  final VoidCallback onPlayAgain;

  const PuzzleSolvedDialog(
      {Key? key,
      required this.moves,
      required this.onCancel,
      required this.onPlayAgain})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedDialog(builder: (controller) {
      return Container(
        margin: EdgeInsets.all(SizeUtil.sWidth * .09),
        decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(defPuzzleRadius)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 35,
            ),
            Text(
              'Puzzle Solved!',
              style: TextStyle(
                  color: white.withOpacity(.7),
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              '$moves',
              style: TextStyle(
                  color: primary, fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 35,
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
                  title: 'PLAY AGAIN',
                  enabled: true,
                  onPressed: () {
                    controller.reverse().whenComplete(() => onPlayAgain.call());
                  },
                )),
              ],
            )
          ],
        ),
      );
    });
  }
}
