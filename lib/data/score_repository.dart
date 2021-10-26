import 'package:shared_preferences/shared_preferences.dart';

class ScoreRepository{
  final _bestScoreKey= 'BEST_SCORE';
  Future<SharedPreferences> get _prefs async=> await SharedPreferences.getInstance();
  Future<int> getBestScore()async{
    final pref = await _prefs;
    final bestScore = pref.getInt(_bestScoreKey) ?? 0;
    return bestScore;
  }

  Future<bool> setBestScore(int score)async{
    final pref = await _prefs;
    return pref.setInt(_bestScoreKey, score);
  }
}