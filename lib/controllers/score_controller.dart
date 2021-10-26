import 'package:fix_it/data/score_repository.dart';
import 'package:flutter/cupertino.dart';

class ScoreController {
  final ScoreRepository scoreRepository;

  ValueNotifier<int> _bestScoreNotifier = ValueNotifier(0);

  ScoreController(this.scoreRepository) {
    fetchBestScore();
  }

  ValueNotifier<int> get bestScoreNotifier => _bestScoreNotifier;

  void checkAndUpdateScore(int score) {
    if (_bestScoreNotifier.value == 0 || score < _bestScoreNotifier.value) {
      scoreRepository.setBestScore(score);
      _bestScoreNotifier.value = score;
    }
  }

  void fetchBestScore() async {
    _bestScoreNotifier.value = await scoreRepository.getBestScore();
  }
}
