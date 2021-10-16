import 'package:fix_it/components/puzzle_button.dart';
import 'package:fix_it/util/styles.dart';
import 'package:flutter/material.dart';

class PuzzleFrame extends StatelessWidget {
  const PuzzleFrame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defHorPadding/2),
      child: LayoutBuilder(builder: (context, constraint) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: primary, width: .7),
              borderRadius: BorderRadius.circular(defPuzzleRadius),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: constraint.maxWidth,
                ),
                PuzzleControls()
              ],
            ),
          ),
        );
      }),
    );
  }
}

class PuzzleControls extends StatelessWidget {
  const PuzzleControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: PuzzleButton.left(
          title: 'START',
          enabled: true,
        )),
        SizedBox(
          width: 2,
        ),
        Expanded(
            child: PuzzleButton.right(
          title: 'SHUFFLE',
          enabled: false,
        )),
      ],
    );
  }
}
