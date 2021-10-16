import 'package:fix_it/util/styles.dart';
import 'package:flutter/material.dart';

class MIcon extends StatelessWidget {
  final String imgName;
  final VoidCallback onTap;
  final double size;

  const MIcon({Key? key, required this.imgName,required this.onTap,required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: CircleBorder(),
      child: Container(
        child: Image.asset(
          imgName,
          height: size,
          color: white,
        ),
        padding: EdgeInsets.all(size*.6),
        decoration: BoxDecoration(
            color: background,
            shape: BoxShape.circle, boxShadow: [
          BoxShadow(
              color: black.withOpacity(.4), offset: Offset(0, 0), blurRadius: 8, spreadRadius: 2)
        ]),
      ),
    );
  }
}
