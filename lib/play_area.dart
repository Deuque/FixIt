import 'package:fix_it/components/best_score.dart';
import 'package:fix_it/components/gallery.dart';
import 'package:fix_it/components/icon_button.dart';
import 'package:fix_it/components/puzzle_frame.dart';
import 'package:fix_it/util/asset_util.dart';
import 'package:fix_it/util/styles.dart';
import 'package:flutter/material.dart';

class PlayArea extends StatelessWidget {
  const PlayArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(),
            Expanded(
                child: PuzzleFrame(
              assetOrFile: tempPuzzleImage,
            )),
            Gallery()
          ],
        ),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(defHorPadding, 15, defHorPadding, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MIcon(
            imgName: shareIcon,
            onTap: () {},
            size: 18,
          ),
          BestScore(size: 20, score: 0)
        ],
      ),
    );
  }
}
