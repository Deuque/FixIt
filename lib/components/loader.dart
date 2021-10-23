import 'package:fix_it/util/styles.dart';
import 'package:flutter/material.dart';
class Loader extends StatelessWidget {
  final double size;
  const Loader({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        color: primary,
        strokeWidth: 2,
      ),
    );
  }
}
