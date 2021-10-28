import 'package:fix_it/components/best_score.dart';
import 'package:fix_it/components/gallery.dart';
import 'package:fix_it/components/icon_button.dart';
import 'package:fix_it/components/puzzle_frame.dart';
import 'package:fix_it/controllers/gallery_controller.dart';
import 'package:fix_it/controllers/score_controller.dart';
import 'package:fix_it/locator.dart';
import 'package:fix_it/util/asset_util.dart';
import 'package:fix_it/util/screen_size_util.dart';
import 'package:fix_it/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class PlayArea extends StatelessWidget {
  const PlayArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeUtil.init(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(),
            Expanded(
                child: ValueListenableBuilder(
                    valueListenable: locator<GalleryController>().imageInPlay,
                    builder: (context, image, child) {
                      return PuzzleFrame(
                        assetOrFile: image,
                      );
                    })),
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
            onTap: () => Share.share(
                'Check out https://play.google.com/store/apps/details?id=com.dcdevs.fix_it',
                subject: 'How fast can you solve a puzzle?'),
            size: 16,
          ),
          ValueListenableBuilder<int>(
              valueListenable: locator<ScoreController>().bestScoreNotifier,
              builder: (context, value, child) {
                return BestScore(size: 18, score: value);
              })
        ],
      ),
    );
  }
}
