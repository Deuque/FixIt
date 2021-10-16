import 'package:fix_it/util/asset_util.dart';
import 'package:fix_it/util/styles.dart';
import 'package:flutter/material.dart';

class BestScore extends StatelessWidget {
  final double size;
  final int score;

  const BestScore({Key? key, required this.size, required this.score})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          crownIcon,
          height: size,
          color: white,
        ),
        SizedBox(
          width: size/2,
        ),
        Text(
          '$score',
          style: TextStyle(color: white, fontSize: size),
        )
      ],
    );
  }
}
