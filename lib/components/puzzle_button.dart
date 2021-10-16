import 'package:fix_it/util/styles.dart';
import 'package:fix_it/util/screen_size_util.dart';
import 'package:flutter/material.dart';

class PuzzleButton extends StatelessWidget {
  const PuzzleButton.left(
      {Key? key, required this.title, required this.enabled, this.onPressed})
      : this.borderRadius = const BorderRadius.only(
          bottomLeft: Radius.circular(defPuzzleRadius),
        ),
        super(key: key);

  const PuzzleButton.right(
      {Key? key, required this.title, required this.enabled, this.onPressed})
      : this.borderRadius = const BorderRadius.only(
          bottomRight: Radius.circular(defPuzzleRadius),
        ),
        super(key: key);

  final BorderRadius borderRadius;
  final String title;
  final bool enabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>onPressed?.call(),
      child: Container(
        height: 40,
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
              color: enabled ? white : white.withOpacity(.6),
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ),
        decoration: BoxDecoration(
          color: primary,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
