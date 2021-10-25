import 'package:fix_it/components/puzzle_button.dart';
import 'package:fix_it/util/screen_size_util.dart';
import 'package:fix_it/util/styles.dart';
import 'package:flutter/material.dart';

class PuzzleSolvedDialog extends StatefulWidget {
  final int moves;
  final VoidCallback onCloseDialog;
  final VoidCallback onPlayAgain;

  const PuzzleSolvedDialog(
      {Key? key,
      required this.moves,
      required this.onCloseDialog,
      required this.onPlayAgain})
      : super(key: key);

  @override
  _PuzzleSolvedDialogState createState() => _PuzzleSolvedDialogState();
}

class _PuzzleSolvedDialogState extends State<PuzzleSolvedDialog>
    with SingleTickerProviderStateMixin {
  late final _animationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
  late final Animation<double> _scaleAnimation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.elasticInOut,
  );

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward();
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
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
              '${widget.moves}',
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
                    _animationController
                        .reverse()
                        .whenComplete(() => widget.onCloseDialog.call());
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
                    _animationController
                        .reverse()
                        .whenComplete(() => widget.onPlayAgain.call());
                  },
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
